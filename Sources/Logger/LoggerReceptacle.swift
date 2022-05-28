import Foundation

public final class LoggerReceptacle {
	private lazy var queue = DispatchQueue(label: "LoggerReceptacle.queue")
	
	/// The `LoggerConfiguration` instances used to construct the receiver.
	public let configurations: [LoggerConfiguration]
	
	/// The minimum `LoggerSeverity` amongst the receiver's `LoggerConfiguration`s.
	public let minimumSeverity: LoggerSeverity
	
	public init(configurations: [LoggerConfiguration]) {
		self.configurations = configurations
		self.minimumSeverity = configurations.map{ $0.minimumSeverity }.reduce(.fatal, { $0 < $1 ? $0 : $1 })
	}
	
	public convenience init(configuration: LoggerConfiguration) {
		self.init(configurations: [configuration])
	}
	
	public func log(_ entry: LoggerEntry) {
		let matchingConfigs = configurations.filter{ entry.severity >= $0.minimumSeverity }
		// Perform the asynchronous configurations first
		let asyncConfigs = matchingConfigs.filter{ !$0.synchronousMode }
		asyncConfigs.forEach{ log(entry: entry, usingConfiguration: $0) }
		
		// and then log the synchronous configurations
		let syncConfigs = matchingConfigs.filter{ $0.synchronousMode }
		syncConfigs.forEach{ log(entry: entry, usingConfiguration: $0) }
	}
}

private extension LoggerReceptacle {
	func log(entry: LoggerEntry, usingConfiguration config: LoggerConfiguration) {
		let dispatcher = dispatcherForQueue(queue, synchronous: config.synchronousMode)
		dispatcher { [weak self] in
			guard let self = self else { return }
			for recorder in config.recorders {
				let recordDispatcher = self.dispatcherForQueue(recorder.queue, synchronous: config.synchronousMode)
				recordDispatcher {
					for formatter in recorder.formatters {
						var shouldBreak = false
						autoreleasepool {
							if let message = formatter.format(entry) {
								recorder.record(
									message: message,
									for: entry,
									currentQueue: recorder.queue,
									synchronousMode: config.synchronousMode
								)
								shouldBreak = true
							}
						}
						if shouldBreak {
							break
						}
					}
				}
			}
		}
	}
	
	func dispatcherForQueue(_ queue: DispatchQueue, synchronous: Bool) -> (@escaping () -> Void) -> Void
	{
		let dispatcher: (@escaping () -> Void) -> Void = { block in
			if synchronous {
				return queue.sync(execute: block)
			}
			return queue.async(execute: block)
		}
		return dispatcher
	}
}

import Foundation

/// A partial implementation of the `LoggerRecorder` protocol.
open class LoggerRecorderBase: LoggerRecorder {
	/// The `LoggerFormatter`s that will be used to format messages for the `LoggerEntry`s to be logged.
	public let formatters: [LoggerFormatter]
	
	/// The GCD queue that should be used for logging actions related to the receiver.
	public let queue: DispatchQueue
	
	/// Initialise's a new `LoggerRecorderBase` instance.
	public init(formatters: [LoggerFormatter], queue: DispatchQueue? = nil) {
		self.formatters = formatters
		self.queue = queue ?? DispatchQueue(label: String(describing: type(of: self)))
	}
	
	/// This implementation does nothing. Subclasses must override this function to provide actual log recording functionality.
	open func record(message: String, for entry: LoggerEntry, currentQueue: DispatchQueue, synchronousMode: Bool) {
	}
}

import Darwin.C.stdio
import Foundation

open class StandardStreamsLoggerRecorder: LoggerRecorderBase {
	private let stdout: StandardOutputLoggerRecorder
	private let stderr: StandardErrorLoggerRecorder
	
	/// Initializes a `StandardStreamsLoggerRecorder` instance to use the specified `LoggerFormatter` implementation for formatting log messages.
	/// - Parameters:
	///   - formatters: An array of `LoggerFormatter`s to use for formatting log entries that will be recorded by the receiver.
	///   - queue: The `DispatchQueue` to use for the recorder. If `nil`, a new queue will be created.
	public override init(formatters: [LoggerFormatter], queue: DispatchQueue? = nil) {
		let queue = queue != nil ? queue! : DispatchQueue(label: String(describing: type(of: self)))
		stdout = StandardOutputLoggerRecorder(formatters: formatters, queue: queue)
		stderr = StandardErrorLoggerRecorder(formatters: formatters, queue: queue)
		super.init(formatters: formatters, queue: queue)
	}
	
	/// Called to record the specified message to stdout/stderr.
	/// - note: This function is only called if one of the `formatters` associated with the receiver returned a non-`nil` string for the given `LoggerEntry`.
	/// - Parameters:
	///   - message: The message to record.
	///   - entry: The `LoggerEntry` for which `message` was created.
	///   - currentQueue: The GCD queue on which the function is being executed.
	///   - synchronousMode: If `true`, the recording is being done in synchronous mode, and the recorder should act accordingly.
	open override func record(message: String, for entry: LoggerEntry, currentQueue: DispatchQueue, synchronousMode: Bool) {
		let logger: LoggerRecorder = entry.severity <= .info ? stdout : stderr
		logger.record(
			message: message,
			for: entry,
			currentQueue: currentQueue,
			synchronousMode: synchronousMode
		)
	}
}

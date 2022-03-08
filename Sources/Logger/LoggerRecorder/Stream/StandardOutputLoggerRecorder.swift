import Darwin.C.stdio
import Foundation

/// The `StandardOutputLoggerRecorder` is an `OutputStreamLoggerRecorder` that writes
/// log messages to the standard output stream ("`stdout`") of the running process.
open class StandardOutputLoggerRecorder: OutputStreamLoggerRecorder {
	/// Initializes a `StandardOutputLoggerRecorder` instance to use the specified `LoggerFormatter` implementation for formatting log messages.
	/// - Parameters:
	///   - formatters: An array of `LoggerFormatter`s to use for formatting log entries that will be recorded by the receiver.
	///   - queue: The `DispatchQueue` to use for the recorder. If `nil`, a new queue will be created.
	public init(formatters: [LoggerFormatter], queue: DispatchQueue? = nil) {
		super.init(stream: stdout, formatters: formatters, queue: queue)
	}
}

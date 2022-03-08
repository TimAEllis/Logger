import Darwin.C.stdio
import Foundation

/// The `StandardErrorLoggerRecorder` is an `OutputStreamLoggerRecorder` that writes
/// log messages to the standard error stream ("`stderr`") of the running process.
open class StandardErrorLoggerRecorder: OutputStreamLoggerRecorder {
	/// Initializes a `StandardErrorLoggerRecorder` instance to use the specified `LoggerFormatter` implementation for formatting log messages.
	/// - Parameters:
	///   - formatters: An array of `LoggerFormatter`s to use for formatting log entries that will be recorded by the receiver.
	///   - queue: The `DispatchQueue` to use for the recorder. If `nil`, a new queue will be created.
	public init(formatters: [LoggerFormatter], queue: DispatchQueue? = nil) {
		super.init(stream: stderr, formatters: formatters, queue: queue)
	}
}

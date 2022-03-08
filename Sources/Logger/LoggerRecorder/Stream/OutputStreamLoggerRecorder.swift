import Darwin.C.stdio
import Foundation

open class OutputStreamLoggerRecorder: LoggerRecorderBase {
	private let stream: UnsafeMutablePointer<FILE>
	private let newlines: [Character] = ["\n", "\r"]
	
	/// Initializes a `OutputStreamLoggerRecorder` instance to use the specified `LoggerFormatter` implementation for formatting log messages.
	/// - Parameters:
	///   - stream: A standard C file handle to use as the output stream.
	///   - formatters: An array of `LoggerFormatter`s to use for formatting log entries that will be recorded by the receiver.
	///   - queue: The `DispatchQueue` to use for the recorder. If `nil`, a new queue will be created.
	public init(stream: UnsafeMutablePointer<FILE>, formatters: [LoggerFormatter], queue: DispatchQueue? = nil) {
		self.stream = stream
		super.init(formatters: formatters, queue: queue)
	}
	
	/// Called to record the specified message to standard output.
	///
	/// - note: This function is only called if one of the `formatters` associated
	/// with the receiver returned a non-`nil` string for the given `LoggerEntry`.
	///
	/// - Parameters:
	///   - message: The message to record.
	///   - entry: The `LoggerEntry` for which `message` was created.
	///   - currentQueue: The GCD queue on which the function is being executed.
	///   - synchronousMode: If `true`, the recording is being done in synchronous mode, and the recorder should act accordingly.
	open override func record(message: String, for entry: LoggerEntry, currentQueue: DispatchQueue, synchronousMode: Bool) {
		var addNewline = true
		if !message.isEmpty {
			let lastChar = message[message.index(before: message.endIndex)]
			addNewline = !newlines.contains(lastChar)
		}
		fputs(message, stream)
		if addNewline {
			fputc(0x0A, stream)
		}
		if synchronousMode {
			fflush(stream)
		}
	}
}

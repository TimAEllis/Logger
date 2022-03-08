import Foundation

/// Each `LoggerRecorder` instance is responsible recording formatted log messages
/// (along with their accompanying `LoggerEntry` instances) to an underlying log
/// facility or data store.
public protocol LoggerRecorder {
	/// The `LoggerFormatter`s that should be used to create a formatted log string
	/// for passing to the receiver's `record()` function.
	/// Formatters are consulted sequentially and given an opportunity to return
	/// a formatted string for each `LoggerEntry`. The first non-`nil` return value
	/// is sent to the log for recording. Typically, an implementation of this
	/// protocol would not hard-code the `LoggerFormatter`s it uses, but would instead
	/// provide a constructor that accepts an array of `LoggerFormatter`s, which it
	/// will subsequently return from this property.
	var formatters: [LoggerFormatter] { get }
	
	/// Returns the GCD queue that will be used when executing tasks related to
	/// the receiver. Log formatting and recording will be performed using
	/// this queue. A serial queue is typically used, such as when the underlying
	/// log facility is inherently single-threaded and/or proper message ordering
	/// wouldn't be ensured otherwise. However, a concurrent queue may also be
	/// used, and might be appropriate when logging to databases or network
	/// endpoints.
	var queue: DispatchQueue { get }
	
	/// Called by the `LoggerReceptacle` to record the formatted log message.
	/// - note: This function is only called if one of the `formatters` associated with the receiver returned a non-`nil` string for the given `LoggerEntry`.
	/// - Parameters:
	///   - message: The message to record.
	///   - entry: The `LoggerEntry` for which `message` was created.
	///   - currentQueue: The GCD queue on which the function is being executed.
	///   - synchronousMode: If `true`, the recording is being done in synchronous mode, and the recorder should act accordingly.
	func record(message: String, for entry: LoggerEntry, currentQueue: DispatchQueue, synchronousMode: Bool)
}

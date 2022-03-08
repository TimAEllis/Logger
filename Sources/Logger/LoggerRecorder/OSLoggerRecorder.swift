import Foundation
import os.log

public struct OSLoggerRecorder: LoggerRecorder {
	/// `true` if the `os_log()` function is available at runtime.
	public static let isAvailable: Bool = {
		guard #available(iOS 10.0, macOS 10.12, tvOS 10.0, watchOS 3.0, *) else {
			return false
		}
		return true
	}()
	
	/// The `LoggerFormatter`s that will be used to format messages for the `LoggerEntry`s to be logged.
	public let formatters: [LoggerFormatter]
	
	/// Governs how `OSLogType` values are generated from `LoggerEntry` values.
	public let logTypeTranslator: OSLoggerTypeTranslator
	
	/// The `OSLog` used to perform logging.
	public let log: OSLog
	
	/// The GCD queue that should be used for logging actions related to the receiver.
	public let queue: DispatchQueue
	
	/// Initialize an `OSLoggerRecorder` instance, which will record log entries using the `os_log()` function.
	///
	/// - important: `os_log()` is only supported as of iOS 10.0, macOS 10.12, tvOS 10.0, and watchOS 3.0.
	/// On incompatible systems, this initializer will fail.
	///
	/// - Parameters:
	///   - formatters: An array of `LoggerFormatter`s to use for formatting log entries to be recorded by the receiver.
	///   Each formatter is consulted in sequence, and the formatted string returned by the first formatter to yield a non-`nil`
	///   value will be recorded (and subsequent formatters, if any, are skipped). The log entry is silently ignored and not recorded if
	///   every formatter returns `nil`.
	///   - subsystem: The name of the subsystem performing the logging. Defaults to the empty string (`""`) if not specified.
	///   - logTypeTranslator: An `OSLogTypeTranslator` value that governs how `OSLogType` values are determined for log entries.
	///   - queue: The `DispatchQueue` to use for the recorder. If `nil`, a new queue will be created.
	public init?(
		formatters: [LoggerFormatter],
		subsystem: String = "",
		logTypeTranslator: OSLoggerTypeTranslator = .default,
		queue: DispatchQueue? = nil
	) {
		guard #available(iOS 10.0, macOS 10.12, tvOS 10.0, watchOS 3.0, *) else { return nil }
		self.log = OSLog(subsystem: subsystem, category: "TELogger")
		self.queue = queue ?? DispatchQueue(label: String(describing: type(of: self)))
		self.formatters = formatters
		self.logTypeTranslator = logTypeTranslator
	}
	
	/// Called to record the specified using the `os_log()` function.
	///
	/// - note: This function is only called if one of the `formatters` associated
	/// with the receiver returned a non-`nil` string for the given `LoggerEntry`.
	///
	/// - Parameters:
	///   - message: The message to record.
	///   - entry: The `LoggerEntry` for which `message` was created.
	///   - currentQueue: The GCD queue on which the function is being executed.
	///   - synchronousMode: If `true`, the recording is being done in synchronous mode, and the recorder should act accordingly.
	public func record(message: String, for entry: LoggerEntry, currentQueue: DispatchQueue, synchronousMode: Bool) {
		guard #available(iOS 10.0, macOS 10.12, tvOS 10.0, watchOS 3.0, *) else {
			fatalError("os.log module not supported on this platform")    // things should never get this far; failable initializers should prevent this condition
		}
		let type = self.logTypeTranslator.osLogType(for: entry)
		os_log("%{public}@", log: self.log, type: type, message)
	}
}

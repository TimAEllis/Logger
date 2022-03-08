import Darwin.C.stdlib
import Foundation

/// A standard `LoggerConfiguration` that, by default, uses the `os_log()` function
/// (via the `OSLogRecorder`), which is only available as of iOS 10.0, macOS 10.12,
/// tvOS 10.0, and watchOS 3.0.
///
/// If `os_log()` is not available, or if the `ConsoleLoggerConfiguration` is
/// configured to bypass it, log messages will be written to either the `stdout`
/// or `stderr` output stream of the running process.
open class ConsoleLoggerConfiguration: LoggerConfigurationBase {
	/// Initializes a new `ConsoleLoggerConfiguration` instance.
	/// - Parameters:
	///   - minimumSeverity: The minimum `LoggerSeverity` supported by the configuration.
	///   Log entries having a `severity` less than `minimumSeverity`
	///   will not be passed to the receiver's `recorders`.
	///   - stdStreamsMode: A `StandardStreamsMode` value that governs when standard
	///   console streams (i.e., `stdout` and `stderr`) should be used for recording log output.
	///   - formatters: An array of `LoggerFormatter`s to use when formatting log entries.
	public convenience init(
		minimumSeverity: LoggerSeverity = .info,
		stdStreamsMode: StandardStreamsMode = .useAsFallback,
		formatters: [LoggerFormatter]
	) {
		self.init(
			minimumSeverity: minimumSeverity,
			stdStreamsMode: stdStreamsMode,
			osLogFormatters: formatters,
			stdoutFormatters: formatters
		)
	}
	
	/// Initializes a new `ConsoleLoggerConfiguration` instance.
	/// - Parameters:
	///   - minimumSeverity: The minimum `LoggerSeverity` supported by the configuration.
	///   Log entries having a `severity` less than `minimumSeverity`
	///   will not be passed to the receiver's `recorders`.
	///   - stdStreamsMode: A `StandardStreamsMode` value that governs when standard
	///   console streams (i.e., `stdout` and `stderr`) should be used for recording log output.
	///   - osLogFormatters: An array of `LoggerFormatter`s to use when formatting log entries
	///   bound for the `OSLogRecorder`.
	///   - stdoutFormatters: An array of `LoggerFormatter`s to use when formatting log entries bound for the `StandardOutputLogRecorder`.
	///   - synchronousMode: Determines whether synchronous mode will be used when passing `LoggerEntry` instances to
	///   the receiver's `recorders`. Synchronous mode is helpful while debugging, as it ensures that logs are always up-to-date
	///   when debug breakpoints are hit. However, synchronous mode can have a negative influence on performance and is therefore
	///   not recommended for use in production code.
	public init(
		minimumSeverity: LoggerSeverity = .info,
		stdStreamsMode: StandardStreamsMode = .useAsFallback,
		osLogFormatters: [LoggerFormatter],
		stdoutFormatters: [LoggerFormatter],
		synchronousMode: Bool = false
	) {
		var recorders: [LoggerRecorder] = []
		if stdStreamsMode.willUseOSLog {
			if let recorder = OSLoggerRecorder(formatters: osLogFormatters) {
				recorders.append(recorder)
			}
		}
		if stdStreamsMode.shouldUseStandardStreams {
			recorders.append(StandardStreamsLoggerRecorder(formatters: stdoutFormatters))
		}
		super.init(
			minimumSeverity: minimumSeverity,
			recorders: recorders,
			synchronousMode: synchronousMode
		)
	}
}

public extension ConsoleLoggerConfiguration {
	enum StandardStreamsMode {
		/// Indicates that logging will be directed to `stdout` and `stderr`
		/// only as a fallback on platforms where `os_log()` is not available.
		case useAsFallback
		
		/// Indicates that `stdout` and `stderr` will always be used,
		/// regardless of whether logging using `os_log()` is also occurring.
		case useAlways
		
		/// Indicates that `stdout` and `stderr` are to be used exclusively;
		/// `os_log()` will not be used even when it is available.
		case useExclusively
		
		/// Determines whether the `os_log()` function will be used given the value of `self`.
		var willUseOSLog: Bool {
			switch self {
			case .useAlways, .useAsFallback:
				return OSLoggerRecorder.isAvailable
			case .useExclusively:
				return false
			}
		}
		
		/// Determines whether the `stdout` and `stderr` streams should be used given
		/// the runtime environment and the value of `self`.
		var shouldUseStandardStreams: Bool {
			guard self == .useAsFallback, OSLoggerRecorder.isAvailable else { return true }
			guard let env = getenv("OS_ACTIVITY_MODE"), let str = String(validatingUTF8: env) else {
				return false
			}
			return str == "disable"
		}
	}
}

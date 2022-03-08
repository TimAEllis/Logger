import Foundation
import os.log

/// Specifies the manner in which an `OSLogType` is selected to represent a
/// given `LoggerEntry`.
///
/// When a log entry is being recorded by an `OSLoggerRecorder`, an `OSLogType`
/// value is used to specify the importance of the message; it is similar in
/// concept to the `LoggerSeverity`.
///
/// Because there is not an exact one-to-one mapping between `OSLogType` and
/// `LoggerSeverity` values, `OSLoggerTypeTranslator` provides a mechanism for
/// deriving the appropriate `OSLogType` for a given `LoggerEntry`.
public enum OSLoggerTypeTranslator {
	/// The most direct translation from a `LoggerEntry`'s `severity` to the
	/// corresponding `OSLogType` value.
	///
	/// This value strikes a sensible balance between the higher-overhead logging
	/// provided by `.strict` and the more ephemeral logging of `.relaxed`.
	///
	/// LoggerSeverity|OSLogType
	/// -----------|---------
	/// `.trace`|`.debug`
	/// `.debug`|`.debug`
	/// `.info`|`.info`
	/// `.warn`|`.default`
	/// `.error`|`.error`
	/// `.fatal`|`.fault`
	case `default`
	
	/// A strict translation from a `LoggerEntry`'s `severity` to an
	/// `OSLogType` value. Warnings are treated as errors; errors are
	/// treated as faults.
	///
	/// This will result in additional logging overhead being recorded by OSLog,
	/// and is not recommended unless you have a specific need for this.
	///
	/// LoggerSeverity|OSLogType
	/// -----------|---------
	/// `.trace`|`.debug`
	/// `.debug`|`.debug`
	/// `.info`|`.default`
	/// `.warn`|`.error`
	/// `.error`|`.fault`
	/// `.fatal`|`.fault`
	case strict
	
	/// A relaxed translation from a `LoggerEntry`'s `severity` to an
	/// `OSLogType` value. Nothing is treated as an error.
	///
	/// This results in low-overhead logging, but log entries are more
	/// ephemeral and may not contain as much OSLog metadata.
	///
	/// LoggerSeverity|OSLogType
	/// -----------|---------
	/// `.trace`|`.debug`
	/// `.debug`|`.debug`
	/// `.info`|`.info`
	/// `.warn`|`.default`
	/// `.error`|`.default`
	/// `.fatal`|`.default`
	case relaxed
	
	/** `OSLogType.default` is used for all messages. */
	case allAsDefault
	
	/** `OSLogType.info` is used for all messages. */
	case allAsInfo
	
	/** `OSLogType.debug` is used for all messages. */
	case allAsDebug
	
	/** Uses a custom function to determine the `OSLogType` to use for each
	 `LoggerEntry`. */
	case function((LoggerEntry) -> OSLogType)
}

extension OSLoggerTypeTranslator {
	internal func osLogType(for entry: LoggerEntry) -> OSLogType {
		logTypeFunction()(entry)
	}
	
	private func logTypeFunction() -> ((LoggerEntry) -> OSLogType) {
		guard #available(iOS 10.0, macOS 10.12, tvOS 10.0, watchOS 3.0, *) else {
			fatalError("os.log module not supported on this platform")    // things should never get this far
		}
		if case .function(let f) = self {
			return f
		}
		return { entry -> OSLogType in
			switch self {
			case .default:
				switch entry.severity {
				case .trace: return .debug
				case .debug: return .debug
				case .info:  return .info
				case .warn:  return .default
				case .error: return .error
				case .fatal: return .fault
				}
			case .strict:
				switch entry.severity {
				case .trace: return .debug
				case .debug: return .debug
				case .info:  return .default
				case .warn:  return .error
				case .error: return .fault
				case .fatal: return .fault
				}
			case .relaxed:
				switch entry.severity {
				case .trace: return .debug
				case .debug: return .debug
				case .info:  return .info
				case .warn:  return .default
				case .error: return .default
				case .fatal: return .default
				}
			case .allAsDefault:
				return .default
			case .allAsInfo:
				return .info
			case .allAsDebug:
				return .debug
			case .function(let f):
				// This case should never get called as it is already handled above
				return f(entry)
			}
		}
	}
}

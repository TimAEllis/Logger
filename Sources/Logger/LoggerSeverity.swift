import Foundation

public enum LoggerSeverity: Int, Comparable, Codable {
	/// One or more key business functionalities are not working and the whole system doesn’t fulfill the business functionalities.
	case fatal = 6
	/// One or more functionalities are not working, preventing some functionalities from working correctly.
	case error = 5
	/// Unexpected behavior happened inside the application, but it is continuing its work and the key business features are operating as expected.
	case warn = 4
	/// An event happened, the event is purely informative and can be ignored during normal operations.
	case info = 3
	/// A log level used for events considered to be useful during software debugging when more granular information is needed.
	case debug = 2
	/// A log level describing events showing step by step execution of your code that can be ignored during the standard operation, but may be useful during extended debugging sessions.
	case trace = 1
}

/// :nodoc:
public func <(lhs: LoggerSeverity, rhs: LoggerSeverity) -> Bool {
	return lhs.rawValue < rhs.rawValue
}

extension LoggerSeverity: CustomStringConvertible
{
	/** Returns a human-readable textual representation of the receiver. */
	public var description: String {
		switch self {
		case .trace: return "Trace"
		case .debug: return "Debug"
		case .info:  return "Info"
		case .warn:  return "Warning"
		case .error: return "Error"
		case .fatal: return "Fatal"
		}
	}
}

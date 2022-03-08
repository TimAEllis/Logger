import Foundation

/// Governs how a `CallingThreadLoggerFormatter` will represent a `LoggerEntry`'s `callingThreadID`.
public enum CallingThreadStyle {
	/// Renders the `callingThreadID` as a hex string.
	case hex
	
	/// Renders the `callingThreadID` as an integer string.
	case integer
	
	internal func format(_ callingThreadID: UInt64) -> String {
		switch self {
		case .hex:
			return String(format: "%08X", callingThreadID)
		case .integer:
			return String(describing: callingThreadID)
		}
	}
}

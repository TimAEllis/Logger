import Foundation

public enum DelimiterStyle {
	/// Specifies a pipe character with a space character on each side.
	case spacedPipe
	
	/// Specifies a hyphen character with a space character on each side.
	case spacedHyphen
	
	/// Specifies the tab character: ASCII `0x09`.
	case tab
	
	/// Specifies the space character: ASCII `0x20`.
	case space
	
	/// Specifies a custom field delimiters.
	case custom(String)
	
	/// Returns the field delimiter string indicated by the receiver's value.
	public var delimiter: String {
		switch self {
		case .spacedPipe:       return " | "
		case .spacedHyphen:     return " - "
		case .tab:              return "\t"
		case .space:            return " "
		case .custom(let sep):  return sep
		}
	}
}

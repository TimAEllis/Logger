import Foundation

public enum TimestampStyle {
	/** Specifies a timestamp style that uses the date format string
	 "yyyy-MM-dd HH:mm:ss.SSS zzz". */
	case `default`
	
	/** Specifies a UNIX timestamp indicating the number of seconds elapsed
	 since January 1, 1970. */
	case unix
	
	/** Specifies a custom date format. */
	case custom(String)
}

private extension TimestampStyle {
	var dateFormat: String? {
		switch self {
		case .default:
			return "yyyy-MM-dd HH:mm:ss.SSS xxx"
		case .unix:
			return nil
		case .custom(let fmt):
			return fmt
		}
	}
}

internal extension TimestampStyle {
	var formatter: DateFormatter? {
		guard let format = dateFormat else { return nil }
		let formatter = DateFormatter()
		formatter.dateFormat = format
		return formatter
	}
	
	func string(from date: Date, using formatter: DateFormatter?) -> String {
		switch self {
		case .unix:
			return String(describing: date.timeIntervalSince1970)
		default:
			let formatter = formatter ?? DateFormatter()
			return formatter.string(from: date)
		}
	}
}

import Foundation

public struct CallSiteLoggerFormatter: LoggerFormatter {
	public func format(_ entry: LoggerEntry) -> String? {
		let file = (entry.callingFilePath as NSString).pathComponents.last ?? "redacted"
		return "\(file):\(entry.callingFileLine)"
	}
}

import Foundation

public struct ProcessNameLoggerFormatter: LoggerFormatter {
	public func format(_ entry: LoggerEntry) -> String? {
		entry.processName
	}
}

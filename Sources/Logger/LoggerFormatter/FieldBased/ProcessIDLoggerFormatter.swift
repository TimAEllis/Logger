import Foundation

public struct ProcessIDLoggerFormatter: LoggerFormatter {
	public func format(_ entry: LoggerEntry) -> String? {
		"\(entry.processID)"
	}
}

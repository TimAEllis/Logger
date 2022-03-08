import Foundation

/// A `LoggerFormatter` that returns the message content of a `LoggerEntry` whose `payload` is a `.message` value.
public struct PayloadMessageLoggerFormatter: LoggerFormatter {
	public init() {}
	
	public func format(_ entry: LoggerEntry) -> String? {
		guard case .message(let content) = entry.payload else { return nil }
		return content
	}
}

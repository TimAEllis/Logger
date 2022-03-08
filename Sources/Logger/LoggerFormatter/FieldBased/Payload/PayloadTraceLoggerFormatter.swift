import Foundation

/// A `LoggerFormatter` that returns the message content of a `LoggerEntry` whose `payload` is a `.trace` value.
public struct PayloadTraceLoggerFormatter: LoggerFormatter {
	public init() {}
	
	public func format(_ entry: LoggerEntry) -> String? {
		guard case .trace = entry.payload else { return nil }
		return entry.callingStackFrame
	}
}

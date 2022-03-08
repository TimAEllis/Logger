import Foundation

public struct StackFrameLoggerFormatter: LoggerFormatter {
	public func format(_ entry: LoggerEntry) -> String? {
		entry.callingStackFrame
	}
}

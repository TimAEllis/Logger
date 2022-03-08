import Foundation

/// A `LoggerFormatter` that returns a string representation of a `LoggerEntry`'s `callingThreadID`.
///
/// This is typically combined with other `LoggerFormatter`s within a `ConcatenatingLoggerFormatter`.
public struct CallingThreadLoggerFormatter: LoggerFormatter {
	/// Governs how the receiver represents `callingThreadID`s.
	public let style: CallingThreadStyle
	
	/// Formats the passed-in `LoggerEntry` by returning a string representation of
	/// its `callingThreadID`. The format is governed by the value of the
	/// receiver's `style` property.
	public func format(_ entry: LoggerEntry) -> String? {
		style.format(entry.callingThreadID)
	}
}

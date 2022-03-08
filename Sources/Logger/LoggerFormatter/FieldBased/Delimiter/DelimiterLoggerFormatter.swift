import Foundation

public struct DelimiterLoggerFormatter: LoggerFormatter {
	/// The `DelimiterStyle` that determines the return value of the receiver's `format(_:)` function.
	public let style: DelimiterStyle
	
	public init(style: DelimiterStyle = .spacedPipe) {
		self.style = style
	}
	
	public func format(_ entry: LoggerEntry) -> String? {
		style.delimiter
	}
}

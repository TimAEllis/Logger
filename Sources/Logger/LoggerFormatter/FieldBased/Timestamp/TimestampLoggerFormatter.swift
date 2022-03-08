import Foundation

public struct TimestampLoggerFormatter: LoggerFormatter {
	/// The `TimestampStyle` that determines how the receiver will format its output.
	public let style: TimestampStyle
	
	private let formatter: DateFormatter?
	
	public init(style: TimestampStyle = .default) {
		self.style = style
		self.formatter = style.formatter
	}
	
	public func format(_ entry: LoggerEntry) -> String? {
		style.string(from: entry.timestamp, using: formatter)
	}
}


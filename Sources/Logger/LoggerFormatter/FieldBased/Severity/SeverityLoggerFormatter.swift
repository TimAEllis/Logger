import Foundation

/// A `LoggerFormatter` that returns a string representation of a `LoggerEntry`'s `severity`.
///
/// This is typically combined with other `LoggerFormatter`s within a `ConcatenatingLoggerFormatter`.
public struct SeverityLoggerFormatter: LoggerFormatter {
	/// The `SeverityStyle` that determines the return value of the receiver's `format(_:)` function.
	public let style: SeverityStyle
	
	/// Initializes a new `SeverityLoggerFormatter`
	/// - Parameters:
	///   - style: The `SeverityStyle` to use when formatting output.
	public init(style: SeverityStyle = .simple) {
		self.style = style
	}
	
	public func format(_ entry: LoggerEntry) -> String? {
		var severityTag = style.textRepresentation.format(severity: entry.severity)
		if let trunc = style.truncateAtWidth {
			if severityTag.count > trunc {
				let startIndex = severityTag.startIndex
				let endIndex = severityTag.index(startIndex, offsetBy: trunc)
				severityTag = String(severityTag[..<endIndex])
			}
		}
		if let pad = style.padToWidth {
			let rightAlign = style.rightAlign
			while severityTag.count < pad {
				if rightAlign {
					severityTag = " " + severityTag
				}
				else {
					severityTag += " "
				}
			}
		}
		return severityTag
	}
}

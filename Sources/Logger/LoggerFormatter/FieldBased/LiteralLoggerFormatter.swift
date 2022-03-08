import Foundation

public struct LiteralLoggerFormatter: LoggerFormatter {
	/// The literal string used as the return value of the receiver's `format(_:)` function.
	public let literal: String
	
	public init(literalString: String) {
		self.literal = literalString
	}
	
	public func format(_ entry: LoggerEntry) -> String? {
		literal
	}
}

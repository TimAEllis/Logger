import Foundation

open class ConcatenatingLoggerFormatter: LoggerFormatter {
	/// The `LoggerFormatter`s whose output will be concatenated.
	public let formatters: [LoggerFormatter]
	
	/// Determines the behavior of `format(_:)` when one of the receiver's
	/// `formatters` returns `nil`. When `false`, if any formatter returns
	/// `nil`, it is simply excluded from the concatenation, but formatting
	/// continues. Unless _none_ of the `formatters` returns a string, the
	/// receiver will always return a non-`nil` value. However, when `hardFail`
	/// is `true`, _all_ of the `formatters` must return strings; if _any_
	/// formatter returns `nil`, the receiver _also_ returns `nil`.
	public let hardFail: Bool
	
	/// Initializes a new `ConcatenatingLoggerFormatter` instance.
	/// - Parameters:
	///   - formatters: The `LoggerFormatter`s whose output will be concatenated.
	///   - hardFail: Determines the behavior of `format(_:)` when one of the receiver's
	///   `formatters` returns `nil`. When `false`, if any formatter returns `nil`, it is
	///   simply excluded from the concatenation, but formatting continues. Unless _none_ of
	///   the `formatters` returns a string, the receiver will always return a non-`nil` value.
	///   However, when `hardFail` is `true`, _all_ of the `formatters` must return strings;
	///   if _any_ formatter returns `nil`, the receiver _also_ returns `nil`.
	public init(formatters: [LoggerFormatter], hardFail: Bool = false) {
		self.formatters = formatters
		self.hardFail = hardFail
	}
	
	open func format(_ entry: LoggerEntry) -> String? {
		var formatted: [String] = []
		for formatter in formatters {
			if let str = formatter.format(entry) {
				formatted.append(str)
			}
			else if hardFail {
				return nil
			}
		}
		guard !formatted.isEmpty else { return nil }
		return formatted.joined(separator: "")
	}
}

import Foundation

/// A `LoggerFormatter` that returns the message content of a `LoggerEntry` whose `payload` is a `.value` value.
public struct PayloadValueLoggerFormatter: LoggerFormatter {
	public init() {}
	
	public func format(_ entry: LoggerEntry) -> String? {
		guard case .value(let nillableValue) = entry.payload else { return nil }
		guard let value = nillableValue else { return "= nil" }
		var strs: [String] = [
			"= ",
			String(describing: type(of: value)),
			": ",
		]
		if let custom = value as? CustomDebugStringConvertible {
			strs.append(custom.debugDescription)
		}
		else if let custom = value as? CustomStringConvertible {
			strs.append(custom.description)
		}
		else {
			strs.append(String(describing: value))
		}
		return strs.joined()
	}
}

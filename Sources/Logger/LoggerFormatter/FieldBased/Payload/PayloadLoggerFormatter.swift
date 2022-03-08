import Foundation

///  A `LoggerFormatter` that returns a string representation of a `LoggerEntry`'s `payload` property.
public struct PayloadLoggerFormatter: LoggerFormatter {
	/// The `LoggerFormatter` used by the receiver when encountering a `LoggerEntry`
	/// whose `payload` property contains a `.trace` value.
	public let traceFormatter: LoggerFormatter
	
	/// The `LoggerFormatter` used by the receiver when encountering a `LoggerEntry`
	/// whose `payload` property contains a `.message` value.
	public let messageFormatter: LoggerFormatter
	
	/// The `LoggerFormatter` used by the receiver when encountering a `LoggerEntry`
	/// whose `payload` property contains a `.value` value.
	public let valueFormatter: LoggerFormatter
	
	public init(
		traceFormatter: LoggerFormatter = PayloadTraceLoggerFormatter(),
		messageFormatter: LoggerFormatter = PayloadMessageLoggerFormatter(),
		valueFormatter: LoggerFormatter = PayloadValueLoggerFormatter()
	) {
		self.traceFormatter = traceFormatter
		self.messageFormatter = messageFormatter
		self.valueFormatter = valueFormatter
	}
	
	public func format(_ entry: LoggerEntry) -> String? {
		switch entry.payload {
		case .trace:
			return traceFormatter.format(entry)
		case .message:
			return messageFormatter.format(entry)
		case .value:
			return valueFormatter.format(entry)
		}
	}
}

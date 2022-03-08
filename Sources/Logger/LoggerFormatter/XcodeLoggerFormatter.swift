import Foundation

public struct XcodeLoggerFormatter: LoggerFormatter {
	private let traceFormatter = XcodeTraceLoggerFormatter()
	private let defaultFormatter: FieldBasedLoggerFormatter
	
	public init(showCallSite: Bool = true) {
		var fields: [FieldBasedLoggerFormatter.Field] = [
			.severity(.xcode),
			.delimiter(.space),
			.payload,
		]
		if showCallSite {
			fields.append(contentsOf: [
				.literal(" ("),
				.callSite,
				.literal(")"),
			])
		}
		defaultFormatter = FieldBasedLoggerFormatter(fields: fields)
	}
	
	public func format(_ entry: LoggerEntry) -> String? {
		traceFormatter.format(entry) ?? defaultFormatter.format(entry)
	}
}

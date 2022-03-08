import Foundation

public final class XcodeTraceLoggerFormatter: FieldBasedLoggerFormatter {
	public init() {
		super.init(fields: [
			.severity(.xcode),
			.literal(" -> "),
			.callSite,
			.delimiter(.spacedHyphen),
			.payload
		])
	}
	
	public override func format(_ entry: LoggerEntry) -> String? {
		guard case .trace = entry.payload else { return nil }
		return super.format(entry)
	}
}

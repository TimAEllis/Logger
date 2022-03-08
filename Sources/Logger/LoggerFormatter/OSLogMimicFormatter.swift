import Foundation

internal final class OSLogMimicFormatter: FieldBasedLoggerFormatter {
	init() {
		super.init(fields: [
			.timestamp(.custom("yyyy-MM-dd HH:mm:ss.SSSSSS")),
			.literal(" "),
			.processName,
			.literal("["),
			.processID,
			.literal(":"),
			.callingThread(.integer),
			.literal("] [TELogger] "),
		])
	}
}

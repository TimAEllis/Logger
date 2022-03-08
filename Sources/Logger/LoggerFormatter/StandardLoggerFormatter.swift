import Foundation

open class StandardLoggerFormatter: FieldBasedLoggerFormatter {
	/// Initializes a new `StandardLoggerFormatter` instance.
	/// - Parameters:
	///   - timestampStyle: Governs the formatting of the timestamp in the log output. Pass `nil` to suppress output of the timestamp.
	///   - severityStyle: Governs the formatting of the `LoggerSeverity` in the log output. Pass `nil` to suppress output of the severity.
	///   - delimiterStyle: If provided, overrides the default field separator delimiters. Pass `nil` to use the default delimiters.
	///   - callingThreadStyle: If provided, specifies a `CallingThreadStyle` to use for representing the calling thread. If `nil`, the calling thread is not shown.
	///   - showCallSite: If `true`, the source file and line indicating the call site of the log request will be added to formatted log messages.
	public init(
		timestampStyle: TimestampStyle? = .default,
		severityStyle: SeverityStyle? = .simple,
		delimiterStyle: DelimiterStyle? = nil,
		callingThreadStyle: CallingThreadStyle? = .hex,
		showCallSite: Bool = true
	) {
		var fields: [Field] = []
		if let timestampStyle = timestampStyle {
			fields += [
				.timestamp(timestampStyle),
				.delimiter(delimiterStyle ?? .spacedPipe),
			]
		}
		if let severityStyle = severityStyle {
			fields += [
				.severity(severityStyle),
				.delimiter(delimiterStyle ?? .spacedPipe),
			]
		}
		if let callingThreadStyle = callingThreadStyle {
			fields += [
				.callingThread(callingThreadStyle),
				.delimiter(delimiterStyle ?? .spacedPipe),
			]
		}
		if showCallSite {
			fields += [
				.callSite,
				.delimiter(delimiterStyle ?? .spacedHyphen),
			]
		}
		fields += [.payload]
		
		super.init(fields: fields)
	}
}

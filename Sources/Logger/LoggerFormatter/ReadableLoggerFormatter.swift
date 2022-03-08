import Foundation

open class ReadableLoggerFormatter: StandardLoggerFormatter {
	public override init(
		timestampStyle: TimestampStyle? = .default,
		severityStyle: SeverityStyle? = .custom(textRepresentation: .capitalized, truncateAtWidth: 7, padToWidth: 7, rightAlign: false),
		delimiterStyle: DelimiterStyle? = nil,
		callingThreadStyle: CallingThreadStyle? = .hex,
		showCallSite: Bool = true
	) {
		super.init(
			timestampStyle: timestampStyle,
			severityStyle: severityStyle,
			delimiterStyle: delimiterStyle,
			callingThreadStyle: callingThreadStyle,
			showCallSite: showCallSite
		)
	}
}

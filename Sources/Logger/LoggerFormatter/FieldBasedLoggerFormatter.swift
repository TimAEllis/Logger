import Foundation

/// The `FieldBasedLoggerFormatter` provides a simple interface for constructing
/// a customized `LoggerFormatter` by specifying different *fields*.
///
/// Let's say you wanted to construct a `LoggerFormatter` that outputs the following
/// fields separated by tabs:
///
/// - The `LoggerEntry`'s `timestamp` property as a UNIX time value
/// - The `severity` of the `LoggerEntry` as a numeric value
/// - The `Payload` of the `LoggerEntry`
///
/// You could do this by constructing a `FieldBasedLoggerFormatter` as follows:
///
/// ```swift
/// let formatter = FieldBasedLoggerFormatter(fields: [
/// 	.timestamp(.unix),
/// 	.delimiter(.tab),
/// 	.severity(.numeric),
/// 	.delimiter(.tab),
/// 	.payload
/// ])
/// ```
open class FieldBasedLoggerFormatter: ConcatenatingLoggerFormatter {
	public init(fields: [Field], hardFail: Bool = false) {
		let formatters = fields.map(\.asFormatter)
		super.init(formatters: formatters, hardFail: hardFail)
	}
}

public extension FieldBasedLoggerFormatter {
	enum Field {
		/// Represents the timestamp field rendered in a specific `TimestampStyle`.
		case timestamp(TimestampStyle)
		
		/// Represents the `LoggerSeverity` field rendered in a specific `SeverityStyle`.
		case severity(SeverityStyle)
		
		/// Represents the call site field. The call site includes the filename and line number corresponding to the call site's source.
		case callSite
		
		/// Represents the stack frame of the caller. Assuming the call site is within a function, this field will contain the signature of the function.
		case stackFrame
		
		/// Represents the ID of the thread on which the call was executed. The `CallingThreadStyle` specifies how the thread ID is represented.
		case callingThread(CallingThreadStyle)
		
		/// Represents the `Payload` of a `LoggerEntry`.
		case payload
		
		/// Represents the name of the currently executing process.
		case processName
		
		/// Represents the ID of the currently executing process.
		case processID
		
		/// Represents a text delimiter. The `DelimiterStyle` specifies the content of the delimiter string.
		case delimiter(DelimiterStyle)
		
		/// Represents a string literal.
		case literal(String)
		
		/// Represents a field containing the output of the given `LoggerFormatter`.
		case custom(LoggerFormatter)
		
		fileprivate var asFormatter: LoggerFormatter {
			switch self {
			case .timestamp(let style):
				return TimestampLoggerFormatter(style: style)
			case .severity(let style):
				return SeverityLoggerFormatter(style: style)
			case .callSite:
				return CallSiteLoggerFormatter()
			case .stackFrame:
				return StackFrameLoggerFormatter()
			case .callingThread(let style):
				return CallingThreadLoggerFormatter(style: style)
			case .payload:
				return PayloadLoggerFormatter()
			case .processName:
				return ProcessNameLoggerFormatter()
			case .processID:
				return ProcessIDLoggerFormatter()
			case .delimiter(let style):
				return DelimiterLoggerFormatter(style: style)
			case .literal(let literal):
				return LiteralLoggerFormatter(literalString: literal)
			case .custom(let formatter):
				return formatter
			}
		}
	}
}

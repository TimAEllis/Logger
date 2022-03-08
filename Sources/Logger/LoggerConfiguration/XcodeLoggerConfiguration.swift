import Foundation

/// A `LoggerConfiguration` optimized for use when running within Xcode.
open class XcodeLoggerConfiguration: ConsoleLoggerConfiguration {
	/// Initializes a new `XcodeLoggerConfiguration` instance.
	/// - Parameters:
	///   - minimumSeverity: The minimum `LoggerSeverity` supported by the configuration.
	///   Log entries having a `severity` less than `minimumSeverity`
	///   will not be passed to the receiver's `recorders`.
	///   - stdStreamsMode: A `StandardStreamsMode` value that governs when standard
	///   console streams (i.e., `stdout` and `stderr`) should be used for recording log output.
	///   - mimicOSLogOutput: If `true`, any output sent to `stdout` will be formatted in such a way as to mimic the output
	///   seen when `os_log()` is used.
	///   - showCallSite: If `true`, the source file and line indicating the call site of the log request will be added to formatted
	///   log messages.
	///   - synchronousMode: Determines whether synchronous mode will be used when passing `LoggerEntry` instances to
	///   the receiver's `recorders`. Synchronous mode is helpful while debugging, as it ensures that logs are always up-to-date
	///   when debug breakpoints are hit. However, synchronous mode can have a negative influence on performance and is therefore
	///   not recommended for use in production code.
	public init(
		minimumSeverity: LoggerSeverity = .info,
		stdStreamsMode: StandardStreamsMode = .useAsFallback,
		mimicOSLogOutput: Bool = true,
		showCallSite: Bool = true,
		synchronousMode: Bool = false
	) {
		let xcodeFormatter = XcodeLoggerFormatter(showCallSite: showCallSite)
		let stdoutFormatters: [LoggerFormatter]
		if mimicOSLogOutput && stdStreamsMode.shouldUseStandardStreams {
			stdoutFormatters = [
				ConcatenatingLoggerFormatter(formatters: [
					OSLogMimicFormatter(),
					xcodeFormatter,
				])
			]
		}
		else {
			stdoutFormatters = [
				FieldBasedLoggerFormatter(fields: [
					.timestamp(.default),
					.delimiter(.spacedPipe),
					.callingThread(.hex),
					.delimiter(.space),
					.custom(xcodeFormatter),
				])
			]
		}
		super.init(
			minimumSeverity: minimumSeverity,
			stdStreamsMode: stdStreamsMode,
			osLogFormatters: [xcodeFormatter],
			stdoutFormatters: stdoutFormatters,
			synchronousMode: synchronousMode
		)
	}
}

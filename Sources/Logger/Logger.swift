import Foundation

public enum Logger {
	private static var hasEnabled: Bool = false
	private static var enableQueue: DispatchQueue = DispatchQueue(label: "TELogger.queue.enable", attributes: .concurrent)
	
	/// The `LoggerChannel` that can be used to perform logging at the `.fatal`
	/// log severity level. Will be `nil` if logging hasn't yet been enabled, or
	/// if logging for the `.fatal` severity has not been configured.
	public private(set) static var fatal: LoggerChannel?
	
	/// The `LoggerChannel` that can be used to perform logging at the `.error`
	/// log severity level. Will be `nil` if logging hasn't yet been enabled, or
	/// if logging for the `.error` severity has not been configured.
	public private(set) static var error: LoggerChannel?
	
	/// The `LoggerChannel` that can be used to perform logging at the `.warn`
	/// log severity level. Will be `nil` if logging hasn't yet been enabled, or
	/// if logging for the `.warn` severity has not been configured.
	public private(set) static var warn: LoggerChannel?
	
	/// The `LoggerChannel` that can be used to perform logging at the `.info`
	/// log severity level. Will be `nil` if logging hasn't yet been enabled, or
	/// if logging for the `.info` severity has not been configured.
	public private(set) static var info: LoggerChannel?
	
	/// The `LoggerChannel` that can be used to perform logging at the `.debug`
	/// log severity level. Will be `nil` if logging hasn't yet been enabled, or
	/// if logging for the `.debug` severity has not been configured.
	public private(set) static var debug: LoggerChannel?
	
	/// The `LoggerChannel` that can be used to perform logging at the `.trace`
	/// log severity level. Will be `nil` if logging hasn't yet been enabled, or
	/// if logging for the `.trace` severity has not been configured.
	public private(set) static var trace: LoggerChannel?
	
	/// Enables logging using an `XcodeLoggerConfiguration`.
	///
	/// Log entries are recorded by being written to the Apple System Log and to the `stdout`/`stderr`
	/// output stream of the running process. In Xcode, log entries will appear in the console.
	///
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
	public static func enable(
		minimumSeverity: LoggerSeverity = .info,
		stdStreamsMode: ConsoleLoggerConfiguration.StandardStreamsMode = .useAsFallback,
		mimicOSLogOutput: Bool = true,
		showCallSite: Bool = true,
		synchronousMode: Bool = false
	) {
		let config = XcodeLoggerConfiguration(
			minimumSeverity: minimumSeverity,
			stdStreamsMode: stdStreamsMode,
			mimicOSLogOutput: mimicOSLogOutput,
			showCallSite: showCallSite,
			synchronousMode: synchronousMode
		)
		enable(configuration: config)
	}
	
	public static func enable(configuration: LoggerConfiguration) {
		enable(
			receptacle: LoggerReceptacle(configuration: configuration)
		)
	}
	
	public static func enable(configurations: [LoggerConfiguration]) {
		enable(
			receptacle: LoggerReceptacle(configurations: configurations)
		)
	}
	
	public static func enable(receptacle: LoggerReceptacle) {
		enable(
			fatalChannel: generateLogChannel(severity: .fatal, receptacle: receptacle),
			errorChannel: generateLogChannel(severity: .error, receptacle: receptacle),
			warnChannel: generateLogChannel(severity: .warn, receptacle: receptacle),
			infoChannel: generateLogChannel(severity: .info, receptacle: receptacle),
			debugChannel: generateLogChannel(severity: .debug, receptacle: receptacle),
			traceChannel: generateLogChannel(severity: .trace, receptacle: receptacle)
		)
	}
	
	public static func enable(
		fatalChannel: LoggerChannel?,
		errorChannel: LoggerChannel?,
		warnChannel: LoggerChannel?,
		infoChannel: LoggerChannel?,
		debugChannel: LoggerChannel?,
		traceChannel: LoggerChannel?
	) {
		enableQueue.sync(flags: .barrier) {
			guard !hasEnabled else { return }
			self.fatal = fatalChannel
			self.error = errorChannel
			self.warn = warnChannel
			self.info = infoChannel
			self.debug = debugChannel
			self.trace = traceChannel
			hasEnabled = true
		}
	}
}

private extension Logger {
	static func generateLogChannel(severity: LoggerSeverity, receptacle: LoggerReceptacle) -> LoggerChannel? {
		guard severity >= receptacle.minimumSeverity else { return nil }
		return LoggerChannel(
			severity: severity,
			receptacle: receptacle
		)
	}
}

import Foundation

/// Basic implementation of the `LoggerConfiguration` protocol
open class LoggerConfigurationBase: LoggerConfiguration {
	/// The minimum `LoggerSeverity` supported by the configuration.
	public let minimumSeverity: LoggerSeverity
	
	/// The `LoggerRecorder`s to use for recording any `LoggerEntry` that has passed the filtering process.
	public let recorders: [LoggerRecorder]
	
	/// A flag indicating whether synchronous mode will be used when passing
	/// `LoggerEntry` instances to the receiver's `recorders`. Synchronous mode is
	/// helpful while debugging, as it ensures that logs are always up-to-date
	/// when debug breakpoints are hit. However, synchronous mode can have a
	/// negative influence on performance and is therefore not recommended for use
	/// in production code.
	public let synchronousMode: Bool
	
	/// Initializes a new `LoggerConfigurationBase` instance.
	/// - Parameters:
	///   - minimumSeverity: The minimum `LoggerSeverity` supported by the configuration.
	///   Log entries having a `severity` less than `minimumSeverity`
	///   will not be passed to the receiver's `recorders`.
	///   - recorders: The `LoggerRecorder`s to use for recording any `LoggerEntry` that has passed the filtering process.
	///   - synchronousMode: Determines whether synchronous mode will be used when passing `LoggerEntry` instances to
	///   the receiver's `recorders`. Synchronous mode is helpful while debugging, as it ensures that logs are always up-to-date
	///   when debug breakpoints are hit. However, synchronous mode can have a negative influence on performance and is therefore
	///   not recommended for use in production code.
	public init(minimumSeverity: LoggerSeverity = .info, recorders: [LoggerRecorder] = [], synchronousMode: Bool = false) {
		self.minimumSeverity = minimumSeverity
		self.recorders = recorders
		self.synchronousMode = synchronousMode
	}
}

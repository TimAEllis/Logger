import Foundation

public protocol LoggerConfiguration {
	/// The minimum `LoggerSeverity` supported by the configuration.
	var minimumSeverity: LoggerSeverity { get }
	
	/// The `LoggerRecorder`s to use for recording any `LoggerEntry` that has passed the filtering process.
	var recorders: [LoggerRecorder]  { get }
	
	/// A flag indicating whether synchronous mode will be used when passing
	/// `LoggerEntry` instances to the receiver's `recorders`. Synchronous mode is
	/// helpful while debugging, as it ensures that logs are always up-to-date
	/// when debug breakpoints are hit. However, synchronous mode can have a
	/// negative influence on performance and is therefore not recommended for use
	/// in production code.
	var synchronousMode: Bool  { get }
}

public extension LoggerConfiguration {
	var synchronousMode: Bool  { false }
}

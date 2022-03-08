import Foundation

public struct LoggerChannel {
	/// The `LoggerSeverity` of this `LoggerChannel`, which determines the severity
	/// of the `LoggerEntry` instances it creates.
	public let severity: LoggerSeverity
	
	/// The `LoggerReceptacle` into which this `LoggerChannel` will deposit the
	/// `LoggerEntry` instances it creates.
	public let receptacle: LoggerReceptacle
	
	public init(severity: LoggerSeverity, receptacle: LoggerReceptacle) {
		self.severity = severity
		self.receptacle = receptacle
	}
	
	/// Sends program execution trace information to the log using the receiver's
	/// severity. This information includes source-level call site information as
	/// well as the stack frame signature of the caller.
	/// - Parameters:
	///   - function: The default value provided for this parameter captures the signature of
	///   the calling function. You should not provide a value for this parameter.
	///   - filePath: The default value provided for this parameter captures the file path of
	///   the code issuing the call to this function. You should not provide a value for this parameter.
	///   - fileLine: The default value provided for this parameter captures the line number
	///   issuing the call to this function. You should not provide a value for this parameter.
	public func trace(_ function: String = #function, filePath: String = #file, fileLine: Int = #line) {
		receptacle.log(generateEntry(
			payload: .trace,
			function: function,
			filePath: filePath,
			fileLine: fileLine
		))
	}
	
	/// Sends a message string to the log using the receiver's severity.
	/// - Parameters:
	///   - msg: The message to send to the log.
	///   - function: The default value provided for this parameter captures the signature of
	///   the calling function. You should not provide a value for this parameter.
	///   - filePath: The default value provided for this parameter captures the file path of
	///   the code issuing the call to this function. You should not provide a value for this parameter.
	///   - fileLine: The default value provided for this parameter captures the line number
	///   issuing the call to this function. You should not provide a value for this parameter.
	public func message(_ msg: String, function: String = #function, filePath: String = #file, fileLine: Int = #line) {
		receptacle.log(generateEntry(
			payload: .message(msg),
			function: function,
			filePath: filePath,
			fileLine: fileLine
		))
	}
	
	/// Sends an arbitrary value to the log using the receiver's severity.
	/// - Parameters:
	///   - value: The value to send to the log. Determining how (and whether) arbitrary values
	///   are captured and represented will be handled by the `LoggerRecorder` implementation
	///   that is ultimately called upon to record the log entry.
	///   - function: The default value provided for this parameter captures the signature of
	///   the calling function. You should not provide a value for this parameter.
	///   - filePath: The default value provided for this parameter captures the file path of
	///   the code issuing the call to this function. You should not provide a value for this parameter.
	///   - fileLine: The default value provided for this parameter captures the line number
	///   issuing the call to this function. You should not provide a value for this parameter.
	public func value(_ value: Any?, function: String = #function, filePath: String = #file, fileLine: Int = #line) {
		receptacle.log(generateEntry(
			payload: .value(value),
			function: function,
			filePath: filePath,
			fileLine: fileLine
		))
	}
}

private extension LoggerChannel {
	func generateEntry(payload: LoggerEntry.Payload, function: String, filePath: String, fileLine: Int) -> LoggerEntry {
		var threadId: UInt64 = 0
		pthread_threadid_np(nil, &threadId)
		return LoggerEntry(
			payload: payload,
			severity: severity,
			callingFilePath: filePath,
			callingFileLine: fileLine,
			callingStackFrame: function,
			callingThreadID: threadId
		)
	}
}

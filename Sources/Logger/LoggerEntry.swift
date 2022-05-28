import Foundation

/// Represents an entry to be written to the log.
public struct LoggerEntry {
	/// The payload of the log entry.
	public let payload: Payload
	
	/// The severity of the log entry.
	public let severity: LoggerSeverity
	
	/// The path of the source file containing the calling function that issued the log request.
	public let callingFilePath: String
	
	/// The line within the source file at which the log request was issued.
	public let callingFileLine: Int
	
	/// The stack frame signature of the caller that issued the log request.
	public let callingStackFrame: String
	
	/// The ID that uniquely identifies the calling thread during its lifetime.
	/// After a thread dies, its ID is no longer meaningful; over time, thread IDs
	/// are recycled.
	public let callingThreadID: UInt64
	
	/// The time at which the `LoggerEntry` was created.
	public let timestamp: Date
	
	/// The name by which the currently executing process is known to the operating system.
	public let processName: String
	
	/// The ID that uniquely identifies the executing process during its
	/// lifetime. After a process exits, its ID is no longer meaningful; over
	/// time, process IDs are recycled.
	public let processID: Int32
	
	/// Initializer method
	/// - Parameters:
	///   - payload: The payload of the `LoggerEntry` being constructed.
	///   - severity: The `LoggerSeverity` of the message being logged.
	///   - callingFilePath: The path of the source file containing the calling function that issued the log request.
	///   - callingFileLine: The line within the source file at which the log request was issued.
	///   - callingStackFrame: The stack frame signature of the caller that issued the log request.
	///   - callingThreadID: A numeric identifier for the calling thread. Note that thread IDs are recycled over time.
	///   - timestamp: The time at which the log entry was created. Defaults to the current time if not explicitly specified.
	public init(
		payload: Payload,
		severity: LoggerSeverity,
		callingFilePath: String,
		callingFileLine: Int,
		callingStackFrame: String,
		callingThreadID: UInt64,
		timestamp: Date = Date()
	) {
		self.payload = payload
		self.severity = severity
		self.callingFilePath = callingFilePath
		self.callingFileLine = callingFileLine
		self.callingStackFrame = callingStackFrame
		self.callingThreadID = callingThreadID
		self.timestamp = timestamp
		self.processName = ProcessIdentification.current.processName
		self.processID = ProcessIdentification.current.processID
	}
}

public extension LoggerEntry {
	/// Represents the payload contained within a log entry.
	enum Payload: Encodable {
		/// The log entry is a trace call and contains no explicit payload.
		case trace
		
		/// The payload contains a text message.
		case message(String)
		
		/// The payload contains an arbitrary value, or `nil`.
		case value(Any?)
		
		private enum CodingKeys: String, CodingKey {
			case type = "payload.type"
			case value = "payload.value"
		}
		
		public func encode(to encoder: Encoder) throws {
			var container = encoder.container(keyedBy: CodingKeys.self)
			switch self {
			case .trace:
				try container.encode("trace", forKey: .type)
				try container.encodeNil(forKey: .value)
			case .message(let msg):
				try container.encode("message", forKey: .type)
				try container.encode(msg, forKey: .value)
			case .value(let val):
				try container.encode("value", forKey: .type)
				if let val = val {
					let str = String(describing: val)
					try container.encode(str, forKey: .value)
				}
				else {
					try container.encodeNil(forKey: .value)
				}
			}
		}
	}
}

internal struct ProcessIdentification {
	/// This ensures we only look up process info once.
	public static let current = ProcessIdentification()
	
	public let processName: String
	public let processID: Int32
	
	private init() {
		let process = ProcessInfo.processInfo
		processName = process.processName
		processID = process.processIdentifier
	}
}

extension LoggerEntry: Encodable {
	private enum CodingKeys: String, CodingKey {
		case payload
		case severity
		case callingFilePath
		case callingFileLine
		case callingStackFrame
		case callingThreadID
		case timestamp
		case processName
		case processID
	}
}

import Foundation

open class RemoteLoggerRecorder: LoggerRecorderBase {
	open var endpoint: URL?
	open lazy var encoder: JSONEncoder = {
		JSONEncoder()
	}()
	open lazy var urlSession: URLSession = {
		let configuration = URLSessionConfiguration.background(withIdentifier: "RemoteLoggerRecorder.session")
		configuration.httpAdditionalHeaders = [
			// https://developer.apple.com/forums/thread/89811
			"Authorization": "Bearer remote_logger",
			"User-Agent": "RemoteLoggerRecorder/1.0",
		]
		let session = URLSession(configuration: configuration)
		return session
	}()
	
	public convenience init(endpoint: URL? = nil) {
		self.init(
			formatters: [ReadableLoggerFormatter()],
			queue: .global()
		)
		self.endpoint = endpoint
	}
	
	open func serialize(entry: LoggerEntry) -> URLRequest? {
		guard let endpoint = endpoint else { return nil }
		do {
			var urlRequest = URLRequest(url: endpoint)
			urlRequest.httpMethod = "POST"
			urlRequest.httpBody = try encoder.encode(entry)
			return urlRequest
		}
		catch let error {
			print("‼️ Failed to serialize entry: \(error)")
			return nil
		}
	}
	
	open override func record(message: String, for entry: LoggerEntry, currentQueue: DispatchQueue, synchronousMode: Bool) {
	}
}

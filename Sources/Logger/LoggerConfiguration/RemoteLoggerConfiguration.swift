import Foundation

open class RemoteLoggerConfiguration: LoggerConfigurationBase {
    let remoteRecorder: RemoteLoggerRecorder
    
	public override init(minimumSeverity: LoggerSeverity = .warn, recorders: [LoggerRecorder] = [], synchronousMode: Bool = false) {
		var recorders = recorders
        self.remoteRecorder = RemoteLoggerRecorder()
        recorders.append(self.remoteRecorder)
		super.init(
			minimumSeverity: minimumSeverity,
			recorders: recorders,
			synchronousMode: synchronousMode
		)
	}
    
    @discardableResult func setEndpoint(_ endpoint: URL) -> Self {
        self.remoteRecorder.endpoint = endpoint
        return self
    }
}

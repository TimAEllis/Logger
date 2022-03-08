import Foundation

open class RemoteLoggerConfiguration: LoggerConfigurationBase {
	public override init(minimumSeverity: LoggerSeverity = .warn, recorders: [LoggerRecorder] = [], synchronousMode: Bool = false) {
		var recorders = recorders
		recorders.append(RemoteLoggerRecorder())
		super.init(
			minimumSeverity: minimumSeverity,
			recorders: recorders,
			synchronousMode: synchronousMode
		)
	}
}

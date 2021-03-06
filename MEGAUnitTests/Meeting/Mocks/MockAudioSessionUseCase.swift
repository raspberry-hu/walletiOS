
@testable import MEGA

final class MockAudioSessionUseCase: AudioSessionUseCaseProtocol {
    var isBluetoothAudioRouteAvailable: Bool = false
    var currentSelectedAudioPort: AudioPort = .builtInReceiver
    var audioPortOutput: AudioPort = .builtInReceiver
    var enableLoudSpeaker_calledTimes = 0
    var disableLoudSpeaker_calledTimes = 0
    var configureAudioSession_calledTimes = 0

    func enableLoudSpeaker(completion: @escaping (Result<Void, AudioSessionErrorEntity>) -> Void) {
        enableLoudSpeaker_calledTimes += 1
    }
    
    func disableLoudSpeaker(completion: @escaping (Result<Void, AudioSessionErrorEntity>) -> Void) {
        disableLoudSpeaker_calledTimes += 1
    }
    
    func isOutputFrom(port: AudioPort) -> Bool {
        return port == audioPortOutput
    }
    
    func routeChanged(handler: ((AudioSessionRouteChangedReason, AudioPort?) -> Void)?) {}
    
    func configureAudioSession() {
        configureAudioSession_calledTimes += 1
    }
}

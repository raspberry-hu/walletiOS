
enum AudioSessionRouteChangedReason {
    case unknown
    case newDeviceAvailable
    case oldDeviceUnavailable
    case categoryChange
    case override
    case wakeFromSleep
    case noSuitableRouteForCategory
    case routeConfigurationChange

}

enum AudioPort {
    case unknown
    case builtInReceiver
    case builtInSpeaker
    case headphones
    case other
}

protocol AudioSessionRepositoryProtocol {
    var isBluetoothAudioRouteAvailable: Bool { get }
    var currentSelectedAudioPort: AudioPort { get }
    func configureAudioSession()
    var routeChanged: ((_ reason: AudioSessionRouteChangedReason, _ previousAudioPort: AudioPort?) -> Void)? { get set }
    func enableLoudSpeaker(completion: @escaping (Result<Void, AudioSessionErrorEntity>) -> Void)
    func disableLoudSpeaker(completion: @escaping (Result<Void, AudioSessionErrorEntity>) -> Void)
    func isOutputFrom(port: AudioPort) -> Bool
}

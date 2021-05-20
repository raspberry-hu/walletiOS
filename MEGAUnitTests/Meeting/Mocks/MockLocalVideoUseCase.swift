@testable import MEGA

class MockCallsLocalVideoUseCase: CallsLocalVideoUseCaseProtocol {
    var enableDisableVideoCompletion: Result<Void, CallsErrorEntity> = .success(())
    var videoDeviceSelectedString: String?
    var addLocalVideo_CalledTimes = 0
    var removeLocalVideo_CalledTimes = 0
    var selectedCamera_calledTimes = 0

    func enableLocalVideo(for chatId: MEGAHandle, completion: @escaping (Result<Void, CallsErrorEntity>) -> Void) {
        completion(enableDisableVideoCompletion)
    }
    
    func disableLocalVideo(for chatId: MEGAHandle, completion: @escaping (Result<Void, CallsErrorEntity>) -> Void) {
        completion(enableDisableVideoCompletion)
    }
    
    func addLocalVideo(for chatId: MEGAHandle, callbacksDelegate: CallsLocalVideoCallbacksUseCaseProtocol) {
        addLocalVideo_CalledTimes += 1
    }
    
    func removeLocalVideo(for chatId: MEGAHandle, callbacksDelegate: CallsLocalVideoCallbacksUseCaseProtocol) {
        removeLocalVideo_CalledTimes += 1
    }
    
    func videoDeviceSelected() -> String? {
        return videoDeviceSelectedString
    }
    
    func selectCamera(withLocalizedName localizedName: String) {
        selectedCamera_calledTimes += 1
    }
}
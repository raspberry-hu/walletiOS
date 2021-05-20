@testable import MEGA

struct MockUserUseCase: UserUseCaseProtocol {
    let handle: UInt64
    var hasUserLoggedIn: Bool = true

    var myHandle: UInt64? {
        return handle
    }
    
    func user(withHandle handle: UInt64) -> UserSDKEntity? {
        return UserSDKEntity(email: "", handle: handle, base64Handle: nil, change: nil, contact: nil)
    }
}
import Foundation

protocol MeetingCreatingViewRouting: Routing {
    func dismiss(completion: @escaping () -> Void)
    func goToMeetingRoom(chatRoom: ChatRoomEntity, call: CallEntity, isVideoEnabled: Bool)
    func openChatRoom(withChatId chatId: UInt64)
}

class MeetingCreatingViewRouter: NSObject, MeetingCreatingViewRouting {
    private weak var baseViewController: UIViewController?
    private weak var viewControllerToPresent: UIViewController?
    private let type: MeetingConfigurationType
    private let link: String?
    
    @objc init(viewControllerToPresent: UIViewController, type: MeetingConfigurationType, link: String?) {
        self.viewControllerToPresent = viewControllerToPresent
        self.type = type
        self.link = link
    }
    
    @objc func build() -> UIViewController {
        let vm = MeetingCreatingViewModel(router: self, type: type, meetingUseCase: MeetingCreatingUseCase(repository: MeetingCreatingRepository()), link: link)
        let vc = MeetingCreatingViewController(viewModel: vm)
        baseViewController = vc
        return vc
    }
    
    @objc func start() {
        guard let viewControllerToPresent = viewControllerToPresent else {
            return
        }
        let nav = UINavigationController(rootViewController: build())
        if #available(iOS 13.0, *) {
            nav.overrideUserInterfaceStyle = .dark
        }
        nav.modalPresentationStyle = .fullScreen
        viewControllerToPresent.present(nav, animated: true, completion: nil)
    }
    
    // MARK: - UI Actions
    func dismiss(completion: @escaping () -> Void) {
        baseViewController?.dismiss(animated: true, completion: completion)
    }
    
    func openChatRoom(withChatId chatId: UInt64) {
        viewControllerToPresent?.present(MEGANavigationController(rootViewController: ChatViewController(chatId: chatId)),
                           animated: true)
    }

    func goToMeetingRoom(chatRoom: ChatRoomEntity, call: CallEntity, isVideoEnabled: Bool) {
     guard let viewControllerToPresent = viewControllerToPresent else {
            return
        }
        MeetingContainerRouter(presenter: viewControllerToPresent, chatRoom: chatRoom, call: call, isVideoEnabled: isVideoEnabled).start()
    }
    
}
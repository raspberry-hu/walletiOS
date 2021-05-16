
final class MeetingParticipantsLayoutRouter: NSObject, MeetingParticipantsLayoutRouting {
    private weak var baseViewController: UIViewController?
    private weak var presenter: UINavigationController?
    private weak var navigationController: UINavigationController?
    private weak var containerViewModel: MeetingContainerViewModel?
    private(set) weak var viewModel: MeetingParticipantsLayoutViewModel?
    
    private let chatRoom: ChatRoomEntity
    private let call: CallEntity
    private var initialVideoCall: Bool

    init(presenter: UINavigationController, containerViewModel: MeetingContainerViewModel, chatRoom: ChatRoomEntity, call: CallEntity, initialVideoCall: Bool = false) {
        self.presenter = presenter
        self.containerViewModel = containerViewModel
        self.chatRoom = chatRoom
        self.call = call
        self.initialVideoCall = initialVideoCall
        super.init()
    }
    
    func build() -> UIViewController {
        guard let containerViewModel = containerViewModel else { return UIViewController() }
        let vm = MeetingParticipantsLayoutViewModel(router: self,
                               containerViewModel: containerViewModel,
                               callManager: CallManagerUseCase(),
                               callsUseCase: CallsUseCase(repository: CallsRepository()),
                               captureDeviceUseCase: CaptureDeviceUseCase(repo: CaptureDeviceRepository()),
                               localVideoUseCase: CallsLocalVideoUseCase(repository: CallsLocalVideoRepository()),
                               remoteVideoUseCase: CallsRemoteVideoUseCase(repository: CallsRemoteVideoRepository()),
                               chatRoomUseCase: ChatRoomUseCase(chatRoomRepo: ChatRoomRepository(sdk: MEGASdkManager.sharedMEGAChatSdk()),
                                                                userStoreRepo: UserStoreRepository(store: MEGAStore.shareInstance())),
                               chatRoom: chatRoom,
                               call: call,
                               initialVideoCall: initialVideoCall)
        
        let vc = UIStoryboard(name: "MeetingParticipantsLayout", bundle: nil).instantiateViewController(withIdentifier: "MeetingParticipantsLayoutViewControllerID") as! MeetingParticipantsLayoutViewController
        vc.viewModel = vm
        baseViewController = vc
        viewModel = vm
        return vc
    }
    
    @objc func start() {
        guard let presenter = presenter else { return }
        presenter.setViewControllers([build()], animated: true)
    }

    func dismissAndShowPasscodeIfNeeded() {
        navigationController?.dismiss(animated: true, completion: {
            if UserDefaults.standard.bool(forKey: "presentPasscodeLater") && LTHPasscodeViewController.doesPasscodeExist() {
                LTHPasscodeViewController.sharedUser()?.showLockScreenOver(UIApplication.mnz_visibleViewController().view, withAnimation: true, withLogout: false, andLogoutTitle: nil)
                UserDefaults.standard.set(false, forKey: "presentPasscodeLater")
            }
            LTHPasscodeViewController.sharedUser()?.enablePasscodeWhenApplicationEntersBackground()
        })
    }
    
    func showRenameChatAlert() {
        viewModel?.dispatch(.showRenameChatAlert)
    }
}

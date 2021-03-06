
protocol MeetingParticipantsLayoutRouting: Routing {
    func showRenameChatAlert()
}

enum CallViewAction: ActionType {
    case onViewLoaded
    case onViewReady
    case tapOnView(onParticipantsView: Bool)
    case tapOnLayoutModeButton
    case tapOnOptionsMenuButton(presenter: UIViewController, sender: UIBarButtonItem)
    case tapOnBackButton
    case switchIphoneOrientation(_ orientation: DeviceOrientation)
    case showRenameChatAlert
    case setNewTitle(String)
    case discardChangeTitle
    case renameTitleDidChange(String)
    case tapParticipantToPinAsSpeaker(CallParticipantEntity, IndexPath)
    case fetchAvatar(participant: CallParticipantEntity)
    case fetchSpeakerAvatar
    case particpantIsVisible(_ participant: CallParticipantEntity, index: Int)
    case indexVisibleParticipants([Int])
}

enum ParticipantsLayoutMode {
    case grid
    case speaker
}

enum DeviceOrientation {
    case landscape
    case portrait
}

private enum CallViewModelConstant {
    static let maxParticipantsCountForHighResolution = 5
}

final class MeetingParticipantsLayoutViewModel: NSObject, ViewModelType {
    enum Command: CommandType, Equatable {
        case configView(title: String, subtitle: String, isUserAGuest: Bool, isOneToOne: Bool)
        case configLocalUserView(position: CameraPositionEntity)
        case switchMenusVisibility
        case enableLayoutButton(Bool)
        case switchLayoutMode(layout: ParticipantsLayoutMode, participantsCount: Int)
        case switchLocalVideo
        case updateName(String)
        case updateDuration(String)
        case updatePageControl(Int)
        case insertParticipant([CallParticipantEntity])
        case deleteParticipantAt(Int, [CallParticipantEntity])
        case reloadParticipantAt(Int, [CallParticipantEntity])
        case updateSpeakerViewFor(CallParticipantEntity?)
        case localVideoFrame(Int, Int, Data)
        case participantAdded(String)
        case participantRemoved(String)
        case reconnecting
        case reconnected
        case updateCameraPositionTo(position: CameraPositionEntity)
        case updatedCameraPosition
        case showRenameAlert(title: String, isMeeting: Bool)
        case enableRenameButton(Bool)
        case showNoOneElseHereMessage
        case showWaitingForOthersMessage
        case hideEmptyRoomMessage
        case updateHasLocalAudio(Bool)
        case selectPinnedCellAt(IndexPath?)
        case shouldHideSpeakerView(Bool)
        case ownPrivilegeChangedToModerator
        case lowNetworkQuality
        case updateAvatar(UIImage, CallParticipantEntity)
        case updateSpeakerAvatar(UIImage)
        case updateMyAvatar(UIImage)
    }
    
    private let router: MeetingParticipantsLayoutRouting
    private var chatRoom: ChatRoomEntity
    private var call: CallEntity
    private var timer: Timer?
    private var callDurationInfo: CallDurationInfo?
    private var callParticipants = [CallParticipantEntity]()
    private var indexOfVisibleParticipants = [Int]()
    private var speakerParticipant: CallParticipantEntity? {
        didSet(newValue) {
            invokeCommand?(.updateSpeakerViewFor(speakerParticipant))
        }
    }
    private var isSpeakerParticipantPinned: Bool = false
    internal var layoutMode: ParticipantsLayoutMode = .grid
    private var localVideoEnabled: Bool = false
    private var reconnecting: Bool = false
    private var switchingCamera: Bool = false
    private weak var containerViewModel: MeetingContainerViewModel?

    private let callUseCase: CallUseCaseProtocol
    private let captureDeviceUseCase: CaptureDeviceUseCaseProtocol
    private let localVideoUseCase: CallLocalVideoUseCaseProtocol
    private let remoteVideoUseCase: CallRemoteVideoUseCaseProtocol
    private let chatRoomUseCase: ChatRoomUseCaseProtocol
    private let userUseCase: UserUseCaseProtocol
    private let userImageUseCase: UserImageUseCaseProtocol

    // MARK: - Internal properties
    var invokeCommand: ((Command) -> Void)?
    
    init(router: MeetingParticipantsLayoutRouting,
         containerViewModel: MeetingContainerViewModel,
         callUseCase: CallUseCaseProtocol,
         captureDeviceUseCase: CaptureDeviceUseCaseProtocol,
         localVideoUseCase: CallLocalVideoUseCaseProtocol,
         remoteVideoUseCase: CallRemoteVideoUseCaseProtocol,
         chatRoomUseCase: ChatRoomUseCaseProtocol,
         userUseCase: UserUseCaseProtocol,
         userImageUseCase: UserImageUseCaseProtocol,
         chatRoom: ChatRoomEntity,
         call: CallEntity) {
        
        self.router = router
        self.containerViewModel = containerViewModel
        self.callUseCase = callUseCase
        self.captureDeviceUseCase = captureDeviceUseCase
        self.localVideoUseCase = localVideoUseCase
        self.remoteVideoUseCase = remoteVideoUseCase
        self.chatRoomUseCase = chatRoomUseCase
        self.userUseCase = userUseCase
        self.userImageUseCase = userImageUseCase
        self.chatRoom = chatRoom
        self.call = call

        super.init()
    }
    
    deinit {
        callUseCase.stopListeningForCall()
    }
    
    private func initTimerIfNeeded(with duration: Int) {
        if timer == nil {
            let callDurationInfo = CallDurationInfo(initDuration: duration, baseDate: Date())
            let timer = Timer(timeInterval: 1, repeats: true, block: { [weak self] (timer) in
                let duration = Int(Date().timeIntervalSince1970) - Int(callDurationInfo.baseDate.timeIntervalSince1970) + callDurationInfo.initDuration
                self?.invokeCommand?(.updateDuration(NSString.mnz_string(fromTimeInterval: TimeInterval(duration))))
            })
            RunLoop.main.add(timer, forMode: .common)
            self.timer = timer
        }
    }
    
    private func forceGridLayout() {
        if layoutMode == .grid {
            return
        }
        layoutMode = .grid
        invokeCommand?(.switchLayoutMode(layout: layoutMode, participantsCount: callParticipants.count))
    }
    
    private func switchLayout() {
        MEGALogDebug("Switch meetings layout from \(layoutMode == .grid ? "grid" : "speaker") to \(layoutMode == .grid ? "speaker" : "grid")")
        callParticipants.forEach { $0.videoDataDelegate = nil }
        if layoutMode == .grid {
            layoutMode = .speaker
        } else {
            layoutMode = .grid
        }
        if speakerParticipant == nil {
            speakerParticipant = callParticipants.first
        }
        
        invokeCommand?(.switchLayoutMode(layout: layoutMode, participantsCount: callParticipants.count))
    }
    
    private func reloadParticipant(_ participant: CallParticipantEntity) {
        guard let index = callParticipants.firstIndex(of: participant) else { return }
        invokeCommand?(.reloadParticipantAt(index, callParticipants))
        
        guard let currentSpeaker = speakerParticipant, currentSpeaker == participant else {
            return
        }
        speakerParticipant = participant
    }
    
    private func enableRemoteVideo(for participant: CallParticipantEntity) {
        switch layoutMode {
        case .grid:
            if participant.isVideoHiRes && participant.canReceiveVideoHiRes {
                remoteVideoUseCase.enableRemoteVideo(for: participant)
            } else if participant.isVideoLowRes && participant.canReceiveVideoLowRes {
                switchVideoResolutionLowToHigh(for: participant.clientId, in: chatRoom.chatId)
            } else {
                remoteVideoUseCase.requestHighResolutionVideo(for: chatRoom.chatId, clientId: participant.clientId, completion: nil)
            }
        case .speaker:
            if participant.speakerVideoDataDelegate == nil {
                if participant.isVideoLowRes && participant.canReceiveVideoLowRes {
                    remoteVideoUseCase.enableRemoteVideo(for: participant)
                } else if participant.isVideoHiRes && participant.canReceiveVideoHiRes {
                    switchVideoResolutionHighToLow(for: participant.clientId, in: chatRoom.chatId)
                } else {
                    remoteVideoUseCase.requestLowResolutionVideos(for: chatRoom.chatId, clientId: participant.clientId, completion: nil)
                }
            } else {
                if participant.isVideoHiRes && participant.canReceiveVideoHiRes {
                    remoteVideoUseCase.enableRemoteVideo(for: participant)
                } else if participant.isVideoLowRes && participant.canReceiveVideoLowRes {
                    switchVideoResolutionLowToHigh(for: participant.clientId, in: chatRoom.chatId)
                } else {
                    remoteVideoUseCase.requestHighResolutionVideo(for: chatRoom.chatId, clientId: participant.clientId, completion: nil)
                }
            }
        }
    }
    
    private func disableRemoteVideo(for participant: CallParticipantEntity) {
        remoteVideoUseCase.disableRemoteVideo(for: participant)
    }
    
    private func fetchAvatar(for participant: CallParticipantEntity, name: String, completion: @escaping ((UIImage) -> Void)) {
        userImageUseCase.fetchUserAvatar(withUserHandle: participant.participantId, name: name) { result in
            switch result {
            case .success(let image):
                completion(image)
            case .failure(_):
                MEGALogError("Error fetching avatar for participant \(MEGASdk.base64Handle(forUserHandle: participant.participantId) ?? "No name")")
            }
        }
    }
    
    private func participantName(for userHandle: MEGAHandle, completion: @escaping (String?) -> Void) {
        chatRoomUseCase.userDisplayName(forPeerId: userHandle, chatId: chatRoom.chatId) { result in
            switch result {
            case .success(let displayName):
                completion(displayName)
            case .failure(let error):
                MEGALogDebug("ParticipantViewModel: failed to get the user display name for \(MEGASdk.base64Handle(forUserHandle: userHandle) ?? "No name") - \(error)")
                completion(nil)
            }
        }
    }
    
    private func isBackCameraSelected() -> Bool {
        guard let selectCameraLocalizedString = captureDeviceUseCase.wideAngleCameraLocalizedName(postion: .back),
              localVideoUseCase.videoDeviceSelected() == selectCameraLocalizedString else {
            return false
        }
        
        return true
    }
    
    private func initialSubtitle() -> String {
        if call.isRinging || call.status == .joining {
            return Strings.Localizable.connecting
        } else {
            return Strings.Localizable.calling
        }
    }
    
    private func isActiveCall() -> Bool {
        callParticipants.isEmpty && !call.clientSessions.isEmpty
    }
    
    // MARK: - Dispatch action
    func dispatch(_ action: CallViewAction) {
        switch action {
        case .onViewLoaded:
            if let updatedCall = callUseCase.call(for: chatRoom.chatId) {
                call = updatedCall
            }
            if chatRoom.chatType == .meeting {
                invokeCommand?(
                    .configView(title: chatRoom.title ?? "",
                                subtitle: "",
                                isUserAGuest: userUseCase.isGuest,
                                isOneToOne: false)
                )
                initTimerIfNeeded(with: Int(call.duration))
            } else {
                invokeCommand?(
                    .configView(title: chatRoom.title ?? "",
                                subtitle: initialSubtitle(),
                                isUserAGuest: userUseCase.isGuest,
                                isOneToOne: chatRoom.chatType == .oneToOne)
                )
            }
            callUseCase.startListeningForCallInChat(chatRoom.chatId, callbacksDelegate: self)
            remoteVideoUseCase.addRemoteVideoListener(self)
            if isActiveCall() {
                callUseCase.createActiveSessions()
            } else {
                if chatRoom.chatType == .meeting {
                    invokeCommand?(.showWaitingForOthersMessage)
                }
            }
            localAvFlagsUpdated(video: call.hasLocalVideo, audio: call.hasLocalAudio)
        case .onViewReady:
            if let myself = CallParticipantEntity.myself(chatId: call.chatId) {
                fetchAvatar(for: myself, name: myself.name ?? "Unknown") { [weak self] image in
                    self?.invokeCommand?(.updateMyAvatar(image))
                }
            }
            invokeCommand?(.configLocalUserView(position: isBackCameraSelected() ? .back : .front))
        case .tapOnView(let onParticipantsView):
            if onParticipantsView && layoutMode == .speaker && !callParticipants.isEmpty {
                return
            }
            invokeCommand?(.switchMenusVisibility)
            containerViewModel?.dispatch(.changeMenuVisibility)
        case .tapOnLayoutModeButton:
            switchLayout()
        case .tapOnOptionsMenuButton(let presenter, let sender):
            containerViewModel?.dispatch(.showOptionsMenu(presenter: presenter, sender: sender, isMyselfModerator: chatRoom.ownPrivilege == .moderator))
        case .tapOnBackButton:
            callUseCase.stopListeningForCall()
            timer?.invalidate()
            remoteVideoUseCase.disableAllRemoteVideos()
            containerViewModel?.dispatch(.tapOnBackButton)
        case .switchIphoneOrientation(let orientation):
            switch orientation {
            case .landscape:
                forceGridLayout()
                invokeCommand?(.enableLayoutButton(false))
            case .portrait:
                invokeCommand?(.enableLayoutButton(true))
            }
        case .showRenameChatAlert:
            invokeCommand?(.showRenameAlert(title: chatRoom.title ?? "", isMeeting: chatRoom.chatType == .meeting))
        case .setNewTitle(let newTitle):
            chatRoomUseCase.renameChatRoom(chatId: chatRoom.chatId, title: newTitle) { [weak self] result in
                switch result {
                case .success(let title):
                    self?.invokeCommand?(.updateName(title))
                case .failure(_):
                    MEGALogDebug("Could not change the chat title")
                }
                self?.containerViewModel?.dispatch(.changeMenuVisibility)
            }
        case .discardChangeTitle:
            containerViewModel?.dispatch(.changeMenuVisibility)
        case .renameTitleDidChange(let newTitle):
            invokeCommand?(.enableRenameButton(chatRoom.title != newTitle && !newTitle.isEmpty))
        case .tapParticipantToPinAsSpeaker(let participant, let indexPath):
            tappedParticipant(participant, at: indexPath)
        case .fetchAvatar(let participant):
            participantName(for: participant.participantId) { [weak self] name in
                guard let name = name else { return }
                self?.fetchAvatar(for: participant, name: name) { [weak self] image in
                    self?.invokeCommand?(.updateAvatar(image, participant))
                }
            }
        case .fetchSpeakerAvatar:
            guard let speakerParticipant = speakerParticipant else { return }
            participantName(for: speakerParticipant.participantId) { [weak self] name in
                guard let name = name else { return }
                self?.fetchAvatar(for: speakerParticipant, name: name) { image in
                    self?.invokeCommand?(.updateSpeakerAvatar(image))
                }
            }
        case .particpantIsVisible(let participant, let index):
            if participant.video == .on {
                enableRemoteVideo(for: participant)
            } else {
                stopVideoForParticipant(participant)
            }
            indexOfVisibleParticipants.append(index)
        case .indexVisibleParticipants(let visibleIndex):
            updateVisibeParticipants(for: visibleIndex)
        }
    }
    
    private func updateVisibeParticipants(for visibleIndex: [Int]) {
        indexOfVisibleParticipants.forEach {
            if !visibleIndex.contains($0),
               let participant = callParticipants[safe: $0] {
                if participant.video == .on && participant.speakerVideoDataDelegate == nil {
                    stopVideoForParticipant(participant)
                }
            }
        }
        indexOfVisibleParticipants = visibleIndex
    }
    
    private func stopVideoForParticipant(_ participant: CallParticipantEntity) {
        if participant.canReceiveVideoLowRes {
            remoteVideoUseCase.stopLowResolutionVideo(for: chatRoom.chatId, clientId: participant.clientId, completion: nil)
        } else if participant.canReceiveVideoHiRes {
            remoteVideoUseCase.stopHighResolutionVideo(for: chatRoom.chatId, clientId: participant.clientId, completion: nil)
        }
    }
    
    private func tappedParticipant(_ participant: CallParticipantEntity, at indexPath: IndexPath) {
        if !isSpeakerParticipantPinned || (isSpeakerParticipantPinned && speakerParticipant != participant) {
            if let currentSpeaker = speakerParticipant, currentSpeaker != participant {
                if currentSpeaker.video == .on && currentSpeaker.isVideoHiRes && currentSpeaker.canReceiveVideoHiRes {
                    switchVideoResolutionHighToLow(for: currentSpeaker.clientId, in: chatRoom.chatId)
                }
            }
            speakerParticipant?.speakerVideoDataDelegate = nil
            speakerParticipant?.isSpeakerPinned = false
            isSpeakerParticipantPinned = true
            participant.isSpeakerPinned = true
            speakerParticipant = participant
            if participant.video == .on && participant.isVideoLowRes && participant.canReceiveVideoLowRes {
                switchVideoResolutionLowToHigh(for: participant.clientId, in: chatRoom.chatId)
            }
            invokeCommand?(.selectPinnedCellAt(indexPath))
        } else {
            participant.isSpeakerPinned = false
            isSpeakerParticipantPinned = false
            invokeCommand?(.selectPinnedCellAt(nil))
        }
    }
    
    private func switchVideoResolutionHighToLow(for clientId: MEGAHandle, in chatId: MEGAHandle) {
        
        remoteVideoUseCase.stopHighResolutionVideo(for: chatRoom.chatId, clientId: clientId) {  [weak self] result in
            switch result {
            case .success:
                self?.remoteVideoUseCase.requestLowResolutionVideos(for: chatId, clientId: clientId, completion: nil)
            case .failure(_):
                break
            }
        }
    }
    
    private func switchVideoResolutionLowToHigh(for clientId: MEGAHandle, in chatId: MEGAHandle) {
        remoteVideoUseCase.stopLowResolutionVideo(for: chatRoom.chatId, clientId: clientId) { [weak self] result in
            switch result {
            case .success:
                self?.remoteVideoUseCase.requestHighResolutionVideo(for: chatId, clientId: clientId, completion: nil)
            case .failure(_):
                break
            }
        }
    }
}

struct CallDurationInfo {
    let initDuration: Int
    let baseDate: Date
}

extension MeetingParticipantsLayoutViewModel: CallCallbacksUseCaseProtocol {
    func participantJoined(participant: CallParticipantEntity) {
        initTimerIfNeeded(with: Int(call.duration))
        participantName(for: participant.participantId) { [weak self] in
            participant.name = $0
            self?.callParticipants.append(participant)
            self?.invokeCommand?(.insertParticipant(self?.callParticipants ?? []))
            if self?.callParticipants.count == 1 && self?.layoutMode == .speaker {
                self?.invokeCommand?(.shouldHideSpeakerView(false))
                self?.speakerParticipant = self?.callParticipants.first
            }
            if self?.layoutMode == .grid {
                self?.invokeCommand?(.updatePageControl(self?.callParticipants.count ?? 0))
            }
            self?.invokeCommand?(.hideEmptyRoomMessage)
        }
    }
    
    func participantLeft(participant: CallParticipantEntity) {
        if callUseCase.call(for: call.chatId) == nil {
            callTerminated(call)
        } else if let index = callParticipants.firstIndex(of: participant) {
            callParticipants.remove(at: index)
            invokeCommand?(.deleteParticipantAt(index, callParticipants))
            stopVideoForParticipant(participant)
            
            if callParticipants.isEmpty {
                if chatRoom.chatType == .meeting && !reconnecting {
                    invokeCommand?(.showNoOneElseHereMessage)
                }
                if layoutMode == .speaker {
                    invokeCommand?(.shouldHideSpeakerView(true))
                }
            }
            
            if layoutMode == .grid {
                invokeCommand?(.updatePageControl(callParticipants.count))
            }
            
            guard let currentSpeaker = speakerParticipant, currentSpeaker == participant else {
                return
            }
            isSpeakerParticipantPinned = false
            speakerParticipant = callParticipants.first
        } else {
            MEGALogError("Error removing participant from call")
        }
    }
    
    func updateParticipant(_ participant: CallParticipantEntity) {
        guard let participantUpdated = callParticipants.filter({$0 == participant}).first else {
            MEGALogError("Error getting participant updated")
            return
        }

        participantUpdated.video = participant.video
        participantUpdated.isVideoLowRes = participant.isVideoLowRes
        participantUpdated.isVideoHiRes = participant.isVideoHiRes
        participantUpdated.audio = participant.audio
        
        reloadParticipant(participantUpdated)
    }
    
    func highResolutionChanged(for participant: CallParticipantEntity) {
        guard let participantUpdated = callParticipants.filter({$0 == participant}).first else {
            MEGALogError("Error getting participant updated with video high resolution")
            return
        }
        
        participantUpdated.canReceiveVideoHiRes = participant.canReceiveVideoHiRes
        
        if participantUpdated.canReceiveVideoHiRes {
            enableRemoteVideo(for: participantUpdated)
        } else {
            disableRemoteVideo(for: participantUpdated)
        }
    }
    
    func lowResolutionChanged(for participant: CallParticipantEntity) {
        guard let participantUpdated = callParticipants.filter({$0 == participant}).first else {
            MEGALogError("Error getting participant updated with video low resolution")
            return
        }
        
        participantUpdated.canReceiveVideoLowRes = participant.canReceiveVideoLowRes

        if participantUpdated.canReceiveVideoLowRes {
            enableRemoteVideo(for: participantUpdated)
        } else {
            disableRemoteVideo(for: participantUpdated)
        }
    }
    
    func audioLevel(for participant: CallParticipantEntity) {
        if isSpeakerParticipantPinned || layoutMode == .grid {
            return
        }
        guard let participantWithAudio = callParticipants.filter({$0 == participant}).first else {
            MEGALogError("Error getting participant with audio")
            return
        }
        if let currentSpeaker = speakerParticipant {
            if currentSpeaker != participantWithAudio {
                currentSpeaker.speakerVideoDataDelegate = nil
                speakerParticipant = participantWithAudio
                if currentSpeaker.video == .on && currentSpeaker.isVideoHiRes && currentSpeaker.canReceiveVideoHiRes {
                    switchVideoResolutionHighToLow(for: currentSpeaker.clientId, in: chatRoom.chatId)
                }
                if participantWithAudio.video == .on && participantWithAudio.isVideoLowRes && participantWithAudio.canReceiveVideoLowRes {
                    switchVideoResolutionLowToHigh(for: participantWithAudio.clientId, in: chatRoom.chatId)
                }
            }
        } else {
            speakerParticipant = participantWithAudio
            if participantWithAudio.video == .on && participantWithAudio.canReceiveVideoLowRes {
                switchVideoResolutionLowToHigh(for: participantWithAudio.clientId, in: chatRoom.chatId)
            }
        }
    }
    
    func callTerminated(_ call: CallEntity) {
        callUseCase.stopListeningForCall()
        timer?.invalidate()
        if (call.termCodeType == .tooManyParticipants)  {
            containerViewModel?.dispatch(.dismissCall(completion: {
                SVProgressHUD.showError(withStatus: Strings.Localizable.Error.noMoreParticipantsAreAllowedInThisGroupCall)
            }))
        }
    }
    
    func participantAdded(with handle: MEGAHandle) {
        participantName(for: handle) { [weak self] displayName in
            guard let displayName = displayName else { return }
            self?.invokeCommand?(.participantAdded(displayName))
        }
    }
    
    func participantRemoved(with handle: MEGAHandle) {
        participantName(for: handle) { [weak self] displayName in
            guard let displayName = displayName else { return }
            self?.invokeCommand?(.participantRemoved(displayName))
        }
    }
    
    func connecting() {
        if !reconnecting {
            reconnecting = true
            invokeCommand?(.reconnecting)
            invokeCommand?(.hideEmptyRoomMessage)
        }
    }
    
    func inProgress() {
        if reconnecting {
            invokeCommand?(.reconnected)
            reconnecting = false
            if callParticipants.isEmpty {
                invokeCommand?(.showNoOneElseHereMessage)
            }
        }
    }
    
    func localAvFlagsUpdated(video: Bool, audio: Bool) {
        if localVideoEnabled != video {
            if localVideoEnabled {
                localVideoUseCase.removeLocalVideo(for: chatRoom.chatId, callbacksDelegate: self)
            } else {
                localVideoUseCase.addLocalVideo(for: chatRoom.chatId, callbacksDelegate: self)
            }
            localVideoEnabled = video
            invokeCommand?(.switchLocalVideo)
        }
        invokeCommand?(.updateHasLocalAudio(audio))
    }
    
    func ownPrivilegeChanged(to privilege: ChatRoomEntity.Privilege, in chatRoom: ChatRoomEntity) {
        if self.chatRoom.ownPrivilege != chatRoom.ownPrivilege && privilege == .moderator {
            invokeCommand?(.ownPrivilegeChangedToModerator)
        }
        self.chatRoom = chatRoom
    }
    
    func chatTitleChanged(chatRoom: ChatRoomEntity) {
        self.chatRoom = chatRoom
        guard let title = chatRoom.title else { return }
        invokeCommand?(.updateName(title))
    }
    
    func networkQuality() {
        invokeCommand?(.lowNetworkQuality)
    }
}

extension MeetingParticipantsLayoutViewModel: CallLocalVideoCallbacksUseCaseProtocol {
    func localVideoFrameData(width: Int, height: Int, buffer: Data) {
        invokeCommand?(.localVideoFrame(width, height, buffer))
        
        if switchingCamera {
            switchingCamera = false
            invokeCommand?(.updatedCameraPosition)
        }
    }
    
    func localVideoChangedCameraPosition() {
        switchingCamera = true
        invokeCommand?(.updateCameraPositionTo(position: isBackCameraSelected() ? .back : .front))
    }
}

extension MeetingParticipantsLayoutViewModel: CallRemoteVideoListenerUseCaseProtocol {
    func remoteVideoFrameData(clientId: MEGAHandle, width: Int, height: Int, buffer: Data) {
        guard let participant = callParticipants.filter({ $0.clientId == clientId }).first else {
            MEGALogError("Error getting participant from remote video frame")
            return
        }
        if participant.videoDataDelegate == nil {
            guard let index = callParticipants.firstIndex(of: participant) else { return }
            invokeCommand?(.reloadParticipantAt(index, callParticipants))
        }
        participant.remoteVideoFrame(width: width, height: height, buffer: buffer)
    }
}

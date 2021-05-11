
enum CallParticipantVideoResolution {
    case low
    case high
}

protocol CallParticipantVideoDelegate {
    func frameData(width: Int, height: Int, buffer: Data!)
}

final class CallParticipantEntity: Equatable {
    enum AttendeeType {
        case moderator
        case particpant
        case guest
    }
    
    enum CallParticipantAudioVideoFlag {
        case off
        case on
        case unknown
    }
    
    let chatId: MEGAHandle
    let participantId: MEGAHandle
    let clientId: MEGAHandle
    var name: String?
    var networkQuality: Int
    var email: String?
    var attendeeType: AttendeeType
    var isInContactList: Bool
    var video: CallParticipantAudioVideoFlag = .unknown
    var audio: CallParticipantAudioVideoFlag = .unknown
    var videoResolution: CallParticipantVideoResolution = .low
    var videoDataDelegate: CallParticipantVideoDelegate?
    var speakerVideoDataDelegate: CallParticipantVideoDelegate?
    
    init(chatId: MEGAHandle,
         participantId: MEGAHandle,
         clientId: MEGAHandle,
         networkQuality: Int,
         email: String?,
         attendeeType: AttendeeType,
         isInContactList: Bool,
         video: CallParticipantAudioVideoFlag = .unknown,
         audio: CallParticipantAudioVideoFlag = .unknown) {
        self.chatId = chatId
        self.participantId = participantId
        self.clientId = clientId
        self.networkQuality = networkQuality
        self.email = email
        self.attendeeType = attendeeType
        self.isInContactList = isInContactList
        self.video = video
        self.audio = audio
    }
    
    static func == (lhs: CallParticipantEntity, rhs: CallParticipantEntity) -> Bool {
        lhs.participantId == rhs.participantId && lhs.clientId == rhs.clientId
    }
    
    func remoteVideoFrame(width: Int, height: Int, buffer: Data!) {
        videoDataDelegate?.frameData(width: width, height: height, buffer: buffer)
        speakerVideoDataDelegate?.frameData(width: width, height: height, buffer: buffer)
    }
}

extension CallParticipantEntity {
    convenience init(session: ChatSessionEntity, chatId: MEGAHandle) {
        var attendeeType: AttendeeType = .guest
        
        if let chatRoom = MEGASdkManager.sharedMEGAChatSdk().chatRoom(forChatId: chatId) {
            switch chatRoom.peerPrivilege(byHandle: session.peerId) {
            case MEGAChatRoomPrivilege.moderator.rawValue:
                attendeeType = .moderator
            case MEGAChatRoomPrivilege.standard.rawValue:
                attendeeType = .particpant
            default:
                attendeeType = .guest
            }
        }
        
        let contactList = MEGASdkManager.sharedMEGASdk().contacts()
        let isInContactList = (0..<contactList.size.intValue).compactMap(contactList.user(at:)).contains(where: { $0.handle == session.peerId })
        
        self.init(chatId: chatId,
                  participantId: session.peerId,
                  clientId: session.clientId,
                  networkQuality: 0,
                  email: MEGASdkManager.sharedMEGAChatSdk().userEmailFromCache(byUserHandle: session.peerId),
                  attendeeType: attendeeType,
                  isInContactList: isInContactList,
                  video: session.hasVideo ? .on : .off,
                  audio: session.hasAudio ? .on : .off)
    }
    
    static func myself(chatId: MEGAHandle) -> CallParticipantEntity? {
        guard let user = MEGASdkManager.sharedMEGASdk().myUser,
              let email = MEGASdkManager.sharedMEGASdk().myEmail,
              let chatRoom = MEGASdkManager.sharedMEGAChatSdk().chatRoom(forChatId: chatId) else {
            return nil
        }
        
        let participant = CallParticipantEntity(chatId: chatId,
                                                participantId: user.handle,
                                                clientId: 0,
                                                networkQuality: 0,
                                                email: email,
                                                attendeeType: ChatRoomEntity(with: chatRoom).ownPrivilege == .moderator ? .moderator : .particpant,
                                                isInContactList: false)
        
        return participant
    }
}

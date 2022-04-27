import Foundation
@testable import MEGA

extension CallEntity {
    ///Init method with default values (0, false, nil, [], ...)
    init(status: CallStatusType = .inProgress,
         chatId: MEGAHandle = 0,
         callId: MEGAHandle = 0,
         changeType: ChangeType = .noChanges,
         duration: Int64 = 0,
         initialTimestamp: Int64 = 0,
         finalTimestamp: Int64 = 0,
         hasLocalAudio: Bool = false,
         hasLocalVideo: Bool = false,
         termCodeType: TermCodeType = .invalid,
         isRinging: Bool = false,
         callCompositionChange: CompositionChangeType = .noChange,
         numberOfParticipants: Int = 0,
         isOnHold: Bool = false,
         sessionClientIds: [MEGAHandle] = [],
         clientSessions: [ChatSessionEntity] = [],
         participants: [MEGAHandle] = [],
         uuid: UUID = UUID(uuidString: "45adcd56-a31c-11eb-bcbc-0242ac130002")!) {
        self.init(status: status, chatId: chatId, callId: callId, changeTye: changeType, duration: duration, initialTimestamp: initialTimestamp, finalTimestamp: finalTimestamp, hasLocalAudio: hasLocalAudio, hasLocalVideo: hasLocalVideo, termCodeType: termCodeType, isRinging: isRinging, callCompositionChange: callCompositionChange, numberOfParticipants: numberOfParticipants, isOnHold: isOnHold, sessionClientIds: sessionClientIds, clientSessions: clientSessions, participants: participants, uuid: uuid)
    }
}

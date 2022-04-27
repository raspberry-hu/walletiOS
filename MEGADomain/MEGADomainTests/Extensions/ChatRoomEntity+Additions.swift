import Foundation
@testable import MEGA

extension ChatRoomEntity {
    ///Init method with default values (0, false, nil, [], ...)
    init(chatId: MEGAHandle = MEGAInvalidHandle,
         ownPrivilege: Privilege = .unknown,
         changeType: ChangeType = .status,
         peerCount: UInt = 0,
         title: String? = "Unit tests",
         unreadCount: Int = 0,
         userTypingHandle: MEGAHandle = MEGAInvalidHandle,
         retentionTime: UInt = 0,
         creationTimeStamp: UInt64 = 0,
         hasCustomTitle: Bool = false,
         isPublicChat: Bool = false,
         isPreview: Bool = false,
         isactive: Bool = false,
         isArchived: Bool = false,
         chatType: ChatType = .oneToOne) {
        self.init(chatId: chatId, ownPrivilege: ownPrivilege, changeType: changeType, peerCount: peerCount, authorizationToken: "", title: title, unreadCount: unreadCount, userTypingHandle: userTypingHandle, retentionTime: retentionTime, creationTimeStamp: creationTimeStamp, hasCustomTitle: hasCustomTitle, isPublicChat: isPublicChat, isPreview: isPreview, isactive: isactive, isArchived: isArchived, chatType: chatType)
    }
}

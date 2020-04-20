import UIKit
import MessageKit

class ChatViewController: MessagesViewController {

    // MARK: - Properties

    @objc var chatRoom: MEGAChatRoom! {
        didSet {
            update()
        }
    }

    @objc var publicChatLink: URL?
    @objc var publicChatWithLinkCreated: Bool = false
    var chatMessageAndAudioInputBar: ChatMessageAndAudioInputBar!
    private(set) lazy var refreshControl: UIRefreshControl = {
         let control = UIRefreshControl()
         control.addTarget(self, action: #selector(loadMoreMessages), for: .valueChanged)
         return control
     }()
    
    var messages: [ChatMessage] {
        return chatRoomDelegate.messages
    }

    var myUser: MEGAUser {
        return MEGASdkManager.sharedMEGASdk()!.myUser!
    }

    lazy var chatRoomDelegate: ChatRoomDelegate = {
        return ChatRoomDelegate(chatRoom: chatRoom,
                                messagesCollectionView: messagesCollectionView)
    }()

    lazy var audioCallBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: "audioCall"),
                               style: .done,
                               target: self,
                               action: #selector(startAudioCall))
    }()

    lazy var videoCallBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: "videoCall"),
                               style: .done,
                               target: self,
                               action: #selector(startVideoCall))
    }()

    lazy var addParticpantBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: "addContact"),
                               style: .done,
                               target: self,
                               action: #selector(addParticipant))
    }()
    

    // MARK: - Overriden methods

    override func viewDidLoad() {
        messagesCollectionView = MessagesCollectionView(frame: .zero,
                                                        collectionViewLayout: ChatViewMessagesFlowLayout())
        registerCustomCells()

        super.viewDidLoad()
        
        configureMessageCollectionView()
        update()
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        return super.collectionView(collectionView, cellForItemAt: indexPath)
    }

    func customCell(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UICollectionViewCell {

        guard let messagesDataSource = messagesCollectionView.messagesDataSource else {
              fatalError("Ouch. nil data source for messages")
          }

        let chatMessage = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView) as! ChatMessage

        if chatMessage.message.type == .attachment
            || chatMessage.message.type == .contact {
            if (chatMessage.message.nodeList?.size?.intValue ?? 0 == 1) {
                let node = chatMessage.message.nodeList.node(at: 0)!
                if (node.name!.mnz_isImagePathExtension || node.name!.mnz_isVideoPathExtension) {
                    let cell = messagesCollectionView.dequeueReusableCell(withReuseIdentifier: ChatMediaCollectionViewCell.reuseIdentifier, for: indexPath) as! ChatMediaCollectionViewCell
                    cell.configure(with: chatMessage, at: indexPath, and: messagesCollectionView)
                    return cell
                }
            }

            let cell = messagesCollectionView.dequeueReusableCell(withReuseIdentifier: ChatViewAttachmentCell.reuseIdentifier, for: indexPath) as! ChatViewAttachmentCell
            cell.configure(with: chatMessage, at: indexPath, and: messagesCollectionView)
            return cell
        } else if chatMessage.message.type == .normal && chatMessage.message.containsMEGALink() {
            let cell = messagesCollectionView.dequeueReusableCell(withReuseIdentifier: ChatRichPreviewMediaCollectionViewCell.reuseIdentifier, for: indexPath) as! ChatRichPreviewMediaCollectionViewCell
            cell.configure(with: chatMessage, at: indexPath, and: messagesCollectionView)
            return cell
        } else if chatMessage.message.type == .voiceClip {
            let cell = messagesCollectionView.dequeueReusableCell(withReuseIdentifier: ChatVoiceClipCollectionViewCell.reuseIdentifier, for: indexPath) as! ChatVoiceClipCollectionViewCell
            cell.configure(with: chatMessage, at: indexPath, and: messagesCollectionView)
            return cell
        } else if chatMessage.message.type == .containsMeta {
            let cell = messagesCollectionView.dequeueReusableCell(withReuseIdentifier: ChatLocationCollectionViewCell.reuseIdentifier, for: indexPath) as! ChatLocationCollectionViewCell
            cell.configure(with: chatMessage, at: indexPath, and: messagesCollectionView)
            return cell
        } else {
            let cell = messagesCollectionView.dequeueReusableCell(withReuseIdentifier: ChatViewCallCollectionCell.reuseIdentifier, for: indexPath) as! ChatViewCallCollectionCell
            cell.configure(with: chatMessage, at: indexPath, and: messagesCollectionView)
            return cell
        }

    }

    // MARK: - Interface methods

    @objc func updateUnreadLabel() {

    }

    @objc func showOptions(forPeerWithHandle handle: UInt64, senderView: UIView) {

    }

    // MARK: - Internal methods used by the extension of this class

    func isFromCurrentSender(message: MessageType) -> Bool {
        return UInt64(message.sender.senderId) == myUser.handle
    }

    func isDateLabelVisible(for indexPath: IndexPath) -> Bool {
        if isPreviousMessageSentSameDay(at: indexPath) {
            return false
        }

        return true
    }

    func isTimeLabelVisible(at indexPath: IndexPath) -> Bool {
        guard let previousIndexPath = indexPath.previousSectionIndexPath else { return true }

        if isPreviousMessageSameSender(at: indexPath)
            && isTimeLabelVisible(at: previousIndexPath)
            && isPreviousMessageSentSameTime(at: indexPath) {
            return false
        }

        return true
    }

    func isPreviousMessageSentSameDay(at indexPath: IndexPath) -> Bool {
        guard let previousIndexPath = indexPath.previousSectionIndexPath else { return true }

        let previousMessageDate = messages[previousIndexPath.section].sentDate
        return messages[indexPath.section].sentDate.isSameDay(date: previousMessageDate)
    }

    /// This method ignores the milliseconds.
    func isPreviousMessageSentSameTime(at indexPath: IndexPath) -> Bool {
        guard let previousIndexPath = indexPath.previousSectionIndexPath else { return true }

        let previousMessageDate = messages[previousIndexPath.section].sentDate
        return messages[indexPath.section].sentDate.isSameMinute(date: previousMessageDate)
    }

    func isPreviousMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard let previousIndexPath = indexPath.previousSectionIndexPath else { return false }
        return messages[indexPath.section].senderHandle == messages[previousIndexPath.section].senderHandle
    }
    
    func avatarImage(for message: MessageType) -> UIImage? {
        guard let peerEmail = chatRoom.peerEmail(byHandle: UInt64(message.sender.senderId)!),
            let user = MEGASdkManager.sharedMEGASdk()?.contact(forEmail: peerEmail) else {
                return nil
        }
        return user.avatarImage(withDelegate: nil)
    }

    func initials(for message: MessageType) -> String {

        if let user = MEGAStore.shareInstance()?.fetchUser(withUserHandle: UInt64(message.sender.senderId)!) {
            return (user.displayName as NSString).mnz_initialForAvatar()
        }

        if let peerFullname = chatRoom.peerFullname(byHandle:UInt64(message.sender.senderId)!) {
            return (peerFullname as NSString).mnz_initialForAvatar()
        }

        return ""
    }

    // MARK: - Private methods
    
    private func configureMessageCollectionView() {
        messagesCollectionView.register(ChatViewIntroductionHeaderView.nib,
                                        forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                        withReuseIdentifier: ChatViewIntroductionHeaderView.reuseIdentifier)

        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        messagesCollectionView.refreshControl = refreshControl
    }

    private func registerCustomCells() {
        messagesCollectionView.register(ChatViewCallCollectionCell.nib,
                                         forCellWithReuseIdentifier: ChatViewCallCollectionCell.reuseIdentifier)
        messagesCollectionView.register(ChatViewAttachmentCell.self,
                                         forCellWithReuseIdentifier: ChatViewAttachmentCell.reuseIdentifier)
        messagesCollectionView.register(ChatMediaCollectionViewCell.self,
                                         forCellWithReuseIdentifier: ChatMediaCollectionViewCell.reuseIdentifier)
        messagesCollectionView.register(ChatRichPreviewMediaCollectionViewCell.self,
                                               forCellWithReuseIdentifier: ChatRichPreviewMediaCollectionViewCell.reuseIdentifier)
        messagesCollectionView.register(ChatVoiceClipCollectionViewCell.self,
                                                 forCellWithReuseIdentifier: ChatVoiceClipCollectionViewCell.reuseIdentifier)
        messagesCollectionView.register(ChatLocationCollectionViewCell.self,
                                        forCellWithReuseIdentifier: ChatLocationCollectionViewCell.reuseIdentifier)
    }

    private func update() {
        guard isViewLoaded, chatRoom != nil else {
            return
        }

        configureNavigationBar()
        chatRoomDelegate.openChatRoom()

        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.setMessageOutgoingAvatarSize(.zero)
            layout.setMessageOutgoingMessageTopLabelAlignment(LabelAlignment(textAlignment: .right, textInsets:  UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 12)))

        }
    }
    
    @objc func loadMoreMessages() {
        
        chatRoomDelegate.loadMoreMessages()
    }

    // MARK: - Bar Button actions

    @objc func startAudioCall() {

    }

    @objc func startVideoCall() {

    }

    @objc func addParticipant() {

    }

    deinit {
        chatRoomDelegate.closeChatRoom()
    }
}

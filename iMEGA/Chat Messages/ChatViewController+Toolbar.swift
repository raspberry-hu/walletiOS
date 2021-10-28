import UIKit

enum ToolbarType {
    case text
    case image
    case attachment
    case contact
    case mixed
}

extension ChatViewController {
    func customToolbar(type: ToolbarType) {
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        switch type {
        case .text:
            setToolbarItems([shareBarButtonItem, flexibleItem, copyBarButtonItem, flexibleItem, forwardBarButtonItem], animated: true)
        case .image:
            setToolbarItems([shareBarButtonItem, flexibleItem, importButtonItem, flexibleItem, saveToPhotosButtonItem, flexibleItem, forwardBarButtonItem], animated: true)
        case .attachment:
            setToolbarItems([shareBarButtonItem, flexibleItem, importButtonItem, flexibleItem, offlineBarButtonItem, flexibleItem, forwardBarButtonItem], animated: true)
        case .contact:
            setToolbarItems([flexibleItem, forwardBarButtonItem], animated: true)
        case .mixed:
            setToolbarItems([shareBarButtonItem, flexibleItem, forwardBarButtonItem], animated: true)
        }
    }
    
    @objc func copySelectedMessages() {
        if selectedMessages.count == 1 {
            UIPasteboard.general.string = selectedMessages.first?.message.content
        } else {
            var content = ""
            for chatMessage in selectedMessages {
                let messageContent = "[\(chatMessage.sentDate.string(withDateFormat: "dd/MM/yyyy HH:mm"))] #\(chatMessage.displayName):\(chatMessage.message.content ?? "")\n"
                content.append(messageContent)
            }
            UIPasteboard.general.string = content
        }
        setEditing(false, animated: true)
    }
    
    @objc func downloadSelectedMessages() {
        downloadMessage(Array(selectedMessages))
        setEditing(false, animated: true)
    }
    
    @objc func saveToPhotoSelectedMessages() {
        saveToPhotos(Array(selectedMessages))
        setEditing(false, animated: true)
    }
    
    @objc func importSelectedMessages() {
        let messages = Array(selectedMessages)
        setEditing(false, animated: false)
        importMessage(messages)
    }
    
    @objc func deleteSelectedMessages() {
        
        for chatMessage in selectedMessages {
            
            let megaMessage =  chatMessage.message
            
            if megaMessage.type == .attachment ||
                megaMessage.type == .voiceClip {
                if audioController.playingMessage?.messageId == chatMessage.messageId {
                    if audioController.state == .playing {
                        audioController.stopAnyOngoingPlaying()
                    }
                }
                MEGASdkManager.sharedMEGAChatSdk().revokeAttachmentMessage(forChat: chatRoom.chatId, messageId: megaMessage.messageId)
            } else {
                let foundIndex = messages.firstIndex { message -> Bool in
                    guard let localChatMessage = message as? ChatMessage else {
                        return false
                    }
                    
                    return chatMessage == localChatMessage
                }
                
                guard let index = foundIndex else {
                    return
                }
                
                if megaMessage.status == .sending {
                    chatRoomDelegate.chatMessages.remove(at: index)
                    messagesCollectionView.performBatchUpdates({
                        messagesCollectionView.deleteSections([index])
                    }, completion: nil)
                } else {
                    let messageId = megaMessage.status == .sending ? megaMessage.temporalId : megaMessage.messageId
                    let deleteMessage = MEGASdkManager.sharedMEGAChatSdk().deleteMessage(forChat: chatRoom.chatId, messageId: messageId)
                    deleteMessage?.chatId = chatRoom.chatId
                    chatRoomDelegate.chatMessages[index] = ChatMessage(message: deleteMessage!, chatRoom: chatRoom)
                }
            }
            
        }
        setEditing(false, animated: true)
    }
    
    @objc func forwardSelectedMessages() {
      
        var megaMessages = [MEGAChatMessage]()
        for chatMessage in selectedMessages {
            megaMessages.append(chatMessage.message)
        }
        let chatStoryboard = UIStoryboard(name: "Chat", bundle: nil)
        let sendToNC = chatStoryboard.instantiateViewController(withIdentifier: "SendToNavigationControllerID") as! UINavigationController
        let sendToViewController = sendToNC.viewControllers.first as! SendToViewController
        
        sendToViewController.sendMode = .forward
        sendToViewController.messages = megaMessages.sorted(by: { (obj1, obj2) -> Bool in
            obj1.messageIndex < obj2.messageIndex
        })
        sendToViewController.sourceChatId = chatRoom.chatId
        sendToViewController.completion = { (chatIdNumbers, sentMessages) in
            var selfForwarded = false
            var showSuccess = false
            self.setEditing(false, animated: true)

            chatIdNumbers?.forEach({ (chatIdNumber) in
                let chatId = chatIdNumber.uint64Value
                if chatId == self.chatRoom.chatId {
                    selfForwarded = true
                }
            })
            
            if selfForwarded {
                sentMessages?.forEach({ (message) in
                    let filteredArray = self.messages.filter { chatMessage in
                        guard let localChatMessage = chatMessage as? ChatMessage else {
                            return false
                        }
                        
                        return localChatMessage.message.temporalId == message.temporalId
                    }
                    if filteredArray.count > 0 {
                        MEGALogWarning("Forwarded message was already added to the array, probably onMessageUpdate received before now.")
                    } else {
                        message.chatId = self.chatRoom.chatId
                        self.chatRoomDelegate.insertMessage(message)
                        self.scrollToBottom()
                    }
                    
                })
                
                showSuccess = chatIdNumbers?.count ?? 0 > 1
            } else if chatIdNumbers?.count == 1 && self.chatRoom.isPreview {
                
                guard let chatId = chatIdNumbers?.first?.uint64Value,
                      let chatRoom = MEGASdkManager.sharedMEGAChatSdk().chatRoom(forChatId: chatId) else {
                    MEGALogDebug("Cannot find chatRoom chat")
                    return
                }
                let messagesVC = ChatViewController(chatRoom: chatRoom)
                self.replaceCurrentViewController(withViewController: messagesVC)
            } else {
                showSuccess = true
            }

            if showSuccess {
                SVProgressHUD.showSuccess(withStatus: NSLocalizedString("messagesSent", comment: "Success message shown after forwarding messages to other chats"))
                
            }
        }
        
        present(viewController: sendToNC)
    }
    
    
    @objc func shareSelectedMessages(sender: UIBarButtonItem) {

        SVProgressHUD.show()
        var megaMessages = [MEGAChatMessage]()
        for chatMessage in selectedMessages {
            megaMessages.append(chatMessage.message)
        }
        megaMessages = megaMessages.sorted(by: { (obj1, obj2) -> Bool in
            obj1.messageIndex < obj2.messageIndex
        })
        
        DispatchQueue.global(qos: .userInitiated).async {
            guard let activityViewController = UIActivityViewController(for: megaMessages, sender: sender) else {
                SVProgressHUD.showError(withStatus: NSLocalizedString("linkUnavailable", comment: ""))
                return
            }
            activityViewController.completionWithItemsHandler = {[weak self] activity, success, items, error in
                if success {
                    self?.setEditing(false, animated: false)
                }
            }
            
            DispatchQueue.main.async(execute: {
                SVProgressHUD.dismiss()
                
                self.present(viewController: activityViewController)
            })
        }
    }
    
    func updateToolbarState() {
        let isEnabled = selectedMessages.count > 0
        var hasGiphy = selectedMessages.contains {
            $0.message.type == .containsMeta && $0.message.containsMeta.type == .giphy
        }
        var hasPhoto = false
        var hasText = false
        var hasAttachments = false
        var hasContact = false
        
        for chatMessage in selectedMessages {
            if chatMessage.message.type == .containsMeta && chatMessage.message.containsMeta.type == .giphy {
               hasGiphy = true
            }
            if chatMessage.message.type == .normal {
                hasText = true
            }
            if chatMessage.message.type == .containsMeta,
               (chatMessage.message.containsMeta.type == .geolocation || chatMessage.message.containsMeta.type == .richPreview) {
                hasText = true
            }
            if chatMessage.message.type == .attachment || chatMessage.message.type == .voiceClip {
                if chatMessage.message.nodeList?.size?.intValue ?? 0 == 1,
                   let node = chatMessage.message.nodeList.node(at: 0),
                   (node.name.mnz_isImagePathExtension || node.name.mnz_isVideoPathExtension) {
                    hasPhoto = true
                } else {
                    hasAttachments = true
                }
            }
            if chatMessage.message.type == .contact {
                hasContact = true
            }
            
        }
        
        forwardBarButtonItem.isEnabled = isEnabled
        shareBarButtonItem.isEnabled = isEnabled && !hasGiphy
        deleteBarButtonItem.isEnabled = isEnabled
        copyBarButtonItem.isEnabled = isEnabled
        offlineBarButtonItem.isEnabled = isEnabled
        saveToPhotosButtonItem.isEnabled = isEnabled
        importButtonItem.isEnabled = isEnabled
        
        if hasText && !hasPhoto && !hasAttachments && !hasGiphy && !hasContact {
            customToolbar(type: .text)
        } else if !hasText && hasPhoto && !hasAttachments && !hasGiphy && !hasContact {
            customToolbar(type: .image)
        } else if !hasText && hasAttachments && !hasGiphy && !hasContact {
            customToolbar(type: .attachment)
        } else if hasContact || hasGiphy {
            customToolbar(type: .contact)
        } else {
            customToolbar(type: .mixed)
        }     
        
    }
}


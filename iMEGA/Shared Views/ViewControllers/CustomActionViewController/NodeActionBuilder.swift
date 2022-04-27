
final class NodeActionBuilder {
    
    private var displayMode: DisplayMode = .unknown
    private var accessLevel: MEGAShareType = .accessUnknown
    private var isMediaFile: Bool = false
    private var isEditableTextFile: Bool = false
    private var isFile: Bool = false
    private var versionCount: Int = 0
    private var isFavourite: Bool = false
    private var label: MEGANodeLabel = .unknown
    private var isRestorable: Bool = false
    private var isPdf: Bool = false
    private var isLink: Bool = false
    private var isPageView: Bool = true
    private var isIncomingShareChildView: Bool = false
    private var isExported: Bool = false
    private var isOutShare: Bool = false
    private var isChildVersion: Bool = false
    private var isBackupFolder: Bool = false
    private var isInVersionsView: Bool = false
    private var viewMode: ViewModePreference = .list
    private var nodeSelectionType: NodeSelectionType = .single

    func setDisplayMode(_ displayMode: DisplayMode) -> NodeActionBuilder {
        self.displayMode = displayMode
        return self
    }
    
    func setAccessLevel(_ accessLevel: MEGAShareType) -> NodeActionBuilder {
        self.accessLevel = accessLevel
        return self
    }
    
    func setIsMediaFile(_ isMediaFile: Bool) -> NodeActionBuilder {
        self.isMediaFile = isMediaFile
        return self
    }
    
    func setIsEditableTextFile(_ isEditableTextFile: Bool) -> NodeActionBuilder {
        self.isEditableTextFile = isEditableTextFile
        return self
    }
    
    func setIsFile(_ isFile: Bool) -> NodeActionBuilder {
        self.isFile = isFile
        return self
    }
    
    func setVersionCount(_ versionCount: Int) -> NodeActionBuilder {
        self.versionCount = versionCount
        return self
    }
    
    func setIsFavourite(_ isFavourite: Bool) -> NodeActionBuilder {
        self.isFavourite = isFavourite
        return self
    }
    
    func setLabel(_ label: MEGANodeLabel) -> NodeActionBuilder {
        self.label = label
        return self
    }
    
    func setIsRestorable(_ isRestorable: Bool) -> NodeActionBuilder {
        self.isRestorable = isRestorable
        return self
    }
    
    func setIsPdf(_ isPdf: Bool) -> NodeActionBuilder {
        self.isPdf = isPdf
        return self
    }
    
    func setIsLink(_ isLink: Bool) -> NodeActionBuilder {
        self.isLink = isLink
        return self
    }
    
    func setIsPageView(_ isPageView: Bool) -> NodeActionBuilder {
        self.isPageView = isPageView
        return self
    }
    
    func setisIncomingShareChildView(_ isIncomingShareChildView: Bool) -> NodeActionBuilder {
        self.isIncomingShareChildView = isIncomingShareChildView
        return self
    }
    
    func setIsExported(_ isExported: Bool) -> NodeActionBuilder {
        self.isExported = isExported
        return self
    }
    
    func setIsOutshare(_ isOutShare: Bool) -> NodeActionBuilder {
        self.isOutShare = isOutShare
        return self
    }
    
    func setIsChildVersion(_ isChildVersion: Bool?) -> NodeActionBuilder {
        self.isChildVersion = isChildVersion ?? false
        return self
    }
    
    func setIsInVersionsView(_ isInVersionsView: Bool) -> NodeActionBuilder {
        self.isInVersionsView = isInVersionsView
        return self
    }

    func setViewMode(_ viewMode: ViewModePreference?) -> NodeActionBuilder {
        self.viewMode = viewMode ?? .list
        return self
    }
    
    func setNodeSelectionType(_ selectionType: NodeSelectionType?) -> NodeActionBuilder {
        self.nodeSelectionType = selectionType ?? .single
        return self
    }
    
    func build() -> [NodeAction] {
        
        var nodeActions = [NodeAction]()
        
        if shouldAddRestoreAction() {
            nodeActions.append(NodeAction.restoreAction())
        }
        
        nodeActions.append(contentsOf: nodeActionsForDispalyModeOrAccessLevels())
    
        return nodeActions
    }
    
    func multiselectBuild() -> [NodeAction] {
        switch nodeSelectionType {
        case .single:
            return []
        case .files:
            return multiselectFilesActions()
        case .folders:
            return multiselectFoldersActions()
        case .filesAndFolders:
            return multiselectFoldersAndFilesActions()
        }
    }
    
    // MARK: - Private methods
    
    private func shouldAddRestoreAction() -> Bool {
        guard isRestorable else {
            return false
        }
        
        return displayMode == .rubbishBin ? !isInVersionsView : true
    }
    
    private func folderLinkNodeActions() -> [NodeAction] {
        var nodeActions: [NodeAction] = [
//            .NFTMintAction(),
            .importAction(),
            .downloadAction(),
            .selectAction(),
            .shareLinkAction(),
            .sendToChatAction(),
            .sortAction()
        ]
        
        if viewMode == .list {
            nodeActions.append(NodeAction.thumbnailAction())
        } else {
            nodeActions.append(NodeAction.listAction())
        }
        
        return nodeActions
    }
    
    private func fileLinkNodeActions() -> [NodeAction] {
        var nodeActions: [NodeAction] = [.importAction(), .downloadAction(), .shareLinkAction(), .sendToChatAction()]
        
        if isMediaFile {
            nodeActions.append(NodeAction.saveToPhotosAction())
        }
        
        return nodeActions
    }
    
    private func nodeInsideFolderLinkActions() -> [NodeAction] {
        var nodeActions: [NodeAction] = [.importAction(), .downloadAction()]

        if isMediaFile {
            nodeActions.append(NodeAction.saveToPhotosAction())
        }
        
        return nodeActions
    }
    
    private func textEditorActions() -> [NodeAction] {
        var nodeActions: [NodeAction] = []

        if (accessLevel != .accessRead) && (accessLevel != .accessUnknown) {
            nodeActions.append(NodeAction.textEditorAction())
        }
        nodeActions.append(NodeAction.downloadAction())
        if accessLevel != .accessOwner {
            nodeActions.append(NodeAction.importAction())
        }
        if accessLevel == .accessOwner {
            nodeActions.append(NodeAction.shareLinkAction())
            nodeActions.append(NodeAction.exportFileAction())
        }
        nodeActions.append(NodeAction.sendToChatAction())

        return nodeActions
    }
    
    private func previewDocumentNodeActions() -> [NodeAction] {
        var nodeActions: [NodeAction] = []

        if isLink {
            nodeActions.append(NodeAction.importAction())
        }
        nodeActions.append(NodeAction.downloadAction())
        if accessLevel == .accessOwner || isLink {
            nodeActions.append(NodeAction.shareLinkAction())
        }
        if accessLevel == .accessOwner {
            nodeActions.append(NodeAction.exportFileAction())
        }
        nodeActions.append(NodeAction.sendToChatAction())
        if isPdf {
            nodeActions.append(NodeAction.searchAction())
            if isPageView {
                nodeActions.append(NodeAction.pdfThumbnailViewAction())
            } else {
                nodeActions.append(NodeAction.pdfPageViewAction())
            }
        }

        return nodeActions
    }
    
    private func chatNodeActions() -> [NodeAction] {
        var nodeActions: [NodeAction] = [.forwardAction()]
        nodeActions.append(.downloadAction())
        nodeActions.append(.exportFileAction())
        if isMediaFile {
            nodeActions.append(.saveToPhotosAction())
        }
        nodeActions.append(.importAction())
        nodeActions.append(.copyAction())
        return nodeActions
    }
    
    private func transfersNodeActions() -> [NodeAction] {
        [.viewInFolderAction(), .shareLinkAction(), .clearAction()]
    }
    
    private func transfersFailedNodeActions() -> [NodeAction] {
        [.retryAction(), .clearAction()]
    }
    
    private func unknownAccessLevelNodeActions() -> [NodeAction] {
        var nodeActions: [NodeAction] = [.importAction()]
        if isMediaFile {
            nodeActions.append(NodeAction.saveToPhotosAction())
        }
        nodeActions.append(NodeAction.downloadAction())
        return nodeActions
    }
    
    private func readAndWriteAccessLevelNodeActions() -> [NodeAction] {
        var nodeActions: [NodeAction] = []
//        nodeActions.append(NodeAction.NFTMintAction())
        if accessLevel == .accessReadWrite && isEditableTextFile && (displayMode == .cloudDrive || displayMode == .recents || displayMode == .sharedItem) {
            nodeActions.append(NodeAction.textEditorAction())
        }
        if displayMode != .nodeInfo && displayMode != .nodeVersions {
            nodeActions.append(NodeAction.infoAction())
            if versionCount > 0 {
                nodeActions.append(NodeAction.viewVersionsAction(versionCount: versionCount))
            }
        }
        if isMediaFile {
            nodeActions.append(NodeAction.saveToPhotosAction())
        }
        nodeActions.append(NodeAction.downloadAction())
        if displayMode != .nodeVersions {
            nodeActions.append(NodeAction.copyAction())
            if isIncomingShareChildView {
                nodeActions.append(NodeAction.leaveSharingAction())
            }
        } else if accessLevel == .accessReadWrite && isChildVersion {
            nodeActions.append(NodeAction.revertVersionAction())
        }
        
        return nodeActions
    }
    
    private func fullAccessLevelNodeActions() -> [NodeAction] {
        var nodeActions: [NodeAction] = []
//        nodeActions.append(NodeAction.NFTMintAction())
        if isEditableTextFile && (displayMode == .cloudDrive || displayMode == .recents || displayMode == .sharedItem) {
            nodeActions.append(NodeAction.textEditorAction())
        }
        if displayMode != .nodeInfo && displayMode != .nodeVersions {
            nodeActions.append(NodeAction.infoAction())
            if versionCount > 0 {
                nodeActions.append(NodeAction.viewVersionsAction(versionCount: versionCount))
            }
            nodeActions.append(NodeAction.favouriteAction(isFavourite: isFavourite))
            nodeActions.append(NodeAction.labelAction(label: label))
        }
        if isMediaFile {
            nodeActions.append(NodeAction.saveToPhotosAction())
        }
        nodeActions.append(NodeAction.downloadAction())
        if displayMode == .nodeVersions {
            if isChildVersion {
                nodeActions.append(NodeAction.revertVersionAction())
            }
            nodeActions.append(NodeAction.removeVersionAction())
        } else {
            if !isBackupFolder {
                nodeActions.append(NodeAction.renameAction())
            }
            nodeActions.append(NodeAction.copyAction())
            if isIncomingShareChildView {
                nodeActions.append(NodeAction.leaveSharingAction())
            } else {
                nodeActions.append(NodeAction.moveAction())
                nodeActions.append(NodeAction.moveToRubbishBinAction())
            }
        }
        
        return nodeActions
    }
    
    private func ownerAccessLevelNodeActions() -> [NodeAction] {
        var nodeActions: [NodeAction] = []
//        nodeActions.append(NodeAction.NFTMintAction())
        switch displayMode {
        case .unknown: break
            
        case .cloudDrive, .sharedItem, .nodeInfo, .recents:
            nodeActions = ownerAccessLevelNodeActionsForCloudLikeViews()
            
        case .rubbishBin:
            nodeActions = nodeActionsForRubbishBin()
            
        case .folderLink, .fileLink, .nodeInsideFolderLink, .publicLinkTransfers, .transfers, .transfersFailed, .chatSharedFiles, .previewDocument, .textEditor, .selectionToolBar: break
            
        case .nodeVersions:
            nodeActions = ownerAccessLevelNodeActionsForNodeVersions()
            
        case .chatAttachment:
            nodeActions = ownerAccessLevelNodeActionsForChatAttachment()
            
        @unknown default: break
        }
        //可以改变插入顺序
        nodeActions.append(NodeAction.NFTMintAction())
        return nodeActions
    }
    
    private func nodeActionsForDispalyModeOrAccessLevels() -> [NodeAction] {
        switch displayMode {
        case .folderLink:
            return folderLinkNodeActions()
        case .fileLink:
            return fileLinkNodeActions()
        case .nodeInsideFolderLink:
            return nodeInsideFolderLinkActions()
        case .publicLinkTransfers:
            return [NodeAction.clearAction()]
        case .transfers:
            return transfersNodeActions()
        case .transfersFailed:
            return transfersFailedNodeActions()
        case .chatSharedFiles, .chatAttachment:
            return chatNodeActions()
        case .previewDocument:
            return previewDocumentNodeActions()
        case .textEditor:
            return textEditorActions()
        default: //.unknown, .cloudDrive, .rubbishBin, .sharedItem, .nodeInfo, .nodeVersions, .recents
            switch accessLevel {
            case .accessUnknown:
                return unknownAccessLevelNodeActions()
            case .accessRead, .accessReadWrite:
                return readAndWriteAccessLevelNodeActions()
            case .accessFull:
                return fullAccessLevelNodeActions()
            case .accessOwner:
                return ownerAccessLevelNodeActions()
            default:
                return []
            }
        }
    }
    
    private func ownerAccessLevelNodeActionsForCloudLikeViews() -> [NodeAction] {
        var nodeActions: [NodeAction] = []
        
        if isEditableTextFile && (displayMode == .cloudDrive || displayMode == .recents || displayMode == .sharedItem) {
            nodeActions.append(NodeAction.textEditorAction())
        }
        
        if displayMode != .nodeInfo {
            nodeActions.append(NodeAction.infoAction())
            if versionCount > 0 {
                nodeActions.append(NodeAction.viewVersionsAction(versionCount: versionCount))
            }
            nodeActions.append(NodeAction.favouriteAction(isFavourite: isFavourite))
            nodeActions.append(NodeAction.labelAction(label: label))
        }
        
        if isMediaFile {
            nodeActions.append(NodeAction.saveToPhotosAction())
        }
        
        nodeActions.append(NodeAction.downloadAction())
        
        if isExported {
            nodeActions.append(NodeAction.manageLinkAction())
            nodeActions.append(NodeAction.removeLinkAction())
        } else {
            nodeActions.append(NodeAction.shareLinkAction())
        }
        
        if !isFile {
            if isOutShare {
                nodeActions.append(NodeAction.manageFolderAction())
            } else {
                nodeActions.append(NodeAction.shareFolderAction())
            }
        } else {
            nodeActions.append(NodeAction.exportFileAction())
        }
        
        if isFile {
            nodeActions.append(NodeAction.sendToChatAction())
        }
        
        if !isBackupFolder {
            nodeActions.append(NodeAction.renameAction())
        }
        
        if displayMode != .sharedItem {
            nodeActions.append(NodeAction.moveAction())
        }
        
        nodeActions.append(NodeAction.copyAction())
        
        if displayMode == .cloudDrive || displayMode == .nodeInfo || displayMode == .recents {
            nodeActions.append(NodeAction.moveToRubbishBinAction())
        } else if displayMode == .sharedItem {
            nodeActions.append(NodeAction.removeSharingAction())
        }
        
        return nodeActions
    }
    
    private func nodeActionsForRubbishBin() -> [NodeAction] {
        var nodeActions: [NodeAction] = []
        
        nodeActions.append(NodeAction.infoAction())

        if !isInVersionsView {
            if versionCount > 0 {
                nodeActions.append(NodeAction.viewVersionsAction(versionCount: versionCount))
            }
            nodeActions.append(NodeAction.removeAction())
        }
        
        return nodeActions
    }
    
    private func ownerAccessLevelNodeActionsForNodeVersions() -> [NodeAction] {
        var nodeActions: [NodeAction] = []
        
        if isMediaFile {
            nodeActions.append(NodeAction.saveToPhotosAction())
        }
        nodeActions.append(NodeAction.downloadAction())
        nodeActions.append(NodeAction.exportFileAction())
        if isChildVersion {
            nodeActions.append(NodeAction.revertVersionAction())
        }
        nodeActions.append(NodeAction.removeVersionAction())
        
        return nodeActions
    }
    
    private func ownerAccessLevelNodeActionsForChatAttachment() -> [NodeAction] {
        var nodeActions: [NodeAction] = []
        
        nodeActions.append(NodeAction.infoAction())
        if versionCount > 0 {
            nodeActions.append(NodeAction.viewVersionsAction(versionCount: versionCount))
        }
        if isMediaFile {
            nodeActions.append(NodeAction.saveToPhotosAction())
        }
        nodeActions.append(NodeAction.downloadAction())
        nodeActions.append(NodeAction.shareLinkAction())
        nodeActions.append(NodeAction.exportFileAction())
        nodeActions.append(NodeAction.sendToChatAction())
        
        return nodeActions
    }
    
    private func multiselectFoldersActions() -> [NodeAction] {
        [NodeAction.downloadAction(),
         NodeAction.shareLinksAction(),
         NodeAction.shareFoldersAction(),
         NodeAction.moveAction(),
         NodeAction.copyAction(),
         NodeAction.moveToRubbishBinAction()]
    }
    
    private func multiselectFilesActions() -> [NodeAction] {
        [NodeAction.downloadAction(),
         NodeAction.shareLinksAction(),
         NodeAction.exportFilesAction(),
         NodeAction.sendToChatAction(),
         NodeAction.moveAction(),
         NodeAction.copyAction(),
         NodeAction.moveToRubbishBinAction()]
    }
    
    private func multiselectFoldersAndFilesActions() -> [NodeAction] {
        [NodeAction.downloadAction(),
         NodeAction.shareLinksAction(),
         NodeAction.moveAction(),
         NodeAction.copyAction(),
         NodeAction.moveToRubbishBinAction()]
    }
}

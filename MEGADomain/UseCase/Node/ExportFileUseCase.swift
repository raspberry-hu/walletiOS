import Foundation

// MARK: - Use case protocol -
protocol ExportFileNodeUseCaseProtocol {
    func export(node: NodeEntity, completion: @escaping (Result<URL, ExportFileErrorEntity>) -> Void)
    func export(nodes: [NodeEntity], completion: @escaping ([URL]) -> Void)
}

protocol ExportFileChatMessageUseCaseProtocol {
    func export(message: MEGAChatMessage, completion: @escaping (Result<URL, ExportFileErrorEntity>) -> Void)
    func export(messages: [MEGAChatMessage], completion:  @escaping ([URL]) -> Void)
    func exportMessageNode(_ node: MEGANode, completion: @escaping (Result<URL, ExportFileErrorEntity>) -> Void)
}

typealias ExportFileUseCaseProtocol = ExportFileNodeUseCaseProtocol & ExportFileChatMessageUseCaseProtocol

// MARK: - Use case implementation -
struct ExportFileUseCase<T: DownloadFileRepositoryProtocol, U: OfflineFilesRepositoryProtocol, V: FileRepositoryProtocol, W: ExportChatMessagesRepositoryProtocol, X: ImportNodeRepositoryProtocol> {
    private let downloadFileRepository: T
    private let offlineFilesRepository: U
    private let fileSystemRepository: V
    private let exportChatMessagesRepository: W
    private let importNodeRepository: X

    init(downloadFileRepository: T, offlineFilesRepository: U, fileSystemRepository: V, exportChatMessagesRepository: W, importNodeRepository: X) {
        self.downloadFileRepository = downloadFileRepository
        self.offlineFilesRepository = offlineFilesRepository
        self.fileSystemRepository = fileSystemRepository
        self.exportChatMessagesRepository = exportChatMessagesRepository
        self.importNodeRepository = importNodeRepository
    }
    
    // MARK: - Private
    private func nodeUrl(_ node: NodeEntity) -> URL? {
        if let offlineUrl = offlineUrl(for: node.base64Handle) {
            return offlineUrl
        } else if node.name.mnz_isImagePathExtension, let imageUrl = cachedImageUrl(for: node.base64Handle, name: node.name) {
            return imageUrl
        } else if let fileUrl = cachedFileUrl(for: node.base64Handle, name: node.name) {
            return fileUrl
        } else {
            return nil
        }
    }
    
    private func offlineUrl(for base64Handle: MEGABase64Handle) -> URL? {
        guard let offlinePath = offlineFilesRepository.offlineFile(for: base64Handle)?.localPath else { return nil }
        return URL(fileURLWithPath: offlineFilesRepository.offlinePath.append(pathComponent: offlinePath))
    }
    
    private func cachedImageUrl(for base64Handle: MEGABase64Handle, name: String) -> URL? {
        let cachedImageUrl = fileSystemRepository.cachedOriginalURL(for: base64Handle, name: name)
        guard fileSystemRepository.fileExists(at: cachedImageUrl) else {
            return nil
        }
        return cachedImageUrl
    }
    
    private func cachedFileUrl(for base64Handle: MEGABase64Handle, name: String) -> URL? {
        let cachedFileUrl = fileSystemRepository.cachedFileURL(for: base64Handle, name: name)
        guard fileSystemRepository.fileExists(at: cachedFileUrl) else {
            return nil
        }
        return cachedFileUrl
    }
    
    private func processDownloadThenShareResult(result: Result<TransferEntity, TransferErrorEntity>, completion: @escaping (Result<URL, ExportFileErrorEntity>) -> Void) {
        switch result {
        case .success(let transferEntity):
            guard let path = transferEntity.path else { return }
            let url = URL(fileURLWithPath: path)
            completion(.success(url))

        case .failure(_):
            completion(.failure(.downloadFailed))
        }
    }
    
    private func importNodeToDownload(_ node: MEGANode, completion: @escaping (Result<URL, ExportFileErrorEntity>) -> Void) {
        importNodeRepository.importChatNode(node) { result in
            switch result {
            case .success(let node):
                downloadNode(NodeEntity(node: node), completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func downloadNode(_ node: NodeEntity, completion: @escaping (Result<URL, ExportFileErrorEntity>) -> Void) {
        if fileSystemRepository.systemVolumeAvailability() < node.size {
            completion(.failure(.notEnoughSpace))
            return
        }
        let appDataToExportFile = NSString().mnz_appDataToExportFile()
        let path = node.name.mnz_isImagePathExtension ? fileSystemRepository.cachedOriginalURL(for: node.base64Handle, name: node.name).path : fileSystemRepository.cachedFileURL(for: node.base64Handle, name: node.name).path
        downloadFileRepository.download(nodeHandle: node.handle, to: path, appData: appDataToExportFile) { result in
            processDownloadThenShareResult(result: result, completion: completion)
        }
    }
}

// MARK: - ExportFileNodeUseCaseProtocol implementation -
extension ExportFileUseCase: ExportFileNodeUseCaseProtocol {
    func export(node: NodeEntity, completion: @escaping (Result<URL, ExportFileErrorEntity>) -> Void) {
        if let nodeUrl = nodeUrl(node) {
            completion(.success(nodeUrl))
        } else {
            downloadNode(node, completion: completion)
        }
    }
    
    func export(nodes: [NodeEntity], completion: @escaping ([URL]) -> Void) {
        var urlsArray = [URL]()
        let myGroup = DispatchGroup()
        
        for node in nodes {
            myGroup.enter()
            
            export(node: node) { result in
                switch result {
                case .success(let url):
                    urlsArray.append(url)
                case .failure(let error):
                    MEGALogError("Failed to export node with error: \(error)")
                }
                myGroup.leave()
            }
        }
        
        myGroup.notify(queue: .main) {
            completion(urlsArray)
        }
    }
}

// MARK: - ExportFileChatMessageUseCaseProtocol implementation -
extension ExportFileUseCase: ExportFileChatMessageUseCaseProtocol {
    func export(message: MEGAChatMessage, completion: @escaping (Result<URL, ExportFileErrorEntity>) -> Void) {
        switch message.type {
        case .normal, .containsMeta:
            if let url = exportChatMessagesRepository.exportText(message: message) {
                completion(.success(url))
            } else {
                completion(.failure(.failedToExportText))
            }
            
        case .contact:
            guard let base64Handle = MEGASdk.base64Handle(forUserHandle: message.userHandle(at: 0)) else {
                completion(.failure(.failedToCreateContact))
                return
            }
            let avatarUrl = fileSystemRepository.cachedThumbnailURL(for: base64Handle)
            if let contactUrl = exportChatMessagesRepository.exportContact(message: message, contactAvatarImage: fileSystemRepository.fileExists(at: avatarUrl) ? avatarUrl.path : nil) {
                completion(.success(contactUrl))
            } else {
                completion(.failure(.failedToCreateContact))
            }
            
        case .attachment, .voiceClip:
            guard let node = message.nodeList?.mnz_nodesArrayFromNodeList().first else {
                completion(.failure(.nonExportableMessage))
                return
            }
            exportMessageNode( node, completion: completion)
            
        default:
            MEGALogError("Failed to export a non compatible message type \(message.type)")
            completion(.failure(.nonExportableMessage))
        }
    }
    
    func export(messages: [MEGAChatMessage], completion: @escaping ([URL]) -> Void) {
        var urlsArray = [URL]()
        let myGroup = DispatchGroup()
        
        for message in messages {
            myGroup.enter()
            
            export(message: message) { result in
                switch result {
                case .success(let url):
                    urlsArray.append(url)
                case .failure(let error):
                    MEGALogError("Failed to export a non compatible message type \(message.type) with error: \(error)")
                }
                myGroup.leave()
            }
        }
        
        myGroup.notify(queue: .main) {
            completion(urlsArray)
        }
    }
    
    func exportMessageNode(_ node: MEGANode, completion: @escaping (Result<URL, ExportFileErrorEntity>) -> Void) {
        if let nodeUrl = nodeUrl(NodeEntity(node: node)) {
            completion(.success(nodeUrl))
        } else {
            importNodeToDownload(node, completion: completion)
        }
    }
}

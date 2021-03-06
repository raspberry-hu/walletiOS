final class TransferDelegate: NSObject, MEGATransferDelegate {
    var start: ((TransferEntity) -> Void)?
    var progress: ((TransferEntity) -> Void)?
    var completion: ((Result<TransferEntity, TransferErrorEntity>) -> Void)?
    
    init(
        start: ((TransferEntity) -> Void)? = nil,
        progress: @escaping (TransferEntity) -> Void,
        completion: @escaping (Result<TransferEntity, TransferErrorEntity>) -> Void
    ) {
        self.start = start
        self.progress = progress
        self.completion = completion
    }
    
    init(completion: @escaping (Result<TransferEntity, TransferErrorEntity>) -> Void) {
        self.completion = completion
    }


    func onTransferStart(_ api: MEGASdk, transfer: MEGATransfer) {
        if let start = start {
            start(TransferEntity(transfer: transfer))
        }
    }

    func onTransferUpdate(_ api: MEGASdk, transfer: MEGATransfer) {
        if let progress = progress {
            progress(TransferEntity(transfer: transfer))
        }
    }

    func onTransferFinish(_ api: MEGASdk, transfer: MEGATransfer, error: MEGAError) {
        if let completion = completion {
            if error.type != .apiOk {
                let transferErrorEntity = transfer.type == .upload ? TransferErrorEntity.upload : TransferErrorEntity.download
                completion(.failure(transferErrorEntity))
            } else {
                completion(.success(TransferEntity(transfer: transfer)))
            }
        }
    }
}

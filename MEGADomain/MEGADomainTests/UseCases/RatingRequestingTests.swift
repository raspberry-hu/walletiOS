import XCTest
@testable import MEGA

class RatingRequestingTests: XCTestCase {
    func testTransferMoment_shouldRequest() {
        let sut = RatingRequesting.transfer
        let moment = TransferMoment(transfer: TransferEntity(speed: 2 * 1024 * 1024, totalSize: 10 * 1024 * 1024))
        XCTAssertTrue(sut.shouldRequestRating(moment, MockRatingRequestBaseConditionsUseCase(hasMetBaseCondition: true)))
    }
    
    func testTransferMoment_shouldNotRequest_lowSpeed() {
        let sut = RatingRequesting.transfer
        let moment = TransferMoment(transfer: TransferEntity(speed: 1 * 1024 * 1024, totalSize: 10 * 1024 * 1024))
        XCTAssertFalse(sut.shouldRequestRating(moment, MockRatingRequestBaseConditionsUseCase(hasMetBaseCondition: true)))
    }
    
    func testTransferMoment_shouldNotRequest_smallSize() {
        let sut = RatingRequesting.transfer
        let moment = TransferMoment(transfer: TransferEntity(speed: 3 * 1024 * 1024, totalSize: 9 * 1024 * 1024))
        XCTAssertFalse(sut.shouldRequestRating(moment, MockRatingRequestBaseConditionsUseCase(hasMetBaseCondition: true)))
    }

    func testTransferMoment_shouldNotRequest_notMetBaseCondition() {
        let sut = RatingRequesting.transfer
        let moment = TransferMoment(transfer: TransferEntity(speed: 3 * 1024 * 1024, totalSize: 19 * 1024 * 1024))
        XCTAssertFalse(sut.shouldRequestRating(moment, MockRatingRequestBaseConditionsUseCase(hasMetBaseCondition: false)))
    }
    
    func testShareMoment_shouldRequest() {
        let sut = RatingRequesting.share
        let moment = ShareMoment(shareUseCase: MockShareUseCase(nodes: [NodeEntity(), NodeEntity()],
                                                                shares: [ShareEntity(), ShareEntity(), ShareEntity()]))
        XCTAssertTrue(sut.shouldRequestRating(moment, MockRatingRequestBaseConditionsUseCase(hasMetBaseCondition: true)))
    }
    
    func testShareMoment_shouldNotRequest_shareCount() {
        let sut = RatingRequesting.share
        let moment = ShareMoment(shareUseCase: MockShareUseCase(nodes: [NodeEntity()],
                                                                shares: [ShareEntity(), ShareEntity(), ShareEntity()]))
        XCTAssertFalse(sut.shouldRequestRating(moment, MockRatingRequestBaseConditionsUseCase(hasMetBaseCondition: true)))
    }
    
    func testShareMoment_shouldNotRequest_notMetBaseCondition() {
        let sut = RatingRequesting.share
        let moment = ShareMoment(shareUseCase: MockShareUseCase(nodes: [NodeEntity(), NodeEntity(), NodeEntity(), NodeEntity()],
                                                                shares: [ShareEntity(), ShareEntity(), ShareEntity()]))
        XCTAssertFalse(sut.shouldRequestRating(moment, MockRatingRequestBaseConditionsUseCase(hasMetBaseCondition: false)))
    }
}

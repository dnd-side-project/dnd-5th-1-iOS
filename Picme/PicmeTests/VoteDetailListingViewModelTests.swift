//
//  VoteDetailListingViewModelTests.swift
//  PicmeTests
//
//  Created by 권민하 on 2021/08/08.
//

import Alamofire
import XCTest
@testable import Picme

@available(iOS 13.0, *)
class VoteDetailListingViewModelTests: XCTestCase {
    
    // MARK: - Propertise
    
    var viewModel: VoteDetailViewModel!
    var vc: VoteDetailViewController!
    var dataSource: GenericDataSource<VoteDetailModel>!
    var mockApiClient: MockAPIClient!
    
    override func setUp() {
        super.setUp()
        
        // Initializing properties
        dataSource = GenericDataSource<VoteDetailModel>()
        viewModel = VoteDetailViewModel(dataSource: dataSource)
        vc = VoteDetailViewController()
        mockApiClient = MockAPIClient()
    }
    
    override func tearDown() {
        
        // Deinitializing propertise
        viewModel = nil
        vc = nil
        dataSource = nil
        mockApiClient = nil
        
        super.tearDown()
    }
    
    /// METHOD to test if fetch vote detail list is working peoperly or not
    /// Expectation will catch a callback and listner would be called to update UI
    
    func testFetchVoteDetailListWorking() {
        let expectation = XCTestExpectation(description: "Vote Detail List fetch")
        
        // giving a service mocking detail list
        mockApiClient.voteDetailListModel = VoteDetailListModel(detailList: [VoteDetailModel(nickname: "1", profileImage: "2", deadline: "3", isVoted: true, votedImageId: "4", title: "5", description: "6", participantsNum: 7, images: [])])
        
        dataSource.data.addObserver(self) { _ in
            expectation.fulfill()
        }
        
        viewModel.fetchVoteDetail(postId: "1")
        wait(for: [expectation], timeout: 5.0)
    }
    
    /// Testing fetch detail list method is calling properly
    /// Expectation is onError or datasourse observer is called
    
    func testFetchVoteDetailListCalled() {
        let expectation = XCTestExpectation(description: "Vote Detail List fetch")
        
        dataSource.data.addObserver(self) { _ in
            expectation.fulfill()
        }
        
        viewModel.fetchVoteDetail(postId: "1")
        wait(for: [expectation], timeout: 5.0)
    }
    
}

// MARK: - MOCK APIClient class for testing

class MockAPIClient: VoteDetailService {
    
    var voteDetailListModel : VoteDetailListModel?
    
    func getVoteDetailList(postId: String, completion: @escaping([VoteDetailModel]?) -> Void) {
        
    }
    
}

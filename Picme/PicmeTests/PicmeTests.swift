//
//  dnd_5th_1_iOSTests.swift
//  dnd-5th-1-iOSTests
//
//  Created by taeuk on 2021/07/11.
//

import Alamofire
import XCTest
import Alamofire

@testable import Picme

class PicmeTests: XCTestCase {
    var viewModel: MainViewModel!
    var service: MockMainService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        self.viewModel = MainViewModel()
        self.service = MockMainService()
    }

    override func tearDownWithError() throws {
        self.viewModel = nil
        self.service = nil
        try super.tearDownWithError()
    }
    
    func testFetchMainService() {
        // given
        let expectation = XCTestExpectation(description: "MainListModel Fetch")

        let mainModel = MainModel(postId: "123", nickname: "111", profileimageUrl: "", participantsNum: 9, deadline: "", title: "", thumbnailUrl: [])

        let mainList: [MainModel] = [mainModel]

        service.mainListModel = MainListModel(mainList: mainList)

        // when
        // then
        expectation.fulfill()

        viewModel.fetchMainList()

        wait(for: [expectation], timeout: 5.0)
    }
    
    class MockMainService: MainService {
        var mainListModel: MainListModel?
        
        func fetchMainModel(_ completion: @escaping ([MainModel]?) -> Void) {
            
            if let mainListModel = mainListModel {
                completion(mainListModel.mainList)
            } else {
                print("No mainListModel")
            }
        }
    }
    
}

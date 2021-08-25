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
    
    var mainService: MainService!
    var dataSource: MainListDatasource!
    var constant: APIConstants!
    var session: URLSession!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        viewModel = MainViewModel(service: mainService, dataSource: dataSource)
        
        session = URLSession(configuration: .default)
        self.constant = APIConstants()
        
    }

    override func tearDownWithError() throws {
        
        
        constant = nil
        session = nil
        try super.tearDownWithError()
    }
    
    func testApiCallCompletes() throws {
        
        // given
        let urlString = APIConstants.Post.postListRetrieve.urlString
        let url = URL(string: urlString)!
        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: Error?
        
        // when
        let dataTask = session.dataTask(with: url) { _, response, error in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            promise.fulfill()
        }
        dataTask.resume()
        wait(for: [promise], timeout: 5)
        
        
        
        // then
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }
    
    func testFetchMainService() {
        // given
        let expectation = XCTestExpectation(description: "MainListModel Fetch")

        let mainModel = MainModel(postId: "12345", deadline: "12", title: "제목",
                                  user: User(nickname: "닉네임", profileImageUrl: "1"),
                                  participantsNum: 99)

        let mainList: [MainModel] = [mainModel]

//        service.mainListModel = MainListModel(mainList: mainList)

        // when
        // then
        expectation.fulfill()

        viewModel.fetchMainList()

        wait(for: [expectation], timeout: 5.0)
    }
    
}

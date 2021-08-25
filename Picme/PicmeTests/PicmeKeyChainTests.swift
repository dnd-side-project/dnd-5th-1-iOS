//
//  PicmeKeyChainTests.swift
//  PicmeTests
//
//  Created by taeuk on 2021/08/25.
//

import XCTest
@testable import Picme

class PicmeKeyChainTests: XCTestCase {

    var keychainModel: KeyChainModel!
    var userID: String? = "12345"
    var userEmail: String? = "123@naver.com"
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        keychainModel = KeyChainModel.shared
    }

    override func tearDownWithError() throws {
        
        keychainModel = nil
        try super.tearDownWithError()
    }
    
    func test_CreateKeyChain() throws {
        let testModel = KeychainUserInfo(userIdentifier: userID, userEmail: userEmail)
        
        let hasKey: Bool = keychainModel.createUserInfo(with: testModel)
        XCTAssertTrue(hasKey)
    }
    
    func test_FetchKeyChain() throws {
        
        let userData: KeychainUserInfo? = keychainModel.readUserInfo()
        XCTAssertNotNil(userData)
        XCTAssertTrue(userData?.userIdentifier == userID)
        XCTAssertTrue(userData?.userEmail == userEmail)
    }
    
    func test_DeleteKeyChain() throws {
        
        let removeKey: Bool = keychainModel.deleteUserinfo()
        XCTAssertTrue(removeKey)
        
        let user: KeychainUserInfo? = keychainModel.readUserInfo()
        XCTAssertNil(user)
    }
}

//
//  UserInfo.swift
//  Picme
//
//  Created by taeuk on 2021/08/03.
//

import Foundation

class UserInfo {
    static let shared: UserInfo = UserInfo()
    
    private init() {}
    
    var vendor: String?
    var vendorID: String?
    var userEmail: String?
    var userNickname: String?
}

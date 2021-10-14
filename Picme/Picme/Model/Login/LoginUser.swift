//
//  LoginUser.swift
//  Picme
//
//  Created by 권민하 on 2021/08/19.
//

import Foundation

class LoginUser {
    static let shared: LoginUser = LoginUser()
    
    private init() {}
    
    var vendor: String?
    var vendorID: String?
    var userNickname: String?
    var userProfileImageUrl: String?
}

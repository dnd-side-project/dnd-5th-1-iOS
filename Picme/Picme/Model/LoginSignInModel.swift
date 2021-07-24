//
//  LoginSignInModel.swift
//  dnd-5th-1-iOS
//
//  Created by taeuk on 2021/07/17.
//

import Foundation

struct LoginSignInModel: Codable {
    let vendor: String
    let vendorAccountId: String
    let email: String
}

struct LoginSignInResponseModel: Codable {
    let profilePictureUrl: String
    let nickname: String
}

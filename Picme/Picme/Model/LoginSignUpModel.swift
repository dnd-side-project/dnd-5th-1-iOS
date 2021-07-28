//
//  LoginSignInModel.swift
//  dnd-5th-1-iOS
//
//  Created by taeuk on 2021/07/17.
//

import Foundation

struct LoginSignUpModel: Codable {
    let vendor: String
    let vendorAccountId: String
    let nickname: String
    let email: String
}

struct LoginSignUpResponseModel: Codable {
    let profilePictureImage: String
    let nickname: String
}

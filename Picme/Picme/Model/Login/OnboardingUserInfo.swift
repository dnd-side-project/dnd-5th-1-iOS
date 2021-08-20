//
//  UserInfo.swift
//  Picme
//
//  Created by taeuk on 2021/08/03.
//

import Foundation

class OnboardingUserInfo {
    static let shared: OnboardingUserInfo = OnboardingUserInfo()
    
    private init() {}
    
    var vendor: String?
    var vendorID: String?
    var userEmail: String?
}

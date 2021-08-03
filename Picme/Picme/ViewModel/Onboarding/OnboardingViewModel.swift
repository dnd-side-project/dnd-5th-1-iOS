//
//  OnboardingViewModel.swift
//  Picme
//
//  Created by taeuk on 2021/08/02.
//

import Foundation

class OnboardingViewModel {
    
    var isButtonState: Dynamic<Bool> = Dynamic(false)
    var isVaildState: Dynamic<Bool> = Dynamic(false)
    let userinfo = UserInfo.shared
    var registSingUp: LoginKind.SignUp?
    
    // SignIn
    func registUser(_ nickName: String) {
        
        guard let vendorType = userinfo.vendor,
              let useridentifier = userinfo.vendorID,
              let userEmail = userinfo.userEmail else { fatalError("vendor is Nothing") }
        
        print(vendorType)
        print(useridentifier)
        print(userEmail)
        
        switch vendorType {
        case LoginKind.LoginRawValue.kakao.vendor:
            registSingUp = LoginKind.SignUp.kakao(userID: useridentifier,
                                                  nickName: nickName,
                                                  email: userEmail)
            
        case LoginKind.LoginRawValue.apple.vendor:
            registSingUp = LoginKind.SignUp.apple(userID: useridentifier,
                                                  nickName: nickName,
                                                  email: userEmail)
        default:
            return
        }
        
        if let registSignUpValue = registSingUp?.loginValue {
            LoginAPICenter.fetchSignUp(registSignUpValue) { (response) in
                switch response {
                case .success(let data):
                    print(data)
                case .failure(let err):
                    print(err.localized)
                }
            }
        }
    }
}

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
    let userinfo = OnboardingUserInfo.shared
    var registSingUp: LoginKind.SignUp?
    
    weak var onboardingDelegate: LoginState?
    
    var saveUserInfo: KeychainUserInfo?
    
    let loginUserInfo = LoginUser.shared
    
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
            
            saveUserInfo = KeychainUserInfo(userIdentifier: useridentifier,
                                            userEmail: userEmail)
        default:
            return
        }
        
        if let registSignUpValue = registSingUp?.loginValue {
            LoginAPICenter.fetchSignUp(registSignUpValue) { [weak self] (response) in
                switch response {
                case .success(let data):
                    print(data)
                    
                    self?.loginUserInfo.userNickname = data.nickname
                    self?.loginUserInfo.userProfileImageUrl = data.profilePictureImage
                    self?.loginUserInfo.vendor = data.nickname
                    
                    if let saveUserInfo = self?.saveUserInfo {
                        _ = KeyChainModel.shared.createUserInfo(with: saveUserInfo)
                    }
                    
                    self?.onboardingDelegate?.loginSuccess()
                case .failure(let err):
                    print(err.localized)
                    
                }
            }
        }
    }
}

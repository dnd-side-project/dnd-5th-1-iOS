//
//  MyPageViewModel.swift
//  Picme
//
//  Created by taeuk on 2021/08/17.
//

import Foundation
import KakaoSDKAuth
import KakaoSDKUser
import AuthenticationServices

protocol LogOutProtocol: AnyObject {
    func logoutFromMain()
}

class MyPageViewModel {
    
    weak var logOutDelegate: LogOutProtocol?
    
    let loginUserInfo = LoginUser.shared
    
    func logOutAction(from kind: String?) {
        
        guard let kind = kind else { return }
        
        switch kind {
        case "Kakao":
            
            UserApi.shared.logout { [weak self] error in
                if let err = error {
                    print(err.localizedDescription)
                } else {
                    
                    print("Kakao Log Out Success")
                    
                    self?.userInfoRemove()
                    self?.logOutDelegate?.logoutFromMain()
                    
                }
            }
            
        case "Apple":
            // 키체인 제거
            if KeyChainModel.shared.deleteUserinfo() {
                print("Keychain Remove")
                
                userInfoRemove()
                logOutDelegate?.logoutFromMain()
            }
        default:
            return
        }
    }
    
    func userInfoRemove() {
        loginUserInfo.vendor = nil
        loginUserInfo.userNickname = nil
        loginUserInfo.userProfileImageUrl = nil
        APIConstants.jwtToken = ""
    }
}

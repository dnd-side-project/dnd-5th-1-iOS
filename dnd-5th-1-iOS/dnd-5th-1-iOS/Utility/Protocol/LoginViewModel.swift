//
//  LoginViewModel.swift
//  dnd-5th-1-iOS
//
//  Created by taeuk on 2021/07/13.
//

import Foundation
import KakaoSDKUser
import KakaoSDKAuth

class LoginViewModel {
    
    weak var loginDelegate: LoginState?
    
    func kakaoLogin() {
        UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
            guard let self = self else { return }
            
            if let error = error {
                self.loginDelegate?.loginFail(error: error.localizedDescription)
            } else {
                print("loginWithKakaoAccount() success.")
                
                let accessToken = oauthToken
                print(accessToken?.accessToken)
                
                // 사용자 액세스 토큰 정보 조회
                UserApi.shared.accessTokenInfo {(accessTokenInfo, error) in
                    if let error = error {
                        print(error)
                    } else {
                        print("accessTokenInfo() success.")

                        let tokenInfo = accessTokenInfo
                        print(tokenInfo)
                    }
                    self.loginDelegate?.loginSuccess()
                }
            }
        }
    }
}

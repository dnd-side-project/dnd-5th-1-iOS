//
//  LoginViewModel.swift
//  dnd-5th-1-iOS
//
//  Created by taeuk on 2021/07/13.
//

import Foundation
import KakaoSDKUser
import KakaoSDKAuth
import AuthenticationServices

class LoginViewModel: NSObject {
    
    weak var loginDelegate: LoginState?
    
}

// MARK: - Kakao Login

extension LoginViewModel {
    
    func kakaoLogin() {
        UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
            guard let self = self else { return }
            
            if let error = error {
                self.loginDelegate?.loginFail(error: "kakao Login Error: \(error.localizedDescription)")
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

// MARK: - Apple Login

extension LoginViewModel: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let loginVC = LoginViewController()
        return loginVC.view.window ?? UIWindow()
    }
    
    // Apple ID 연동 성공 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential {
        case let appleIDCredetial as ASAuthorizationAppleIDCredential:
            
            print(appleIDCredetial.identityToken?.base64EncodedString())
            
            loginDelegate?.loginSuccess()
            
        default:
            break
        }
    }
    
    // Apple ID 연동 실패 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        loginDelegate?.loginFail(error: "apple Login Error: \(error.localizedDescription)")
    }
    
}

/*
 fetchURLSession { response in
     switch response{
     case .success(let data):
         print(data)
     case .failure(let err):
         print(err.localized)
     }
 }
 */

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
        UserApi.shared.loginWithKakaoAccount { [weak self] (_ oauthToken, error) in
            guard let self = self else { return }
            
            if let error = error {
                self.loginDelegate?.loginFail(error: "kakao Login Error: \(error.localizedDescription)")
            } else {
                print("loginWithKakaoAccount() success.")
                
                UserApi.shared.me { user, error in
                    if let error = error {
                        print("Kakao user get info Error, \(error.localizedDescription)")
                    } else {
                        
                        guard let kakaoUser = user,
                              let kakaoUserId = kakaoUser.id,
                              let kakaoUserEmail = kakaoUser.kakaoAccount?.email else { return }
                        
                        print(kakaoUserId)
                        print(kakaoUserEmail)
                        
                        LoginAPICenter.fetchUserData(.kakao, userID: String(kakaoUserId), email: kakaoUserEmail) { (response) in
                            switch response {
                            case .success(let data):
                                print(data)
                                
                                self.loginDelegate?.loginSuccess()
                            case .failure(let err):
                                print(err.localized)
                            }
                        }
                    }
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
            
            if let userEmail = appleIDCredetial.email {
                
                print(appleIDCredetial.user)
                print(userEmail)
                
                LoginAPICenter.fetchUserData(.apple,
                                             userID: appleIDCredetial.user,
                                             email: userEmail) { (response) in
                    switch response {
                    case .success(let data):
                        print(data)
                        
                        self.loginDelegate?.loginSuccess()
                    case .failure(let err):
                        print(err.localized)
                    }
                }
            }
            
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

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
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk {[weak self] (_ oauthToken, error) in
                guard let self = self else { return }
                
                if let error = error {
                    print(error)
                } else {
                    print("loginWithKakaoTalk() success.")
                    self.requestKakaoLogin()
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { [weak self] (_ oauthToken, error) in
                guard let self = self else { return }
                
                if let error = error {
                    self.loginDelegate?.loginFail(error: "kakao Login Error: \(error.localizedDescription)")
                } else {
                    print("loginWithKakaoAccount() success.")
                    self.requestKakaoLogin()
                }
            }
        }
    }
    
    private func requestKakaoLogin() {
        
        // do something
        UserApi.shared.me { user, error in
            if let error = error {
                print("Kakao user get info Error, \(error.localizedDescription)")
            } else {
                guard let kakaoUser = user,
                      let kakaoUserId = kakaoUser.id,
                      let kakaoUserEmail = kakaoUser.kakaoAccount?.email else { return }
                
                print(kakaoUserId)
                print(kakaoUserEmail)
                
                let kakaoUserInfo = LoginKind.SignIn.kakao(userID: String(kakaoUserId),
                                                           email: kakaoUserEmail)
                
                LoginAPICenter.fetchSignIn(kakaoUserInfo.loginValue) { [weak self] (response) in
                    guard let self = self else { return }
                    
                    switch response {
                    case .success(let data):
                        // home으로 이동
                        print(data)
                        self.loginDelegate?.loginSuccess()
                    case .failure(let err):
                        // onboarding으로 이동
                        print(err.localized)
                        // user정보 싱글턴에 저장
                        let userinfo = UserInfo.shared
                        userinfo.vendor = LoginKind.LoginRawValue.kakao.vendor
                        userinfo.vendorID = String(kakaoUserId)
                        userinfo.userEmail = kakaoUserEmail
                        
                        print("=======================")
                        print(userinfo.vendor)
                        print(userinfo.vendorID)
                        print(userinfo.userEmail)
                        print("=======================")
                        
                        self.loginDelegate?.presentOnboarding()
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
            print(appleIDCredetial.email)
            print(appleIDCredetial.fullName)
            print(appleIDCredetial.user)
            
            let tokenString = String(data: appleIDCredetial.identityToken!, encoding: .utf8)
            print(tokenString)
            // keychain 저장용 프로퍼티
            let saveUserInfo = KeychainUserInfo(userIdentifier: appleIDCredetial.user,
                                                userEmail: appleIDCredetial.email)
            
            // 초기 로그인시에만 이메일받아오기 때문에 로직 수정 필요
            if let userEmail = appleIDCredetial.email {
                
                print(appleIDCredetial.user)
                print(userEmail)
                
                let appleUserInfo = LoginKind.SignIn.apple(userID: appleIDCredetial.user, email: userEmail)
                
                LoginAPICenter.fetchSignIn(appleUserInfo.loginValue) { [weak self] (response) in
                    guard let self = self else { return}
                    
                    switch response {
                    case .success(let data):
                        print(data)

                        _ = KeyChainModel.shared.createUserInfo(with: saveUserInfo)
                        self.loginDelegate?.loginSuccess()
                    case .failure(let err):
                        print(err.localized)
                        // user정보 싱글턴에 저장
                        let userinfo = UserInfo.shared
                        userinfo.vendor = LoginKind.LoginRawValue.apple.vendor
                        userinfo.vendorID = String(appleIDCredetial.user)
                        userinfo.userEmail = appleIDCredetial.email
                        
                        print(userinfo.vendor)
                        print(userinfo.vendorID)
                        print(userinfo.userEmail)
                        _ = KeyChainModel.shared.createUserInfo(with: saveUserInfo)
                        self.loginDelegate?.presentOnboarding()
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

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
    
    // 로그인 성공시 유저정보 저장
    let loginUserInfo = LoginUser.shared
    // 로그인 실패시 온보딩으로 전달하기위한 유저정보
    let onboardingUserInfo = OnboardingUserInfo.shared
    
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
                        
                        self.loginUserInfo.userNickname = data.nickname
                        self.loginUserInfo.userProfileImageUrl = data.profilePictureImage
                        self.loginUserInfo.vendor = data.vendor
                        
                        self.loginDelegate?.loginSuccess()
                    case .failure(let err):
                        // onboarding으로 이동
                        print(err.localized)
                        // user정보 싱글턴에 저장
                        
                        self.onboardingUserInfo.vendor = LoginKind.LoginRawValue.kakao.vendor
                        self.onboardingUserInfo.vendorID = String(kakaoUserId)
                        self.onboardingUserInfo.userEmail = kakaoUserEmail
                        
                        print("=======================")
                        print(self.onboardingUserInfo.vendor)
                        print(self.onboardingUserInfo.vendorID)
                        print(self.onboardingUserInfo.userEmail)
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
            
            print("========================")
            print(appleIDCredetial.email)
            print(appleIDCredetial.fullName)
            print(appleIDCredetial.user)
            print("========================")
            
//            let tokenString = String(data: appleIDCredetial.identityToken!, encoding: .utf8)
//            print(tokenString)
            // keychain 저장용 프로퍼티
            let saveUserInfo = KeychainUserInfo(userIdentifier: appleIDCredetial.user,
                                                userEmail: appleIDCredetial.email)
            
            let appleUserInfo = LoginKind.SignIn.apple(userID: appleIDCredetial.user,
                                                       email: appleIDCredetial.email ?? "")
            
            LoginAPICenter.fetchSignIn(appleUserInfo.loginValue) { [weak self] (response) in
                guard let self = self else { return}
                
                switch response {
                case .success(let data):
                    print(data)
                    
                    self.loginUserInfo.userNickname = data.nickname
                    self.loginUserInfo.userProfileImageUrl = data.profilePictureImage
//                        loginUserInfo.vendor = data.vendor
                    
                    _ = KeyChainModel.shared.createUserInfo(with: saveUserInfo)
                    self.loginDelegate?.loginSuccess()
                case .failure(let err):
                    print(err.localized)
                    // user정보 싱글턴에 저장
                    
                    self.onboardingUserInfo.vendor = LoginKind.LoginRawValue.apple.vendor
                    self.onboardingUserInfo.vendorID = String(appleIDCredetial.user)
                    self.onboardingUserInfo.userEmail = appleIDCredetial.email
                    
                    self.loginDelegate?.presentOnboarding()
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

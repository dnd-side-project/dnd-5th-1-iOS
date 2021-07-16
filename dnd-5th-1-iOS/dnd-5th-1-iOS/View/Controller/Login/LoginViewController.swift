//
//  LoginViewController.swift
//  dnd-5th-1-iOS
//
//  Created by taeuk on 2021/07/12.
//

import UIKit
import AuthenticationServices
import KakaoSDKUser
import KakaoSDKAuth

class LoginViewController: BaseViewContoller {
    
    // MARK: - Properties
    
    var loginViewModel: LoginViewModel? = LoginViewModel()
    
    @IBOutlet weak var appleLoginButton: ASAuthorizationAppleIDButton!
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginViewModel?.loginDelegate = self
    }

    @IBAction func kakaoAction(_ sender: UIButton) {
        loginViewModel?.kakaoLogin()
    }
    
    @IBAction func appleLogin(_ sender: ASAuthorizationAppleIDButton) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = loginViewModel
        authorizationController.presentationContextProvider = loginViewModel
        authorizationController.performRequests()
    }
}

// MARK: - Protocol Login State

extension LoginViewController: LoginState {
    
    func loginSuccess() {
        print("\(Date()): Login Success")
    }
    
    func loginFail(error: String) {
        print(error)
    }
}

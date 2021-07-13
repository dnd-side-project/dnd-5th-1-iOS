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

class LoginViewController: UIViewController {
    
    var loginViewModel: LoginViewModel? = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginViewModel?.loginDelegate = self
    }

    @IBAction func kakaoAction(_ sender: UIButton) {
        loginViewModel?.kakaoLogin()
    }
}

extension LoginViewController: LoginState {
    
    func loginSuccess() {
        print("\(Date()): Login Success")
    }
    
    func loginFail(error: String) {
        print(error)
    }
}

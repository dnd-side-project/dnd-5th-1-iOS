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
        
        UserApi.shared.unlink {(error) in
            if let error = error {
                print(error)
            } else {
                print("unlink() success.")
            }
        }
        
//        let images = ["3","3","3","4","5","5"]
        let images = ["4"]
        var imageData: [Any] = []
        
        images.forEach {
            let image = UIImage(named: $0)
            imageData.append((image?.jpegData(compressionQuality: 0.2))!)
//            imageData.append((image?.pngData()) ?? Data())
        }
        if let imagedatas = imageData as? [Data] {
            print(imagedatas)
            print(imagedatas.count)
            let param = [
                "files": imagedatas
            ]
//            ImageAPICenter.convertImage(param)
        }
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
    
    @IBAction func apiTestAction(_ sender: UIButton) {
        
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

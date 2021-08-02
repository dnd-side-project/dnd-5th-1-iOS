//
//  LoginsViewController.swift
//  Picme
//
//  Created by taeuk on 2021/08/02.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKUser
import AuthenticationServices

class LoginViewController: BaseViewContoller {

    // MARK: - Properties
    
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var subLable: UILabel!
    @IBOutlet weak var kakaoLoginButton: UIButton!
    @IBOutlet weak var appleLoginButton: ASAuthorizationAppleIDButton!
    @IBOutlet weak var unLoginButton: UIButton!
    
    var loginViewModel: LoginViewModel? = LoginViewModel()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginViewModel?.loginDelegate = self
    }

    @IBAction func kakaoLoginAction(_ sender: UIButton) {
        loginViewModel?.kakaoLogin()
    }
    
    @IBAction func appleLoginAction(_ sender: Any) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = loginViewModel
        authorizationController.presentationContextProvider = loginViewModel
        authorizationController.performRequests()
    }
    
    @IBAction func unLoginAction(_ sender: UIButton) {
        self.present(OnboardingViewController(), animated: true, completion: nil)
    }
}

// MARK: - UI

extension LoginViewController {
    
    // Label 일부 색 변경
    func attributeString(text: String?, changeString: String) -> NSMutableAttributedString {
        guard let text = text else { fatalError("NSMutable Error") }
        let attributeString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(.foregroundColor,
                                     value: UIColor.logoColor(.logoPink),
                                     range: (text as NSString).range(of: changeString))
        return attributeString
    }
    
    override func setConfiguration() {
        
        // Color
        view.backgroundColor = .solidColor(.solid0)
        mainTitleLabel.textColor = .textColor(.text100)
        subLable.textColor = .textColor(.text71)
        unLoginButton.setTitleColor(.textColor(.text91), for: .normal)
        
        // String
        mainTitleLabel.attributedText = attributeString(text: mainTitleLabel.text, changeString: "인생사진")
        
        appleLoginButton.layer.cornerRadius = 12
    }
}

extension LoginViewController: LoginState {
    
    func presentOnboarding() {
        let onBoarding = UIStoryboard(name: "Onboarding", bundle: nil)
        let presentController = onBoarding.instantiateViewController(withIdentifier: "OnboardingViewController")
        self.present(presentController, animated: true, completion: nil)
    }
    
    func loginSuccess() {
        print("\(Date()): Login Success")
    }
    
    func loginFail(error: String) {
        print(error)
    }
}

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
    @IBOutlet weak var kakaoLoginButton: UIButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    @IBOutlet weak var unLoginButton: UIButton!
    
    var loginViewModel: LoginViewModel? = LoginViewModel()
    
    // 애플 로고
    let appleLogoImage: UIImageView = {
        $0.image = UIImage(named: "Black Logo Large")
        $0.contentMode = .scaleAspectFill
        return $0
    }(UIImageView())
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginViewModel?.loginDelegate = self
        
    }

    @IBAction func kakaoLoginAction(_ sender: UIButton) {
        loginViewModel?.kakaoLogin()
    }
    
    @IBAction func appleLoginAction(_ sender: ASAuthorizationAppleIDButton) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = loginViewModel
        authorizationController.presentationContextProvider = loginViewModel
        authorizationController.performRequests()
    }
    
    @IBAction func unLoginAction(_ sender: UIButton) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = mainStoryboard.instantiateViewController(withIdentifier:
                                                                            "TabBarController")
        self.present(mainViewController, animated: true, completion: nil)
    }
}

// MARK: - UI

extension LoginViewController {
    
    // Label 일부 색 변경
    func attributeString(text: String?, changeString: String) -> NSMutableAttributedString {
        guard let text = text else { fatalError("NSMutable Error") }
        let attributeString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(.foregroundColor,
                                     value: UIColor.mainColor(.logoPink),
                                     range: (text as NSString).range(of: changeString))
        return attributeString
    }
    
    override func setProperties() {
        
        appleLoginButton.layer.cornerRadius = 10
        appleLoginButton.backgroundColor = .white
        appleLoginButton.setTitleColor(.solidColor(.solid0), for: .normal)
        appleLoginButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        appleLoginButton.addSubview(appleLogoImage)
    }
    
    override func setConfiguration() {
        
        // Color
        view.backgroundColor = .solidColor(.solid0)
        mainTitleLabel.textColor = .textColor(.text100)
        unLoginButton.setTitleColor(.textColor(.text91), for: .normal)
        
        // String
        mainTitleLabel.attributedText = attributeString(text: mainTitleLabel.text, changeString: "인생사진")
        
        appleLoginButton.layer.cornerRadius = 12
    }
    
    override func setConstraints() {
        
        appleLogoImage.snp.makeConstraints {
            $0.leading.equalTo(appleLoginButton.snp.leading).offset(15)
            $0.centerY.equalTo(appleLoginButton.snp.centerY)
            $0.width.equalTo(24)
        }
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
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = mainStoryboard.instantiateViewController(withIdentifier:
                                                                            "TabBarController")
        mainViewController.modalPresentationStyle = .fullScreen
        self.present(mainViewController, animated: true, completion: nil)
    }
    
    func loginFail(error: String) {
        print(error)
    }
}

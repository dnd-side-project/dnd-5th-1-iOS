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

final class LoginViewController: BaseViewContoller {

    // MARK: - Properties
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var kakaoLoginButton: UIButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    @IBOutlet weak var unLoginButton: UIButton!
    
    var loginViewModel: LoginViewModel? = LoginViewModel()
 
    // 카카오 로고
    private let kakaoLogoImage: UIImageView = {
        $0.image = UIImage(named: "kakaosymbol")
        $0.contentMode = .scaleAspectFill
        return $0
    }(UIImageView())
    
    // 애플 로고
    private let appleLogoImage: UIImageView = {
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
        mainViewController.modalPresentationStyle = .fullScreen
        self.present(mainViewController, animated: true, completion: nil)
    }
}

// MARK: - UI

extension LoginViewController {
    
    // Label 일부 색 변경
    func attributeString(text: String?, changeString: String) -> NSMutableAttributedString {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.87
        
        guard let text = text else { fatalError("NSMutable Error") }
        let attributeString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(.foregroundColor,
                                     value: UIColor.mainColor(.logoPink),
                                     range: (text as NSString).range(of: changeString))
        
        attributeString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                     value: paragraphStyle,
                                     range: NSMakeRange(0, attributeString.length))
        
        attributeString.addAttribute(.font,
                                     value: UIFont.kr(.black, size: 36),
                                     range: (text as NSString).range(of: changeString))
        
        return attributeString
    }
    
    override func setProperties() {
        
        mainLabel.textColor = .textColor(.text100)
        
        mainLabel.attributedText = attributeString(text: mainLabel.text, changeString: "인생사진")
        
        appleLoginButton.layer.cornerRadius = 10
        appleLoginButton.backgroundColor = .white
        appleLoginButton.setTitleColor(.solidColor(.solid0), for: .normal)
        appleLoginButton.titleLabel?.font = .kr(.bold, size: 16)
        appleLoginButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        appleLoginButton.addSubview(appleLogoImage)
        
        kakaoLoginButton.layer.cornerRadius = 10
        kakaoLoginButton.backgroundColor = UIColor(red: 254/255, green: 229/255, blue: 0/255, alpha: 1.0)
        kakaoLoginButton.setTitleColor(.solidColor(.solid0), for: .normal)
        kakaoLoginButton.titleLabel?.font = .kr(.bold, size: 16)
        kakaoLoginButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        kakaoLoginButton.addSubview(kakaoLogoImage)
    }
    
    override func setConfiguration() {
        
        // Color
        view.backgroundColor = .solidColor(.solid0)
        unLoginButton.setTitleColor(.textColor(.text91), for: .normal)
        
    }
    
    override func setConstraints() {
        
        kakaoLogoImage.snp.makeConstraints {
            $0.leading.equalTo(kakaoLoginButton.snp.leading).offset(15)
            $0.centerY.equalTo(kakaoLoginButton.snp.centerY)
            $0.width.equalTo(24)
        }
        
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
        
        if let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as? SceneDelegate {

            sceneDelegate.window?.rootViewController = mainViewController
            
            UIView.transition(with: sceneDelegate.window!,
                                  duration: 0.3,
                                  options: .transitionCrossDissolve,
                                  animations: nil,
                                  completion: nil)
        }
        
    }
    
    func loginFail(error: String) {
        print(error)
    }
}

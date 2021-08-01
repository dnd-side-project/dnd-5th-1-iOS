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
    @IBOutlet weak var appleLoginButton: UIButton!
    @IBOutlet weak var unLoginButton: UIButton!
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
    }
}

//
//  OnboardViewController.swift
//  Picme
//
//  Created by taeuk on 2021/08/02.
//

import UIKit

class OnboardingViewController: BaseViewContoller {

    // MARK: - Properties
    
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var nickNameTextfield: UITextField!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var validLabel: UILabel!
    
    var onboardingViewModel: OnboardingViewModel? = OnboardingViewModel()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nickNameTextfield.delegate = self
        onboardingViewModel?.onboardingDelegate = self
        // 시작하기 버튼 활성화 비활성화
        onboardingViewModel?.isButtonState.bindAndFire(listener: { state in
            self.startButtonState(state)
        })
        
        onboardingViewModel?.isVaildState.bindAndFire(listener: { state in
            self.validState(state)
        })
        
    }
    
    @objc func textfieldDidChanged(_ textfield: UITextField) {
        guard let text = textfield.text else { return }
        print(text)
        print(text.count)
        
        if text.count >= 12 {
            onboardingViewModel?.isVaildState.value = true
        } else {
            onboardingViewModel?.isVaildState.value = false
        }
        
        if !text.isEmpty {
            onboardingViewModel?.isButtonState.value = true
        } else {
            onboardingViewModel?.isButtonState.value = false
        }
    }
    
    func startButtonState(_ state: Bool) {
        
        if state {
            startButton.setTitleColor(.textColor(.text100), for: .normal)
            startButton.backgroundColor = .mainColor(.pink)
        } else {
            startButton.setTitleColor(.textColor(.text50), for: .normal)
            startButton.backgroundColor = .solidColor(.solid26)
        }
    }
    
    func validState(_ state: Bool) {
        if state {
            validLabel.isHidden = false
        } else {
            validLabel.isHidden = true
        }
    }
    
    @IBAction func loginRegistAction(_ sender: UIButton) {
        guard let nickNameText = nickNameTextfield.text else { return }
        onboardingViewModel?.registUser(nickNameText)
    }
}

extension OnboardingViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let utf8Char = string.cString(using: .utf8)
        let isBackSpace = strcmp(utf8Char, "\\b")
        
        if string.hasValidCharacter() || isBackSpace == -92 {
            return true
        }
        
        if textField.text!.count >= 12 {
            return false
        }
        
        return false
    }
}

// MARK: - addPadding

extension UITextField {
    
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
}

extension String {
    func hasValidCharacter() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[a-z0-9가-힣ㄱ-ㅎㅏ-ㅣ\\s]$",
                                                options: .caseInsensitive)
            if let _ = regex.firstMatch(in: self,
                                        options: .reportCompletion,
                                        range: NSMakeRange(0, self.count)) {
                return true
            }
        } catch let error {
            print(error.localizedDescription)
            return false
        }
        return false
    }
}

// MARK: - UI

extension OnboardingViewController {
    
    override func setProperties() {
        
        nickNameTextfield.textColor = .white
        nickNameTextfield.layer.cornerRadius = 10
        startButton.layer.cornerRadius = 10
        
        nickNameTextfield.addTarget(self, action: #selector(textfieldDidChanged(_:)), for: .editingChanged)
    }
    
    override func setConfiguration() {
        
        view.backgroundColor = .solidColor(.solid0)
        nickNameLabel.textColor = .mainColor(.pink)
        nickNameTextfield.backgroundColor = .solidColor(.solid12)
        startButton.setTitleColor(.textColor(.text50), for: .normal)
        startButton.backgroundColor = .solidColor(.solid26)
        
        nickNameTextfield.addLeftPadding()
        
        validLabel.isHidden = true
    }
}

extension OnboardingViewController: LoginState {
    
    // Main 연결
    func loginSuccess() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let presentVC = mainStoryboard.instantiateViewController(withIdentifier: "TabBarController")
        presentVC.modalPresentationStyle = .fullScreen
        self.present(presentVC, animated: true, completion: nil)
    }
    
    func loginFail(error: String) {}
    func presentOnboarding() {}

}

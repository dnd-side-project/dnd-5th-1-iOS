//
//  OnboardViewController.swift
//  Picme
//
//  Created by taeuk on 2021/08/02.
//

import UIKit
import SnapKit

final class OnboardingViewController: BaseViewContoller {

    // MARK: - Properties
    
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var nickNameCountLabel: UILabel!
    @IBOutlet weak var nickNameTextfield: UITextField!
    @IBOutlet weak var startButton: UIButton!
    
    private let clearTextViewButton: UIButton = {
        $0.isUserInteractionEnabled = true
        $0.setImage(UIImage(named: "x24"), for: .normal)
        return $0
    }(UIButton(type: .custom))
    
    var onboardingViewModel: OnboardingViewModel? = OnboardingViewModel()
    
    var nickNameTextCount: Int = 0 {
        didSet {
            nickNameCountLabel.text = "\(nickNameTextCount)/12"
            if nickNameTextCount >= 12 {
                nickNameCountLabel.textColor = .mainColor(.pink)
            } else {
                nickNameCountLabel.textColor = .textColor(.text71)
            }
        }
    }
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nickNameTextfield.delegate = self
        onboardingViewModel?.onboardingDelegate = self
        // 시작하기 버튼 활성화 비활성화
        onboardingViewModel?.isButtonState.bindAndFire(listener: { state in
            self.startButtonState(state)
        })
        
    }
    
    @objc func textfieldDidChanged(_ textfield: UITextField) {
        guard let text = textfield.text else { return }
        
        nickNameTextCount = text.count
        
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
            startButton.isEnabled = state
        } else {
            startButton.setTitleColor(.textColor(.text50), for: .normal)
            startButton.backgroundColor = .solidColor(.solid26)
            startButton.isEnabled = state
        }
    }
    
    @IBAction func loginRegistAction(_ sender: UIButton) {
        guard let nickNameText = nickNameTextfield.text else { return }
        onboardingViewModel?.registUser(nickNameText)
    }
    
    @objc func clearText(_ sender: UIButton) {
        nickNameTextfield.text = ""
        nickNameTextCount = 0
        clearTextViewButton.isHidden = true
        startButton.setTitleColor(.textColor(.text50), for: .normal)
        startButton.backgroundColor = .solidColor(.solid26)
        startButton.isEnabled = false
    }
}

extension OnboardingViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let utf8Char = string.cString(using: .utf8)
        let isBackSpace = strcmp(utf8Char, "\\b")
        
        if string.hasValidCharacter() || isBackSpace == -92 {
            
            if textField.text!.count < 12 || isBackSpace == -92 {
                return true
            } else {
                return false
            }
        }
        return false
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text != "" {
            clearTextViewButton.isHidden = false
        } else {
            clearTextViewButton.isHidden = true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        nickNameTextfield.layer.borderWidth = 1
        nickNameTextfield.layer.borderColor = UIColor.solidColor(.solid26).cgColor
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        nickNameTextfield.layer.borderWidth = 0
        nickNameTextfield.layer.borderColor = UIColor.clear.cgColor
        
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
            let regex = try NSRegularExpression(pattern: "^[a-z0-9가-힣ㄱ-ㅎㅏ-ㅣ]$",
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
        
        nickNameTextfield.textColor = .textColor(.text100)
        nickNameTextfield.layer.cornerRadius = 10
        nickNameCountLabel.textColor = .textColor(.text71)
        
        startButton.layer.cornerRadius = 10
        
        nickNameTextfield.addTarget(self, action: #selector(textfieldDidChanged(_:)), for: .editingChanged)
        clearTextViewButton.addTarget(self, action: #selector(clearText(_:)), for: .touchUpInside)
    }
    
    override func setConfiguration() {
        
        view.backgroundColor = .solidColor(.solid0)
        nickNameLabel.textColor = .mainColor(.pink)
        nickNameTextfield.backgroundColor = .solidColor(.solid12)
        startButton.setTitleColor(.textColor(.text50), for: .normal)
        startButton.backgroundColor = .solidColor(.solid26)
        
        nickNameTextfield.addLeftPadding()

        view.addSubview(clearTextViewButton)
        clearTextViewButton.isHidden = true
    }
    
    override func setConstraints() {
        
        clearTextViewButton.snp.makeConstraints {
            $0.top.equalTo(nickNameTextfield).offset(12)
            $0.trailing.equalTo(nickNameTextfield).inset(12)
            $0.bottom.equalTo(nickNameTextfield).inset(12)
            $0.width.equalTo(24)
        }
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

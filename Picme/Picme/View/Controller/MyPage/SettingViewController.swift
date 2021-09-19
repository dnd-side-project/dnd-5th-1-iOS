//
//  SettingViewController.swift
//  Picme
//
//  Created by 권민하 on 2021/09/14.
//

import UIKit

class SettingViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var nicknameOverlapLabel: UILabel!
    @IBOutlet weak var nicknameCountLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    // MARK: - Variables
    
    var settingViewModel: SettingViewModel? = SettingViewModel()
    
    var nickNameTextCount: Int = 0 {
        didSet {
            nicknameCountLabel.text = "\(nickNameTextCount)/12"
            if nickNameTextCount >= 12 {
                nicknameCountLabel.textColor = .mainColor(.pink)
            } else {
                nicknameCountLabel.textColor = .textColor(.text71)
            }
        }
    }
    
    // MARK: - Left Bar Button Action
    
    @IBAction func leftBarButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nickNameTextField.delegate = self
        nickNameTextField.clearButtonMode = .whileEditing
        nickNameTextField.addLeftPadding()
        nickNameTextField.addTarget(self, action: #selector(textfieldDidChanged(_:)), for: .editingChanged)
       
        // nickNameTextField.addRightPadding()
        if let button = nickNameTextField.value(forKey: "clearButton") as? UIButton {
            button.setImage(button.image(for: .normal)?.withRenderingMode(.alwaysTemplate), for: .normal)
            button.tintColor = .white
           // button.setImage(UIImage(named: "x24")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        // 수정하기 버튼 활성화 비활성화
        settingViewModel?.isButtonState.bindAndFire(listener: { state in
            self.startButtonState(state)
        })
    }
    
    @objc func textfieldDidChanged(_ textfield: UITextField) {
        guard let text = textfield.text else { return }
        
        nickNameTextCount = text.count
        
        if text.count >= 12 {
            settingViewModel?.isVaildState.value = true
        } else {
            settingViewModel?.isVaildState.value = false
        }
        
        if !text.isEmpty {
            settingViewModel?.isButtonState.value = true
        } else {
            settingViewModel?.isButtonState.value = false
        }
    }
    
    func startButtonState(_ state: Bool) {
        
        if state {
            editButton.setTitleColor(.textColor(.text100), for: .normal)
            editButton.backgroundColor = .mainColor(.pink)
            editButton.isEnabled = state
        } else {
            editButton.setTitleColor(.textColor(.text50), for: .normal)
            editButton.backgroundColor = .solidColor(.solid26)
            editButton.isEnabled = state
        }
    }
    
}

//extension UITextField {
//
//    // Clear Button White
//    open override func layoutSubviews() {
//          super.layoutSubviews()
//
//          for view in subviews {
//              if let button = view as? UIButton {
//                  button.setImage(button.image(for: .normal)?.withRenderingMode(.alwaysTemplate), for: .normal)
//                  button.tintColor = .white
//              }
//          }
//      }
//}

//// MARK: - addPadding
//
//extension UITextField {
//
//    func addRightPadding() {
//        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
//        self.rightView = paddingView
//        self.rightViewMode = ViewMode.always
//    }
//}

extension SettingViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let utf8Char = string.cString(using: .utf8)
        let isBackSpace = strcmp(utf8Char, "\\b")
        
        // OnboardingViewController에서 정의한 hasValidCharacter 사용
        if string.hasValidCharacter() || isBackSpace == -92 {
            
            if textField.text!.count < 12 || isBackSpace == -92 {
                return true
            } else {
                return false
            }
        }
        return false
    }
}

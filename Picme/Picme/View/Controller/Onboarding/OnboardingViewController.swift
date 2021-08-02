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
    
    var onboardingViewModel: OnboardingViewModel? = OnboardingViewModel()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onboardingViewModel?.isButtonState.bindAndFire(listener: { state in
            self.startButtonState(state)
        })
    }
    
    @objc func textfieldDidChanged(_ textfield: UITextField) {
        guard let text = textfield.text else { return }
        
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
}

// MARK: - addPadding

extension UITextField {
    
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
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
    }
}

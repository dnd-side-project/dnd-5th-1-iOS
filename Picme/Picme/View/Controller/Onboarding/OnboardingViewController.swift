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
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    }
    
    override func setConfiguration() {
        
        view.backgroundColor = .solidColor(.solid0)
        nickNameLabel.textColor = .mainColor(.pink)
        nickNameTextfield.backgroundColor = .solidColor(.solid12)
        startButton.setTitleColor(.textColor(.text50), for: .normal)
        startButton.backgroundColor = .solidColor(.solid26)
        
        // 입력시
//        startButton.setTitleColor(.textColor(.text100), for: .normal)
//        startButton.backgroundColor = .mainColor(.pink)
        
        nickNameTextfield.addLeftPadding()
    }
}

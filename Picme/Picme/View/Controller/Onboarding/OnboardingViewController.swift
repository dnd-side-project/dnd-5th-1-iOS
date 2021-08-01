//
//  OnboardingViewController.swift
//  Picme
//
//  Created by taeuk on 2021/08/01.
//

import UIKit

class OnboardingViewController: BaseViewContoller {

    // MARK: - Properties
//    @IBOutlet weak var nickNameLabel: UILabel!
//    @IBOutlet weak var nickNameTextfield: UITextField!
//    @IBOutlet weak var startButton: UIButton!
    
    private let nickNameLable: UILabel = {
        $0.text = "사용할 닉네임"
        $0.textColor = .mainColor(.pink)
        $0.font = .systemFont(ofSize: 16)
        return $0
    }(UILabel())
    
    private let nickNameTextfield: UITextField = {
        $0.placeholder = "최대 12자 까지 자유롭게 입력해 주세요."
        $0.backgroundColor = .solidColor(.solid12)
        $0.layer.cornerRadius = 10
        $0.textColor = .white
        $0.addLeftPadding()
        return $0
    }(UITextField())
    
    private let centerStackView: UIStackView = {
        $0.axis = .vertical
        $0.alignment = .center
        $0.distribution = .fill
        $0.spacing = 10
        return $0
    }(UIStackView())
    
    private let startButton: UIButton = {
        $0.setTitle("시작하기", for: .normal)
        $0.setTitleColor(.textColor(.text50), for: .normal)
        $0.backgroundColor = .solidColor(.solid26)
        $0.layer.cornerRadius = 10
        return $0
    }(UIButton(type: .system))
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
extension UITextField {
    
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
}
// MARK: - UI

extension OnboardingViewController {
    
    override func setConfiguration() {
        
        view.backgroundColor = .solidColor(.solid0)
        view.addSubview(centerStackView)
        view.addSubview(startButton)
        centerStackView.addArrangedSubview(nickNameLable)
        centerStackView.addArrangedSubview(nickNameTextfield)
        
        // 입력시
//        startButton.backgroundColor = .mainColor(.pink)
//        startButton.setTitleColor(.textColor(.text100), for: .normal)
    }
    
    override func setConstraints() {
        
        nickNameTextfield.translatesAutoresizingMaskIntoConstraints = false
        nickNameTextfield.heightAnchor.constraint(equalToConstant: 52)
            .isActive = true
        nickNameTextfield.leadingAnchor.constraint(equalTo: centerStackView.leadingAnchor)
            .isActive = true
        nickNameTextfield.trailingAnchor.constraint(equalTo: centerStackView.trailingAnchor)
            .isActive = true
        
        centerStackView.translatesAutoresizingMaskIntoConstraints = false
        centerStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20)
            .isActive = true
        centerStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            .isActive = true
        centerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
            .isActive = true
        centerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            .isActive = true
        
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
            .isActive = true
        startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            .isActive = true
        startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
            .isActive = true
        startButton.heightAnchor.constraint(equalToConstant: 52)
            .isActive = true
    }
    
}

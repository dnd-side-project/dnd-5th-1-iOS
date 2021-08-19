//
//  MyPageViewController.swift
//  Picme
//
//  Created by taeuk on 2021/08/15.
//

import UIKit
import AuthenticationServices

class MyPageViewController: BaseViewContoller {

    // MARK: - Properties
    
    @IBOutlet weak var logOutButton: UIButton!
    
    @IBOutlet weak var userIdentifierLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userStackView: UIStackView!
    var mypageViewModel: MyPageViewModel?
    
    let loginUserInfo = LoginUser.shared
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mypageViewModel?.logOutDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let nickName = loginUserInfo.userNickname,
           let userImageUrl = loginUserInfo.userProfileImageUrl {
            myPageSetting(name: nickName, image: userImageUrl)
        } else {
            myPageSetting(name: "로그인 전", image: "mypageWhite")
        }
    }
    
    @IBAction func userSettingAction(_ sender: UIButton) {
        
    }
    
    @IBAction func logOutAction(_ sender: UIButton) {
        print("LogOut")
        mypageViewModel?.logOutAction(from: loginUserInfo.vendor)
        // 로그인 뷰로 이동 ( 초기화면으로 이동?)
    }
    
    func myPageSetting(name: String, image: String) {
        userIdentifierLabel.text = name
        // 수정전
        userImage.image = UIImage(named: image)
    }
}

// 로그아웃

extension MyPageViewController: LogOutProtocol {
    
    func logoutFromMain() {
        let presentLogin = UIStoryboard(name: "Login", bundle: nil)
        let loginVC = presentLogin.instantiateViewController(withIdentifier: "LoginViewController")
        loginVC.modalPresentationStyle = .fullScreen
        self.present(loginVC, animated: true, completion: nil)
    }
}

// MARK: - UI

extension MyPageViewController {
    
    override func setProperties() {
        
        userStackView.layer.cornerRadius = 10
        userStackView.backgroundColor = .solidColor(.solid12)
        
        logOutButton.setTitleColor(.textColor(.text100), for: .normal)
        logOutButton.layer.cornerRadius = 10
        logOutButton.layer.borderWidth = 1
        logOutButton.layer.borderColor = UIColor.textColor(.text100).cgColor
        logOutButton.backgroundColor = .solidColor(.solid0)
    }
    
    override func setConfiguration() {
        
        view.backgroundColor = .solidColor(.solid0)
        
        // isLayoutMarginsRelativeArrangement 프로퍼티 true를 해야 arranged view들이 지정된 margin의 값을 따름
        userStackView.isLayoutMarginsRelativeArrangement = true
        userStackView.layoutMargins = UIEdgeInsets(top: 24, left: 16, bottom: 24, right: 16)
        
        // navigation
        if let navBar = navigationController?.navigationBar {
            navBar.isTranslucent = false
            navBar.barTintColor = .solidColor(.solid0)

            navBar.topItem?.title = "마이페이지"
            
            navBar.titleTextAttributes = [.foregroundColor: UIColor.textColor(.text100),
                                          NSAttributedString.Key.font: UIFont.kr(.bold, size: 16)]
        }
    }
}

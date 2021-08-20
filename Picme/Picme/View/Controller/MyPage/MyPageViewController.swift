//
//  MyPageViewController.swift
//  Picme
//
//  Created by taeuk on 2021/08/15.
//

import UIKit
import AuthenticationServices

class MyPageViewController: BaseViewContoller {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var allVoteListButton: UIButton!
    @IBOutlet weak var myBedgeButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    
    @IBOutlet weak var userIdentifierLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var myVoteCountLabel: UILabel!
    @IBOutlet weak var participationCountLabel: UILabel!
    @IBOutlet weak var overallWinRateLabel: UILabel!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    var mypageViewModel: MyPageViewModel? = MyPageViewModel()
    
    let loginUserInfo = LoginUser.shared
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mypageViewModel?.logOutDelegate = self
        
        userIdentifierLabel.text = loginUserInfo.userNickname
        userImage.kf.setImage(with: URL(string: loginUserInfo.userProfileImageUrl!), placeholder: #imageLiteral(resourceName: "progressCircle"))
        
        setupButtons()
    }
    
    // MARK: - Log Out
    
    @IBAction func logOutAction(_ sender: UIButton) {
        
        // guard let userVendor = loginUserInfo.vendor else { return }
        
        AlertView.instance.showAlert(using: .logOut)
        AlertView.instance.actionDelegate = self
        
//        let alert = UIAlertController(title: nil, message: "로그아웃하시겠습니까", preferredStyle: .alert)
//
//        let doneAction = UIAlertAction(title: "예", style: .default) { [weak self] _ in
//
//            self?.mypageViewModel?.logOutAction(from: userVendor)
//            // 로그인 뷰로 이동 ( 초기화면으로 이동?)
//
//        }
//
//        let cancelAction = UIAlertAction(title: "아니요", style: .cancel, handler: nil)
//
//        alert.addAction(cancelAction)
//        alert.addAction(doneAction)
//
//        self.present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Button Actions
    
    func setupButtons() {
        allVoteListButton.tag = 1
        myBedgeButton.tag = 2
        settingButton.tag = 3
        
        allVoteListButton.addTarget(self, action: #selector(showAlertView), for: UIControl.Event.touchUpInside)
        myBedgeButton.addTarget(self, action: #selector(showAlertView), for: UIControl.Event.touchUpInside)
        settingButton.addTarget(self, action: #selector(showAlertView), for: UIControl.Event.touchUpInside)
    }
    
    @objc func showAlertView(_ sender: UIButton) {
        AlertView.instance.showAlert(using: .service)
        AlertView.instance.actionDelegate = self
    }

}

// MARK: - Alert View Action Delegate

extension MyPageViewController: AlertViewActionDelegate {
    
    func serviceTapped() {
        guard let userVendor = loginUserInfo.vendor else { return }
        self.mypageViewModel?.logOutAction(from: userVendor)
    }

}

// MARK: - Log Out Protocol

extension MyPageViewController: LogOutProtocol {
    
    func logoutFromMain() {
        let presentLogin = UIStoryboard(name: "Login", bundle: nil)
        let loginVC = presentLogin.instantiateViewController(withIdentifier: "LoginViewController")
        loginVC.modalPresentationStyle = .fullScreen
        self.present(loginVC, animated: true, completion: nil)
    }
}

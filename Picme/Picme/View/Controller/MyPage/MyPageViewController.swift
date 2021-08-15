//
//  MyPageViewController.swift
//  Picme
//
//  Created by taeuk on 2021/08/15.
//

import UIKit

class MyPageViewController: BaseViewContoller {

    @IBOutlet weak var logOutButton: UIButton!
    
    @IBOutlet weak var userIdentifierLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func userSettingAction(_ sender: UIButton) {
        
    }
    
    @IBAction func logOutAction(_ sender: UIButton) {
        print("LogOut")
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

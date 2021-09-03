//
//  PersonalInfoViewContoller.swift
//  Picme
//
//  Created by taeuk on 2021/09/03.
//

import UIKit

class PersonalInfoViewContoller: BaseViewContoller {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Navigation
        navigationController?.navigationBar.tintColor = .white
        navigationItem.title = "개인정보 처리방침"
        navigationItem.hidesBackButton = true
        
        let customBackButton = UIBarButtonItem(image: UIImage(named: "x28"),
                                               style: .done,
                                               target: self,
                                               action: #selector(backAction(_:)))
        navigationItem.leftBarButtonItem = customBackButton
    }

    @objc func backAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

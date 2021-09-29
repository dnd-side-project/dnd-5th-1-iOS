//
//  MyVoteViewController.swift
//  Picme
//
//  Created by 권민하 on 2021/09/28.
//

import UIKit

class MyVoteViewController: UIViewController {

    @IBAction func leftBarButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}

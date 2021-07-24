//
//  BaseViewContoller.swift
//  dnd-5th-1-iOS
//
//  Created by taeuk on 2021/07/11.
//

import UIKit

class BaseViewContoller: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setProperties()
        setConfiguration()

    }
    
    @objc dynamic func setConfiguration() {}
    @objc dynamic func setProperties() {}

}

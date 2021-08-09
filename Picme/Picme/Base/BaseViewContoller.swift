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
        setConstraints()
        setBind()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        view.endEditing(true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc dynamic func setConstraints() {}
    @objc dynamic func setConfiguration() {}
    @objc dynamic func setProperties() {}
    @objc dynamic func setBind() {}
}

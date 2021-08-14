//
//  AlertView.swift
//  Picme
//
//  Created by 권민하 on 2021/08/15.
//

import UIKit

class AlertView: UIView {
    
    static let instance = AlertView()
    
    @IBOutlet var rootView: UIView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var XButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var denyButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        Bundle.main.loadNibNamed("AlertView", owner: self, options: nil)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        rootView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        rootView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        XButton.addTarget(self, action: #selector(removeButtonClicked), for: UIControl.Event.touchUpInside)
        denyButton.addTarget(self, action: #selector(removeButtonClicked), for: UIControl.Event.touchUpInside)
        doneButton.addTarget(self, action: #selector(doneButtonClicked), for: UIControl.Event.touchUpInside)
    }
    
    enum AlertType {
        case login
        case delete
        case report
    }
    
    func showAlert(title: String, denyButtonTitle: String, doneButtonTitle: String, image: UIImage, alertType: AlertType) {
        
        self.titleLabel.text = title
        self.imageView.image = image
        self.denyButton.setTitle(denyButtonTitle, for: .normal)
        self.doneButton.setTitle(doneButtonTitle, for: .normal)
   
        switch alertType {
        case .login:
            doneButton.tag = 1
        case .delete:
            doneButton.tag = 2
        case .report:
            doneButton.tag = 3
        }
        
        UIApplication.shared.windows.first?.addSubview(rootView)
    }
    
    @objc func doneButtonClicked(_ sender: UIButton) {
        print("doneButton")

        switch sender.tag {
        case 1:
            print("login")
        case 2:
            print("delete")
        case 3:
            print("report")
        default:
            print("error")
        }
    }
    
    @objc func removeButtonClicked(_ sender: UIButton) {
        rootView.removeFromSuperview()
    }
    
}

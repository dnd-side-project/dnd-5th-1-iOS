//
//  AlertView.swift
//  Picme
//
//  Created by 권민하 on 2021/08/15.
//

import UIKit

protocol AlertViewwDelegate: AnyObject {
    func loginButtonTapped()
}

class AlertView: UIView {
    
    static let instance = AlertView()
    
    var delegate: AlertViewwDelegate?
    
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
        alertView.layer.cornerRadius = 10
        
        XButton.addTarget(self, action: #selector(removeButtonClicked), for: UIControl.Event.touchUpInside)
        denyButton.addTarget(self, action: #selector(removeButtonClicked), for: UIControl.Event.touchUpInside)
        doneButton.addTarget(self, action: #selector(doneButtonClicked), for: UIControl.Event.touchUpInside)
    }
    
    enum AlertType {
        case login
        case delete
        case report
    }
    
//    func showAlert(title: String, denyButtonTitle: String, doneButtonTitle: String, image: UIImage, alertType: AlertType) {
//
//        self.titleLabel.text = title
//        self.imageView.image = image
//        self.denyButton.setTitle(denyButtonTitle, for: .normal)
//        self.doneButton.setTitle(doneButtonTitle, for: .normal)
//
//        switch alertType {
//        case .login:
//            doneButton.tag = 1
//        case .delete:
//            doneButton.tag = 2
//        case .report:
//            doneButton.tag = 3
//        }
//
//        UIApplication.shared.windows.first?.addSubview(rootView)
//    }
    enum MyAlert {
        case login
        case delete
        case report
        
        var tag: Int {
            switch self {
            case .login:
                return 0
            case .delete:
                return 1
            case .report:
                return 2
            }
        }
        
        func send(_ test: @escaping TypeCompletion) -> TypeCompletion? {
            switch self {
            case .login:
                return test
            case .report:
                return nil
            case .delete:
                return nil
            }
        }
    }
    
    typealias TypeCompletion = () -> Void
    
    func showAlert(title: String, denyButtonTitle: String, doneButtonTitle: String, image: UIImage, alertType: MyAlert, completion: @escaping TypeCompletion) {
        
        self.titleLabel.text = title
        self.imageView.image = image
        self.denyButton.setTitle(denyButtonTitle, for: .normal)
        self.doneButton.setTitle(doneButtonTitle, for: .normal)
        
        _ = alertType.send {
            completion()
        }
        
        doneButton.tag = alertType.tag
        
        UIApplication.shared.windows.first?.addSubview(rootView)
    }
    
    
    @objc func doneButtonClicked(_ sender: UIButton) {
        print("doneButton")
        

        
        switch sender.tag {
        case 0:
//            print("login")
            _ = MyAlert.login.send {
                print("Login")
            }
        case 2:
            print("delete")
        case 3:
            print("report")
        default:
            print("error")
        }
    }
    func testAction(_ voids: () -> Void) {
        
    }
    
//    func customAlert(_ type: AlertKind, doneAction: @escaping () -> Void) {
//
//        switch type {
//        case .declaration:
//            declarationAlert {
//                doneAction()
//            }
//        case .inputDataCancel:
//            dataCancelAlert {
//                doneAction()
//            }
//        case .listRemove:
//            listRemoveAction {
//                doneAction()
//            }
//        case .login:
//            loginAction {
//                doneAction()
//            }
//        case .logOut:
//            logOutAction {
//                doneAction()
//            }
//        }
//    }
//
//    private func declarationAlert(action: @escaping () -> Void) {
//        let alert = UIAlertController(title: "신고하기", message: "게시글에 문제가 있나요?\n신고를 하면 더이상 게시글이 안보여요", preferredStyle: .alert)
//        let cancel = UIAlertAction(title: "아니요", style: .cancel, handler: nil)
//
//        let okAction = UIAlertAction(title: "신고하기", style: .default) { _ in
//            action()
//        }
//
//        alert.addAction(cancel)
//        alert.addAction(okAction)
//        present(alert, animated: true, completion: nil)
//    }
    
    @objc func removeButtonClicked(_ sender: UIButton) {
        rootView.removeFromSuperview()
    }
    
}

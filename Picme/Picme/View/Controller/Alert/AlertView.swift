//
//  AlertView.swift
//  Picme
//
//  Created by 권민하 on 2021/08/15.
//

import UIKit

@objc protocol AlertViewActionDelegate: AnyObject {
    @objc optional func loginTapped()
    @objc optional func logOutTapped()
    @objc optional func inputDataCencelTapped()
    @objc optional func listRemoveTapped()
    @objc optional func reportTapped()
}

class AlertView: UIView {
    
    static let instance = AlertView()
    
    weak var actionDelegate: AlertViewActionDelegate?
    
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
        
        // setProperties
        titleLabel.font = .kr(.bold, size: 16)
        denyButton.titleLabel?.font = .kr(.bold, size: 16)
        doneButton.titleLabel?.font = .kr(.bold, size: 16)
    }
    
    enum AlertType: Int {
        /// 로그인, Tag = 0
        case logIn = 0
        /// 로그아웃, Tag = 1
        case logOut
        /// 입력중인 데이터 취소, Tag = 2
        case inputDataCencel
        /// 리스트 제거, Tag = 3
        case listRemove
        /// 신고하기, Tag = 4
        case report
        
        fileprivate var title: String {
            switch self {
            case .logIn:
                return "로그인을 해야 투표를 볼 수 있어요.\n로그인을 해주시겠어요?"
            case .logOut:
                return "로그아웃 하시겠어요?"
            case .inputDataCencel:
                return "지금 종료하면 입력중인 데이터가 사라져요.\n그래도 나가시겠어요?"
            case .listRemove:
                return "게시글을 삭제하면 다시 업로드 해야해요.\n정말 삭제하시겠어요?"
            case .report:
                return "게시글에 문제가 있나요?\n신고를 하면 더 이상 게시글이 안보여요"
            }
        }
        
        fileprivate var cancelButtonText: String {
            switch self {
            case .logOut, .inputDataCencel, .listRemove, .report:
                return "아니요"
            case .logIn:
                return "더 둘러볼래요"
            }
        }
        
        fileprivate var doneButtonText: String {
            switch self {
            case .logIn:
                return "로그인하기"
            case .logOut:
                return "로그아웃"
            case .inputDataCencel:
                return "나가기"
            case .listRemove:
                return "삭제하기"
            case .report:
                return "신고하기"
            }
        }
        
        fileprivate var image: UIImage? {
            switch self {
            case .logIn, .logOut:
                return UIImage(named: "eyeLarge")
            case .inputDataCencel, .listRemove:
                return UIImage(named: "trash")
            case .report:
                return UIImage(named: "report")
            }
        }
    }
    
    func showAlert(using type: AlertType) {
        
        titleLabel.text = type.title
        imageView.image = type.image
        denyButton.setTitle(type.cancelButtonText, for: .normal)
        doneButton.setTitle(type.doneButtonText, for: .normal)
        
        doneButton.tag = type.rawValue
        
        UIApplication.shared.windows.first?.addSubview(rootView)
    }
    
    @objc func doneButtonClicked(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            actionDelegate?.loginTapped?()
        case 1:
            actionDelegate?.logOutTapped?()
        case 2:
            actionDelegate?.inputDataCencelTapped?()
        case 3:
            actionDelegate?.listRemoveTapped?()
        case 4:
            actionDelegate?.reportTapped?()
        default:
            print("AlertView has Error....nothing case")
        }
        
        rootView.removeFromSuperview()
    }
    
    @objc func removeButtonClicked(_ sender: UIButton) {
        rootView.removeFromSuperview()
    }
}

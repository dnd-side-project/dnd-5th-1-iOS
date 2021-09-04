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
    @objc optional func serviceTapped()
    @objc optional func moveToHomeTab()
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
    @IBOutlet weak var buttonStackView: UIStackView!
    
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
        /// 로그인, Tag = 0, 1, 2
        case logInDetail
        case logInVote
        case logInMypage
        /// 로그아웃, Tag = 3
        case logOut
        /// 입력중인 데이터 취소, Tag = 4
        case inputDataCencel
        /// 리스트 제거, Tag = 5
        case listRemove
        /// 신고하기, Tag = 6
        case report
        /// 서비스 준비중, Tag = 7
        case service
        /// 업로드 사진 두 장 이하일 경우, Tag = 8
        case uploadImagesFailed
        /// 회원탈퇴, Tag = 9
        case leave
        
        fileprivate var title: String {
            switch self {
            case .logInDetail:
                return "로그인을 해야 투표를 볼 수 있어요.\n로그인을 해주시겠어요?"
            case .logInVote:
                return "로그인을 해야 투표를 만들 수 있어요.\n로그인을 해주시겠어요?"
            case .logInMypage:
                return "로그인을 해야 투표를 이용할 수 있어요.\n로그인을 해주시겠어요?"
            case .logOut:
                return "정말 로그아웃 하시겠어요?"
            case .inputDataCencel:
                return "지금 종료하면 입력중인 데이터가 사라져요.\n그래도 나가시겠어요?"
            case .listRemove:
                return "게시글을 삭제하면 다시 업로드 해야해요.\n정말 삭제하시겠어요?"
            case .report:
                return "게시글에 문제가 있나요?\n신고를 하면 더 이상 게시글이 안보여요"
            case .service:
                return "아직 서비스 준비 중이에요.\n조금만 기다려 주시면 곧 찾아갈게요!"
            case .uploadImagesFailed:
                return "2장 이상 업로드해야 투표를 만들 수 있어요\n사진을 더 업로드 해주시겠어요?"
            case .leave:
                return "정말 탈퇴하시겠어요?\n'탈퇴하기'를 누르시면 더 이상 만날 수 없어요."
            }
        }
        
        fileprivate var cancelButtonText: String {
            switch self {
            case .logOut, .inputDataCencel, .listRemove, .report, .leave:
                return "아니요"
            case .logInDetail, .logInVote, .logInMypage:
                return "더 둘러볼래요"
            case .service, .uploadImagesFailed:
                return ""
            }
        }
        
        fileprivate var doneButtonText: String {
            switch self {
            case .logInDetail, .logInVote, .logInMypage:
                return "로그인하기"
            case .logOut:
                return "로그아웃"
            case .inputDataCencel:
                return "나가기"
            case .listRemove:
                return "삭제하기"
            case .report:
                return "신고하기"
            case .uploadImagesFailed:
                return "네, 업로드할게요."
            case .leave:
                return "탈퇴하기"
            case .service:
                return ""
            }
        }
        
        fileprivate var image: UIImage? {
            switch self {
            case .logInDetail, .logInVote, .logInMypage, .logOut:
                return UIImage(named: "eyeLarge")
            case .inputDataCencel, .listRemove:
                return UIImage(named: "trash")
            case .report:
                return UIImage(named: "report")
            case .service:
                return UIImage(named: "setting")
            case .uploadImagesFailed, .leave:
                return UIImage(named: "hmm")
            }
        }
    }
    
    func showAlert(using type: AlertType) {
        titleLabel.text = type.title
        imageView.image = type.image
        denyButton.setTitle(type.cancelButtonText, for: .normal)
        doneButton.setTitle(type.doneButtonText, for: .normal)
        
        doneButton.tag = type.rawValue
        denyButton.tag = type.rawValue
        
        switch type {
        case .service:
            buttonStackView.isHidden = true
        case .uploadImagesFailed:
            denyButton.isHidden = true
        default:
            buttonStackView.isHidden = false
        }
        
        UIApplication.shared.windows.first?.addSubview(rootView)
    }
    
    @objc func doneButtonClicked(_ sender: UIButton) {
        switch sender.tag {
        case 0, 1, 2:
            actionDelegate?.loginTapped?()
        case 3:
            actionDelegate?.logOutTapped?()
        case 4:
            actionDelegate?.inputDataCencelTapped?()
        case 5:
            actionDelegate?.listRemoveTapped?()
        case 6:
            actionDelegate?.reportTapped?()
        case 7:
            actionDelegate?.serviceTapped?()
        default:
            print("AlertView has Not Work")
        }
        
        rootView.removeFromSuperview()
    }
    
    @objc func removeButtonClicked(_ sender: UIButton) {
        // 로그인 Alert창에서 둘러보기를 누르면 홈 탭으로 이동
        if sender.tag == 0 || sender.tag == 1 || sender.tag == 2 {
            actionDelegate?.moveToHomeTab?()
        }
        rootView.removeFromSuperview()
    }
}

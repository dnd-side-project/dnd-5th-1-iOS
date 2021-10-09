//
//  ToastView.swift
//  Picme
//
//  Created by taeuk on 2021/08/18.
//

import UIKit
import SnapKit

class Toast {
    
    enum ToastKind: String {
        
        /// 게시글 제거
        case remove = "게시글이 삭제되었어요."
        /// 게시글 삭제
        case report = "게시글이 신고되었어요."
        /// 투표 생성 완료시
        case voteUpload = "내가 만든 투표가 업로드 되었어요."
        /// 투표했을 때
        case voteComplete = "투표가 완료되었어요."
        
        var image: UIImage? {
            switch self {
            case .report:
                return UIImage(named: "bangPink")
            case .remove, .voteComplete, .voteUpload:
                return UIImage(named: "checkPink")
            }
        }
    }
    
    private static let toastContainer: UIStackView = {
        // $0.alpha = 0.0 // ??
        $0.axis = .horizontal
        $0.alignment = .leading
        $0.distribution = .fillProportionally
        $0.spacing = 15
        $0.backgroundColor = .solidColor(.solid26)
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        return $0
    }(UIStackView())
    
    private static let toastLabel: UILabel = {
        $0.textColor = .white
        $0.textAlignment = .left
        $0.font = .kr(.medium, size: 12)
        $0.clipsToBounds = true
        $0.numberOfLines = 0
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return $0
    }(UILabel())
    
    private static let toastImage: UIImageView = {
        $0.contentMode = .scaleAspectFit
        $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return $0
    }(UIImageView())
    
    static func show(using toast: ToastKind, controller: UIViewController) {
        
        toastContainer.addArrangedSubview(toastImage)
        toastContainer.addArrangedSubview(toastLabel)
        
        controller.view.addSubview(toastContainer)
        
        toastLabel.text = toast.rawValue
        toastImage.image = toast.image
        
        toastContainer.isLayoutMarginsRelativeArrangement = true
        toastContainer.layoutMargins = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        
        toastImage.snp.makeConstraints {
            $0.width.equalTo(18)
            $0.height.equalTo(toastLabel.snp.height)
        }
        
        toastContainer.snp.makeConstraints {
            $0.leading.equalTo(controller.view.snp.leading).offset(20)
            $0.trailing.equalTo(controller.view.snp.trailing).offset(-20)
            $0.bottom.equalTo(controller.view.snp.bottom).offset(-controller.view.frame.size.height / 10)
            $0.height.equalTo(42)
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }, completion: {_ in
                toastContainer.removeFromSuperview()
            })
        })
    }
}

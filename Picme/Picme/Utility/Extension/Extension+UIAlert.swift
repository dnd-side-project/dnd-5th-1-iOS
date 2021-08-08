//
//  Extension+UIAlert.swift
//  Picme
//
//  Created by taeuk on 2021/08/08.
//

import UIKit

enum AlertKind {
    /// 신고하기 alert
    /// ```
    /// UIAlertController(title: "신고하기", message: "게시글에 문제가 있나요?\n신고를 하면 더이상 게시글이 안보여요", preferredStyle: .alert)
    /// ```
    case declaration
    /// 입력중인 내용 사라짐 alert
    /// ```
    /// UIAlertController(title: "삭제하기", message: "지금 종료하면 입력중인 내용이 사라져요.\n그래도 나가시겠어요?", preferredStyle: .alert)
    /// ```
    case inputDataCancel
    /// 리스트 제거 alert
    /// ```
    /// UIAlertController(title: "게시글 삭제", message: "게시글을 삭제하면 다시 업로드해야해요.\n정말 삭제하시겠어요?", preferredStyle: .alert)
    /// ```
    case listRemove
    /// 로그인 alert
    /// ```
    /// UIAlertController(title: "로그인", message: "로그인을 해야 투표를 할 수 있어요.\n로그인을 해주시겠어요?", preferredStyle: .alert)
    /// ```
    case login
    /// 로그아웃 alert
    /// ```
    /// UIAlertController(title: "로그아웃", message: "정말 로그아웃하시겠어요?", preferredStyle: .alert)
    /// ```
    case logOut
}

extension UIViewController {
    
    func customAlert(_ type: AlertKind, doneAction: @escaping () -> Void) {
        
        switch type {
        case .declaration:
            declarationAlert {
                doneAction()
            }
        case .inputDataCancel:
            dataCancelAlert {
                doneAction()
            }
        case .listRemove:
            listRemoveAction {
                doneAction()
            }
        case .login:
            loginAction {
                doneAction()
            }
        case .logOut:
            logOutAction {
                doneAction()
            }
        }
    }
    
    private func declarationAlert(action: @escaping () -> Void) {
        let alert = UIAlertController(title: "신고하기", message: "게시글에 문제가 있나요?\n신고를 하면 더이상 게시글이 안보여요", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "아니요", style: .cancel, handler: nil)
        
        let okAction = UIAlertAction(title: "신고하기", style: .default) { _ in
            action()
        }
        
        alert.addAction(cancel)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func dataCancelAlert(action: @escaping () -> Void) {
        let alert = UIAlertController(title: "삭제하기", message: "지금 종료하면 입력중인 내용이 사라져요.\n그래도 나가시겠어요?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "아니요", style: .cancel, handler: nil)
        
        let okAction = UIAlertAction(title: "나가기", style: .default) { _ in
            action()
        }
        
        alert.addAction(cancel)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func listRemoveAction(action: @escaping () -> Void) {
        let alert = UIAlertController(title: "게시글 삭제", message: "게시글을 삭제하면 다시 업로드해야해요.\n정말 삭제하시겠어요?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "아니요", style: .cancel, handler: nil)
        
        let okAction = UIAlertAction(title: "삭제하기", style: .default) { _ in
            action()
        }
        
        alert.addAction(cancel)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func loginAction(action: @escaping () -> Void) {
        let alert = UIAlertController(title: "로그인", message: "로그인을 해야 투표를 할 수 있어요.\n로그인을 해주시겠어요?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "더 둘러볼래요.", style: .cancel, handler: nil)
        
        let okAction = UIAlertAction(title: "로그인 하기", style: .default) { _ in
            action()
        }
        
        alert.addAction(cancel)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func logOutAction(action: @escaping () -> Void) {
        let alert = UIAlertController(title: "로그아웃", message: "정말 로그아웃하시겠어요?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "아니요", style: .cancel, handler: nil)
        
        let okAction = UIAlertAction(title: "로그아웃", style: .default) { _ in
            action()
        }
        
        alert.addAction(cancel)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

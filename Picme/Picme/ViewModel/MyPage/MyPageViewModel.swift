//
//  MyPageViewModel.swift
//  Picme
//
//  Created by taeuk on 2021/08/17.
//

import Foundation
import KakaoSDKAuth
import KakaoSDKUser
import AuthenticationServices

protocol LogOutProtocol: AnyObject {
    func logoutFromMain()
}

class MyPageViewModel {
    
    weak var logOutDelegate: LogOutProtocol?
    
    func logOutAction(from kind: String?) {
        
        guard let kind = kind else { return }
        
        switch kind {
        case "Kakao":
            
            UserApi.shared.logout { [weak self] error in
                if let err = error {
                    print(err.localizedDescription)
                } else {
                    self?.logOutDelegate?.logoutFromMain()
                    print("Kakao Log Out Success")
                }
            }
            
        case "Apple":
            // 키체인 제거
            print("Apple")
        default:
            return
        }
    }
}

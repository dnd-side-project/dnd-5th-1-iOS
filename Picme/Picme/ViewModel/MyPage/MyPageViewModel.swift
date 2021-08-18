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
    
    func logOutAction() {
        
        // 유저Body 저장하는 싱글턴 vendor로 대체예정
        let tt = "123"
        
        switch tt {
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
            print("Apple")
        default:
            return
        }
    }
}

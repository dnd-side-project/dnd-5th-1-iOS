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

enum SeccsionCase {
    case loginUser
    case onBoardingUser
}

protocol LogOutProtocol: AnyObject {
    func logoutFromMain()
}

protocol UserSeccsionProtocol: AnyObject {
    func seccsionUserAction()
}

final class MyPageViewModel {
    
    // MARK: - Properties
    
    var myPageModel: Dynamic<MyPageModel> = Dynamic(MyPageModel(createdCount: 0, attendedCount: 0))
    
    var service: MyPageServiceProtocol?
    var onErrorHandling: ((APIError?) -> Void)?
    
    weak var logOutDelegate: LogOutProtocol?
    weak var seccsionDelegate: UserSeccsionProtocol?
    
    let loginUserInfo = LoginUser.shared
    let onboardingUser = OnboardingUserInfo.shared
    
    // MARK: - Initializer
    
    init(service: MyPageServiceProtocol) {
        self.service = service
    }
    
    func getVersion() -> String {
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return "Version NULL"
        }
        return "Version \(version)"
    }
    
    func requestUserSecession(_ userinfo: SeccsionCase) {
        service?.fetchUserSecession(userinfo, completion: { [weak self] in
            print("response Fetch User Secession")
            self?.userInfoRemove()
            self?.seccsionDelegate?.seccsionUserAction()
        })
    }
    
    // MARK: - LogOut
    
    func logOutAction(from kind: String?) {
        
        guard let kind = kind else { return }
        
        switch kind {
        case "Kakao":
            UserApi.shared.logout { [weak self] error in
                if let err = error {
                    print(err.localizedDescription)
                } else {
                    print("Kakao Log Out Success")
                    
                    self?.userInfoRemove()
                    self?.logOutDelegate?.logoutFromMain()
                    
                }
            }
        case "Apple":
            // 키체인 제거
            if KeyChainModel.shared.deleteUserinfo() {
                print("Keychain Remove")
                
                userInfoRemove()
                logOutDelegate?.logoutFromMain()
            }
        default:
            return
        }
    }
    
    func userInfoRemove() {
        
        loginUserInfo.vendor = nil
        loginUserInfo.vendorID = nil
        loginUserInfo.userNickname = nil
        loginUserInfo.userProfileImageUrl = nil
        APIConstants.jwtToken = ""
        onboardingUser.userEmail = nil
        onboardingUser.vendor = nil
        onboardingUser.vendorID = nil
    }
}

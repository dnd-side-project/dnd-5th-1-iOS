//
//  MyPageService.swift
//  Picme
//
//  Created by 권민하 on 2021/08/28.
//

import Foundation
import Alamofire

protocol MyPageServiceProtocol: AnyObject {
    func getUser(completion: @escaping (MyPageModel) -> Void)
    func fetchUserSecession(_ userInfo: SeccsionCase, completion: @escaping () -> Void)
}

class MyPageService: MyPageServiceProtocol {
    
    // MARK: - 유저 프로필 조회
    
    func getUser(completion: @escaping (MyPageModel) -> Void) {
        let URL = APIConstants.MyPage.userRetrieve.urlString
        let header: HTTPHeaders = [
            "Authorization": APIConstants.jwtToken
        ]
        
        let dataRequest = AF.request(URL,
                                     method: .get,
                                     parameters: nil,
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
        dataRequest
            .validate(statusCode: 200..<500)
            .responseDecodable(of: MyPageModel.self) { dataResponse in
                switch dataResponse.result {
                case .success:
                    completion(dataResponse.value!)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
    
    // MARK: - 유저 탈퇴
    
    func fetchUserSecession(_ userInfo: SeccsionCase, completion: @escaping () -> Void) {
        
        let url = APIConstants.Auth.secession.urlString
        
        var parameter: Parameters = [:]
        
        switch userInfo {
        case .loginUser:
            guard let vendor = LoginUser.shared.vendor,
                  let vendorIdentifier = LoginUser.shared.vendorID else { return }
            
            parameter = [
                "vendor": vendor,
                "vendorAccountId": vendorIdentifier
            ]
        case .onBoardingUser:
            guard let vendor = OnboardingUserInfo.shared.vendor,
                  let vendorIdentifier = OnboardingUserInfo.shared.vendorID else { return }
            
            parameter = [
                "vendor": vendor,
                "vendorAccountId": vendorIdentifier
            ]
        }

        AF.request(url, method: .delete, parameters: parameter, encoding: JSONEncoding.default, headers: nil).response { response in
            print(response.response?.statusCode)
            print("Secesson", response)
            completion()
        }
    }
}

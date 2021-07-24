//
//  LoginAPICenter.swift
//  dnd-5th-1-iOS
//
//  Created by taeuk on 2021/07/14.
//

import Foundation
import Alamofire

struct LoginAPICenter {
    
    enum LoginKind {
        case apple(userID: String, email: String)
        case kakao(userID: String, email: String)
        
        var loginRawValue: String {
            switch self {
            case .apple:
                return "apple"
            case .kakao:
                return "kakao"
            }
        }
        
        var loginValue: LoginSignInModel {
            switch self {
            case let .apple(userID, email):
                return LoginSignInModel(vendor: loginRawValue, vendorAccountId: userID, email: email)
            case let .kakao(userID, email):
                return LoginSignInModel(vendor: loginRawValue, vendorAccountId: userID, email: email)
            }
        }
    }
    
    static func fetchUserData(_ type: LoginSignInModel,
                              completion: @escaping ResultModel<LoginSignInResponseModel>) {
        
        let urlString = "https://ptsv2.com/t/m3fgc-1626575320"
        
        let parameters = type
        
        print(parameters)
        
        AF.request(urlString,
                   method: .post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default).responseDecodable(of: LoginSignInResponseModel.self, completionHandler: { (response) in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(_):
                completion(.failure(.decodingFailed))
            }
        })
        
        /*
        // JSONEncoding
        let parameter = [
            "vendor": type.rawValue,
            "vendorAccountId": userID,
            "email": email
        ]
        
        AF.request(urlString,
                   method: .post,
                   parameters: parameter,
                   encoding: JSONEncoding.default).responseDecodable(of: LoginSignInResponseModel.self, completionHandler: { (response) in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(_):
                completion(.failure(.decodingFailed))
            }
        })
        
        */
        
    }
}

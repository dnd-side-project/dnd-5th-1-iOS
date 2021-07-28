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
        case apple(userID: String, nickName: String, email: String)
        case kakao(userID: String, nickName: String, email: String)
        
        var loginRawValue: String {
            switch self {
            case .apple:
                return "Apple"
            case .kakao:
                return "Kakao"
            }
        }
        
        var loginValue: LoginSignUpModel {
            switch self {
            case let .apple(userID, nickName, email):
                return LoginSignUpModel(vendor: loginRawValue, vendorAccountId: userID, nickname: nickName, email: email)
            case let .kakao(userID, nickName, email):
                return LoginSignUpModel(vendor: loginRawValue, vendorAccountId: userID, nickname: nickName, email: email)
            }
        }
    }
    
    static func fetchUserData(_ type: LoginSignUpModel,
                              completion: @escaping ResultModel<LoginSignUpResponseModel>) {
        
        let urlString = "http://2d63c4581cec.ngrok.io/v1/auth/signup"
        
        let parameters = type
        
        print(parameters)
        
        // JSONEncoding
        let parameter = [
            "vendor": type.vendor,
            "vendorAccountId": type.vendorAccountId,
            "nickname": type.nickname,
            "email": type.email
        ]

        print(parameter)
        
        AF.request(urlString,
                   method: .post,
                   parameters: parameter,
                   encoding: JSONEncoding.default).responseDecodable(of: LoginSignUpResponseModel.self, completionHandler: { (response) in
                    print(response.response)
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let err):
                switch response.response?.statusCode {
                case 400:
                    completion(.failure(.decodingFailed))
                default:
                    return print(err.localizedDescription)
                }
            }
        })
        
    }
}

//
//  LoginAPICenter.swift
//  dnd-5th-1-iOS
//
//  Created by taeuk on 2021/07/14.
//

import Foundation
import Alamofire

struct LoginKind {
    
    enum LoginRawValue {
        case apple
        case kakao
        
        var vendor: String {
            switch self {
            case .apple:
                return "Apple"
            case .kakao:
                return "Kakao"
            }
        }
    }
    
    enum SignIn {
        case kakao(userID: String, email: String)
        case apple(userID: String, email: String)
        
        var loginValue: LoginSignInModel {
            switch self {
            case let .kakao(userID, email):
                return LoginSignInModel(vendor: LoginRawValue.kakao.vendor,
                                        vendorAccountId: userID,
                                        email: email)
                
            case let .apple(userID, email):
                return LoginSignInModel(vendor: LoginRawValue.apple.vendor,
                                        vendorAccountId: userID,
                                        email: email)
            }
        }
    }
    
    enum SignUp {
        case kakao(userID: String, nickName: String, email: String)
        case apple(userID: String, nickName: String, email: String)
        
        var loginValue: LoginSignUpModel {
            switch self {
            case let .kakao(userID, nickName, email):
                return LoginSignUpModel(vendor: LoginRawValue.kakao.vendor,
                                        vendorAccountId: userID,
                                        nickname: nickName,
                                        email: email)
                
            case let .apple(userID, nickName, email):
                return LoginSignUpModel(vendor: LoginRawValue.apple.vendor,
                                        vendorAccountId: userID,
                                        nickname: nickName,
                                        email: email)
            }
        }
    }
}

struct LoginAPICenter {
    
    static func fetchSignIn(_ type: LoginSignInModel,
                            completion: @escaping ResultModel<LoginResponseModel>) {
        
        let urlString = APIConstants.Auth.signIn.urlString
        
        let parameter = [
            "vendor": type.vendor,
            "vendorAccountId": type.vendorAccountId,
            "email": type.email ?? ""
        ]
        
        AF.request(urlString,
                   method: .post,
                   parameters: parameter,
                   encoding: JSONEncoding.default)
            .responseDecodable(of: LoginResponseModel.self) { (response) in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let err):
                    switch response.response?.statusCode {
                    case 404:
                        completion(.failure(.requestFailed))
                    default:
                        print(err.localizedDescription)
                    }
                }
            }
    }
    
    static func fetchSignUp(_ type: LoginSignUpModel,
                            completion: @escaping ResultModel<LoginResponseModel>) {
        
        let urlString = APIConstants.Auth.signUp.urlString
//        let urlString = "http://2d63c4581cec.ngrok.io/v1/auth/signup"
        
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
                   encoding: JSONEncoding.default).responseDecodable(of: LoginResponseModel.self, completionHandler: { (response) in
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

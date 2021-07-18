//
//  LoginAPICenter.swift
//  dnd-5th-1-iOS
//
//  Created by taeuk on 2021/07/14.
//

import Foundation
import Alamofire

struct LoginAPICenter {
    
    static func fetchUserData(_ type: SNSLoginKind,
                              userID: String,
                              email: String,
                              completion: @escaping ResultModel<LoginSignInResponseModel>) {
        
        let urlString = "https://ptsv2.com/t/m3fgc-1626575320"
        
        let parameters = LoginSignInModel(vendor: type.rawValue, vendorAccountId: userID, email: email)
        
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

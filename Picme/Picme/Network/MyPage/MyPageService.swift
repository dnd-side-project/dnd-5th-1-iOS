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
    
}

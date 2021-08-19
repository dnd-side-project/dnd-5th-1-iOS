//
//  MainService.swift
//  Picme
//
//  Created by 권민하 on 2021/08/12.
//

import Foundation
import Alamofire

protocol MainServiceProtocol: AnyObject {
    func getMainList(page: Int, completion: @escaping ((NetworkResult<Any>) -> Void))
}

class MainService: MainServiceProtocol {
    
    func getMainList(page: Int, completion: @escaping ((NetworkResult<Any>) -> Void)) {
        let URL = APIConstants.Post.postListRetrieve.urlString.replacingOccurrences(of: "pageNum", with: String(page))
        
        let dataRequest = AF.request(URL,
                                     method: .get,
                                     parameters: nil,
                                     encoding: JSONEncoding.default,
                                     headers: nil)
        
        dataRequest.responseData { dataResponse in
            switch dataResponse.result {
            case .success:
                guard let statusCode = dataResponse.response?.statusCode else {return}
                guard let value = dataResponse.value else {return}
                let networkResult = self.judgeStatus(by: statusCode, value)
                completion(networkResult)
            case .failure: completion(.pathErr)
            }
        }
    }
    
    func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        switch statusCode {
        case 200: return isValidData(data: data)
        case 400: return .pathErr
        case 500: return .serverErr
        default: return .networkFail
        }
    }
    
    func isValidData(data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        
        guard let decodedData = try? decoder.decode(MainListModel.self, from: data)
        else { return .pathErr }
        
        return .success(decodedData.mainList)
    }
    
}

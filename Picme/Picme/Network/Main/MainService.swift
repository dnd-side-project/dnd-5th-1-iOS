//
//  MainService.swift
//  Picme
//
//  Created by 권민하 on 2021/07/30.
//

import Foundation
import Alamofire

class MainService {
    
    static func getMainList(page: Int, completion: @escaping([MainModel]?) -> Void) {
        let URL = APIConstants.Post.main.urlString.replacingOccurrences(of: "pageNum", with: String(page))
        
        let dataRequest = AF.request(URL,
                                     method: .get,
                                     parameters: nil,
                                     encoding: JSONEncoding.default,
                                     headers: nil)
        
        dataRequest.responseData { dataResponse in
            switch dataResponse.result {
            case .success:
                guard let value = dataResponse.value else { return }
                let mainData = try? JSONDecoder().decode(MainListModel.self, from: value)
                completion(mainData?.mainList)
            case .failure(let error):
                print(error.errorDescription ?? "")
            }
        }
    }
    
    static func getMainList2(page: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        let URL = APIConstants.Post.main.urlString.replacingOccurrences(of: "pageNum", with: String(page))
        
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
    
    static func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH:mm"
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        guard let decodedData = try? decoder.decode(MainListModel.self, from: data)
        else { return .pathErr }
        
        switch statusCode {
        case 200: return .success(decodedData)
        case 400: return .pathErr
        case 500: return .serverErr
        default: return .networkFail
        }
    }
    
}

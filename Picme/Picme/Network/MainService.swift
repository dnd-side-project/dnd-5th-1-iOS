//
//  MainService.swift
//  Picme
//
//  Created by 권민하 on 2021/07/30.
//

import Foundation
import Alamofire
import SwiftyJSON

class MainService {
    
    static func getMainList(page: Int, completion: @escaping([MainModel]?) -> Void) {
        let URL = APIConstants.Post.create.urlString
        
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
    
}

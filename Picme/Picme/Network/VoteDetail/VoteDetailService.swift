//
//  VoteDetailService.swift
//  Picme
//
//  Created by 권민하 on 2021/08/07.
//

import Foundation
import Alamofire

class VoteDetailService {
    
    static func getVoteDetailList(postId: String, completion: @escaping([VoteDetailModel]?) -> Void) {
        let URL = APIConstants.Post.voteDetail.urlString.replacingOccurrences(of: ":post_id", with: postId)
        
        let dataRequest = AF.request(URL,
                                     method: .get,
                                     parameters: nil,
                                     encoding: JSONEncoding.default,
                                     headers: nil)
        
        dataRequest.responseData { dataResponse in
            switch dataResponse.result {
            case .success:
                guard let value = dataResponse.value else { return }
                let voteDetailData = try? JSONDecoder().decode(VoteDetailListModel.self, from: value)
                completion(voteDetailData?.detailList)
            case .failure(let error):
                print(error.errorDescription ?? "")
            }
        }
    }
    
}

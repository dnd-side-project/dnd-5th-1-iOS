//
//  VoteDetailService.swift
//  Picme
//
//  Created by 권민하 on 2021/08/07.
//

import Foundation
import Alamofire

protocol VoteDetailServiceProtocol: AnyObject {
    func getVoteDetail(postId: String, completion: @escaping ((NetworkResult<Any>) -> Void))
    func createVote(postId: String, imageId: String, category: String, completion: @escaping () -> Void)
    func deletePost(postId: String, completion: @escaping () -> Void)
}

class VoteDetailService: VoteDetailServiceProtocol {
    
    // MARK: - 투표 상세 조회
    
    func getVoteDetail(postId: String, completion: @escaping ((NetworkResult<Any>) -> Void)) {
        let URL = APIConstants.Post.postRetrieve(postID: postId).urlString
        let header: HTTPHeaders = [ "Authorization": APIConstants.jwtToken ]
        
        let dataRequest = AF.request(URL,
                                     method: .get,
                                     parameters: nil,
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
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
    
    // MARK: - 투표 생성
    
    func createVote(postId: String, imageId: String, category: String, completion: @escaping () -> Void) {
        let URL = APIConstants.Vote.createVote(postID: postId, postImageID: imageId).urlString
        let body: [ String: String ] = [ "category": category ]
        let header: HTTPHeaders = [ "Authorization": APIConstants.jwtToken ]
        
        let dataRequest = AF.request(URL,
                                     method: .post,
                                     parameters: body,
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
        dataRequest.responseData { dataResponse in
            switch dataResponse.result {
            case .success:
                completion()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - 게시글 삭제
    
    func deletePost(postId: String, completion: @escaping () -> Void) {
        let URL = APIConstants.Post.deletePost(postID: postId).urlString
        let header: HTTPHeaders = [ "Authorization": APIConstants.jwtToken ]
        
        let dataRequest = AF.request(URL,
                                     method: .delete,
                                     parameters: nil,
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
        dataRequest.responseData { dataResponse in
            switch dataResponse.result {
            case .success:
                completion()
            case .failure(let error):
                print(error.localizedDescription)
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
        
        guard let decodedData = try? decoder.decode(VoteDetailModel.self, from: data)
        else { return .pathErr }
        
        return .success(decodedData)
    }
    
}

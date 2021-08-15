//
//  VoteDetailViewModel.swift
//  Picme
//
//  Created by 권민하 on 2021/08/07.
//

import Alamofire
import Foundation

class VoteDetailViewModel {
    
    // MARK: - Properties
    
    var service: VoteDetailServiceProtocol?
    var dataSource: GenericDataSource<VoteDetailModel>?
    var onErrorHandling: ((APIError?) -> Void)?
    
    // MARK: - Initializer
    
    init(service: VoteDetailServiceProtocol, dataSource: GenericDataSource<VoteDetailModel>?) {
        self.service = service
        self.dataSource = dataSource
    }
    
    // MARK: - 게시글 조회
    
    func fetchVoteDetail(postId: Int) {
        
        guard let service = service else {
            onErrorHandling?(APIError.networkFailed)
            return
        }
        
        service.getVoteDetail(postId: postId) { [weak self] response in
            DispatchQueue.main.async {
                switch response {
                case .success(let data):
                    if let voteDetailData = data as? VoteDetailModel {
                        self?.dataSource?.data.value = [voteDetailData]
                    }
                case .requestErr(let message):
                    print("requestERR", message)
                case .pathErr:
                    print("pathERR")
                case .serverErr:
                    print("serverERR")
                case .networkFail:
                    print("networkERR")
                }
            }
        }
        
    }
    
}

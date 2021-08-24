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
    
    var voteDetailModel: Dynamic<VoteDetailModel> = Dynamic(VoteDetailModel(postNickname: "", postProfileUrl: "", onePickImageId: 0, isVoted: false, votedImageId: 0, title: "", participantsNum: 0, deadline: "", images: [VoteDetailImage(imageId: "", imageUrl: "", pickedNum: 0, emotion: 0, composition: 0, light: 0, color: 0, skip: 0)]))
    
    var service: VoteDetailServiceProtocol?
    var onErrorHandling: ((APIError?) -> Void)?
    
    // MARK: - Initializer
    
    init(service: VoteDetailServiceProtocol) {
        self.service = service
    }
    
    // MARK: - 게시글 조회
    
    func fetchVoteDetail(postId: String) {
        guard let service = service else {
            onErrorHandling?(APIError.networkFailed)
            return
        }
        
        service.getVoteDetail(postId: postId) { [weak self] response in
            DispatchQueue.main.async {
                switch response {
                case .success(let data):
                    if let voteDetailData = data as? VoteDetailModel {
                        self?.voteDetailModel.value = voteDetailData
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

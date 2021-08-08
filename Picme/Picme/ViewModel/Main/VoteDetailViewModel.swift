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
    
    var dataSource: GenericDataSource<VoteDetailModel>?
    
    // MARK: - Initializer
    
    init(dataSource: GenericDataSource<VoteDetailModel>?) {
        self.dataSource = dataSource
    }
    
    // MARK: - 게시글 조회
    
    func fetchVoteDetail(postId: String) {
        VoteDetailService.getVoteDetailList(postId: postId) { (detailList) in
            if let detailList = detailList {
                self.dataSource?.data.value = detailList
                return
            }
        }
    }
    
}

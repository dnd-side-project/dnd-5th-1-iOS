//
//  MainViewModel.swift
//  Picme
//
//  Created by 권민하 on 2021/07/30.
//

import Foundation

class MainViewModel {
    
    // MARK: - Properties
    
    var mainList: Dynamic<[MainModel]> = Dynamic([])
    
    private var currentPage = 1
    
    // MARK: - 게시글 리스트 조회
    
    func fetchMainList() {
        MainService.getMainList(page: currentPage) { (mainList) in
            if let mainList = mainList {
                self.currentPage += 1
                //self.mainList.value = mainList
                self.mainList.value.append(contentsOf: mainList)
                return
            }
        }
    }
    
}

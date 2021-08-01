//
//  MainViewModel.swift
//  Picme
//
//  Created by 권민하 on 2021/07/30.
//

import Foundation

class MainViewModel {
    
    var mainList: Dynamic<[MainModel]> = Dynamic([])
    
    // MARK: - 게시글 가져오기
    
    func fetchMainList() {
        MainService.getMainList { (mainList) in
            if let mainList = mainList {
                self.mainList.value = mainList
                return
            }
        }
    }
    
}

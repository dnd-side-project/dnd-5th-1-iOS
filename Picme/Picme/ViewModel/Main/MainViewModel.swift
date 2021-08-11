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
    
    var currentPage = 1
    
    // MARK: - 게시글 리스트 조회
    
    func fetchMainList() {
        MainService.getMainList(page: currentPage) { (response) in
            if let mainData = response {
                self.currentPage += 1
                //self.mainList.value = mainList
                self.mainList.value.append(contentsOf: mainData)
                return
            }
        }
    }
    
    func fetchMainList2() {
        MainService.getMainList2(page: currentPage) { (response) in
            switch(response) {
            case .success(let data):
                if let mainData = data as? MainListModel {
                    self.mainList.value.append(contentsOf: mainData.mainList)
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

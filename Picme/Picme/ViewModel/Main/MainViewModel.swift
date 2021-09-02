//
//  MainViewModel.swift
//  Picme
//
//  Created by 권민하 on 2021/07/30.
//

import Foundation

class MainViewModel {
    
    // MARK: - Properties
    
    var service: MainServiceProtocol?
    var dataSource: GenericDataSource<MainModel>?
    var onErrorHandling: ((APIError?) -> Void)?
    
    var currentPage = 1
  
    // MARK: - Initializer
    
    init(service: MainServiceProtocol, dataSource: GenericDataSource<MainModel>?) {
        self.service = service
        self.dataSource = dataSource
    }
    
    // MARK: - 게시글 리스트 조회
    
    func fetchMainList() {
        guard let service = service else {
            onErrorHandling?(APIError.networkFailed)
            return
        }
        
        service.getMainList(page: currentPage, completion: { [weak self] (response) in
            DispatchQueue.main.async {
                switch response {
                case .success(let data):
                    if let mainData = data as? [MainModel] {
                        // self?.currentPage += 1
                        self?.dataSource?.data.value = mainData
                        // self?.dataSource?.data.value.append(contentsOf: mainData)
                   
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
        })
    }
    
}

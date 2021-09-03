//
//  MainViewModel.swift
//  Picme
//
//  Created by 권민하 on 2021/07/30.
//

import Foundation

protocol MainViewModelDelegate: AnyObject {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(with reason: String)
}

class MainViewModel {
    
    // MARK: - Properties
    
    var service: MainServiceProtocol?
    var dataSource: GenericDataSource<MainModel>?
    var onErrorHandling: ((APIError?) -> Void)?
    
    ///
    private var mainList: [MainModel] = []
    
    private weak var delegate: MainViewModelDelegate?
    private var currentPage: Int = 1
    private var page: Int = 0
    private var total: Int = 0
    private var isFetchInProgress: Bool = false
    
    // MARK: - Initializer
    
    init(service: MainServiceProtocol, delegate: MainViewModelDelegate) {
        self.service = service
        self.delegate = delegate
    }
    
//    init(service: MainServiceProtocol, dataSource: GenericDataSource<MainModel>?, delegate: MainViewModelDelegate) {
//        self.service = service
//        self.dataSource = dataSource
//        self.delegate = delegate
//    }
    
    //    init(service: MainServiceProtocol, dataSource: GenericDataSource<MainModel>?) {
    //        self.service = service
    //        self.dataSource = dataSource
    //    }
    
    ///
    var totalCount: Int {
        return total
    }
//
//    var currentCount: Int {
//        return dataSource?.data.value.count ?? 0
//        // return moderators.count
//    }
//
//    func mainListIndex(at index: Int) -> MainModel {
//        return (dataSource?.data.value[index])!
//    }
    
    var currentCount: Int {
      return mainList.count
    }
    
    func moderator(at index: Int) -> MainModel {
      return mainList[index]
    }
    
    // MARK: - 게시글 리스트 조회
    
    func fetchMainList() {
        guard let service = service else {
            onErrorHandling?(APIError.networkFailed)
            return
        }
        
        service.getMainList(page: currentPage, completion: { [weak self] (response) in
            print("* get Main List")
            
            DispatchQueue.main.async {
                switch response {
                case .success(let data):
                    
                    if let responseData = data as? MainListModel {
                        self?.currentPage += 1
                        self?.isFetchInProgress = false
                        
                        self?.total = responseData.total
                        
                        print("* total : \(String(describing: self?.total))")
                        self?.dataSource?.data.value.append(contentsOf: responseData.mainList)
                        
                        self?.mainList.append(contentsOf: responseData.mainList)
                        
                        print("* in response data 개수!?! \(responseData.mainList.count)")
                        
                        // 3
                        if self?.page ?? 0 > 1 {
                            print("* page > 1 \(String(describing: self?.page))")
                            let indexPathsToReload = self?.calculateIndexPathsToReload(from: responseData.mainList)
                            self?.delegate?.onFetchCompleted(with: indexPathsToReload)
                        } else {
                            print("* page else \(String(describing: self?.page))")
                            self?.delegate?.onFetchCompleted(with: .none)
                            self?.page += 1
                        }
                        
                    }
                    
                // 페이징 전 코드
                // if let mainData = data as? [MainModel] {
                // self?.dataSource?.data.value = mainData
                // }
                
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
    
    private func calculateIndexPathsToReload(from newMainList: [MainModel]) -> [IndexPath] {
        print("* calculate Index Paths To Reload")
        // let startIndex = dataSource?.data.value.count ?? 0 - newMainList.count
        let startIndex = mainList.count - newMainList.count
        
        let endIndex = startIndex + newMainList.count
        print("start : \(startIndex) + end : \(endIndex)")
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
}

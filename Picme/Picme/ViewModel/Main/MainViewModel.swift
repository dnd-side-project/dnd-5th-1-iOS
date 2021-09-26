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
    
    var mainList: [MainModel] = []
    
    private weak var delegate: MainViewModelDelegate?
    var currentPage: Int = 1
    var page: Int = 0
    private var total: Int = 0
    private var isFetchInProgress: Bool = false
    
    // MARK: - Initializer
    
    init(service: MainServiceProtocol, delegate: MainViewModelDelegate) {
        self.service = service
        self.delegate = delegate
    }
    
    var totalCount: Int {
        return total
    }
    
    var currentCount: Int {
        return mainList.count
    }
    
    func mainModel(at index: Int) -> MainModel {
        return mainList[index]
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
                    
                    if let responseData = data as? MainListModel {
                        self?.currentPage += 1
                        self?.isFetchInProgress = false
                        
                        self?.total = responseData.total
                        
                        self?.dataSource?.data.value.append(contentsOf: responseData.mainList)
                        
                        self?.mainList.append(contentsOf: responseData.mainList)
                        
                        if self?.page ?? 0 >= 1 { // 그 이외의 페이지일 경우
                            let indexPathsToReload = self?.calculateIndexPathsToReload(from: responseData.mainList)
                            self?.delegate?.onFetchCompleted(with: indexPathsToReload)
                        } else { // 첫 페이지일 경우
                            self?.delegate?.onFetchCompleted(with: .none)
                            self?.page += 1
                        }
                        
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
    
    private func calculateIndexPathsToReload(from newMainList: [MainModel]) -> [IndexPath] {
        let startIndex = mainList.count - newMainList.count
        let endIndex = startIndex + newMainList.count
        
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
}

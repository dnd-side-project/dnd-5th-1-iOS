//
//  MainViewController.swift
//  dnd-5th-1-iOS
//
//  Created by 권민하 on 2021/07/21.
//

import UIKit

// MARK: - Collection View Cell 클릭 시 실행할 프로토콜
protocol TouchDelegate: AnyObject {
    func pushVoteDetailView(index: Int, postId: String)
}

protocol MainViewControllerDelegate: AnyObject {
    func passTotalCount() -> Int
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool
    
    func passMainListIndex(index: Int) -> MainModel
}

class MainViewController: BaseViewContoller, TouchDelegate, UITableViewDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    // MARK: - IBActions
    
    @IBAction func voteButtonClicked(_ sender: Any) {
        if APIConstants.jwtToken == "" {
            AlertView.instance.showAlert(using: .logInVote)
            AlertView.instance.actionDelegate = self
        } else {
            if let uploadImageVC = tabBarController?.storyboard?.instantiateViewController(withIdentifier: "UploadImage") {
                tabBarController?.present(uploadImageVC, animated: true)
            }
        }
    }
    
    // MARK: - Variables
    
    // var dataSource = MainListDatasource()
    
    var viewModel: MainViewModel!
    
    var isFirst: Bool = true
    
    var isUpdate: Bool = false
    
    weak var delegate: TouchDelegate?
    
    let refresh = UIRefreshControl()
    
    var timer: Timer?
    var dateHelper = DateHelper()
    let currentDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("* main view did load")
        
        setupTabBar()
        
        mainTableView.dataSource = self
        mainTableView.delegate = self
        mainTableView.prefetchDataSource = self
        mainTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        self.initRefresh()
        
        viewModel = MainViewModel(service: MainService(), delegate: self)
        // viewModel = MainViewModel(service: MainService(), dataSource: dataSource, delegate: self)
        // viewModel = MainViewModel(service: MainService(), dataSource: dataSource)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("* main view will appear")
        
        // self.bindViewModel()
        ActivityView.instance.start(controller: self)
        
        viewModel.page = 0
        viewModel.currentPage = 1
        viewModel.mainList = []
        viewModel.fetchMainList()
        
    }
    
    // MARK: - Tab Bar
    
    func setupTabBar() {
        self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
        
        // tab bar item - title 설정
        if let downcastStrings = self.tabBarController?.tabBar.items {
            downcastStrings[1].title = "투표만들기"
            downcastStrings[2].title = "마이페이지"
        }
        
        // tab bar item - image 설정
        self.tabBarController?.tabBar.items![1].image = #imageLiteral(resourceName: "plusPink").withRenderingMode(.alwaysOriginal)
        self.tabBarController?.tabBar.items![2].image = #imageLiteral(resourceName: "mypageWhite")
        
    }
    
    /*
     // MARK: - Bind View Model
     
     private func bindViewModel() {
     
     print("* main bind view model")
     
     mainTableView.dataSource = dataSource
     dataSource.delegate = self
     dataSource.mainDelegate = self
     
     dataSource.data.addAndNotify(observer: self) { [weak self] _ in
     print("* main show Table View")
     self?.showTableView()
     }
     
     // 메인 리스트 조회
     viewModel.fetchMainList()
     }
     
     // MARK: - Table View
     
     func showTableView() {
     DispatchQueue.main.async {
     // 제일 처음 뷰가 로드되면 데이터가 무조건 없는 isEmpty로 빠졌다가 로드되기 때문에 isFirt 변수 추가
     if self.isFirst {
     self.isFirst = false
     } else {
     if self.dataSource.data.value.isEmpty {
     self.showEmptyView()
     } else {
     self.emptyView.isHidden = true
     self.mainTableView.isHidden = false
     // self.mainTableView.reloadData()
     print("* main reload data")
     }
     }
     }
     }
     
     func showEmptyView() {
     self.emptyView.isHidden = false
     self.mainTableView.isHidden = true
     }
     */
    
    func showEmptyView() {
        self.emptyView.isHidden = false
        self.mainTableView.isHidden = true
    }
    
    // MARK: - Collection View Cell 클릭시
    
    func pushVoteDetailView(index: Int, postId: String) {
        if APIConstants.jwtToken == "" { // 미로그인 사용자
            AlertView.instance.showAlert(using: .logInDetail)
            AlertView.instance.actionDelegate = self
        } else { // 로그인한 사용자
            guard let voteDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "VoteDetailViewController") as? VoteDetailViewController else { return }
            voteDetailVC.postId = postId
            self.navigationController?.pushViewController(voteDetailVC, animated: true)
        }
    }
    
    //    func passTotalCount() -> Int {
    //        return viewModel.totalCount()
    //    }
    //
    //    func isLoadingCell(for indexPath: IndexPath) -> Bool {
    //      return indexPath.row >= viewModel.currentCount
    //    }
    //
    //    func passMainListIndex(index: Int) -> MainModel {
    //        print("* pass Main List Index 개수??? \(viewModel.mainListIndex(at: index))")
    //        return viewModel.mainListIndex(at: index)
    //    }
}

/*
 // MARK: - Table View Data Source / Collection View Cell Delegate
 
 class MainListDatasource: GenericDataSource<MainModel>, UITableViewDataSource, CollectionViewCellDelegate {
 
 // MARK: - CollectionV View Cell Delegate
 
 weak var delegate: TouchDelegate?
 weak var mainDelegate: MainViewControllerDelegate?
 
 // Collection View Cell 클릭시 실행할 함수
 func selectedCVCell(_ index: Int, _ postId: String) {
 delegate?.pushVoteDetailView(index: index, postId: postId)
 }
 
 // MARK: - Table View Data Source
 
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 // return data.value.count
 
 print("* number of rows in section : \( mainDelegate?.passTotalCount() ?? 0)")
 
 return mainDelegate?.passTotalCount() ?? 0
 }
 
 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 let cell: MainTableViewCell = tableView.dequeueTableCell(for: indexPath)
 
 if mainDelegate?.isLoadingCell(for: indexPath) ?? false {
 cell.updateCell(model: 0)
 } else {
 cell.setCollectionViewDataSourceDelegate(forRow: indexPath.row)
 cell.cellDelegate = self
 cell.updateCell(model: mainDelegate?.passMainListIndex(index: indexPath.row) ?? 0)
 }
 
 // 페이징 전 코드
 //        cell.setCollectionViewDataSourceDelegate(forRow: indexPath.row)
 //        cell.cellDelegate = self
 //        cell.updateCell(model: data.value[indexPath.row])
 
 return cell
 }
 }
 */

extension MainViewController: UITableViewDataSource, CollectionViewCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.totalCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MainTableViewCell = tableView.dequeueTableCell(for: indexPath)
        
        if isLoadingCell(for: indexPath) {
            cell.configure(with: .none)
        } else {
            cell.setCollectionViewDataSourceDelegate(forRow: indexPath.row)
            cell.cellDelegate = self
            
            let endDate = dateHelper.stringToDate(dateString: viewModel.moderator(at: indexPath.row).deadline)
            
            let remainTime = dateHelper.getTimer(startDate: currentDate, endDate: endDate!)
            
            cell.remainSeconds = remainTime
            
            // print("remainTime : \(remainTime)")
            
            createTimer()
            
//            if remainTime <= 0 {
//                cancelTimer()
//            }
            
            cell.configure(with: viewModel.moderator(at: indexPath.row))
            
        }
        
        return cell
    }
    
    // Collection View Cell 클릭시 실행할 함수
    func selectedCVCell(_ index: Int, _ postId: String) {
        if APIConstants.jwtToken == "" { // 미로그인 사용자
            AlertView.instance.showAlert(using: .logInDetail)
            AlertView.instance.actionDelegate = self
        } else { // 로그인한 사용자
            guard let voteDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "VoteDetailViewController") as? VoteDetailViewController else { return }
            voteDetailVC.postId = postId
            self.navigationController?.pushViewController(voteDetailVC, animated: true)
        }
    }
}

extension MainViewController: MainViewModelDelegate {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            print("* on fetch com - guard 안 ")
            //          indicatorView.stopAnimating()
            //          tableView.isHidden = false
            
            // 처음 1페이지일 때 아무것도 없으면 empty
            print("* 메인 개수 : \(viewModel.mainList.count)")
            print(viewModel.mainList)
            
            if viewModel.mainList.isEmpty {
                self.showEmptyView()
            }
            
            mainTableView.reloadData()
            
            ActivityView.instance.stop()
            
            return
        }
        
        print("* on fetch com - guard 밖")
        
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        mainTableView.reloadRows(at: indexPathsToReload, with: .automatic)
        
        ActivityView.instance.stop()
    }
    
    func onFetchFailed(with reason: String) {
        //        indicatorView.stopAnimating()
        //
        //        let title = "Warning".localizedString
        //        let action = UIAlertAction(title: "OK".localizedString, style: .default)
        //        displayAlert(with: title , message: reason, actions: [action])
        
        print("* Main View Model Delegate - onFetchFailed")
    }
}

extension MainViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            viewModel.fetchMainList()
        }
    }
}

private extension MainViewController {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel.currentCount
    }
    
    func  visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = mainTableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}

// MARK: - Alert View Action Delegate

extension MainViewController: AlertViewActionDelegate {
    func loginTapped() {
        self.view.window?.rootViewController?.dismiss(animated: false, completion: {
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
            loginVC.modalPresentationStyle = .fullScreen
            let window = UIApplication.shared.windows.first { $0.isKeyWindow }
            window?.rootViewController = loginVC
            
            UIView.transition(with: window ?? UIWindow(),
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
        })
    }
}

// Refresh Control
extension MainViewController {
    
    func initRefresh() {
        refresh.addTarget(self, action: #selector(refreshTable(refresh:)), for: .valueChanged)
        refresh.tintColor = UIColor.white
        self.mainTableView.refreshControl = refresh
    }
    
    @objc func refreshTable(refresh: UIRefreshControl) {
        print("refreshTable")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            
            self.viewModel.page = 0
            self.viewModel.currentPage = 1
            self.viewModel.mainList = []
            self.viewModel.fetchMainList()
            
            refresh.endRefreshing()
        }
    }
    
    //    //MARK: - UIRefreshControl of ScrollView
    //    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    //        if(velocity.y < -0.1) {
    //            self.refreshTable(refresh: self.refresh)
    //        }
    //    }
    
}

// MARK: - Timer
extension MainViewController: TableViewCellDelegate {

    func createTimer() {
        if timer == nil {
            print("* create timer")
            let timer = Timer(timeInterval: 1.0,
                              target: self,
                              selector: #selector(updateTimer),
                              userInfo: nil,
                              repeats: true)
            RunLoop.current.add(timer, forMode: .common)
            timer.tolerance = 0.1
            
            self.timer = timer
        }
    }
    
    func expiredSeconds() {
        timer?.invalidate()
        timer = nil
    }
    
//    func cancelTimer() {
//        timer?.invalidate()
//        timer = nil
//    }
    
    @objc func updateTimer() {
        guard let visibleRowsIndexPaths = mainTableView.indexPathsForVisibleRows else {
            return
        }
        
        for indexPath in visibleRowsIndexPaths {
            if let cell = mainTableView.cellForRow(at: indexPath) as? MainTableViewCell {
                // print("* cell. updatetime")
                cell.updateTime()
            }
        }
    }
}

//
//  MainViewController.swift
//  dnd-5th-1-iOS
//
//  Created by 권민하 on 2021/07/21.
//

import UIKit

class MainViewController: BaseViewContoller, UITableViewDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    // MARK: - IBActions
    
    // Empty View일 때 투표만들기 버튼 눌렀을 때
    @IBAction func voteButtonClicked(_ sender: Any) {
        if APIConstants.jwtToken == "" { // 미로그인 사용자일 경우 로그인 Alert View
            AlertView.instance.showAlert(using: .logInVote)
            AlertView.instance.actionDelegate = self
        } else { // 투표 만들기 뷰 Present
            if let uploadImageVC = tabBarController?.storyboard?.instantiateViewController(withIdentifier: "UploadImage") {
                tabBarController?.present(uploadImageVC, animated: true)
            }
        }
    }
    
    // MARK: - Variables
    
    var viewModel: MainViewModel!
    
    // Refresh Control
    let refresh = UIRefreshControl()
    
    // Timer
    var timer: Timer?
    var dateHelper = DateHelper()
    let currentDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        setupTabBar()
        
        mainTableView.dataSource = self
        mainTableView.delegate = self
        mainTableView.prefetchDataSource = self
        mainTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        self.initRefresh()
        
        viewModel = MainViewModel(service: MainService(), delegate: self)
        
        ActivityView.instance.start(controller: self)
        
        viewModel.page = 0
        viewModel.currentPage = 1
        viewModel.mainList = []
        viewModel.fetchMainList()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        ActivityView.instance.start(controller: self)
//
//        viewModel.page = 0
//        viewModel.currentPage = 1
//        viewModel.mainList = []
//        viewModel.fetchMainList()
//
//    }
    
    // MARK: - Empty View
    
    func showEmptyView() {
        self.emptyView.isHidden = false
        self.mainTableView.isHidden = true
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
}

// MARK: - Table View Data Source

extension MainViewController: UITableViewDataSource, CollectionViewCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.totalCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MainTableViewCell = tableView.dequeueTableCell(for: indexPath)
        
        if isLoadingCell(for: indexPath) { // 로딩된 셀이 없을 경우 .none을 넘김
            cell.configure(with: .none)
        } else {
            cell.setCollectionViewDataSourceDelegate(forRow: indexPath.row)
            cell.cellDelegate = self

            createTimer()
            cell.currentDate = Date() // 여기서 현재 시간 초기화를 해줘야지 매번 올바르게 마감시간 설정 가능
            
            cell.configure(with: viewModel.mainModel(at: indexPath.row))
        }
        
        return cell
    }
    
    // MARK: - Collection View Cell Delegate - Collection View Cell 클릭시 실행
    
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

// MARK: - Infinite Scrolling

extension MainViewController: MainViewModelDelegate {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        // 첫 로딩 - 1페이지일 경우
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            
            ActivityView.instance.stop()
            
            // 처음 1페이지일 때 아무것도 없으면 empty view
            if viewModel.mainList.isEmpty {
                self.showEmptyView()
            }
            
            mainTableView.reloadData()
            
            return
        }
        
        // 그 이외의 페이지의 경우 - 새로 로드될 셀만 업데이트
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        mainTableView.reloadRows(at: indexPathsToReload, with: .automatic)
        
        ActivityView.instance.stop()
    }
    
    func onFetchFailed(with reason: String) {
        ActivityView.instance.stop()
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

// MARK: - Refresh Control

extension MainViewController {
    
    func initRefresh() {
        refresh.addTarget(self, action: #selector(refreshTable(refresh:)), for: .valueChanged)
        refresh.tintColor = UIColor.white
        self.mainTableView.refreshControl = refresh
    }
    
    @objc func refreshTable(refresh: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            
            self.viewModel.page = 0
            self.viewModel.currentPage = 1
            self.viewModel.mainList = []
            self.viewModel.fetchMainList()
            
            refresh.endRefreshing()
        }
    }
    
}

// MARK: - Timer

extension MainViewController: TableViewCellDelegate {
   
    func createTimer() {
        if timer == nil {
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
    
    func cancleTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func updateTimer() {
        guard let visibleRowsIndexPaths = mainTableView.indexPathsForVisibleRows else {
            return
        }
        
        for indexPath in visibleRowsIndexPaths {
            if let cell = mainTableView.cellForRow(at: indexPath) as? MainTableViewCell {
                cell.updateTime()
            }
        }
    }
}

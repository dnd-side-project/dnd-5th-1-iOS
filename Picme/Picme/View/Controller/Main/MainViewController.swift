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

class MainViewController: BaseViewContoller, TouchDelegate {

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
    
    var dataSource = MainListDatasource()
    private var viewModel: MainViewModel!
    
    var isFirst: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("viewdidload")
        
        setupTabBar()
        
        viewModel = MainViewModel(service: MainService(), dataSource: dataSource)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        bindViewModel()
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
    
    // MARK: - Bind View Model
    
    private func bindViewModel() {
        mainTableView.dataSource = dataSource
        dataSource.delegate = self
        
        dataSource.data.addAndNotify(observer: self) { [weak self] _ in
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
                    self.mainTableView.reloadData()
                }
            }
        }
    }
    
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

// MARK: - Table View Data Source / Collection View Cell Delegate

class MainListDatasource: GenericDataSource<MainModel>, UITableViewDataSource, CollectionViewCellDelegate {
    
    // MARK: - CollectionV View Cell Delegate
    
    weak var delegate: TouchDelegate?
    
    // Collection View Cell 클릭시 실행할 함수
    func selectedCVCell(_ index: Int, _ postId: String) {
        delegate?.pushVoteDetailView(index: index, postId: postId)
    }
    
    // MARK: - Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MainTableViewCell = tableView.dequeueTableCell(for: indexPath)
        
        cell.setCollectionViewDataSourceDelegate(forRow: indexPath.row)
        cell.cellDelegate = self
        cell.updateCell(model: data.value[indexPath.row])
        
        return cell
    }
    
}

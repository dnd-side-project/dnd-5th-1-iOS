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
        if let uploadImageVC = tabBarController?.storyboard?.instantiateViewController(withIdentifier: "UploadImage") {
            tabBarController?.present(uploadImageVC, animated: true)
        }
    }
    
    // MARK: - Variables
    
    var dataSource = MainListDatasource()
    private var viewModel: MainViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
        
        viewModel = MainViewModel(service: MainService(), dataSource: dataSource)
        
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
        self.tabBarController?.tabBar.items![1].image = #imageLiteral(resourceName: "plusPink")
        self.tabBarController?.tabBar.items![2].image = #imageLiteral(resourceName: "mypageWhite")
    }
    
    // MARK: - Bind View Model
    
    private func bindViewModel() {
        mainTableView.dataSource = dataSource
        dataSource.delegate = self
        
        dataSource.data.addAndNotify(observer: self) { [weak self] _ in
            self?.showTableView()
        }
        
        // 서버 통신
        // viewModel.fetchMainList()
    }
    
    // MARK: - Table View
    
    func showTableView() {
        DispatchQueue.main.async {
            if self.dataSource.data.value.isEmpty {
                self.emptyView.isHidden = true
                // self.showEmptyView()
            } else {
                self.mainTableView.isHidden = false
                self.emptyView.isHidden = true
                self.mainTableView.reloadData()
            }
        }
    }
    
    func showEmptyView() {
        self.mainTableView.isHidden = true
        self.emptyView.isHidden = false
    }
    
    // MARK: - Collection View Cell 클릭시
    
    func pushVoteDetailView(index: Int, postId: String) {
        
        if APIConstants.jwtToken != "" { // 미로그인 사용자
            let alertTitle = """
            로그인 해야 투표를 할 수 있어요.
            로그인을 해주시겠어요?
            """
            
            AlertView.instance.showAlert(
            title: alertTitle, denyButtonTitle: "더 둘러보기", doneButtonTitle: "로그인하기", image: #imageLiteral(resourceName: "eyeLarge"), alertType: .login)
        } else { // 로그인한 사용자
            guard let voteDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "VoteDetailViewController") as? VoteDetailViewController else { return }
            voteDetailVC.postId = "1"
            voteDetailVC.userNickname = "minha"
            voteDetailVC.userProfileimageUrl = ""
            self.navigationController?.pushViewController(voteDetailVC, animated: true)
        }
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
        // return data.value.count
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MainTableViewCell = tableView.dequeueTableCell(for: indexPath)
        
        cell.setCollectionViewDataSourceDelegate(forRow: indexPath.row)
        cell.cellDelegate = self
        // cell.updateCell(model: data.value[indexPath.row])
        
        return cell
    }
    
}

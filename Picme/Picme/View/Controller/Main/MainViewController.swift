//
//  MainViewController.swift
//  dnd-5th-1-iOS
//
//  Created by 권민하 on 2021/07/21.
//

import UIKit

// MARK: - Collection View Cell 클릭 시 실행할 프로토콜

protocol TouchDelegate: AnyObject {
    func pushVoteDetailView(index: Int)
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
    
    // MARK: - Paging
    
    var isPaging: Bool = false // 현재 페이징 중인지 체크하는 flag
    var hasNextPage: Bool = false // 마지막 페이지 인지 체크 하는 flag
    
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
        self.tabBarController?.tabBar.items![1].image = #imageLiteral(resourceName: "tabBarVote")
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
        // self.activityIndicator.isHidden = true
    }
    
    // MARK: - Collection View Cell 클릭 시 투표 상세 뷰로 이동
    
    func pushVoteDetailView(index: Int) {
        
        // 미로그인 사용자 - Alert
        
        let alertTitle = """
            로그인 해야 투표를 할 수 있어요.
            로그인을 해주시겠어요?
            """
        
        AlertView.instance.showAlert(
            title: alertTitle, denyButtonTitle: "더 둘러보기", doneButtonTitle: "로그인하기", image: #imageLiteral(resourceName: "eyeLarge"), alertType: .login)
        
        // 로그인한 사용자 - pushViewController
        /*
        guard let voteDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "VoteDetailViewController") as? VoteDetailViewController else { return }
        voteDetailVC.postId = 1
        voteDetailVC.userNickname = ""
        voteDetailVC.userProfileimageUrl = ""
        self.navigationController?.pushViewController(voteDetailVC, animated: true)
 */
    }
    
    // MARK: - Table View Data Source / Collection View Cell Delegate
    
    class MainListDatasource: GenericDataSource<MainModel>, UITableViewDataSource, CollectionViewCellDelegate {
        
        // MARK: - CollectionV View Cell Delegate
        
        weak var delegate: TouchDelegate?
        
        // Collection View Cell 클릭시 실행할 함수
        func selectedCVCell(_ index: Int) {
            delegate?.pushVoteDetailView(index: index)
        }
        
        // MARK: - Table View Data Source
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // return data.value.count
            
            return 5
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell: MainTableViewCell = tableView.dequeueTableCell(for: indexPath)
            
            cell.setCollectionViewDataSourceDelegate(forRow: indexPath.row)
            cell.cellDelegate = self
            // cell.updateCell(model: data.value[indexPath.row])
            
            // 서버 통신 전 예시 코드
            cell.mainNicknameLabel.text = "오늘도 개미는 뚠뚠"
            cell.mainParticipantsLabel.text = "99명 참가중"
            cell.mainDeadlineLabel.text = "1시간 후 마감"
            cell.mainTitleLabel.text = "사진 잘 나온거 하나만 골라주세요!!"
            cell.mainProfileImageView.image = #imageLiteral(resourceName: "defalutImage")
            
            return cell
        }
        
    }
}

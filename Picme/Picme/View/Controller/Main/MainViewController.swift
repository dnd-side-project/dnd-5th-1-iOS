//
//  MainViewController.swift
//  dnd-5th-1-iOS
//
//  Created by 권민하 on 2021/07/21.
//

import UIKit

// MARK: - Collection View Cell 클릭 시 실행할 프로토콜
protocol TouchDelegate: AnyObject {
    // func pushVoteDetailView(index: Int, postId: String)
    func pushVoteDetailView(index: Int, postId: String, postNickname: String, postProfileUrl: String)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
        
        viewModel = MainViewModel(service: MainService(), dataSource: dataSource)
        
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mainTableView.reloadData()
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
        
        // 서버 통신
        viewModel.fetchMainList()
    }
    
    // MARK: - Table View
    
    func showTableView() {
        DispatchQueue.main.async {
            if self.dataSource.data.value.isEmpty {
                print("empty")
                self.showEmptyView()
            } else {
                self.emptyView.isHidden = true
                self.mainTableView.isHidden = false
                self.mainTableView.reloadData()
            }
        }
    }
    
    func showEmptyView() {
        self.emptyView.isHidden = false
        self.mainTableView.isHidden = true
    }
    
    // MARK: - Collection View Cell 클릭시
    
    /*
    func pushVoteDetailView(index: Int, postId: String) {
        
        if APIConstants.jwtToken == "" { // 미로그인 사용자
            AlertView.instance.showAlert(using: .logIn)
            AlertView.instance.actionDelegate = self
        } else { // 로그인한 사용자
            guard let voteDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "VoteDetailViewController") as? VoteDetailViewController else { return }
            voteDetailVC.postId = postId
            voteDetailVC.userNickname = "minha"
            voteDetailVC.userProfileimageUrl = ""
            self.navigationController?.pushViewController(voteDetailVC, animated: true)
        }
     
    }
    */
    
    func pushVoteDetailView(index: Int, postId: String, postNickname: String, postProfileUrl: String) {
        if APIConstants.jwtToken == "" { // 미로그인 사용자
            AlertView.instance.showAlert(using: .logInDetail)
            AlertView.instance.actionDelegate = self
        } else { // 로그인한 사용자
            guard let voteDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "VoteDetailViewController") as? VoteDetailViewController else { return }
            voteDetailVC.postId = postId
            voteDetailVC.postNickname = postNickname
            voteDetailVC.postProfileUrl = postProfileUrl
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
        })
    }
}

// MARK: - Table View Data Source / Collection View Cell Delegate
class MainListDatasource: GenericDataSource<MainModel>, UITableViewDataSource, CollectionViewCellDelegate {
    
    // MARK: - CollectionV View Cell Delegate
    
    weak var delegate: TouchDelegate?
    
    // Collection View Cell 클릭시 실행할 함수
    
//    func selectedCVCell(_ index: Int, _ postId: String) {
//        delegate?.pushVoteDetailView(index: index, postId: postId)
//    }
    
    func selectedCVCell(_ index: Int, _ postId: String, _ postNickname: String, _ postProfileUrl: String) {
        delegate?.pushVoteDetailView(index: index, postId: postId, postNickname: postNickname, postProfileUrl: postProfileUrl)
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

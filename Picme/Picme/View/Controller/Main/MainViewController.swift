//
//  MainViewController.swift
//  dnd-5th-1-iOS
//
//  Created by 권민하 on 2021/07/21.
//

import UIKit

class MainViewController: UIViewController {
    
    lazy var mainViewModel: MainViewModel = {
        let mainViewModel = MainViewModel()
        return mainViewModel
    }()
    
    @IBOutlet weak var mainTableView: UITableView!
    
    //MARK: paging
    
    var isPaging: Bool = false // 현재 페이징 중인지 체크하는 flag
    var hasNextPage: Bool = false // 마지막 페이지 인지 체크 하는 flag
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    func setupTableView() {
        self.mainTableView.dataSource = self
        self.mainTableView.delegate = self
        
        mainViewModel.mainList.bind { (_) in
            self.showTableView()
        }
        
        //self.mainViewModel.fetchMainList()
    }
    
    
    func showTableView() {
        DispatchQueue.main.async {
            if self.mainViewModel.mainList.value.isEmpty {
                //self.showEmptyView()
            } else {
                self.mainTableView.reloadData()
            }
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //return mainViewModel.mainList.value.count
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: MainTableViewCell = mainTableView.dequeueTableCell(for: indexPath)
        
        cell.delegate = self
        //        cell.setCollectionViewDataSourceDelegate(forRow: indexPath.row)
        //        cell.item = self.mainViewModel.mainList.value[indexPath.row]
        
        // 서버 통신 전 예시 코드
        cell.mainNicknameLabel.text = "오늘도 개미는 뚠뚠"
        cell.mainParticipantsLabel.text = "99명 참가중"
        cell.mainDeadlineLabel.text = "1시간 후 마감"
        cell.mainTitleLabel.text = "사진 잘 나온거 하나만 골라주세요!!"
        cell.mainProfileImageView.image = #imageLiteral(resourceName: "defalutImage")
        cell.setCollectionViewDataSourceDelegate(forRow: indexPath.row)
        
        return cell
    }
    
    /*
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
     
     if mainViewModel.mainList.value.count == indexPath.row - 1 {
     mainViewModel.fetchMainList()
     }
     }
     */
    
}

extension MainViewController: CollectionViewCellDelegate {
    func selectedCollectionViewCell(_ index: Int) {
        
        guard let voteDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "VoteDetailViewController") as? VoteDetailViewController else { return }

        self.navigationController?.pushViewController(voteDetailVC, animated: true)
    }
    
}

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    func setupTableView() {
        self.mainTableView.dataSource = self
        self.mainTableView.delegate = self
        
        /*
         mainViewModel.mainList.bind { (_) in
         self.showTableView()
         }
         
         self.mainViewModel.fetchMainList()
         */
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
        
        guard let cell = mainTableView.dequeueReusableCell(withIdentifier: "MainTableViewCell") as? MainTableViewCell else { return UITableViewCell() }
        
//        cell.setCollectionViewDataSourceDelegate(forRow: indexPath.row)
//        cell.item = self.mainViewModel.mainList.value[indexPath.row]
        
        // 서버 통신 전 예시 코드
        cell.mainNicknameLabel.text = "오늘도 개미는 뚠뚠"
        cell.mainDateLabel.text = "4시간 전"
        cell.mainDeadlineLabel.text = "1시간 후 마감"
        cell.mainTitleLabel.text = "사진 잘 나온거 하나만 골라주세요!!"
        cell.mainProfileImageView.image = #imageLiteral(resourceName: "defalutImage")
        cell.setCollectionViewDataSourceDelegate(forRow: indexPath.row)
        
        return cell
    }
    
}

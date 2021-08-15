//
//  VoteDetailTableViewController.swift
//  Picme
//
//  Created by 권민하 on 2021/08/02.
//

import UIKit

class VoteDetailTableViewController: BaseViewContoller {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var detailTableView: UITableView!
    
    // MARK: - IBActions
    
    @IBAction func backButtonClickAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Properties
    
    var dataSource = VoteDetailDatasource()
    var viewModel: VoteDetailViewModel!
    weak var delegate: CollectionViewCellDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = VoteDetailViewModel(service: VoteDetailService(), dataSource: dataSource)
        
        bindViewModel()
    }
    
    private func bindViewModel() {
        detailTableView.dataSource = dataSource
        
        dataSource.data.addAndNotify(observer: self) { [weak self] _ in
            self?.detailTableView.reloadData()
            // self?.showTableView()
        }
        
        // viewModel.fetchVoteDetail(postId: 1)
    }
    
    func showTableView() {
        DispatchQueue.main.async {
            if self.dataSource.data.value.isEmpty {
                self.showEmptyView()
            } else {
                self.detailTableView.reloadData()
            }
        }
    }
    
    func showEmptyView() {
        // self.detailTableView.isHidden = true
        // self.emptyView.isHidden = false
        // self.activityIndicator.isHidden = true
    }
    
}

class VoteDetailDatasource: GenericDataSource<VoteDetailModel>, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return data.value.count
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: VoteDetailTableViewCell = tableView.dequeueTableCell(for: indexPath)
   
        cell.setCollectionViewDataSourceDelegate(forRow: indexPath.row)
        // cell.delegate = self
        // cell.updateCell(model: data.value[indexPath.row])
       
        return cell
    }

}

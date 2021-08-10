//
//  VoteDetailViewController.swift
//  Picme
//
//  Created by 권민하 on 2021/08/02.
//

import UIKit

class VoteDetailViewController: BaseViewContoller {
    
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
        
        viewModel = VoteDetailViewModel(dataSource: dataSource)
        
        bindViewModel()
    }
    
    private func bindViewModel() {
        detailTableView.dataSource = dataSource
        
        dataSource.data.addAndNotify(observer: self) { [weak self] _ in
            self?.detailTableView.reloadData()
        }
        
        viewModel.fetchVoteDetail(postId: "1")
    }
    
}

class VoteDetailDatasource: GenericDataSource<VoteDetailModel>, UITableViewDataSource, CollectionViewCellDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        //return data.value.count
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: VoteDetailTableViewCell = tableView.dequeueTableCell(for: indexPath)
   
        cell.setCollectionViewDataSourceDelegate(forRow: indexPath.row)
        cell.delegate = self
        //cell.updateCell(model: data.value[indexPath.row])
       
        return cell
    }
    
    func selectedCollectionViewCell(_ index: Int) {
        
        //        guard let voteDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "VoteDetailViewController") as? VoteDetailViewController else { return }
        //
        //        self.navigationController?.pushViewController(voteDetailVC, animated: true)
    }
}

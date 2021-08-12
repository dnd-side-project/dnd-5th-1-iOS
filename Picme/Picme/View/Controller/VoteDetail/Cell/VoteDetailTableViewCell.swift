//
//  VoteDetailTableViewCell.swift
//  Picme
//
//  Created by 권민하 on 2021/08/07.
//

import UIKit
import Kingfisher

class VoteDetailTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var detailNicknameLabel: UILabel!
    @IBOutlet weak var detailParticipantsLabel: UILabel!
    @IBOutlet weak var detailProfileImageView: UIImageView!
    @IBOutlet weak var detailPageLabel: UILabel!
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var detailDeadlineLabel: UILabel!
    @IBOutlet weak var detailNextLabel: UILabel!
    @IBOutlet weak var detailPageControl: UIPageControl!
    @IBOutlet weak var detailCollectionView: UICollectionView!
    
    @IBAction func detailPickButton(_ sender: UIButton) {
        
    }
    
    @IBOutlet weak var detailNextButton: UIButton!
    
    // MARK: - Variables
    
    var imageData: [VoteDetailImage]!
    
    // 서버 통신 전 예시 이미지
    var imageArray = [#imageLiteral(resourceName: "defalutImage"), #imageLiteral(resourceName: "defalutImage"), #imageLiteral(resourceName: "defalutImage"), #imageLiteral(resourceName: "defalutImage"), #imageLiteral(resourceName: "defalutImage")]
    
    weak var delegate: CollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setCollectionViewDataSourceDelegate(forRow row: Int) {
        detailCollectionView.delegate = self
        detailCollectionView.dataSource = self
        detailCollectionView.reloadData()
    }
    
    func updateCell(model: Any) {
        
        if let object = model as? VoteDetailModel {
            
//            detailNicknameLabel.text = object.nickname
//            detailProfileImageView.kf.setImage(with: URL(string: object.profileImage ?? "0"), placeholder: #imageLiteral(resourceName: "defalutImage"))
//            detailParticipantsLabel.text = "\(object.participantsNum ?? 0)명 참가중"
//            detailDeadlineLabel.text = object.deadline
//            detailPageLabel.text = "currentPage/\(object.images?.count ?? 0)"
//            detailDescriptionLabel.text = object.description
//            imageData = object.images
        }
    }
    
}

// MARK: - CollectionView Delegate, DataSource

extension VoteDetailTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // return imageData.count
        
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: VoteDetailCollectionViewCell = detailCollectionView.dequeueCollectionCell(for: indexPath)
        
        //        cell.detailPhotoImageView.kf.setImage(with: URL(string: imageData[indexPath.row].imageUrl!), placeholder: #imageLiteral(resourceName: "defalutImage"))
        
        cell.detailPhotoImageView.image = imageArray[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    }
    
}

// MARK: - CollectionView Animation

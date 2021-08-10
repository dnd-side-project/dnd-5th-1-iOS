//
//  MainTableViewCell.swift
//  Picme
//
//  Created by 권민하 on 2021/07/30.
//

import UIKit
import Kingfisher

class MainTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var mainProfileImageView: UIImageView!
    @IBOutlet weak var mainNicknameLabel: UILabel!
    @IBOutlet weak var mainParticipantsLabel: UILabel!
    @IBOutlet weak var mainDeadlineLabel: UILabel!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    // MARK: - Variables
    
    weak var delegate: CollectionViewCellDelegate?
    
    var imageData: [String]!
    
    // 서버 통신 전 예시 이미지
    var imageArray = [#imageLiteral(resourceName: "defalutImage"), #imageLiteral(resourceName: "defalutImage"), #imageLiteral(resourceName: "defalutImage")]
    
    var item: MainModel? {
        didSet {
            guard let mainList = item else { return }
            
            self.mainProfileImageView.kf.setImage(with: URL(string: mainList.userProfileimageUrl), placeholder: #imageLiteral(resourceName: "defalutImage"))
            self.mainNicknameLabel.text = mainList.userNickname
            self.mainParticipantsLabel.text = String(mainList.participantsNum)
            self.mainDeadlineLabel.text = mainList.deadline
            self.mainTitleLabel.text = mainList.title
            self.imageData = mainList.thumbnailUrl
        }
    }
    
    func setCollectionViewDataSourceDelegate(forRow row: Int) {
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 프로필 이미지 원형으로 만들기
        mainProfileImageView.layer.cornerRadius = mainProfileImageView.frame.width / 2 // 프레임 원으로
        mainProfileImageView.contentMode = UIView.ContentMode.scaleAspectFill // 이미지 비율 바로잡기
        mainProfileImageView.clipsToBounds = true // 이미지를 뷰 프레임에 맞게 clip
    }
    
}

// MARK: - CollectionView

extension MainTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // return imageData.count
        
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MainCollectionViewCell = mainCollectionView.dequeueCollectionCell(for: indexPath)
        
        // cell.mainPhotoImageView.kf.setImage(with: URL(string: imageData[indexPath.row]), placeholder: #imageLiteral(resourceName: "defalutImage"))
        
        if indexPath.item == imageArray.count - 1 { // 마지막 cell 설정
            cell.mainPhotoImageView.image = #imageLiteral(resourceName: "defalutImage").withRenderingMode(.alwaysTemplate)
            cell.mainPhotoImageView.tintColor = .solidColor(.solid12)
            cell.stackView.isHidden = false
        } else {
            cell.mainPhotoImageView.image = imageArray[indexPath.row]
            cell.stackView.isHidden = true
        }
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let delegate = delegate {
            delegate.selectedCollectionViewCell(indexPath.item)
        }
    }
    
}

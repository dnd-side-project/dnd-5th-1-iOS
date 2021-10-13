//
//  MainTableViewCell.swift
//  Picme
//
//  Created by 권민하 on 2021/07/30.
//

import UIKit
import Kingfisher

// MARK: - Collection View Cell Delegate

protocol CollectionViewCellDelegate: AnyObject {
    func selectedCVCell(_ index: Int, _ postId: String)
}

// MARK: - Main Table View Cell Delegate

protocol TableViewCellDelegate: AnyObject {
    func cancleTimer()
}

class MainTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var mainProfileImageView: UIImageView!
    @IBOutlet weak var mainNicknameLabel: UILabel!
    @IBOutlet weak var mainParticipantsLabel: UILabel!
    @IBOutlet weak var mainDeadlineLabel: UILabel!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var mainClockImageView: UIImageView!
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    // MARK: - Variables
    
    weak var cellDelegate: CollectionViewCellDelegate?
    weak var tableDelegate: TableViewCellDelegate?
    
    var imageData: [Images]?
    var postId: String!
    
    // Timer
    var dateHelper = DateHelper()
    var currentDate: Date?
    var remainSeconds: Int = 0
    
    func configure(with object: MainModel?) {
        if let object = object {
            mainProfileImageView.image = UIImage.profileImage(object.user.profileImageUrl)
            mainNicknameLabel.text = object.user.nickname
            mainParticipantsLabel.text = "\(object.participantsNum)명 참여중"
            mainTitleLabel.text = object.title
            imageData = object.images
            
            // 타이머 설정
            let endDate = dateHelper.stringToDate(dateString: object.deadline)
            remainSeconds = dateHelper.getTimer(startDate: currentDate!, endDate: endDate!)
            updateTime()
            
            postId = object.postId
        }
    }
    
    // MARK: - Timer
    
    func updateTime() {
        remainSeconds -= 1
        self.mainClockImageView.isHidden = false
        self.mainDeadlineLabel.text = self.dateHelper.timerString(remainSeconds: remainSeconds)
        
        if remainSeconds <= 0 {
            self.mainDeadlineLabel.text = "마감된 투표에요"
            self.mainClockImageView.isHidden = true
            
            tableDelegate?.cancleTimer()
        }
    }
    
    func setCollectionViewDataSourceDelegate(forRow row: Int) {
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainProfileImageView.circular() // 프로필 이미지 원형
        
        mainCollectionView.showsHorizontalScrollIndicator = false // 컬렉션뷰 스크롤바 없앰
    }
}

// MARK: - CollectionView

extension MainTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let count = imageData?.count ?? 0
        
        return count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: MainCollectionViewCell = mainCollectionView.dequeueCollectionCell(for: indexPath)
        
        if let imageData = imageData {
            if indexPath.item == imageData.count {
                cell.mainPhotoImageView.image = #imageLiteral(resourceName: "defalutImage").withRenderingMode(.alwaysTemplate)
                cell.mainPhotoImageView.tintColor = .solidColor(.solid12)
                cell.stackView.isHidden = false
            } else {
                cell.mainPhotoImageView.kf.setImage(with: URL(string: (imageData[indexPath.row].thumbnailUrl)), placeholder: #imageLiteral(resourceName: "defalutImage"))
                cell.stackView.isHidden = true
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cellDelegate = cellDelegate {
            cellDelegate.selectedCVCell(mainCollectionView.tag, postId)
        }
    }
    
}

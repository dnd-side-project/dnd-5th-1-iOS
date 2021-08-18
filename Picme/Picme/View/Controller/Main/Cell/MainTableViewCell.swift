//
//  MainTableViewCell.swift
//  Picme
//
//  Created by 권민하 on 2021/07/30.
//

import UIKit
import Kingfisher

// MARK: - CollectionviewCellDelegate

protocol CollectionViewCellDelegate: AnyObject {
    func selectedCVCell(_ index: Int, _ postId: String)
}

class MainTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var mainProfileImageView: UIImageView!
    @IBOutlet weak var mainNicknameLabel: UILabel!
    @IBOutlet weak var mainParticipantsLabel: UILabel!
    @IBOutlet weak var mainDeadlineLabel: UILabel!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    // MARK: - Variables
    
    weak var cellDelegate: CollectionViewCellDelegate?
    var imageData: [Images]!
    var postId: String!
    
    // 서버 통신 전 예시 이미지
    var imageArray = [#imageLiteral(resourceName: "defalutImage"), #imageLiteral(resourceName: "defalutImage"), #imageLiteral(resourceName: "defalutImage")]
    
    // MARK: - Timer
    var timer = Timer()
    
    deinit {
        timer.invalidate()
    }
    
    func updateCell(model: Any) {
        if let object = model as? MainModel {
            mainProfileImageView.kf.setImage(with: URL(string: object.user.profileImageUrl), placeholder: #imageLiteral(resourceName: "profilePink"))
            mainNicknameLabel.text = object.user.nickname
            mainParticipantsLabel.text = String(object.participantsNum)
            mainTitleLabel.text = object.title
            imageData = object.images
            setTimer(endTime: object.deadline)
            postId = object.postId
        }
    }
    
    func setTimer(endTime: String) {
        DispatchQueue.main.async { [weak self] in
            self?.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                let convertDate = dateFormatter.date(from: endTime)
                
                let elapsedTimeSeconds = Int(Date().timeIntervalSince(convertDate!))
                let expireLimit = Int(Date().timeIntervalSince(Date()))
                
                guard elapsedTimeSeconds <= expireLimit else { // 시간 초과한 경우
                    timer.invalidate()
                    return
                }

                let remainSeconds = expireLimit - elapsedTimeSeconds
                
                let hours   = Int(remainSeconds) / 3600
                let minutes = Int(remainSeconds) / 60 % 60
                let seconds = Int(remainSeconds) % 60
                
                self?.mainDeadlineLabel.text = String(format: "%02i:%02i:%02i", hours, minutes, seconds)
            }
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
        
        /*
        if indexPath.item == imageData.count - 1 {
            cell.mainPhotoImageView.image = #imageLiteral(resourceName: "defalutImage").withRenderingMode(.alwaysTemplate)
            cell.mainPhotoImageView.tintColor = .solidColor(.solid12)
            cell.stackView.isHidden = false
        } else {
            cell.mainPhotoImageView.kf.setImage(with: URL(string: imageData[indexPath.row].thumbnailUrl), placeholder: #imageLiteral(resourceName: "defalutImage"))
            cell.stackView.isHidden = true
        }
        */
        
        if indexPath.item == imageArray.count - 1 {
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
        if let cellDelegate = cellDelegate {
            // cellDelegate.selectedCVCell(indexPath.item, postId)
            cellDelegate.selectedCVCell(indexPath.item, "1")
        }
    }
    
}

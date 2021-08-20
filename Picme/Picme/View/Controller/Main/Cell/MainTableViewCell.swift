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
    // func selectedCVCell(_ index: Int, _ postId: String)
    func selectedCVCell(_ index: Int, _ postId: String, _ postNickname: String, _ postProfileUrl: String)
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
    var imageData: [Images]?
    var postId: String!
    var postNickname: String!
    var postProfileUrl: String!
    
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
            // imageData = object.images
            // setTimer(endTime: object.deadline)
            setTimer(endTime: "2021-08-20T23:05:59.703Z")
            
            postId = object.postId
            postNickname = object.user.nickname
            postProfileUrl = object.user.profileImageUrl
        }
    }
    
    func setTimer(endTime: String) {
        DispatchQueue.main.async { [weak self] in
            self?.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
                
                // 마감 시간 Date 형식으로 변환
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                let convertDate = dateFormatter.date(from: endTime)
                
                // 현재 시간 적용하기 - 시간 + 9시간
                let calendar = Calendar.current
                let today = Date()
                let localDate = Date(timeInterval: TimeInterval(calendar.timeZone.secondsFromGMT()), since: today)
                let localConvertDate =  Date(timeInterval: TimeInterval(calendar.timeZone.secondsFromGMT()), since: convertDate!)
                
                let elapsedTimeSeconds = Int(Date().timeIntervalSince(localConvertDate)) // 마감 시간
                let expireLimit = Int(Date().timeIntervalSince(localDate)) // 현재 시간
                
                guard elapsedTimeSeconds <= expireLimit else { // 시간 초과한 경우
                    timer.invalidate()
                    
                    self?.mainDeadlineLabel.text = "마감된 투표에요"
                    self?.mainClockImageView.isHidden = true
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
        // return imageData?.count ?? 0
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MainCollectionViewCell = mainCollectionView.dequeueCollectionCell(for: indexPath)
        
        /*
        if indexPath.item == imageData!.count - 1 {
            cell.mainPhotoImageView.image = #imageLiteral(resourceName: "defalutImage").withRenderingMode(.alwaysTemplate)
            cell.mainPhotoImageView.tintColor = .solidColor(.solid12)
            cell.stackView.isHidden = false
        } else {
            cell.mainPhotoImageView.kf.setImage(with: URL(string: (imageData?[indexPath.row].thumbnailUrl)!), placeholder: #imageLiteral(resourceName: "defalutImage"))
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
            cellDelegate.selectedCVCell(indexPath.item, postId, postNickname, postProfileUrl)
        }
    }
    
}

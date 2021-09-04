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
    @IBOutlet weak var mainClockImageView: UIImageView!
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    // MARK: - Variables
    
    weak var cellDelegate: CollectionViewCellDelegate?
    var imageData: [Images]?
    // var imageData = [#imageLiteral(resourceName: "defalutImage"), #imageLiteral(resourceName: "defalutImage"), #imageLiteral(resourceName: "defalutImage")]
    var postId: String!
    
    // Timer
    var timer = Timer()
    let currentDate = Date()
    
    deinit {
        timer.invalidate()
    }
    
    /*
    func updateCell(model: Any) {
        if let object = model as? MainModel {
            // mainProfileImageView.kf.setImage(with: URL(string: object.user.profileImageUrl), placeholder: #imageLiteral(resourceName: "progressCircle"))
            
            mainProfileImageView.image = UIImage.profileImage(object.user.profileImageUrl)
            mainNicknameLabel.text = object.user.nickname
            mainParticipantsLabel.text = "\(object.participantsNum)명 참여중"
            mainTitleLabel.text = object.title
            imageData = object.images
            // setTimer(endTime: object.deadline)
            setTimer(deadline: object.deadline)
            postId = object.postId
        } else {
       
        }
    }
 */
    
    func configure(with object: MainModel?) {
        if let object = object {
            mainProfileImageView.image = UIImage.profileImage(object.user.profileImageUrl)
            mainNicknameLabel.text = object.user.nickname
            mainParticipantsLabel.text = "\(object.participantsNum)명 참여중"
            mainTitleLabel.text = object.title
            imageData = object.images
            // setTimer(endTime: object.deadline)
            setTimer(deadline: object.deadline)
            postId = object.postId
        } else {
           // print("로딩중")
        }
    }
    
    // MARK: - Timer
    
    func setTimer(deadline: String) {
        let endDate = DateHelper.stringToDate(dateString: deadline)!
        var remainSeconds = DateHelper.getTimer(startDate: currentDate, endDate: endDate)
        
        DispatchQueue.main.async { [weak self] in
            self?.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
           
                if remainSeconds < 0 {
                    timer.invalidate()
                    self?.mainDeadlineLabel.text = "마감된 투표에요"
                    self?.mainClockImageView.isHidden = true
                    return
                }
                
                remainSeconds -= 1
                self?.mainClockImageView.isHidden = false
                self?.mainDeadlineLabel.text = DateHelper.timerString(remainSeconds: remainSeconds)
            }
        }
    }
    
    /*
    func setTimer(endTime: String) {
        print("settiemr")
        DispatchQueue.main.async { [weak self] in
            self?.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
                
  
                // 마감 시간 Date 형식으로 변환
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
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
                
                self?.mainClockImageView.isHidden = false
                self?.mainDeadlineLabel.text = String(format: "%02i:%02i:%02i", hours, minutes, seconds)
            }
        }
    }
 */
    
    func setCollectionViewDataSourceDelegate(forRow row: Int) {
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainProfileImageView.circular() // 프로필 이미지 원형
        
        mainCollectionView.showsHorizontalScrollIndicator = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        timer.invalidate()
    }
    
}

// MARK: - CollectionView

extension MainTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = imageData?.count ?? 0
        return count + 1
        
        // return 3
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
        
        // cell.mainPhotoImageView.image = imageData[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cellDelegate = cellDelegate {
            cellDelegate.selectedCVCell(indexPath.item, postId)
        }
    }
    
}

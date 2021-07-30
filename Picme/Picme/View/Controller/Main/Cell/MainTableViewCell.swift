//
//  MainTableViewCell.swift
//  Picme
//
//  Created by 권민하 on 2021/07/30.
//

import UIKit
import Kingfisher

class MainTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainProfileImageView: UIImageView!
    @IBOutlet weak var mainNicknameLabel: UILabel!
    @IBOutlet weak var mainDateLabel: UILabel!
    @IBOutlet weak var mainDeadlineLabel: UILabel!
    @IBOutlet weak var mainTitleLabel: UILabel!
    
    var imageData: [String]!
    
    // 서버 통신 전 예시 이미지
    var imageArray = [#imageLiteral(resourceName: "defalutImage"), #imageLiteral(resourceName: "defalutImage"), #imageLiteral(resourceName: "defalutImage"), #imageLiteral(resourceName: "defalutImage"), #imageLiteral(resourceName: "defalutImage")]
    
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    var item: MainModel? {
        didSet {
            guard let mainList = item else { return }
            
            self.mainProfileImageView.kf.setImage(with: URL(string: mainList.profileimageUrl), placeholder: #imageLiteral(resourceName: "defalutImage"))
            self.mainNicknameLabel.text = mainList.nickname
            self.mainDateLabel.text = mainList.date
            self.mainDeadlineLabel.text = mainList.deadline
            self.mainTitleLabel.text = mainList.title
            
            self.imageData = mainList.images
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
        mainProfileImageView.layer.cornerRadius = mainProfileImageView.frame.width / 2 // 프레임 원으로 만들기
        mainProfileImageView.contentMode = UIView.ContentMode.scaleAspectFill // 이미지 비율 바로잡기
        mainProfileImageView.clipsToBounds = true //이미지를 뷰 프레임에 맞게 clip
    }
    
}

extension MainTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //return imageData.count
        
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath) as? MainCollectionViewCell else { return UICollectionViewCell() }
        
        //cell.mainPhotoImageView.kf.setImage(with: URL(string: imageData[indexPath.row]), placeholder: #imageLiteral(resourceName: "defalutImage"))

        cell.mainPhotoImageView.image = imageArray[indexPath.row]
        
        return cell
    }
    
}

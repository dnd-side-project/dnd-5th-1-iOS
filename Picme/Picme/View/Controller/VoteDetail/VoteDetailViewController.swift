//
//  VoteDetailViewController.swift
//  Picme
//
//  Created by 권민하 on 2021/08/12.
//

import UIKit

class VoteDetailViewController: BaseViewContoller {
    
    // MARK: - IBOutlets
    
    // Navigation Bar Button Item
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    
    // Vote Detail Item
    @IBOutlet weak var detailProfileImageView: UIImageView!
    @IBOutlet weak var detailNicknameLabel: UILabel!
    @IBOutlet weak var detailParticipantsLabel: UILabel!
    @IBOutlet weak var detailDeadlineLabel: UILabel!
    @IBOutlet weak var detailPageLabel: UILabel!
    @IBOutlet weak var detailTitleLabel: UILabel!
    
    // Collection View
    @IBOutlet weak var detailCollectionview: UICollectionView!
    
    // Pick View
    @IBOutlet weak var pickView: UIView!
    @IBOutlet weak var detailPageControl: UIPageControl!
    @IBOutlet weak var pickButton: UIButton!
    
    // Feedback View
    @IBOutlet weak var feedbackView: UIView!
    @IBOutlet weak var sensitivityButton: UIButton!
    @IBOutlet weak var compositionButton: UIButton!
    @IBOutlet weak var lightButton: UIButton!
    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    // MARK: - Properties
    
    var postId: Int = 0
    var userNickname: String = ""
    var userProfileimageUrl: String = ""
    
    var currentImageId: Int?
    var selectedImageId: Int?
    
    var dataSource = VoteDetailDatasource()
    var viewModel: VoteDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = VoteDetailViewModel(dataSource: dataSource)
        
        bindViewModel()
        
        setupButtonTag()
        setupButtonAction()
        
    }
    
    // MARK: - Bind View Model
    
    private func bindViewModel() {

        // viewModel.fetchVoteDetail(postId: "1")
    }
    
}

// MARK: - Helpers

extension VoteDetailViewController {
    
    // MARK: - Set Up View
    
    private func setupView() {
        
        // 투표 작성자 - Feedback View + 원픽 이미지
        
        // 투표하지 않은 사용자 - Pick View
        
        // 투표한 사용자 - Feedback View + 투표 이미지
    }
    
    // MARK: - Button Tag
    private func setupButtonTag() {
        rightBarButton.tag = 0
        // rightBarButton.tag = 1
        
        rightBarButton.image = #imageLiteral(resourceName: "megaphone")
        
        // Feedback Button
        sensitivityButton.tag = 2
        compositionButton.tag = 3
        lightButton.tag = 4
        colorButton.tag = 5
        skipButton.tag = 6
        
    }
    
    // MARK: - Button Actions
    
    private func setupButtonAction() {
        backButton.action = #selector(backButtonClicked(_:))
        backButton.target = self
        
        rightBarButton.action = #selector(rightButtonClicked(_:))
        rightBarButton.target = self
        
        pickButton.addTarget(self, action: #selector(pickButtonClicked), for: UIControl.Event.touchUpInside)
        
        // Feedback Button
        sensitivityButton.addTarget(self, action: #selector(feedbackButtonClicked), for: UIControl.Event.touchUpInside)
        compositionButton.addTarget(self, action: #selector(feedbackButtonClicked), for: UIControl.Event.touchUpInside)
        lightButton.addTarget(self, action: #selector(feedbackButtonClicked), for: UIControl.Event.touchUpInside)
        colorButton.addTarget(self, action: #selector(feedbackButtonClicked), for: UIControl.Event.touchUpInside)
        skipButton.addTarget(self, action: #selector(feedbackButtonClicked), for: UIControl.Event.touchUpInside)
    }
    
    @objc func backButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func rightButtonClicked(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            print("trash")
        case 1:
            print("report")
        default:
            print("error")
        }
    }
    
    @objc func pickButtonClicked(_ sender: UIButton) {
        print("pickButton")
    }
    
    @objc func feedbackButtonClicked(_ sender: UIButton) {
        switch sender.tag {
        case 2:
            print("sensitivityButton")
        case 3:
            print("compositionButton")
        case 4:
            print("lightButton")
        case 5:
            print("colorButton")
        case 6:
            print("skipButton")
        default:
            print("error")
        }
    }
    
}

// MARK: - Collection View Data Source

extension VoteDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: VoteDetailCollectionViewCell = detailCollectionview.dequeueCollectionCell(for: indexPath)
        
        return cell
    }
    
}

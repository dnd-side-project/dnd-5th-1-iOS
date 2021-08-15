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
    
    var currentImageId: Int?
    var selectedImageId: Int?
    var onePickImageId: Int?
    
    var dataSource = VoteDetailDatasource()
    var viewModel: VoteDetailViewModel!
    
    // 테스트 코드
    var postId: Int = 1
    var userNickname: String = "minha"
    var userProfileimageUrl: String = ""
    var loginUserNickName: String = "minha222"
    var isVoted: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = VoteDetailViewModel(service: VoteDetailService(), dataSource: dataSource)
        
        bindViewModel()
        
        setupButtonTag()
        setupButtonAction()
        setupView()
        
    }
    
    // MARK: - Bind View Model
    
    private func bindViewModel() {
        
        detailCollectionview.dataSource = dataSource
        
        dataSource.data.addAndNotify(observer: self) { [weak self] _ in
            self?.detailCollectionview.reloadData()
        }
        
        // viewModel.fetchVoteDetail(postId: postId)

    }
    
}

// MARK: - Helpers

extension VoteDetailViewController {
    
    // MARK: - Set Up View
    
    private func setupView() {
        
        detailNicknameLabel.text = userNickname
        detailProfileImageView.kf.setImage(with: URL(string: userProfileimageUrl), placeholder: #imageLiteral(resourceName: "profilePink"))
        // detailTitleLabel.text = dataSource.data.value[0].title
        // detailParticipantsLabel.text = String(dataSource.data.value[0].participantsNum!)
        
        if loginUserNickName == userNickname { // 1. 투표 작성자인 경우 - Feedback View + 원픽 이미지
            print("투표 작성자인 경우")
            rightBarButton.setBackgroundImage(#imageLiteral(resourceName: "trashcan"), for: .normal, barMetrics: .default)
            rightBarButton.tag = 0
            setupResultView(isVoted: true)
        } else { // 2. 투표 작성자가 아닐 경우
            rightBarButton.setBackgroundImage(#imageLiteral(resourceName: "megaphone"), for: .normal, barMetrics: .default)
            rightBarButton.tag = 1
            
            if !isVoted { // 투표하지 않은 사용자 - Pick View
                print("사용자 투표 X")
                pickView.isHidden = false
                feedbackView.isHidden = true
            } else { // 3. 투표한 사용자 - Feedback View + 투표 이미지
                print("사용자 투표 O")
                setupResultView(isVoted: true)
            }
        }
        
    }
    
    private func setupResultView(isVoted: Bool) {
        pickView.isHidden = true
        feedbackView.isHidden = false
        
        if isVoted {
            skipButton.setImage(#imageLiteral(resourceName: "profilePink"), for: .normal)
            skipButton.setTitle("", for: .normal)
            skipButton.tag = 7
        }
        
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
            
            let alertTitle = """
                게시글을 삭제하면 다시 업로드해야해요.
                정말 삭제하시겠어요?
                """
            
            AlertView.instance.showAlert(
                title: alertTitle, denyButtonTitle: "아니요", doneButtonTitle: "삭제하기", image: #imageLiteral(resourceName: "trash"), alertType: .delete)
        case 1:
            print("report")
            
            let alertTitle = """
                게시글에 문제가 있나요?
                신고를 하면 더 이상 게시글이 안보여요.
                """
            
            AlertView.instance.showAlert(
                title: alertTitle, denyButtonTitle: "아니요", doneButtonTitle: "신고하기", image: #imageLiteral(resourceName: "report"), alertType: .report)
        default:
            print("error")
        }
    }
    
    @objc func pickButtonClicked(_ sender: UIButton) {
        print("pickButton")
        selectedImageId = currentImageId
        setupResultView(isVoted: false)
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
        case 7:
            print("onePickButton")
        default:
            print("error")
        }
    }
    
    // MARK: - Collection View Data Source
    
    class VoteDetailDatasource: GenericDataSource<VoteDetailModel>, UICollectionViewDataSource {
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 5
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let cell: VoteDetailCollectionViewCell = collectionView.dequeueCollectionCell(for: indexPath)
            cell.detailPhotoImageView.image = #imageLiteral(resourceName: "defalutImage")
            return cell
        }
        
    }
    
}

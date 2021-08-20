import UIKit
import ScalingCarousel

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
    @IBOutlet weak var carouselCollectionView: ScalingCarouselView!
    
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
    @IBOutlet weak var onePickLabel: UILabel!
    
    // Feedback Result View
    @IBOutlet weak var sensitivityResultView: UIView!
    @IBOutlet weak var compositionResultView: UIView!
    @IBOutlet weak var lightResultView: UIView!
    @IBOutlet weak var colorResultView: UIView!
    
    // Feedback Percent Label
    @IBOutlet weak var sensitivityPercentLabel: UILabel!
    @IBOutlet weak var compositionPercentLabel: UILabel!
    @IBOutlet weak var lightPercentLabel: UILabel!
    @IBOutlet weak var colorPercentLabel: UILabel!
    
    // Feedback Height constraint
    @IBOutlet weak var sensitivityHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var compositionHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lightHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var colorHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    
    var currentImageId: Int?
    var selectedImageId: Int?
    var onePickImageId: Int?
    var currentPage: Int = 0
    var isPicked: Bool = false
    var firstRankSet: Set<Int> = []
    var isFirstRank: Bool = false
    var isFirstSetUpResultPercent: Bool = false
    
    var dataSource = VoteDetailDatasource()
    var viewModel: VoteDetailViewModel!
    
    // 테스트 코드
    var postId: String?
    var postNickname: String?
    var postProfileUrl: String?
    let loginUserNickname = LoginUser.shared.userNickname
    var isVoted: Bool = false
    
    var voteDetailImages: [VoteDetailImage]?
    var voteDetailModel: VoteDetailModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 테스트 코드
        let image1 = VoteDetailImage(imageId: "0", imageUrl: "", pickedNum: 0, emotion: 0, composition: 0, light: 0, color: 0, skip: 0)
        let image2: VoteDetailImage = VoteDetailImage(imageId: "1", imageUrl: "", pickedNum: 8, emotion: 1, composition: 1, light: 4, color: 1, skip: 1)
        let image3: VoteDetailImage = VoteDetailImage(imageId: "2", imageUrl: "", pickedNum: 3, emotion: 1, composition: 0, light: 1, color: 0, skip: 1)
        let image4: VoteDetailImage = VoteDetailImage(imageId: "3", imageUrl: "", pickedNum: 4, emotion: 2, composition: 0, light: 0, color: 2, skip: 0)
        let image5: VoteDetailImage = VoteDetailImage(imageId: "4", imageUrl: "", pickedNum: 3, emotion: 1, composition: 0, light: 0, color: 1, skip: 1)
        
        voteDetailImages = [image1, image2, image3, image4, image5]
        
        voteDetailModel = VoteDetailModel(onePickImageId: 2, isVoted: false, votedImageId: 0, title: "minha", participantsNum: 18, deadline: Date(), images: voteDetailImages!)
        
        viewModel = VoteDetailViewModel(service: VoteDetailService(), dataSource: dataSource)
        
        bindViewModel()
        
        setupButtonTag()
        setupButtonAction()
        setupView()
    }
    
    // MARK: - Bind View Model
    
    private func bindViewModel() {
        
        dataSource.data.addAndNotify(observer: self) { [weak self] _ in
            self?.carouselCollectionView.reloadData()
        }
        
        // viewModel.fetchVoteDetail(postId: postId)
        
    }
    
}

// MARK: - Collection View Data Source
typealias CarouselDatasource = VoteDetailViewController

extension CarouselDatasource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return voteDetailModel?.images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: VoteDetailCollectionViewCell = collectionView.dequeueCollectionCell(for: indexPath)
        
        if let scalingCell = cell as? ScalingCarouselCell {
            scalingCell.mainView.backgroundColor = .black
            scalingCell.cornerRadius = 10
        }
        
        // 투표 결과 화면
        if isVoted {
            cell.resultView.isHidden = false
            cell.diamondsImageView.isHidden = true
            cell.viewWidthConstraint.constant = 0
            
            // 투표 퍼센트 및 순위 구하기
            let participantsNum = gino(voteDetailModel?.participantsNum)
            let count = gino(voteDetailModel?.images?.count)
            
            var pickedNums = [Int](repeating: 0, count: count)
            var percents = [Double](repeating: 0, count: count)
            
            // 피드백 퍼센트 구하기
            for index in 0..<count {
                let sensitivityCount = gino(voteDetailModel?.images?[index].emotion)
                let compositionCount = gino(voteDetailModel?.images?[index].composition)
                let lightCount = gino(voteDetailModel?.images?[index].light)
                let colorCount = gino(voteDetailModel?.images?[index].color)
                let skipCount = gino(voteDetailModel?.images?[index].skip)
                
                let total = sensitivityCount + compositionCount + lightCount + colorCount + skipCount
                
                if total == 0 { // total이 0일 경우 0 / 0 = nan이니 예외처리
                    voteDetailModel?.images?[index].sensitivityPercent = 0.0
                    voteDetailModel?.images?[index].compositionPercent = 0.0
                    voteDetailModel?.images?[index].lightPercent = 0.0
                    voteDetailModel?.images?[index].colorPercent = 0.0
                } else {
                    voteDetailModel?.images?[index].sensitivityPercent = round((Double(sensitivityCount) / Double(total) * 100) * 10) / 10
                    voteDetailModel?.images?[index].compositionPercent = round((Double(compositionCount) / Double(total) * 100) * 10) / 10
                    voteDetailModel?.images?[index].lightPercent = round((Double(lightCount) / Double(total) * 100) * 10) / 10
                    voteDetailModel?.images?[index].colorPercent = round((Double(colorCount) / Double(total) * 100) * 10) / 10
                }
                
                // 이미지 퍼센트 구하기
                pickedNums[index] = gino(voteDetailModel?.images?[index].pickedNum)
                percents[index] = round((Double(pickedNums[index]) / Double(participantsNum) * 100) * 10) / 10
                voteDetailModel?.images?[index].percent = percents[index]
            }
            
            // 이미지 percent 순위별 내림차순 정렬
            var dictionary = [Int: Double]()
            
            for index in 0..<percents.count {
                dictionary[index] = percents[index]
            }
            
            let sortedDitionary = dictionary.sorted { $0.1 > $1.1 }
            
            // 공동 순위 정리
            var rank = 1
            // 정렬했으니 0번째가 1등
            var rankPickedNum = voteDetailModel?.images?[sortedDitionary[0].key].pickedNum
            voteDetailModel?.images?[sortedDitionary[0].key].rank = rank
            firstRankSet.insert(sortedDitionary[0].key)
            
            for index in 1..<sortedDitionary.count {
                
                // 이전 퍼센트와 동일할 경우 공동 순위
                if voteDetailModel?.images?[sortedDitionary[index].key].pickedNum == rankPickedNum {
                    voteDetailModel?.images?[sortedDitionary[index].key].rank = rank
                    if rank == 1 { // 공동 1위라면 1위 Set에 추가
                        firstRankSet.insert(sortedDitionary[index].key)
                    }
                } else { // 다르면 다음 순위
                    rank += 1
                    voteDetailModel?.images?[sortedDitionary[index].key].rank = rank
                    rankPickedNum = voteDetailModel?.images?[sortedDitionary[index].key].pickedNum
                }
            }
            
            cell.pickedNumLabel.text = "\(gino(voteDetailModel?.images?[indexPath.row].pickedNum))명"
            cell.percentLabel.text = "\(gdno(voteDetailModel?.images?[indexPath.row].percent))%"
            cell.rankingLabel.text = "\(gino(voteDetailModel?.images?[indexPath.row].rank))위"
            
            if cell.percentLabel.text == "0.0%" {
                cell.viewWidthConstraint.constant = 301
                cell.resultColorView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
            } else {
                let size = 239 * 0.01 * (voteDetailModel?.images?[indexPath.row].percent)! + 62
                cell.viewWidthConstraint.constant = CGFloat(size)
                
                // 1위 이미지일 경우
                if firstRankSet.contains(indexPath.row) {
                    // 작성자 원픽이 1위 or 투표자 투표 이미지가 1위
                    if (loginUserNickname == postNickname && voteDetailModel?.onePickImageId == indexPath.row) || (loginUserNickname != postNickname && voteDetailModel?.votedImageId == indexPath.row) {
                        cell.resultColorView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.2862745098, blue: 0.6039215686, alpha: 0.8)
                        isFirstRank = true
                    } else { // 1위가 다르면
                        cell.resultColorView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.4745098039, blue: 0.2352941176, alpha: 0.8)
                        isFirstRank = false
                    }
                } else { // 그 외
                    cell.resultColorView.backgroundColor = #colorLiteral(red: 0.2, green: 0.8, blue: 0.5490196078, alpha: 0.8)
                }
            }
            
            // Pick View에서 투표시 바로 피드백 퍼센트가 반영되지 않기 때문에 투표 완료후 한 번 setupResultViewPercent 호출
            if isFirstSetUpResultPercent {
                setupResultViewPercent()
                isFirstSetUpResultPercent = false
            }
            
        } else { // 투표 선택 화면
            if isPicked {
                // 선택한 이미지 핑크 뷰
                if indexPath.item == selectedImageId {
                    cell.viewWidthConstraint.constant = 301 // 300 말고 301로 해야 모서리가 꽉 채워짐
                    cell.diamondsImageView.isHidden = false
                } else { // 나머지 이미지는 그대로
                    cell.viewWidthConstraint.constant = 0
                    cell.diamondsImageView.isHidden = true
                }
            }
        }
        
        cell.detailPhotoImageView.kf.setImage(with: URL(string: (voteDetailModel?.images![indexPath.row].imageUrl)!), placeholder: #imageLiteral(resourceName: "defalutImage"))
        
        DispatchQueue.main.async {
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
        }
        
        return cell
    }
}

// MARK: - Collection View Delegate
typealias CarouselDelegate = VoteDetailViewController

extension VoteDetailViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        isPicked = true
        selectedImageId = indexPath.row
        pickButton.setImage(#imageLiteral(resourceName: "pickButtonNormal"), for: .normal)
        carouselCollectionView.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        carouselCollectionView.didScroll()
        
        guard let currentCenterIndex = carouselCollectionView.currentCenterCellIndex?.row else { return }
        currentPage = currentCenterIndex
        detailPageLabel.text = String(describing: currentPage + 1)
        // detailPageLabel.text = "\(String(describing: currentCenterIndex)) / \(String(describing: dataSource.data.value[0].images?.count))"
        
        detailPageControl.currentPage = currentPage
        
        if !isVoted {
            // 투표 시작 뷰
            if isPicked { // 이미지 선택 됨
                if currentPage != selectedImageId { // 선택된 이미지일 경우
                    pickButton.setImage(#imageLiteral(resourceName: "pickButtonDisabled"), for: .normal)
                } else { // 선택안된 이미지일 경우
                    pickButton.setImage(#imageLiteral(resourceName: "pickButtonNormal"), for: .normal)
                }
            }
        } else { // pick 선택 후
            setupResultViewPercent()
        }
    }
}

// MARK: - Collection View Delegate Flow Layout
private typealias ScalingCarouselFlowDelegate = VoteDetailViewController

extension ScalingCarouselFlowDelegate: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
}

// MARK: - Helpers
extension VoteDetailViewController: AlertViewActionDelegate {
    
    // MARK: - Set Up View
    
    private func setupView() {
        
        // Page Control
        detailPageControl.numberOfPages = voteDetailModel?.images?.count ?? 0
        detailPageControl.currentPage = 0
        
        detailNicknameLabel.text = postNickname
        detailProfileImageView.kf.setImage(with: URL(string: postProfileUrl!), placeholder: #imageLiteral(resourceName: "profilePink"))
        // detailTitleLabel.text = dataSource.data.value[0].title
        // detailParticipantsLabel.text = String(dataSource.data.value[0].participantsNum!)
        // Timer 설정
        
        if loginUserNickname == postNickname { // 1. 투표 작성자인 경우 - Feedback View + 원픽 이미지
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
    
    // MARK: - Set Up Result View(Feedback View)
    
    private func setupResultView(isVoted: Bool) {
        pickView.isHidden = true
        feedbackView.isHidden = false
        
        if isVoted {
            skipButton.setImage(#imageLiteral(resourceName: "onePickButton"), for: .normal)
            skipButton.setImage(#imageLiteral(resourceName: "onePickButtonDisabled"), for: .highlighted)
            skipButton.setTitle("", for: .normal)
            skipButton.tag = 7
            onePickLabel.text = "내 원픽!"
            onePickLabel.textColor = .textColor(.text91)
            
            sensitivityResultView.isHidden = false
            compositionResultView.isHidden = false
            lightResultView.isHidden = false
            colorResultView.isHidden = false
            
            sensitivityPercentLabel.isHidden = false
            compositionPercentLabel.isHidden = false
            lightPercentLabel.isHidden = false
            colorPercentLabel.isHidden = false
        }
        
    }
    
    // MARK: - Set Up Result View Percent
    
    private func setupResultViewPercent() {
        // 투표 결과 뷰
        sensitivityPercentLabel.text = "\(gdno(voteDetailModel?.images?[currentPage].sensitivityPercent))%"
        compositionPercentLabel.text = "\(gdno(voteDetailModel?.images?[currentPage].compositionPercent))%"
        lightPercentLabel.text = "\(gdno(voteDetailModel?.images?[currentPage].lightPercent))%"
        colorPercentLabel.text = "\(gdno(voteDetailModel?.images?[currentPage].colorPercent))%"
        
        // 감성
        if sensitivityPercentLabel.text == "0.0%" { // 0%
            sensitivityResultView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
            sensitivityHeightConstraint.constant = 48
        } else {
            if firstRankSet.contains(currentPage) && isFirstRank { // 1위 = 원픽 or 투표이미지
                sensitivityResultView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.2862745098, blue: 0.6039215686, alpha: 0.8)
            } else if firstRankSet.contains(currentPage) && !isFirstRank { // 1위 != 원픽 or 투표이미지
                sensitivityResultView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.4745098039, blue: 0.2352941176, alpha: 0.8)
            } else { // 그 외
                sensitivityResultView.backgroundColor = #colorLiteral(red: 0.2, green: 0.8, blue: 0.5490196078, alpha: 0.8)
            }
            
            // 뷰 사이즈 조정
            let size = 44 * 0.01 * (voteDetailModel?.images?[currentPage].sensitivityPercent)! + 4
            sensitivityHeightConstraint.constant = CGFloat(size)
        }
        
        // 구도
        if compositionPercentLabel.text == "0.0%" {
            compositionResultView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
            compositionHeightConstraint.constant = 48
        } else {
            if firstRankSet.contains(currentPage) && isFirstRank {
                compositionResultView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.2862745098, blue: 0.6039215686, alpha: 0.8)
            } else if firstRankSet.contains(currentPage) && !isFirstRank {
                compositionResultView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.4745098039, blue: 0.2352941176, alpha: 0.8)
            } else {
                compositionResultView.backgroundColor = #colorLiteral(red: 0.2, green: 0.8, blue: 0.5490196078, alpha: 0.8)
            }
            
            let size = 44 * 0.01 * (voteDetailModel?.images?[currentPage].compositionPercent)! + 4
            compositionHeightConstraint.constant = CGFloat(size)
        }
        
        // 조명
        if lightPercentLabel.text == "0.0%" {
            lightResultView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
            lightHeightConstraint.constant = 48
        } else {
            if firstRankSet.contains(currentPage) && isFirstRank {
                lightResultView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.2862745098, blue: 0.6039215686, alpha: 0.8)
            } else if firstRankSet.contains(currentPage) && !isFirstRank {
                lightResultView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.4745098039, blue: 0.2352941176, alpha: 0.8)
            } else {
                lightResultView.backgroundColor = #colorLiteral(red: 0.2, green: 0.8, blue: 0.5490196078, alpha: 0.8)
            }
            
            let size = 44 * 0.01 * (voteDetailModel?.images?[currentPage].lightPercent)! + 4
            lightHeightConstraint.constant = CGFloat(size)
        }
        
        // 색감
        if colorPercentLabel.text == "0.0%" {
            colorResultView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
            colorHeightConstraint.constant = 48
        } else {
            if firstRankSet.contains(currentPage) && isFirstRank {
                colorResultView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.2862745098, blue: 0.6039215686, alpha: 0.8)
            } else if firstRankSet.contains(currentPage) && !isFirstRank {
                colorResultView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.4745098039, blue: 0.2352941176, alpha: 0.8)
            } else {
                colorResultView.backgroundColor = #colorLiteral(red: 0.2, green: 0.8, blue: 0.5490196078, alpha: 0.8)
            }
            
            let size = 44 * 0.01 * (voteDetailModel?.images?[currentPage].colorPercent)! + 4
            colorHeightConstraint.constant = CGFloat(size)
        }
    }
    
    // MARK: - Button Tag
    
    private func setupButtonTag() {
        if postNickname == loginUserNickname { // 투표 작성자 - 삭제하기
            rightBarButton.image = #imageLiteral(resourceName: "trashcan")
            rightBarButton.tag = 0
        } else { // 투표자 - 신고하기
            rightBarButton.image = #imageLiteral(resourceName: "megaphone")
            rightBarButton.tag = 1
        }
        
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
    
    // MARK: - Back Button Actions
    
    @objc func backButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Right Button Actions - Alert View
    
    @objc func rightButtonClicked(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            print("trash")
            
            AlertView.instance.showAlert(using: .listRemove)
            AlertView.instance.actionDelegate = self
        
        case 1:
            print("report")
            
            let alertTitle = """
                게시글에 문제가 있나요?
                신고를 하면 더 이상 게시글이 안보여요.
                """
            AlertView.instance.showAlert(using: .report)
            AlertView.instance.actionDelegate = self
            
//            AlertView.instance.showAlert(
//                title: alertTitle, denyButtonTitle: "아니요", doneButtonTitle: "신고하기", image: #imageLiteral(resourceName: "report"), alertType: .report)
        default:
            print("error")
        }
    }
    
    // MARK: - Vote Alert View Delegate
    
    func deleteButtonTapped() {
        // 게시물 삭제 서버 통신 
        viewModel.fetchDeletePost(postId: postId!)
    }
    
    // MARK: - Pick Button Actions
    
    @objc func pickButtonClicked(_ sender: UIButton) {
        print("pickButton")
        
        setupResultView(isVoted: false)
        
        //        let indexPath = IndexPath(item: currentPage, section: 0)
        //        carouselCollectionView.reloadItems(at: [indexPath])
    }
    
    // MARK: - Feedback Button Actions
    
    @objc func feedbackButtonClicked(_ sender: UIButton) {
        
        if !isVoted {
            var feedback = ""
            switch sender.tag {
            case 2:
                print("sensitivityButton")
                feedback = "sensitivity"
            case 3:
                print("compositionButton")
                feedback = "composition"
            case 4:
                print("lightButton")
                feedback = "light"
            case 5:
                print("colorButton")
                feedback = "color"
            case 6:
                print("skipButton")
                feedback = "skip"
            default:
                print("error")
            }
            
            /*
             let allButtonTags = [2, 3, 4, 5, 6]
             let currentButtonTag = sender.tag
             
             allButtonTags.filter { $0 != currentButtonTag }.forEach { tag in
             if let button = self.view.viewWithTag(tag) as? UIButton {
             // Deselect/Disable these buttons
             
             if tag == 6 {
             skipButton.setTitleColor(#colorLiteral(red: 0.2156862745, green: 0.2352941176, blue: 0.2588235294, alpha: 1), for: .normal)
             }
             
             button.isSelected = false
             }
             }
             
             if currentButtonTag == 6 {
             skipButton.setTitleColor(#colorLiteral(red: 0.9215686275, green: 0.2862745098, blue: 0.6039215686, alpha: 1), for: .normal)
             }
             
             sender.backgroundColor = #colorLiteral(red: 0.9385799486, green: 0.1098039216, blue: 0.1215686275, alpha: 1)
             sender.borderWidth = 2
             sender.borderColor = #colorLiteral(red: 0.9215686275, green: 0.2862745098, blue: 0.6039215686, alpha: 1)
             sender.cornerRadiusLayer = 10
             
             sender.isSelected = !sender.isSelected
             */
            
            // 투표 생성 서버 통신
            viewModel.fetchCreatePost(postId: postId!, imageId: String(currentPage), category: feedback)
            
            isVoted = true
            setupResultView(isVoted: true)
            voteDetailModel?.votedImageId = currentPage
            isFirstSetUpResultPercent = true
            carouselCollectionView.reloadData()
        } else {
            if sender.tag == 7 {
                print("onePickButton")
                
                if postNickname == loginUserNickname { // 투표 작성자 - 원픽 이미지로 이동
                    carouselCollectionView.scrollToItem(at: IndexPath(row: voteDetailModel?.onePickImageId ?? 0, section: 0), at: .top, animated: true)
                } else { // 투표자 - 투표한 이미지로 이동
                    carouselCollectionView.scrollToItem(at: IndexPath(row: voteDetailModel?.votedImageId ?? 0, section: 0), at: .top, animated: true)
                }
            }
        }
        
    }
    
}

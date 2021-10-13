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
    @IBOutlet weak var detailClockImageView: UIImageView!
    
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
    
    // Feedback Button Label
    @IBOutlet weak var sensitivityLabel: UILabel!
    @IBOutlet weak var compositionLabel: UILabel!
    @IBOutlet weak var lightLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    
    // Feedback View Array
    var buttonArray = [UIButton]()
    var percentLabelArray = [UILabel]()
    var resultViewArray = [UIView]()
    var heightConstraintArray = [NSLayoutConstraint]()
    var buttonLabelArray = [UILabel]()
    
    // Delete View
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var deleteImageView: UIImageView!
    @IBOutlet weak var deleteLabel: UILabel!
    
    // MARK: - Properties
    
    var isSelect: Bool = false // didSelectItemAt으로 이미지 선택이 되었는지 판별할 Bool 값 - true라면 선택함
    var selectedImageId: String? // 선택된 이미지의 ID 값
    var selectImageIndex: Int? // 선택된 이미지의 컬렉션뷰 상의 IndexPath.row 값
    
    var firstRankSet: Set<Int> = [] // 1위 이미지 인덱스 값들 저장
    var isFirstRank: Bool = false // 1위 이미지가 원픽 이미지 or 투표한 이미지일 경우 true
    var firstRankColor = #colorLiteral(red: 0.9411764706, green: 0.4745098039, blue: 0.2352941176, alpha: 0.8)
    
    var currentPage: Int = 0 // 현재 중앙에 보이는 컬렉션뷰 이미지의 IndexPath.row 값
    
    var isPick: Bool = false // pick 버튼 클릭한 경우만 피드백 뷰를 보여주기 위한 Bool 값 - true면 Feedback View 보여줌
    var isPickStart: Bool = false // Pick View에서 이미지 선택한 경우만 투표하기 통신을 하게 하기위한 Bool 값
    
    var isFirst: Bool = true // 제일 처음 뷰가 로드되면 데이터가 무조건 없는 상태로 빠졌다가 로드되기 때문에 Flag 처리
    
    var isDeadline: Bool = false
    
    // View Model
    lazy var viewModel: VoteDetailViewModel = {
        let viewModel = VoteDetailViewModel(service: VoteDetailService())
        return viewModel
    }()
    
    var postId: String! // 메인에서 받아오는 게시글 아이디 값
    
    let loginUserNickname = LoginUser.shared.userNickname! // 로그인 유저 아이디
    var isSameNickname: Bool = false // 로그인 유저와 게시글 작성자가 일치하는지 판별
    
    var voteResultModel: [VoteResultModel] = [] // 투표 결과 값 담을 배열
    
    // MARK: - Timer
    
    var timer: Timer?
    var dateHelper = DateHelper()
    let currentDate = Date()
    var remainSeconds: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        setConfiguration()
        setupButton()
        createTimer()
        
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let deviceType = UIDevice().type
        
        print("* Running on: \(deviceType)")
        
        switch deviceType {
        case .iPhone6, .iPhone7, .iPhone8, .iPhoneSE, .iPhoneSE2: self.tabBarController?.tabBar.isHidden = true
        default: break
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 투표 삭제 후 메인으로 갈 경우 
        if !deleteView.isHidden {
            NotificationCenter.default.post(name: .backToMain, object: nil)
        }
    }
    
    // MARK: - Bind View Model
    
    private func bindViewModel() {
        ActivityView.instance.start(controller: self) // 인디케이터 시작
        
        viewModel.voteDetailModel.bindAndFire { (response) in
            
            // 제일 처음 뷰가 로드되면 데이터가 무조건 없는 상태로 빠졌다가 로드되기 때문에 isFirst로 한 번 예외처리
            if self.isFirst {
                self.isFirst = false
                return
            }
            
                self.detailNicknameLabel.text = response.postNickname
                self.detailProfileImageView.image = UIImage.profileImage(response.postProfileUrl)
                self.detailParticipantsLabel.text = "\(response.participantsNum)명 참여중"
                self.detailPageLabel.text = "\(self.currentPage + 1)/\(response.images.count)"
                self.detailTitleLabel.text = response.title
                self.detailTitleLabel.lineBreakMode = .byCharWrapping
                
                // 기기별 타이틀 사이즈 조절
                self.detailTitleLabel.minimumScaleFactor = 10 / UIFont.labelFontSize
                self.detailTitleLabel.adjustsFontSizeToFitWidth = true
                
                // 타이머 설정
                let endDate = self.dateHelper.stringToDate(dateString: response.deadline!)
                self.remainSeconds = self.dateHelper.getTimer(startDate: self.currentDate, endDate: endDate!)
                self.updateTimer()
                
                self.detailPageControl.numberOfPages = response.images.count
                
                // 로그인 유저 = 투표 게시자
                if self.loginUserNickname == response.postNickname {
                    self.isSameNickname = true
                }
                
                // Navigation Right Bar Button 사용자별 초기화
                if self.isSameNickname { // 투표 작성자 -> 삭제하기
                    self.rightBarButton.image = #imageLiteral(resourceName: "trashcan")
                    self.rightBarButton.tag = 0
                } else { // 투표자 -> 신고하기
                    self.rightBarButton.image = #imageLiteral(resourceName: "megaphone")
                    self.rightBarButton.tag = 1
                }
                
                // 투표 게시자 or 투표한 사용자의 경우 - 결과 값 구하기
                if self.isSameNickname || response.isVoted || self.isDeadline {
                    // 투표 이미지 별 결과를 담을 배열 초기화
                    self.voteResultModel = Array(repeating: VoteResultModel(percent: 0.0, rank: 0, sensitivityPercent: 0.0, compositionPercent: 0.0, lightPercent: 0.0, colorPercent: 0.0), count: self.viewModel.voteDetailModel.value.images.count)
                    
                    // 결과 값 계산
                    self.getVoteResult()
                }
                
                self.setupView() // 결과값 계산 후 Feedback View 퍼센트 초기화 해야함
      
                self.carouselCollectionView.reloadData()
        }
     
        // 게시글 상세 조회 서버 통신
        // viewModel.fetchVoteDetail(postId: postId)
        
        // 투표가 삭제된 경우
        viewModel.fetchVoteDetail(postId: postId) { result in
            if result == "networkERR" {
                self.rightBarButton.isEnabled = false
                self.deleteView.isHidden = false
                self.deleteImageView.image = #imageLiteral(resourceName: "hmm")
                self.deleteLabel.text = "게시글이 삭제되어 볼 수 없어요.\n다시 돌아가주세요."
            }
        }
    }
}

// MARK: - Collection View Data Source

typealias CarouselDatasource = VoteDetailViewController

extension CarouselDatasource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.voteDetailModel.value.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: VoteDetailCollectionViewCell = collectionView.dequeueCollectionCell(for: indexPath)
        
        cell.mainView.backgroundColor = .black
        cell.cornerRadius = 10
        
        let object = self.viewModel.voteDetailModel.value
        
        // 1. 투표 게시자 & 2-2. 투표한 사용자 & 마감된 투표일 경우-> 투표 결과 화면 Feedback View
        if isSameNickname || object.isVoted || isDeadline {
            
            // 선택 이미지 효과(핑크 다이아몬드) 해제
            cell.viewWidthConstraint.constant = 0
            cell.diamondsImageView.isHidden = true
            
            // Result View 활성화 및 값 적용
            cell.resultView.isHidden = false
            cell.pickedNumLabel.text = "\(object.images[indexPath.row].pickedNum)명"
            cell.percentLabel.text = "\(voteResultModel[indexPath.row].percent)%"
            cell.rankingLabel.text = "\(voteResultModel[indexPath.row].rank)위"
            
            if cell.percentLabel.text == "0.0%" { // 0%
                cell.viewWidthConstraint.constant = 299
                cell.resultColorView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
            } else { // 그 이외의 퍼센트
                let size = 239 * 0.01 * (voteResultModel[indexPath.row].percent) + 60
                cell.viewWidthConstraint.constant = CGFloat(size)
                
                // 각 사용자별 1,2,3위 이미지일 경우
                if firstRankSet.contains(indexPath.row) {
                    cell.resultColorView.backgroundColor = firstRankColor
                } else {
                    cell.resultColorView.backgroundColor = #colorLiteral(red: 0.2, green: 0.8, blue: 0.5490196078, alpha: 0.8)
                }
            }
        } else { // 2-1. 마감되지 않고, 투표 안한 사용자 -> 투표 선택 화면 Pick View
//            if isSelect {
//                // 투표는 안했지만 선택한 이미지가 있는 경우 -> 핑크 다이아몬드 이미지 활성화
//                if indexPath.item == selectImageIndex {
//                    cell.viewWidthConstraint.constant = 299
//                    cell.diamondsImageView.isHidden = false
//                } else { // 나머지 이미지는 그대로
//                    cell.viewWidthConstraint.constant = 0
//                    cell.diamondsImageView.isHidden = true
//                }
//            }
            
            if isSelect { // 2-1. 마감되지 않고, 투표 안한 사용자 -> 투표 선택 화면 Pick View
                // 투표는 안했지만 선택한 이미지가 있는 경우 -> 핑크 다이아몬드 이미지 활성화
                if indexPath.item == selectImageIndex {
                    cell.viewWidthConstraint.constant = 299
                    cell.diamondsImageView.isHidden = false
                } else { // 나머지 이미지는 그대로
                    cell.viewWidthConstraint.constant = 0
                    cell.diamondsImageView.isHidden = true
                }
            } else {
                cell.viewWidthConstraint.constant = 0
                cell.diamondsImageView.isHidden = true
            }
        }
        
        cell.detailPhotoImageView.kf.setImage(with: URL(string: (object.images[indexPath.row].imageUrl)), placeholder: #imageLiteral(resourceName: "defalutImage"))
        
        DispatchQueue.main.async {
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
        }
        
        ActivityView.instance.stop() // 인디케이터 중지
        
        return cell
    }
}

// MARK: - Collection View Delegate

typealias CarouselDelegate = VoteDetailViewController

extension VoteDetailViewController: UICollectionViewDelegate {
    
    // MARK: - Did Select Item At
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        isSelect = true
//        selectImageIndex = indexPath.row
//        selectedImageId = viewModel.voteDetailModel.value.images[indexPath.row].imageId
//        pickButton.setImage(#imageLiteral(resourceName: "pickButtonNormal"), for: .normal)
//        carouselCollectionView.reloadData() // 컬렉션 뷰 업데이트 해줘야지 반영됨
        
        if !isSelect { // 투표 사진을 선택하지 않은 경우
            initPickView(index: indexPath.row)
            carouselCollectionView.reloadData() // 컬렉션 뷰 업데이트 해줘야지 반영됨
        } else { // 이미 투표한 사진을 다시 선택한 경우
            if selectImageIndex == indexPath.row {
                isSelect = false
                pickButton.setImage(#imageLiteral(resourceName: "pickButtonDisabled"), for: .normal)
                carouselCollectionView.reloadData()
            } else { // 투표한 상태에서 다른 사진을 선택한 경우
                initPickView(index: indexPath.row)
            }
        }
    }
    
    func initPickView(index: Int) {
        isSelect = true // 선택했다고 true 변경 후 관련 인덱스 저장 및 픽 버튼 활성화
        selectImageIndex = index
        selectedImageId = viewModel.voteDetailModel.value.images[index].imageId
        pickButton.setImage(#imageLiteral(resourceName: "pickButtonNormal"), for: .normal)
        carouselCollectionView.reloadData() // 컬렉션 뷰 업데이트 해줘야지 반영됨
    }
    
    // MARK: - Scroll View Did Scroll
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        carouselCollectionView.didScroll()
        
        guard let currentCenterIndex = carouselCollectionView.currentCenterCellIndex?.row else { return }
        currentPage = currentCenterIndex // 현재 보이는 컬렉션뷰 이미지 인덱스
        
        // Page Label, Page Control 설정
        detailPageLabel.text = "\(String(describing: currentPage + 1)) / \(String(describing: viewModel.voteDetailModel.value.images.count))"
        detailPageControl.currentPage = currentPage
        
        // 투표하지 않고 마감되지 않은 경우 (Pick View) -> 투표 이미지 선택해야 함
        if !isSameNickname && !viewModel.voteDetailModel.value.isVoted && !isDeadline {
            if isSelect { // 선택한 이미지가 있을 경우
                if currentPage == selectImageIndex { // 현재 이미지 인덱스 = 선택된 이미지 인덱스
                    if !isPick {
                        pickButton.setImage(#imageLiteral(resourceName: "pickButtonNormal"), for: .normal) // Pick Button 활성화
                    } else {
                        setupResultView(isPicked: true, isVoted: false)
                    }
                } else { // 현재 이미지 인덱스 != 선택된 이미지 인덱스
                    pickButton.setImage(#imageLiteral(resourceName: "pickButtonDisabled"), for: .normal)
                    setupResultView(isPicked: false, isVoted: false)
                }
            }
        } else { // 투표한 경우 (Feedback View)
            // 현재 이미지 인덱스에 따른 결과값 보여줌
            setupResultViewPercent(currentPage: currentPage)
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
        detailPageControl.currentPage = 0
        detailPageControl.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        
        // 1. 투표 작성자인 경우 -> Feedback View + 원픽 버튼(원픽 이미지)
        if isSameNickname {
            isPickStart = false
            setupResultView(isPicked: true, isVoted: true)
        } else { // 2. 투표 작성자가 아닐 경우
            if !viewModel.voteDetailModel.value.isVoted && !isDeadline { // 2-1. 마감되지 않은 투표이고, 투표하지 않은 사용자 -> Pick View
                isPickStart = true
                setupResultView(isPicked: false, isVoted: false)
            } else { // 2-2. 투표한 사용자 -> Feedback View + 원픽 버튼(투표 이미지)
                isPickStart = false
                setupResultView(isPicked: true, isVoted: true)
            }
        }
    }
    
    // MARK: - Set Up Result View (Feedback View)
    
    private func setupResultView(isPicked: Bool, isVoted: Bool) {
        if isPicked { // Current Page가 픽버튼 누른 선택된 이미지의 페이지라면 -> Feedback View 보여줌
            pickView.isHidden = true
            feedbackView.isHidden = false
        } else { // Current Page가 픽버튼을 누르지 않은 이미지의 페이지라면 -> Pick View 보여줌
            pickView.isHidden = false
            feedbackView.isHidden = true
        }
        
        if isSameNickname || isVoted { // 투표 작성자이거나 투표를 한 상태 -> 스킵 버튼이 원픽 버튼이어야 함
            // Skip Button -> One Pick Button
            skipButton.setImage(#imageLiteral(resourceName: "onePickButton"), for: .normal)
            skipButton.setImage(#imageLiteral(resourceName: "onePickButtonDisabled"), for: .highlighted)
            skipButton.setTitle("", for: .normal)
            
            skipButton.tag = 17
            onePickLabel.text = "내 원픽!"
            onePickLabel.textColor = .textColor(.text91)
            
            setupResultViewPercent(currentPage: currentPage) // 처음 보여줄 이미지의 피드백뷰 퍼센트 값 설정
        }
    }
    
    // MARK: - Set Up Result View Percent (Feedback View)
    
    private func setupResultViewPercent(currentPage: Int) {
        let percentArray = [voteResultModel[currentPage].sensitivityPercent,
                            voteResultModel[currentPage].compositionPercent,
                            voteResultModel[currentPage].lightPercent,
                            voteResultModel[currentPage].colorPercent]
        
        for index in 0..<resultViewArray.count {
            percentLabelArray[index].isHidden = false
            resultViewArray[index].isHidden = false
            
            // Feedback View - Percent Label 설정
            percentLabelArray[index].text = "\(percentArray[index])%"
            
            // Feedback View - Result View Color 설정
            if percentLabelArray[index].text == "0.0%" {
                resultViewArray[index].backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
                heightConstraintArray[index].constant = 48
            } else {
                if firstRankSet.contains(currentPage) {
                    resultViewArray[index].backgroundColor = firstRankColor
                } else {
                    resultViewArray[index].backgroundColor = #colorLiteral(red: 0.2, green: 0.8, blue: 0.5490196078, alpha: 0.8)
                }
                
                // Feedback View - Height Constraint 설정
                let size = 44 * 0.01 * (percentArray[index]) + 4
                heightConstraintArray[index].constant = CGFloat(size)
            }
        }
    }
    
    // MARK: - Set Configuration
    
    override func setConfiguration() {
        buttonArray = [sensitivityButton, compositionButton, lightButton, colorButton, skipButton]
        percentLabelArray = [sensitivityPercentLabel, compositionPercentLabel, lightPercentLabel, colorPercentLabel]
        resultViewArray = [sensitivityResultView, compositionResultView, lightResultView, colorResultView]
        heightConstraintArray = [sensitivityHeightConstraint, compositionHeightConstraint, lightHeightConstraint, colorHeightConstraint]
        buttonLabelArray = [sensitivityLabel, compositionLabel, lightLabel, colorLabel]
    }
    
    // MARK: - Button Tags
    
    private func setupButton() {
        
        // 다양한 방식으로 Button Action 적용
        rightBarButton.action = #selector(rightButtonClicked(_:))
        rightBarButton.target = self
        
        // Back Button
        backButton.action = #selector(backButtonClicked(_:))
        backButton.target = self
        
        // Pick Button
        pickButton.addTarget(self, action: #selector(pickButtonClicked), for: .touchUpInside)
        
        // Feedback Button
        for button in buttonArray {
            button.addTarget(self, action: #selector(feedbackButtonClicked), for: UIControl.Event.touchUpInside)
        }
    }
    
    // MARK: - Back Button Action
    
    @objc func backButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Pick Button Action
    
    @objc func pickButtonClicked(_ sender: UIButton) {
        // 이미지를 선택했고, 현재 이미지와 선택한 이미지가 같을 경우에만 버튼 누르기 가능
        if isSelect && currentPage == selectImageIndex {
            isPick = true
            setupResultView(isPicked: true, isVoted: false) // 투표는 되지 않은 상태로 Feedback View 보여줌
        }
    }
    
    // MARK: - Feedback Button Action
    
    @objc func feedbackButtonClicked(_ sender: UIButton) {
        // 투표 안 했을 때만 투표 생성 서버 통신 - Pick View에서 투표해서 온 경우만 통신 가능
        if isPickStart {
            isPickStart = false
            
            let feedbackDictionary: [Int: String] = [11: "emotion", 12: "composition", 13: "light", 14: "color", 15: "skip"]
            
            let buttonDictionary: [Int: Int] = [11: 0, 12: 1, 13: 2, 14: 3]
            
            let category = feedbackDictionary[sender.tag]!
            
            // 투표 생성
            viewModel.service?.createVote(postId: postId, imageId: selectedImageId!, category: category, completion: {
                let currentButtonTag = sender.tag
                
                feedbackDictionary.keys.filter { $0 != currentButtonTag }.forEach { tag in
                    if let button = self.view.viewWithTag(tag) as? UIButton {
                        
                        // Skip 버튼 비활성화
                        if tag == 15 {
                            self.skipButton.setTitleColor(#colorLiteral(red: 0.2156862745, green: 0.2352941176, blue: 0.2588235294, alpha: 1), for: .normal)
                        } else { // 그 이외의 버튼 비활성화
                            self.resultViewArray[buttonDictionary[tag] ?? 0].isHidden = false
                            self.heightConstraintArray[buttonDictionary[tag] ?? 0].constant = 48
                            self.resultViewArray[buttonDictionary[tag] ?? 0].backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
                            self.buttonLabelArray[buttonDictionary[tag] ?? 0].textColor = #colorLiteral(red: 0.3607843137, green: 0.3607843137, blue: 0.3647058824, alpha: 1)
                        }
                        
                        button.isSelected = false
                    }
                }
                
                // Skip 버튼을 누른 경우 - Skip 버튼 활성화
                if currentButtonTag == 15 {
                    self.skipButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
                }
                
                // 그 이외의 버튼 활성화
                sender.borderWidth = 2
                sender.borderColor = #colorLiteral(red: 0.9215686275, green: 0.2862745098, blue: 0.6039215686, alpha: 1)
                sender.cornerRadiusLayer = 10
                sender.isSelected = !sender.isSelected
                
                let time = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: time) {
                    Toast.show(using: .voteComplete, controller: self)
                    sender.borderWidth = 0
                    self.pickView.isHidden = true // 결과 뷰 나오기 전에 처리를 위해 여기서 hidden
                    self.bindViewModel()
                }
            })
        }
        
        // One Pick Button Clicked
        if sender.tag == 17 {
            // 투표 작성자일 경우 -> 원픽 이미지 인덱스로 이동
            if isSameNickname {
                carouselCollectionView.scrollToItem(at: IndexPath(row: viewModel.voteDetailModel.value.onePickImageId, section: 0), at: .top, animated: true)
            } else { // 투표자일 경우
                if viewModel.voteDetailModel.value.isVoted { // 투표한 경우 - 투표한 이미지 인덱스로 이동
                    carouselCollectionView.scrollToItem(at: IndexPath(row: viewModel.voteDetailModel.value.votedImageId, section: 0), at: .top, animated: true)
                } else {
//                    // 투표하지 않은 경우 - 투표 작성자 원픽 이미지 인덱스로 이동
//                    carouselCollectionView.scrollToItem(at: IndexPath(row: viewModel.voteDetailModel.value.onePickImageId, section: 0), at: .top, animated: true)
                }
            }
        }
    }
    
    // MARK: - Navigation Right Button Action - Alert View
    
    @objc func rightButtonClicked(_ sender: UIButton) {
        switch sender.tag {
        case 0: // 삭제하기
            AlertView.instance.showAlert(using: .listRemove)
            AlertView.instance.actionDelegate = self
        case 1: // 신고하기
            AlertView.instance.showAlert(using: .report)
            AlertView.instance.actionDelegate = self
        default: // Error
            print("Right Button Clicked Error")
        }
    }
    
    // MARK: - Alert View Action
    
    func listRemoveTapped() {
        viewModel.service?.deletePost(postId: postId, completion: {
            // self.navigationController?.popViewController(animated: true)
            
            let time = DispatchTime.now() + 0.5
            DispatchQueue.main.asyncAfter(deadline: time) {
                self.deleteView.isHidden = false
                self.rightBarButton.isEnabled = false
                Toast.show(using: .remove, controller: self)
            }
        })
    }
    
    func reportTapped() {
        Toast.show(using: .report, controller: self)
    }
    
}

// MARK: - Get Vote Result

extension VoteDetailViewController {
    
    func getVoteResult() {
        // 전체 투표 결과 값 구하기
        let object = viewModel.voteDetailModel.value
        
        let participantsNum = object.participantsNum
        let count = object.images.count
        
        var pickedNums = [Int](repeating: 0, count: count)
        var percents = [Double](repeating: 0, count: count)
        
        // 피드백 퍼센트 구하기
        for index in 0..<count {
            let sensitivityCount = object.images[index].emotion
            let compositionCount = object.images[index].composition
            let lightCount = object.images[index].light
            let colorCount = object.images[index].color
            let skipCount = object.images[index].skip
            
            let total = sensitivityCount + compositionCount + lightCount + colorCount + skipCount
            
            if total == 0 { // total이 0일 경우 -> 0 / 0 = nan이니 예외처리
                voteResultModel[index].sensitivityPercent = 0.0
                voteResultModel[index].compositionPercent = 0.0
                voteResultModel[index].lightPercent = 0.0
                voteResultModel[index].colorPercent = 0.0
            } else {
                voteResultModel[index].sensitivityPercent = round((Double(sensitivityCount) / Double(total) * 100) * 10) / 10
                voteResultModel[index].compositionPercent = round((Double(compositionCount) / Double(total) * 100) * 10) / 10
                voteResultModel[index].lightPercent = round((Double(lightCount) / Double(total) * 100) * 10) / 10
                voteResultModel[index].colorPercent = round((Double(colorCount) / Double(total) * 100) * 10) / 10
            }
            
            // 이미지 퍼센트 구하기
            pickedNums[index] = object.images[index].pickedNum
            
            if pickedNums[index] == 0 { // 투표한 인원이 0일 경우 -> 0 / 0 = nan이니 예외처리
                voteResultModel[index].percent = 0.0
            } else {
                percents[index] = round((Double(pickedNums[index]) / Double(participantsNum) * 100) * 10) / 10
                voteResultModel[index].percent = percents[index]
            }
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
        var rankPickedNum = object.images[sortedDitionary[0].key].pickedNum
        voteResultModel[sortedDitionary[0].key].rank = rank
        firstRankSet.insert(sortedDitionary[0].key)
        
        for index in 1..<sortedDitionary.count {
            
            // 이전 퍼센트와 동일할 경우 공동 순위
            if object.images[sortedDitionary[index].key].pickedNum == rankPickedNum {
                voteResultModel[sortedDitionary[index].key].rank = rank
                //                if rank == 1 { // 공동 1위라면 1위 Set에 추가
                //                    firstRankSet.insert(sortedDitionary[index].key)
                //                }
            } else { // 다르면 다음 순위
                rank += 1
                voteResultModel[sortedDitionary[index].key].rank = rank
                rankPickedNum = object.images[sortedDitionary[index].key].pickedNum
            }
            
            if isSameNickname || object.isVoted { // 투표 게시자이거나 투표한 사용자일 경우
                // 1,2,3 순위에 속한다면
                if rank == 1 || rank == 2 || rank == 3 {
                    firstRankSet.insert(sortedDitionary[index].key)
                }
            } else { // 투표를 하지 않은 사용자일 경우
                // 1순위에 속한다면
                if rank == 1 {
                    firstRankSet.insert(sortedDitionary[index].key)
                }
            }
        }
        
        if !isSameNickname && !object.isVoted { // 투표게시자가 아닌데 투표 안했으면 패스
            return
        }
        
        // 1,2,3위 색 판별을 위한 기준 인덱스 - 투표 게시자일 경우 firstPickIndex / 투표자일 경우 votedImageIndex
        let compareIndex = isSameNickname ? object.onePickImageId : object.votedImageId
        
        if firstRankSet.contains(compareIndex) { // 1,2,3 순위 안에 있을 경우 핑크
            firstRankColor = #colorLiteral(red: 0.9215686275, green: 0.2862745098, blue: 0.6039215686, alpha: 0.8)
        }
    }
}

// MARK: - Timer

extension VoteDetailViewController {
    
    // 타이머 생성
    func createTimer() {
        if timer == nil {
            let timer = Timer(timeInterval: 1.0,
                              target: self,
                              selector: #selector(updateTimer),
                              userInfo: nil,
                              repeats: true)
            RunLoop.current.add(timer, forMode: .common)
            timer.tolerance = 0.1
            
            self.timer = timer
        }
    }
    
    // 타이머 삭제
    func cancelTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // 1초 씩 업데이트
    @objc func updateTimer() {
        remainSeconds -= 1
        self.detailClockImageView.isHidden = false
        self.detailDeadlineLabel.text = self.dateHelper.timerString(remainSeconds: remainSeconds)
        
        // 마감시간이 지닌 경우
        if remainSeconds <= 0 {
            isDeadline = true
            self.detailDeadlineLabel.text = "마감된 투표에요"
            self.detailClockImageView.isHidden = true
            self.detailTitleLabel.textColor = .textColor(.text50)
            cancelTimer()
        }
    }
}

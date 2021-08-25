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
    
    // Feedback View Array
    var buttonArray = [UIButton]()
    var percentLabelArray = [UILabel]()
    var resultViewArray = [UIView]()
    var heightConstraintArray = [NSLayoutConstraint]()
    
    // MARK: - Properties
    
    var selectedImageId: String? // 실제 선택된 이미지의 ID 값
    var firstRankSet: Set<Int> = [] // 1위 이미지 인덱스 값 저장
    var isFirstRank: Bool = false // 1위 이미지가 원픽 이미지 or 투표한 이미지일 경우 true
    
    var currentPage: Int = 0 // 현재 중앙에 보이는 컬렉션뷰 이미지의 IndexPath.row 값
    var isSelect: Bool = false // didSelectItemAt으로 이미지 선택이 되었는지 판별할 Bool 값 - true라면 선택함
    var selectImageIndex: Int? // 선택된 이미지의 컬렉션뷰 상의 IndexPath.row 값
    var isPick: Bool = false // pick Button 클릭시 피드백 뷰를 보여주기 위한 Bool 값 - true라면 Feedback View 보여줌
    var isPickStart: Bool = false
    
    lazy var viewModel: VoteDetailViewModel = {
        let viewModel = VoteDetailViewModel(service: VoteDetailService())
        return viewModel
    }()
    
    var postId: String!
    
    let loginUserNickname = LoginUser.shared.userNickname
    var isSameNickname: Bool = false // 로그인 유저와 게시글 작성자가 일치하는지 판별
    
    var voteResultModel: [VoteResultModel] = []
    
    // MARK: - Timer
    var timer = Timer()
    
    deinit {
        timer.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setConfiguration()
        
        bindViewModel()
    }
    
    // MARK: - Bind View Model
    
    private func bindViewModel() {
        
        viewModel.voteDetailModel.bindAndFire { (response) in
            print("bind!!!!")
            
            if response.postNickname != "" {
                self.detailNicknameLabel.text = response.postNickname
                self.detailProfileImageView.kf.setImage(with: URL(string: response.postProfileUrl), placeholder: #imageLiteral(resourceName: "progressCircle"))
                self.detailParticipantsLabel.text = "\(response.participantsNum)명 참여중"
                self.detailTitleLabel.text = response.title
                self.detailPageLabel.text = "\(self.currentPage)/\(response.images.count)"
                
                // Set Deadline Timer
//                if let deadline = response.deadline {
//                    self.setTimer(endTime: deadline)
//                }
                
                self.detailPageControl.numberOfPages = response.images.count
                
                // 로그인 유저 = 투표 게시자
                if self.loginUserNickname == response.postNickname {
                    self.isSameNickname = true
                }
                
                // 투표 게시자 or 투표한 사용자의 경우 - 결과 값 구하기
                if self.isSameNickname || response.isVoted {
                    // 투표 이미지 별 결과를 담을 배열
                    self.voteResultModel = Array(repeating: VoteResultModel(percent: 0.0, rank: 0, sensitivityPercent: 0.0, compositionPercent: 0.0, lightPercent: 0.0, colorPercent: 0.0), count: self.viewModel.voteDetailModel.value.images.count)
                    
                    // 결과 값 계산
                    self.getVoteResult()
                }
                
                self.setupButton()
                self.setupView() // 결과값 계산 후 Feedback View 퍼센트 초기화 해야함
                
                self.carouselCollectionView.reloadData()
            }
        }
        
        // 게시글 상세 조회
        viewModel.fetchVoteDetail(postId: postId)
    }
    
    override func setConfiguration() {
        buttonArray = [sensitivityButton, compositionButton, lightButton, colorButton, skipButton]
        percentLabelArray = [sensitivityPercentLabel, compositionPercentLabel, lightPercentLabel, colorPercentLabel]
        resultViewArray = [sensitivityResultView, compositionResultView, lightResultView, colorResultView]
        heightConstraintArray = [sensitivityHeightConstraint, compositionHeightConstraint, lightHeightConstraint, colorHeightConstraint]
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
        
        if let scalingCell = cell as? ScalingCarouselCell {
            scalingCell.mainView.backgroundColor = .black
            scalingCell.cornerRadius = 10
        }
        
        let object = self.viewModel.voteDetailModel.value
        
        // 1. 투표 게시자 and 2-2. 투표한 사용자 -> 투표 결과 화면 Feedback View
        if isSameNickname || object.isVoted {
            // 선택 이미지 효과 해제
            cell.viewWidthConstraint.constant = 0
            cell.diamondsImageView.isHidden = true
            
            // Result View 활성화 및 값 적용
            cell.resultView.isHidden = false
            cell.pickedNumLabel.text = "\(object.images[indexPath.row].pickedNum)명"
            cell.percentLabel.text = "\(voteResultModel[indexPath.row].percent)%"
            cell.rankingLabel.text = "\(voteResultModel[indexPath.row].rank)위"
            
            if cell.percentLabel.text == "0.0%" {
                cell.viewWidthConstraint.constant = 301
                cell.resultColorView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
            } else {
                let size = 239 * 0.01 * (voteResultModel[indexPath.row].percent) + 62
                cell.viewWidthConstraint.constant = CGFloat(size)
                
                // 1위 이미지일 경우
                if firstRankSet.contains(indexPath.row) {
                    // 작성자 원픽이 1위 or 투표자 투표 이미지가 1위
                    if (isSameNickname && object.onePickImageId == indexPath.row) || (loginUserNickname != object.postNickname && object.votedImageId == indexPath.row) {
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
        } else { // 2-1. 투표 안한 사용자 -> 투표 선택 화면 Pick View
            if isSelect {
                // 투표는 안했지만 선택한 이미지가 있는 경우 -> 핑크뷰 + 다이아몬드 이미지 활성화
                if indexPath.item == selectImageIndex {
                    cell.viewWidthConstraint.constant = 301 // 300 말고 301로 해야 모서리가 꽉 채워짐
                    cell.diamondsImageView.isHidden = false
                } else { // 나머지 이미지는 그대로
                    cell.viewWidthConstraint.constant = 0
                    cell.diamondsImageView.isHidden = true
                }
            }
        }
        
        cell.detailPhotoImageView.kf.setImage(with: URL(string: (object.images[indexPath.row].imageUrl)), placeholder: #imageLiteral(resourceName: "defalutImage"))
        
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
    
    // MARK: - Did Select Item At
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        isSelect = true
        selectImageIndex = indexPath.row
        selectedImageId = viewModel.voteDetailModel.value.images[indexPath.row].imageId
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
        
        // 투표하지 않은 경우 (Pick View)
        if !viewModel.voteDetailModel.value.isVoted { // 투표를 하지 않아 이미지를 선택해야할 경우 (Pick View)
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
            print("투표 작성자인 경우")
            setupResultView(isPicked: true, isVoted: true)
        } else { // 2. 투표 작성자가 아닐 경우
            if !viewModel.voteDetailModel.value.isVoted { // 2-1. 투표하지 않은 사용자 -> Pick View
                print("사용자 투표 X")
                isPickStart = true
                setupResultView(isPicked: false, isVoted: false)
            } else { // 2-2. 투표한 사용자 -> Feedback View + 원픽 버튼(투표 이미지)
                print("사용자 투표 O")
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
                if firstRankSet.contains(currentPage) && isFirstRank { // 1위 = 원픽 or 투표이미지
                    resultViewArray[index].backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.2862745098, blue: 0.6039215686, alpha: 0.8)
                } else if firstRankSet.contains(currentPage) && !isFirstRank { // 1위 != 원픽 or 투표이미지
                    resultViewArray[index].backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.4745098039, blue: 0.2352941176, alpha: 0.8)
                } else { // 그 외
                    resultViewArray[index].backgroundColor = #colorLiteral(red: 0.2, green: 0.8, blue: 0.5490196078, alpha: 0.8)
                }
                
                // Feedback View - Height Constraint 설정
                let size = 44 * 0.01 * (percentArray[index]) + 4
                heightConstraintArray[index].constant = CGFloat(size)
            }
        }
    }
    
    // MARK: - Set Timer
    
    func setTimer(endTime: String) {
        DispatchQueue.main.async { [weak self] in
            self?.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
                
                print("endTime : \(endTime)")
                // 마감 시간 Date 형식으로 변환
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                // "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                let convertDate = dateFormatter.date(from: endTime)
                
                // 현재 시간 적용하기 - 시간 + 9시간
                let calendar = Calendar.current
                let today = Date()
                let localDate = Date(timeInterval: TimeInterval(calendar.timeZone.secondsFromGMT()), since: today)
                let localConvertDate =  Date(timeInterval: TimeInterval(calendar.timeZone.secondsFromGMT()), since: convertDate!)
                
                print("localdate : \(localDate)")
                print("localConvert : \(localConvertDate)")
                
                let elapsedTimeSeconds = Int(Date().timeIntervalSince(localConvertDate)) // 마감 시간
                let expireLimit = Int(Date().timeIntervalSince(localDate)) // 현재 시간
                
                guard elapsedTimeSeconds <= expireLimit else { // 시간 초과한 경우
                    timer.invalidate()
                    
                    self?.detailDeadlineLabel.text = "마감된 투표에요"
                    // self?.mainClockImageView.isHidden = true
                    return
                }
                
                let remainSeconds = expireLimit - elapsedTimeSeconds
                
                let hours   = Int(remainSeconds) / 3600
                let minutes = Int(remainSeconds) / 60 % 60
                let seconds = Int(remainSeconds) % 60
                
                self?.detailDeadlineLabel.text = String(format: "%02i:%02i:%02i", hours, minutes, seconds)
            }
        }
    }
    
    // MARK: - Button Tags
    
    private func setupButton() {
        
        // Navigation Right Bar Button
        if isSameNickname { // 투표 작성자 -> 삭제하기
            rightBarButton.image = #imageLiteral(resourceName: "trashcan")
            rightBarButton.tag = 0
        } else { // 투표자 -> 신고하기
            rightBarButton.image = #imageLiteral(resourceName: "megaphone")
            rightBarButton.tag = 1
        }
        
        rightBarButton.action = #selector(rightButtonClicked(_:))
        rightBarButton.target = self
        
        // Back Button
        backButton.action = #selector(backButtonClicked(_:))
        backButton.target = self
        
        // Pick Button
        pickButton.addTarget(self, action: #selector(pickButtonClicked), for: UIControl.Event.touchUpInside)
        
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
        // 투표 안 했을 때만 투표 생성 서버 통신
        if isPickStart { // Pick View에서 투표해서 온 경우만 통신 가능
            isPickStart = false
            
            let feedbackDictionary: [Int: String] = [11: "emotion", 12: "composition", 13: "light", 14: "color", 15: "skip"]
            
            let category = feedbackDictionary[sender.tag]!
            
            viewModel.service?.createVote(postId: postId, imageId: selectedImageId!, category: category, completion: {
                print("vote")
                
                self.bindViewModel()
            })
        }
        
        // One Pick Button Clicked
        if sender.tag == 17 {
            // 투표 작성자일 경우 -> 원픽 이미지로 이동
            if isSameNickname {
                print("투표 작성자 원픽 ")
                carouselCollectionView.scrollToItem(at: IndexPath(row: viewModel.voteDetailModel.value.onePickImageId, section: 0), at: .top, animated: true)
            } else { // 투표자일 경우 -> 투표한 이미지로 이동
                print("투표자 투표한 이미지 ")
                carouselCollectionView.scrollToItem(at: IndexPath(row: viewModel.voteDetailModel.value.votedImageId, section: 0), at: .top, animated: true)
            }
        }
    }
    
    // MARK: - Right Button Action - Alert View
    
    @objc func rightButtonClicked(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            AlertView.instance.showAlert(using: .listRemove)
            AlertView.instance.actionDelegate = self
        case 1:
            AlertView.instance.showAlert(using: .report)
            AlertView.instance.actionDelegate = self
        default:
            print("error")
        }
    }
    
    // MARK: - Alert View Action
    
    func listRemoveTapped() {
        viewModel.service?.deletePost(postId: postId, completion: {
            print("vote delete")
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    func reportTapped() {
        
    }
    
    // MARK: - Get Vote Result
    
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
                if rank == 1 { // 공동 1위라면 1위 Set에 추가
                    firstRankSet.insert(sortedDitionary[index].key)
                }
            } else { // 다르면 다음 순위
                rank += 1
                voteResultModel[sortedDitionary[index].key].rank = rank
                rankPickedNum = object.images[sortedDitionary[index].key].pickedNum
            }
        }
    }
    
}

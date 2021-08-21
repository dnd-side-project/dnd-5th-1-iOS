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
    
    var selectedImageId: Int?
    var currentPage: Int = 0
    var isPicked: Bool = false
    var firstRankSet: Set<Int> = []
    var isFirstRank: Bool = false
    var isFirstSetUpResultPercent: Bool = false
    
    var viewModel: VoteDetailViewModel!
    
    var postId: String!
    var postNickname: String!
    var postProfileUrl: String!
    
    let loginUserNickname = LoginUser.shared.userNickname
    
    var voteResultModel: [VoteResultModel] = []
    
    // MARK: - Timer
    var timer = Timer()
    
    deinit {
        timer.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = VoteDetailViewModel(service: VoteDetailService())
        
        bindViewModel()
    }
    
    // MARK: - Bind View Model
    
    private func bindViewModel() {
        viewModel.fetchVoteDetail(postId: postId)
        
        if let postId = postId {
            viewModel.fetchVoteDetail(postId: postId)
        }
        
        viewModel.voteDetailModel.bindAndFire { (response) in
          
            if response.deadline != "" {
                self.detailNicknameLabel.text = response.postNickname
                self.detailProfileImageView.kf.setImage(with: URL(string: response.postProfileUrl), placeholder: #imageLiteral(resourceName: "progressCircle"))
                self.detailParticipantsLabel.text = "\(response.participantsNum)명 참여중"
                self.detailDeadlineLabel.text = response.deadline
                self.detailTitleLabel.text = response.title
                self.detailPageLabel.text = "\(self.currentPage)/\(response.images.count)"
                self.setTimer(endTime: response.deadline)
                
                self.detailPageControl.numberOfPages = response.images.count
         
                self.setupButtonTag()
                self.setupButtonAction()
                
                self.carouselCollectionView.reloadData()
            }
            
        }
        
        voteResultModel = Array(repeating: VoteResultModel(percent: 0.0, rank: 0, sensitivityPercent: 0.0, compositionPercent: 0.0, lightPercent: 0.0, colorPercent: 0.0), count: viewModel.voteDetailModel.value.images.count)
        
        print("voteResultModel \(voteResultModel.count)")
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
        
        // 투표 결과 화면
        if object.isVoted {
            cell.resultView.isHidden = false
            cell.diamondsImageView.isHidden = true
            cell.viewWidthConstraint.constant = 0

            // 투표 퍼센트 및 순위 구하기
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

                if total == 0 { // total이 0일 경우 0 / 0 = nan이니 예외처리
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
                percents[index] = round((Double(pickedNums[index]) / Double(participantsNum) * 100) * 10) / 10
                voteResultModel[index].percent = percents[index]
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

            cell.pickedNumLabel.text = "\(object.images[indexPath.row].pickedNum)명"
            cell.percentLabel.text = "\(voteResultModel[indexPath.row].percent))%"
            cell.rankingLabel.text = "\(voteResultModel[indexPath.row].rank))위"

            if cell.percentLabel.text == "0.0%" {
                cell.viewWidthConstraint.constant = 301
                cell.resultColorView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
            } else {
                let size = 239 * 0.01 * (voteResultModel[indexPath.row].percent) + 62
                cell.viewWidthConstraint.constant = CGFloat(size)

                // 1위 이미지일 경우
                if firstRankSet.contains(indexPath.row) {
                    // 작성자 원픽이 1위 or 투표자 투표 이미지가 1위
                    if (loginUserNickname == postNickname && object.onePickImageId == indexPath.row) || (loginUserNickname != postNickname && object.votedImageId == indexPath.row) {
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
        
        detailPageLabel.text = "\(String(describing: currentPage + 1)) / \(String(describing: viewModel.voteDetailModel.value.images.count))"
        
        detailPageControl.currentPage = currentPage
        
        if !viewModel.voteDetailModel.value.isVoted {
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
        detailPageControl.currentPage = 0
        detailPageControl.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
       
        if loginUserNickname == postNickname { // 1. 투표 작성자인 경우 - Feedback View + 원픽 이미지
            print("투표 작성자인 경우")
            rightBarButton.setBackgroundImage(#imageLiteral(resourceName: "trashcan"), for: .normal, barMetrics: .default)
            rightBarButton.tag = 0
            setupResultView(isVoted: true)
        } else { // 2. 투표 작성자가 아닐 경우
            rightBarButton.setBackgroundImage(#imageLiteral(resourceName: "megaphone"), for: .normal, barMetrics: .default)
            rightBarButton.tag = 1
            
            if !viewModel.voteDetailModel.value.isVoted { // 투표하지 않은 사용자 - Pick View
                print("사용자 투표 X")
                pickView.isHidden = false
                feedbackView.isHidden = true
            } else { // 3. 투표한 사용자 - Feedback View + 투표 이미지
                print("사용자 투표 O")
                setupResultView(isVoted: true)
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
        sensitivityPercentLabel.text = "\(voteResultModel[currentPage].sensitivityPercent)%"
        compositionPercentLabel.text = "\(voteResultModel[currentPage].compositionPercent)%"
        lightPercentLabel.text = "\(voteResultModel[currentPage].lightPercent)%"
        colorPercentLabel.text = "\(voteResultModel[currentPage].colorPercent)%"
        
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
            let size = 44 * 0.01 * (voteResultModel[currentPage].sensitivityPercent) + 4
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
            
            let size = 44 * 0.01 * (voteResultModel[currentPage].compositionPercent) + 4
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
            
            let size = 44 * 0.01 * (voteResultModel[currentPage].lightPercent) + 4
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
            
            let size = 44 * 0.01 * (voteResultModel[currentPage].colorPercent) + 4
            colorHeightConstraint.constant = CGFloat(size)
        }
    }
    
    // MARK: - Button Tags
    
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
    
    // MARK: - Back Button Action
    
    @objc func backButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
        // viewModel.fetchDeletePost(postId: postId)
    }
    
    func reportTapped() {
        
    }
    
    // MARK: - Pick Button Action
    
    @objc func pickButtonClicked(_ sender: UIButton) {
        setupResultView(isVoted: false)
    }
    
    // MARK: - Feedback Button Actions
    
    @objc func feedbackButtonClicked(_ sender: UIButton) {
        
        if !viewModel.voteDetailModel.value.isVoted {
            var feedback = ""
            switch sender.tag {
            case 2:
                feedback = "sensitivity"
            case 3:
                feedback = "composition"
            case 4:
                feedback = "light"
            case 5:
                feedback = "color"
            case 6:
                feedback = "skip"
            default:
                print("error")
            }
            
            // 투표 생성 서버 통신
            //viewModel.fetchCreatePost(postId: postId, imageId: String(currentPage), category: feedback)
            
            setupResultView(isVoted: true)
            isFirstSetUpResultPercent = true
            carouselCollectionView.reloadData()
        } else {
            if sender.tag == 7 {
                if postNickname == loginUserNickname { // 투표 작성자 - 원픽 이미지로 이동
                    carouselCollectionView.scrollToItem(at: IndexPath(row: viewModel.voteDetailModel.value.onePickImageId, section: 0), at: .top, animated: true)
                } else { // 투표자 - 투표한 이미지로 이동
                    carouselCollectionView.scrollToItem(at: IndexPath(row: viewModel.voteDetailModel.value.votedImageId, section: 0), at: .top, animated: true)
                }
            }
        }
        
    }
    
}

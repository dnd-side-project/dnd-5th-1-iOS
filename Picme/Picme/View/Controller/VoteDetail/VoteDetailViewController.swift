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
    
    var isSelect: Bool = false // didSelectItemAt?????? ????????? ????????? ???????????? ????????? Bool ??? - true?????? ?????????
    var selectedImageId: String? // ????????? ???????????? ID ???
    var selectImageIndex: Int? // ????????? ???????????? ???????????? ?????? IndexPath.row ???
    
    var firstRankSet: Set<Int> = [] // 1??? ????????? ????????? ?????? ??????
    var isFirstRank: Bool = false // 1??? ???????????? ?????? ????????? or ????????? ???????????? ?????? true
    var firstRankColor = #colorLiteral(red: 0.9411764706, green: 0.4745098039, blue: 0.2352941176, alpha: 0.8)
    
    var currentPage: Int = 0 // ?????? ????????? ????????? ???????????? ???????????? IndexPath.row ???
    
    var isPick: Bool = false // pick ?????? ????????? ????????? ????????? ?????? ???????????? ?????? Bool ??? - true??? Feedback View ?????????
    var isPickStart: Bool = false // Pick View?????? ????????? ????????? ????????? ???????????? ????????? ?????? ???????????? Bool ???
    
    var isFirst: Bool = true // ?????? ?????? ?????? ???????????? ???????????? ????????? ?????? ????????? ???????????? ???????????? ????????? Flag ??????
    
    var isDeadline: Bool = false
    
    // View Model
    lazy var viewModel: VoteDetailViewModel = {
        let viewModel = VoteDetailViewModel(service: VoteDetailService())
        return viewModel
    }()
    
    var postId: String! // ???????????? ???????????? ????????? ????????? ???
    
    let loginUserNickname = LoginUser.shared.userNickname! // ????????? ?????? ?????????
    var isSameNickname: Bool = false // ????????? ????????? ????????? ???????????? ??????????????? ??????
    
    var voteResultModel: [VoteResultModel] = [] // ?????? ?????? ??? ?????? ??????
    
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
        
        // ?????? ?????? ??? ???????????? ??? ?????? 
        if !deleteView.isHidden {
            NotificationCenter.default.post(name: .backToMain, object: nil)
        }
    }
    
    // MARK: - Bind View Model
    
    private func bindViewModel() {
        ActivityView.instance.start(controller: self) // ??????????????? ??????
        
        viewModel.voteDetailModel.bindAndFire { (response) in
            
            // ?????? ?????? ?????? ???????????? ???????????? ????????? ?????? ????????? ???????????? ???????????? ????????? isFirst??? ??? ??? ????????????
            if self.isFirst {
                self.isFirst = false
                return
            }
            
                self.detailNicknameLabel.text = response.postNickname
                self.detailProfileImageView.image = UIImage.profileImage(response.postProfileUrl)
                self.detailParticipantsLabel.text = "\(response.participantsNum)??? ?????????"
                self.detailPageLabel.text = "\(self.currentPage + 1)/\(response.images.count)"
                self.detailTitleLabel.text = response.title
                self.detailTitleLabel.lineBreakMode = .byCharWrapping
                
                // ????????? ????????? ????????? ??????
                self.detailTitleLabel.minimumScaleFactor = 10 / UIFont.labelFontSize
                self.detailTitleLabel.adjustsFontSizeToFitWidth = true
                
                // ????????? ??????
                let endDate = self.dateHelper.stringToDate(dateString: response.deadline!)
                self.remainSeconds = self.dateHelper.getTimer(startDate: self.currentDate, endDate: endDate!)
                self.updateTimer()
                
                self.detailPageControl.numberOfPages = response.images.count
                
                // ????????? ?????? = ?????? ?????????
                if self.loginUserNickname == response.postNickname {
                    self.isSameNickname = true
                }
                
                // Navigation Right Bar Button ???????????? ?????????
                if self.isSameNickname { // ?????? ????????? -> ????????????
                    self.rightBarButton.image = #imageLiteral(resourceName: "trashcan")
                    self.rightBarButton.tag = 0
                } else { // ????????? -> ????????????
                    self.rightBarButton.image = #imageLiteral(resourceName: "megaphone")
                    self.rightBarButton.tag = 1
                }
                
                // ?????? ????????? or ????????? ???????????? ?????? - ?????? ??? ?????????
                if self.isSameNickname || response.isVoted || self.isDeadline {
                    // ?????? ????????? ??? ????????? ?????? ?????? ?????????
                    self.voteResultModel = Array(repeating: VoteResultModel(percent: 0.0, rank: 0, sensitivityPercent: 0.0, compositionPercent: 0.0, lightPercent: 0.0, colorPercent: 0.0), count: self.viewModel.voteDetailModel.value.images.count)
                    
                    // ?????? ??? ??????
                    self.getVoteResult()
                }
                
                self.setupView() // ????????? ?????? ??? Feedback View ????????? ????????? ?????????
      
                self.carouselCollectionView.reloadData()
        }
     
        // ????????? ?????? ?????? ?????? ??????
        // viewModel.fetchVoteDetail(postId: postId)
        
        // ????????? ????????? ??????
        viewModel.fetchVoteDetail(postId: postId) { result in
            if result == "networkERR" {
                self.rightBarButton.isEnabled = false
                self.deleteView.isHidden = false
                self.deleteImageView.image = #imageLiteral(resourceName: "hmm")
                self.deleteLabel.text = "???????????? ???????????? ??? ??? ?????????.\n?????? ??????????????????."
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
        
        // 1. ?????? ????????? & 2-2. ????????? ????????? & ????????? ????????? ??????-> ?????? ?????? ?????? Feedback View
        if isSameNickname || object.isVoted || isDeadline {
            
            // ?????? ????????? ??????(?????? ???????????????) ??????
            cell.viewWidthConstraint.constant = 0
            cell.diamondsImageView.isHidden = true
            
            // Result View ????????? ??? ??? ??????
            cell.resultView.isHidden = false
            cell.pickedNumLabel.text = "\(object.images[indexPath.row].pickedNum)???"
            cell.percentLabel.text = "\(voteResultModel[indexPath.row].percent)%"
            cell.rankingLabel.text = "\(voteResultModel[indexPath.row].rank)???"
            
            if cell.percentLabel.text == "0.0%" { // 0%
                cell.viewWidthConstraint.constant = 299
                cell.resultColorView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
            } else { // ??? ????????? ?????????
                let size = 239 * 0.01 * (voteResultModel[indexPath.row].percent) + 60
                cell.viewWidthConstraint.constant = CGFloat(size)
                
                // ??? ???????????? 1,2,3??? ???????????? ??????
                if firstRankSet.contains(indexPath.row) {
                    cell.resultColorView.backgroundColor = firstRankColor
                } else {
                    cell.resultColorView.backgroundColor = #colorLiteral(red: 0.2, green: 0.8, blue: 0.5490196078, alpha: 0.8)
                }
            }
        } else { // 2-1. ???????????? ??????, ?????? ?????? ????????? -> ?????? ?????? ?????? Pick View
//            if isSelect {
//                // ????????? ???????????? ????????? ???????????? ?????? ?????? -> ?????? ??????????????? ????????? ?????????
//                if indexPath.item == selectImageIndex {
//                    cell.viewWidthConstraint.constant = 299
//                    cell.diamondsImageView.isHidden = false
//                } else { // ????????? ???????????? ?????????
//                    cell.viewWidthConstraint.constant = 0
//                    cell.diamondsImageView.isHidden = true
//                }
//            }
            
            if isSelect { // 2-1. ???????????? ??????, ?????? ?????? ????????? -> ?????? ?????? ?????? Pick View
                // ????????? ???????????? ????????? ???????????? ?????? ?????? -> ?????? ??????????????? ????????? ?????????
                if indexPath.item == selectImageIndex {
                    cell.viewWidthConstraint.constant = 299
                    cell.diamondsImageView.isHidden = false
                } else { // ????????? ???????????? ?????????
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
        
        ActivityView.instance.stop() // ??????????????? ??????
        
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
//        carouselCollectionView.reloadData() // ????????? ??? ???????????? ???????????? ?????????
        
        if !isSelect { // ?????? ????????? ???????????? ?????? ??????
            initPickView(index: indexPath.row)
            carouselCollectionView.reloadData() // ????????? ??? ???????????? ???????????? ?????????
        } else { // ?????? ????????? ????????? ?????? ????????? ??????
            if selectImageIndex == indexPath.row {
                isSelect = false
                pickButton.setImage(#imageLiteral(resourceName: "pickButtonDisabled"), for: .normal)
                carouselCollectionView.reloadData()
            } else { // ????????? ???????????? ?????? ????????? ????????? ??????
                initPickView(index: indexPath.row)
            }
        }
    }
    
    func initPickView(index: Int) {
        isSelect = true // ??????????????? true ?????? ??? ?????? ????????? ?????? ??? ??? ?????? ?????????
        selectImageIndex = index
        selectedImageId = viewModel.voteDetailModel.value.images[index].imageId
        pickButton.setImage(#imageLiteral(resourceName: "pickButtonNormal"), for: .normal)
        carouselCollectionView.reloadData() // ????????? ??? ???????????? ???????????? ?????????
    }
    
    // MARK: - Scroll View Did Scroll
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        carouselCollectionView.didScroll()
        
        guard let currentCenterIndex = carouselCollectionView.currentCenterCellIndex?.row else { return }
        currentPage = currentCenterIndex // ?????? ????????? ???????????? ????????? ?????????
        
        // Page Label, Page Control ??????
        detailPageLabel.text = "\(String(describing: currentPage + 1)) / \(String(describing: viewModel.voteDetailModel.value.images.count))"
        detailPageControl.currentPage = currentPage
        
        // ???????????? ?????? ???????????? ?????? ?????? (Pick View) -> ?????? ????????? ???????????? ???
        if !isSameNickname && !viewModel.voteDetailModel.value.isVoted && !isDeadline {
            if isSelect { // ????????? ???????????? ?????? ??????
                if currentPage == selectImageIndex { // ?????? ????????? ????????? = ????????? ????????? ?????????
                    if !isPick {
                        pickButton.setImage(#imageLiteral(resourceName: "pickButtonNormal"), for: .normal) // Pick Button ?????????
                    } else {
                        setupResultView(isPicked: true, isVoted: false)
                    }
                } else { // ?????? ????????? ????????? != ????????? ????????? ?????????
                    pickButton.setImage(#imageLiteral(resourceName: "pickButtonDisabled"), for: .normal)
                    setupResultView(isPicked: false, isVoted: false)
                }
            }
        } else { // ????????? ?????? (Feedback View)
            // ?????? ????????? ???????????? ?????? ????????? ?????????
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
        
        // 1. ?????? ???????????? ?????? -> Feedback View + ?????? ??????(?????? ?????????)
        if isSameNickname {
            isPickStart = false
            setupResultView(isPicked: true, isVoted: true)
        } else { // 2. ?????? ???????????? ?????? ??????
            if !viewModel.voteDetailModel.value.isVoted && !isDeadline { // 2-1. ???????????? ?????? ????????????, ???????????? ?????? ????????? -> Pick View
                isPickStart = true
                setupResultView(isPicked: false, isVoted: false)
            } else { // 2-2. ????????? ????????? -> Feedback View + ?????? ??????(?????? ?????????)
                isPickStart = false
                setupResultView(isPicked: true, isVoted: true)
            }
        }
    }
    
    // MARK: - Set Up Result View (Feedback View)
    
    private func setupResultView(isPicked: Bool, isVoted: Bool) {
        if isPicked { // Current Page??? ????????? ?????? ????????? ???????????? ??????????????? -> Feedback View ?????????
            pickView.isHidden = true
            feedbackView.isHidden = false
        } else { // Current Page??? ???????????? ????????? ?????? ???????????? ??????????????? -> Pick View ?????????
            pickView.isHidden = false
            feedbackView.isHidden = true
        }
        
        if isSameNickname || isVoted { // ?????? ?????????????????? ????????? ??? ?????? -> ?????? ????????? ?????? ??????????????? ???
            // Skip Button -> One Pick Button
            skipButton.setImage(#imageLiteral(resourceName: "onePickButton"), for: .normal)
            skipButton.setImage(#imageLiteral(resourceName: "onePickButtonDisabled"), for: .highlighted)
            skipButton.setTitle("", for: .normal)
            
            skipButton.tag = 17
            onePickLabel.text = "??? ??????!"
            onePickLabel.textColor = .textColor(.text91)
            
            setupResultViewPercent(currentPage: currentPage) // ?????? ????????? ???????????? ???????????? ????????? ??? ??????
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
            
            // Feedback View - Percent Label ??????
            percentLabelArray[index].text = "\(percentArray[index])%"
            
            // Feedback View - Result View Color ??????
            if percentLabelArray[index].text == "0.0%" {
                resultViewArray[index].backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
                heightConstraintArray[index].constant = 48
            } else {
                if firstRankSet.contains(currentPage) {
                    resultViewArray[index].backgroundColor = firstRankColor
                } else {
                    resultViewArray[index].backgroundColor = #colorLiteral(red: 0.2, green: 0.8, blue: 0.5490196078, alpha: 0.8)
                }
                
                // Feedback View - Height Constraint ??????
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
        
        // ????????? ???????????? Button Action ??????
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
        // ???????????? ????????????, ?????? ???????????? ????????? ???????????? ?????? ???????????? ?????? ????????? ??????
        if isSelect && currentPage == selectImageIndex {
            isPick = true
            setupResultView(isPicked: true, isVoted: false) // ????????? ?????? ?????? ????????? Feedback View ?????????
        }
    }
    
    // MARK: - Feedback Button Action
    
    @objc func feedbackButtonClicked(_ sender: UIButton) {
        // ?????? ??? ?????? ?????? ?????? ?????? ?????? ?????? - Pick View?????? ???????????? ??? ????????? ?????? ??????
        if isPickStart {
            isPickStart = false
            
            let feedbackDictionary: [Int: String] = [11: "emotion", 12: "composition", 13: "light", 14: "color", 15: "skip"]
            
            let buttonDictionary: [Int: Int] = [11: 0, 12: 1, 13: 2, 14: 3]
            
            let category = feedbackDictionary[sender.tag]!
            
            // ?????? ??????
            viewModel.service?.createVote(postId: postId, imageId: selectedImageId!, category: category, completion: {
                let currentButtonTag = sender.tag
                
                feedbackDictionary.keys.filter { $0 != currentButtonTag }.forEach { tag in
                    if let button = self.view.viewWithTag(tag) as? UIButton {
                        
                        // Skip ?????? ????????????
                        if tag == 15 {
                            self.skipButton.setTitleColor(#colorLiteral(red: 0.2156862745, green: 0.2352941176, blue: 0.2588235294, alpha: 1), for: .normal)
                        } else { // ??? ????????? ?????? ????????????
                            self.resultViewArray[buttonDictionary[tag] ?? 0].isHidden = false
                            self.heightConstraintArray[buttonDictionary[tag] ?? 0].constant = 48
                            self.resultViewArray[buttonDictionary[tag] ?? 0].backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
                            self.buttonLabelArray[buttonDictionary[tag] ?? 0].textColor = #colorLiteral(red: 0.3607843137, green: 0.3607843137, blue: 0.3647058824, alpha: 1)
                        }
                        
                        button.isSelected = false
                    }
                }
                
                // Skip ????????? ?????? ?????? - Skip ?????? ?????????
                if currentButtonTag == 15 {
                    self.skipButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
                }
                
                // ??? ????????? ?????? ?????????
                sender.borderWidth = 2
                sender.borderColor = #colorLiteral(red: 0.9215686275, green: 0.2862745098, blue: 0.6039215686, alpha: 1)
                sender.cornerRadiusLayer = 10
                sender.isSelected = !sender.isSelected
                
                let time = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: time) {
                    Toast.show(using: .voteComplete, controller: self)
                    sender.borderWidth = 0
                    self.pickView.isHidden = true // ?????? ??? ????????? ?????? ????????? ?????? ????????? hidden
                    self.bindViewModel()
                }
            })
        }
        
        // One Pick Button Clicked
        if sender.tag == 17 {
            // ?????? ???????????? ?????? -> ?????? ????????? ???????????? ??????
            if isSameNickname {
                carouselCollectionView.scrollToItem(at: IndexPath(row: viewModel.voteDetailModel.value.onePickImageId, section: 0), at: .top, animated: true)
            } else { // ???????????? ??????
                if viewModel.voteDetailModel.value.isVoted { // ????????? ?????? - ????????? ????????? ???????????? ??????
                    carouselCollectionView.scrollToItem(at: IndexPath(row: viewModel.voteDetailModel.value.votedImageId, section: 0), at: .top, animated: true)
                } else {
//                    // ???????????? ?????? ?????? - ?????? ????????? ?????? ????????? ???????????? ??????
//                    carouselCollectionView.scrollToItem(at: IndexPath(row: viewModel.voteDetailModel.value.onePickImageId, section: 0), at: .top, animated: true)
                }
            }
        }
    }
    
    // MARK: - Navigation Right Button Action - Alert View
    
    @objc func rightButtonClicked(_ sender: UIButton) {
        switch sender.tag {
        case 0: // ????????????
            AlertView.instance.showAlert(using: .listRemove)
            AlertView.instance.actionDelegate = self
        case 1: // ????????????
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
        viewModel.requestReport(postId: postId)
        self.deleteView.isHidden = false
        self.rightBarButton.isEnabled = false
        deleteLabel.text = "???????????? ???????????? ??? ??? ?????????.\n????????? ??????????????????."
        deleteImageView.image = #imageLiteral(resourceName: "report")
        Toast.show(using: .report, controller: self)
        
    }
    
}

// MARK: - Get Vote Result

extension VoteDetailViewController {
    
    func getVoteResult() {
        // ?????? ?????? ?????? ??? ?????????
        let object = viewModel.voteDetailModel.value
        
        let participantsNum = object.participantsNum
        let count = object.images.count
        
        var pickedNums = [Int](repeating: 0, count: count)
        var percents = [Double](repeating: 0, count: count)
        
        // ????????? ????????? ?????????
        for index in 0..<count {
            let sensitivityCount = object.images[index].emotion
            let compositionCount = object.images[index].composition
            let lightCount = object.images[index].light
            let colorCount = object.images[index].color
            let skipCount = object.images[index].skip
            
            let total = sensitivityCount + compositionCount + lightCount + colorCount + skipCount
            
            if total == 0 { // total??? 0??? ?????? -> 0 / 0 = nan?????? ????????????
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
            
            // ????????? ????????? ?????????
            pickedNums[index] = object.images[index].pickedNum
            
            if pickedNums[index] == 0 { // ????????? ????????? 0??? ?????? -> 0 / 0 = nan?????? ????????????
                voteResultModel[index].percent = 0.0
            } else {
                percents[index] = round((Double(pickedNums[index]) / Double(participantsNum) * 100) * 10) / 10
                voteResultModel[index].percent = percents[index]
            }
        }
        
        // ????????? percent ????????? ???????????? ??????
        var dictionary = [Int: Double]()
        
        for index in 0..<percents.count {
            dictionary[index] = percents[index]
        }
        
        let sortedDitionary = dictionary.sorted { $0.1 > $1.1 }
        
        // ?????? ?????? ??????
        var rank = 1
        
        // ??????????????? 0????????? 1???
        var rankPickedNum = object.images[sortedDitionary[0].key].pickedNum
        voteResultModel[sortedDitionary[0].key].rank = rank
        firstRankSet.insert(sortedDitionary[0].key)
        
        for index in 1..<sortedDitionary.count {
            
            // ?????? ???????????? ????????? ?????? ?????? ??????
            if object.images[sortedDitionary[index].key].pickedNum == rankPickedNum {
                voteResultModel[sortedDitionary[index].key].rank = rank
                //                if rank == 1 { // ?????? 1????????? 1??? Set??? ??????
                //                    firstRankSet.insert(sortedDitionary[index].key)
                //                }
            } else { // ????????? ?????? ??????
                rank += 1
                voteResultModel[sortedDitionary[index].key].rank = rank
                rankPickedNum = object.images[sortedDitionary[index].key].pickedNum
            }
            
            if isSameNickname || object.isVoted { // ?????? ?????????????????? ????????? ???????????? ??????
                // 1,2,3 ????????? ????????????
                if rank == 1 || rank == 2 || rank == 3 {
                    firstRankSet.insert(sortedDitionary[index].key)
                }
            } else { // ????????? ?????? ?????? ???????????? ??????
                // 1????????? ????????????
                if rank == 1 {
                    firstRankSet.insert(sortedDitionary[index].key)
                }
            }
        }
        
        if !isSameNickname && !object.isVoted { // ?????????????????? ????????? ?????? ???????????? ??????
            return
        }
        
        // 1,2,3??? ??? ????????? ?????? ?????? ????????? - ?????? ???????????? ?????? firstPickIndex / ???????????? ?????? votedImageIndex
        let compareIndex = isSameNickname ? object.onePickImageId : object.votedImageId
        
        if firstRankSet.contains(compareIndex) { // 1,2,3 ?????? ?????? ?????? ?????? ??????
            firstRankColor = #colorLiteral(red: 0.9215686275, green: 0.2862745098, blue: 0.6039215686, alpha: 0.8)
        }
    }
}

// MARK: - Timer

extension VoteDetailViewController {
    
    // ????????? ??????
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
    
    // ????????? ??????
    func cancelTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // 1??? ??? ????????????
    @objc func updateTimer() {
        remainSeconds -= 1
        self.detailClockImageView.isHidden = false
        self.detailDeadlineLabel.text = self.dateHelper.timerString(remainSeconds: remainSeconds)
        
        // ??????????????? ?????? ??????
        if remainSeconds <= 0 {
            isDeadline = true
            self.detailDeadlineLabel.text = "????????? ????????????"
            self.detailClockImageView.isHidden = true
            self.detailTitleLabel.textColor = .textColor(.text50)
            cancelTimer()
        }
    }
}

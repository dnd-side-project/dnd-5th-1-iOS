//
//  ContentViewController.swift
//  Picme
//
//  Created by taeuk on 2021/08/09.
//

import UIKit
import SnapKit

final class ContentViewController: BaseViewContoller {

    // MARK: - Properties
    
    var contentViewModel: ContentViewModel? = ContentViewModel()
    let stepView = StepView(stepText: "STEP 3", title: "마지막으로 제목과 마감시간을 설정해 주세요!")
    
    var textCount: Int = 0 {
        didSet {
            voteTitleTextNumber.text = "\(String(textCount))/45"
            if textCount >= 45 {
                voteTitleTextNumber.textColor = .mainColor(.pink)
            } else {
                voteTitleTextNumber.textColor = .textColor(.text71)
            }
        }
    }
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    // 투표 제목적는 곳
    @IBOutlet weak var voteTitle: UILabel!
    @IBOutlet weak var voteTitleTextNumber: UILabel!
    @IBOutlet weak var voteTextView: UITextView!
    
    // 투표 마감시간
    @IBOutlet weak var voteEndDateTextLabel: UILabel!
    @IBOutlet weak var voteEndDateTextfield: UITextField!
    
    @IBOutlet weak var upStackView: UIStackView!
    @IBOutlet weak var bottomStackView: UIStackView!
    
    @IBOutlet weak var registVoteButton: UIButton!
    
    private let pickerView: UIPickerView = {
        return $0
    }(UIPickerView())
    
    private let clearTextViewButton: UIButton = {
        $0.setImage(UIImage(named: "x24"), for: .normal)
        return $0
    }(UIButton(type: .custom))
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 200)
        voteEndDateTextfield.inputView = pickerView
        datePickerToolBar()
        voteTextView.delegate = self
        pickerView.delegate = self
        voteEndDateTextfield.delegate = self
        
    }
    
    @IBAction func registVote(_ sender: UIButton) {
        print("Regist")
        
        ActivityView.instance.start(controller: self)
        
        if let voteText = voteTextView.text, let voteEndDate = voteEndDateTextfield.text {
            contentViewModel?.createList(title: voteText, endDate: voteEndDate, completion: {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    ActivityView.instance.stop()
                    self.dismiss(animated: true) {
                        
                        guard let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as? SceneDelegate, let rootVC = sceneDelegate.window?.rootViewController else { return }
                        
                        if let tabbarVC = rootVC as? UITabBarController,
                           let mainNav = tabbarVC.selectedViewController as? UINavigationController,
                           let mainVC = mainNav.topViewController as? MainViewController {
                            
                            mainVC.mainTableView.reloadData()
                            mainVC.mainTableView.scrollToTop()
                            Toast.show(using: .voteUpload, controller: mainVC)
                        }
                    }
                }
            })
        }
    }

    func datePickerToolBar() {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .white
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "완료", style: UIBarButtonItem.Style.done, target: self, action: #selector(toolBarDoneButton(_:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "취소", style: UIBarButtonItem.Style.plain, target: self, action: #selector(toolBarCancelButton(_:)))

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        voteEndDateTextfield.inputAccessoryView = toolBar
        
    }
    
    @objc func toolBarDoneButton(_ sender: UIButton) {
        print("DONE")
        if voteEndDateTextfield.text == contentViewModel?.addDate(0) {
            contentViewModel?.hasVoteEndDate.value = false
        }
        
        contentViewModel?.completeCheck()
        voteEndDateTextfield.resignFirstResponder()
    }
    
    @objc func toolBarCancelButton(_ sender: UIButton) {
        voteEndDateTextfield.text = contentViewModel?.addDate(0)
        contentViewModel?.hasVoteEndDate.value = false
        
        contentViewModel?.completeCheck()
        voteEndDateTextfield.resignFirstResponder()
    }
    
    func isRegistButtonState(state: Bool) {
        
        if state {
            self.registVoteButton.backgroundColor = .mainColor(.pink)
            self.registVoteButton.setTitleColor(.textColor(.text100), for: .normal)
            self.registVoteButton.isEnabled = true
        } else {
            self.registVoteButton.backgroundColor = .solidColor(.solid26)
            self.registVoteButton.setTitleColor(.textColor(.text50), for: .normal)
            self.registVoteButton.isEnabled = false
        }
    }
    
    deinit {
        print("contentViewController deInit")
    }
}

// MARK: - TextViewDelegate

extension ContentViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.text != "" {
            contentViewModel?.hasTitleText.value = true
        } else {
            contentViewModel?.hasTitleText.value = false
        }
        
        if textView.text.count >= 46 {
            textView.text.removeLast()
        }
        
        textCount = textView.text.count
        contentViewModel?.completeCheck()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.layer.borderWidth = 3
        textView.layer.borderColor = UIColor.solidColor(.solid26).cgColor
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.layer.borderWidth = 0
        textView.layer.borderColor = UIColor.clear.cgColor
    }
}

extension ContentViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 3
        textField.layer.borderColor = UIColor.solidColor(.solid26).cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0
        textField.layer.borderColor = UIColor.clear.cgColor
    }
}

// MARK: - PickerViewDelegate

extension ContentViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ExpirationDate.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ExpirationDate.allCases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        guard let contentVM = contentViewModel else { return }
        
        voteEndDateTextfield.text = contentVM.stringConvertDate(ExpirationDate.allCases[row])
        
        if voteEndDateTextfield.text != "" && voteEndDateTextfield.text != contentViewModel?.addDate(0) {
            contentViewModel?.hasVoteEndDate.value = true
        } else if ExpirationDate.timeSelect.rawValue == "시간 선택" {
            contentViewModel?.hasVoteEndDate.value = false
        }
        
        contentViewModel?.completeCheck()
    }
}

// MARK: - UI

extension ContentViewController {

    override func setBind() {
        
        contentViewModel?.isCompleteState.bindAndFire(listener: { [weak self] state in
            self?.isRegistButtonState(state: state)
        })
    }
    
    override func setProperties() {
        
        stepView.clipsToBounds = true
        stepView.backgroundColor = .solidColor(.solid12)
        stepView.layer.cornerRadius = 10
        
        voteTitle.textColor = .mainColor(.pink)
        voteTitleTextNumber.textColor = .textColor(.text71)
        voteTextView.textColor = .textColor(.text100)
        voteTextView.backgroundColor = .solidColor(.solid12)
        voteTextView.layer.cornerRadius = 10
        voteTextView.textContainerInset = UIEdgeInsets(top: 5, left: 12, bottom: 0, right: 12)
        
        voteEndDateTextLabel.textColor = .mainColor(.pink)
        voteEndDateTextfield.backgroundColor = .solidColor(.solid12)
        voteEndDateTextfield.textAlignment = .center
        voteEndDateTextfield.text = contentViewModel?.addDate(0)
        voteEndDateTextfield.textColor = .white
        voteEndDateTextfield.layer.cornerRadius = 10
        
        registVoteButton.backgroundColor = .solidColor(.solid26)
        registVoteButton.setTitleColor(.textColor(.text50), for: .normal)
        registVoteButton.setTitle("투표 다 만들었어요!", for: .normal)
        registVoteButton.layer.cornerRadius = 10
        
        clearTextViewButton.addTarget(self, action: #selector(clearTextAction(_:)), for: .touchUpInside)
    }
    
    @objc func clearTextAction(_ sender: UIButton) {
        
        voteTextView.text = ""
        
        textCount = 0
        contentViewModel?.hasTitleText.value = false
        contentViewModel?.completeCheck()
    }
    
    override func setConfiguration() {
        
        view.addSubview(stepView)
        voteTextView.addSubview(clearTextViewButton)
        
        view.backgroundColor = .solidColor(.solid0)
        
        // navigation
        navigationController?.navigationBar.tintColor = .white
        navigationItem.title = "제목/마감시간 설정"
        navigationItem.hidesBackButton = true
        
        let customBackButton = UIBarButtonItem(image: UIImage(named: "leftArrow28"),
                                               style: .done,
                                               target: self,
                                               action: #selector(backAction(_:)))
        navigationItem.leftBarButtonItem = customBackButton
    }
    
    @objc func backAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func setConstraints() {
        
        stepView.snp.makeConstraints {
            $0.top.equalTo(progressBar.snp.bottom).offset(14)
            $0.leading.equalTo(progressBar.snp.leading)
            $0.trailing.equalTo(progressBar.snp.trailing)
            $0.height.equalTo(72)
        }
        
        upStackView.snp.makeConstraints {
            $0.top.equalTo(stepView.snp.bottom).offset(100)
            $0.leading.equalTo(progressBar.snp.leading)
            $0.trailing.equalTo(progressBar.snp.trailing)
        }
        
        bottomStackView.snp.makeConstraints {
            $0.top.equalTo(upStackView.snp.bottom).offset(40)
            $0.leading.equalTo(stepView.snp.leading)
            $0.trailing.equalTo(stepView.snp.trailing)
            $0.bottom.lessThanOrEqualTo(registVoteButton.snp.top).offset(-30)
        }
        
        registVoteButton.snp.makeConstraints {
            $0.bottom.equalTo(view.snp.bottom).offset(-100)
            $0.leading.equalTo(progressBar.snp.leading)
            $0.trailing.equalTo(progressBar.snp.trailing)
            $0.height.equalTo(52)
        }
        
        clearTextViewButton.snp.makeConstraints {
            $0.top.equalTo(voteTextView.snp.top).offset(14)
            $0.trailing.equalTo(view.snp.trailing).offset(-30)
            $0.width.equalTo(24)
        }
        
    }
}

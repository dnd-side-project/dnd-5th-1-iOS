//
//  ContentViewController.swift
//  Picme
//
//  Created by taeuk on 2021/08/09.
//

import UIKit
import SnapKit

class ContentViewController: BaseViewContoller {

    // MARK: - Properties
    @IBOutlet weak var progressBar: UIProgressView!
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
    
    lazy var datePicker: UIDatePicker = {
        $0.locale = Locale(identifier: "en_kr")
        $0.datePickerMode = .dateAndTime
        $0.backgroundColor = .white
        
        if #available(iOS 13.4, *) {
            $0.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        return $0
    }(UIDatePicker())
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        voteEndDateTextfield.inputView = datePicker
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
//        datePickerToolBar()
        voteTextView.delegate = self
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        let dateformatter = DateFormatter()
        dateformatter.locale = Locale(identifier: "ko_KR")
        dateformatter.dateFormat = "yy/MM/dd hh:mm"
        
        let selectDate: String = dateformatter.string(from: sender.date)
        voteEndDateTextfield.text = selectDate
    }

    @IBAction func registVote(_ sender: UIButton) {
        print("Regist")
    }
    
    func datePickerToolBar() {
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.tintColor = .white
        toolbar.sizeToFit()
        
        let done = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(toolBarDoneButton(_:)))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(toolBarCancelButton(_:)))
        
        toolbar.setItems([cancel, flexibleSpace, done], animated: true)
        toolbar.isUserInteractionEnabled = true
        
        voteEndDateTextfield.inputAccessoryView = toolbar
    }
    
    @objc func toolBarDoneButton(_ sender: UIButton) {
        print("DONE")
        voteEndDateTextfield.resignFirstResponder()
    }
    
    @objc func toolBarCancelButton(_ sender: UIButton) {
        voteEndDateTextfield.text = nil
        voteEndDateTextfield.resignFirstResponder()
    }
}

extension ContentViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.text.count >= 46 {
            textView.text.removeLast()
        }
        
        textCount = textView.text.count
    }
}

// MARK: - UI

extension ContentViewController {

    override func setProperties() {
        
        stepView.clipsToBounds = true
        stepView.backgroundColor = .solidColor(.solid12)
        stepView.layer.cornerRadius = 10
        
        voteTitle.textColor = .mainColor(.pink)
        voteTitleTextNumber.textColor = .textColor(.text71)
        voteTextView.textColor = .textColor(.text100)
        voteTextView.backgroundColor = .solidColor(.solid12)
        voteTextView.layer.cornerRadius = 10
        
        voteEndDateTextLabel.textColor = .mainColor(.pink)
        voteEndDateTextfield.backgroundColor = .solidColor(.solid12)
        voteEndDateTextfield.textAlignment = .center
        voteEndDateTextfield.text = "21/07/15 00:00"
        voteEndDateTextfield.textColor = .white
        
        registVoteButton.backgroundColor = .solidColor(.solid26)
        registVoteButton.setTitleColor(.textColor(.text50), for: .normal)
        registVoteButton.setTitle("투표 다 만들었어요!", for: .normal)
        registVoteButton.layer.cornerRadius = 10
    }
    
    override func setConfiguration() {
        
        view.addSubview(stepView)
        view.backgroundColor = .solidColor(.solid0)
        
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
        
    }
}

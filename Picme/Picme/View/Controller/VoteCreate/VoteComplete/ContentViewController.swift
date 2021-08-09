//
//  ContentViewController.swift
//  Picme
//
//  Created by taeuk on 2021/08/09.
//

import UIKit

class ContentViewController: BaseViewContoller {

    // MARK: - Properties
    @IBOutlet weak var progressBar: UIProgressView!
    let stepView = StepView(stepText: "STEP 3", title: "마지막으로 제목과 마감시간을 설정해 주세요!")
    
    // 투표 제목적는 곳
    @IBOutlet weak var voteTitle: UILabel!
    @IBOutlet weak var voteTitleTextNumber: UILabel!
    @IBOutlet weak var voteTextView: UITextView!
    
    // 투표 마감시간
    @IBOutlet weak var voteEndDateTimeLabel: UILabel!
    @IBOutlet weak var voteEndView: UIView!
    @IBOutlet weak var voteEndDate: UILabel!
    
    @IBOutlet weak var upStackView: UIStackView!
    @IBOutlet weak var bottomStackView: UIStackView!
    
    @IBOutlet weak var registVoteButton: UIButton!
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func registVote(_ sender: UIButton) {
        print("Regist")
    }
}

// MARK: - UI

extension ContentViewController {

    override func setProperties() {
        
    }
    
    override func setConfiguration() {
        
        view.backgroundColor = .solidColor(.solid0)
        
        view.addSubview(stepView)
        stepView.clipsToBounds = true
        stepView.backgroundColor = .solidColor(.solid12)
        stepView.layer.cornerRadius = 10
        
        voteTitle.textColor = .mainColor(.pink)
        voteTitleTextNumber.textColor = .textColor(.text71)
        voteTextView.textColor = .textColor(.text100)
        voteTextView.backgroundColor = .solidColor(.solid12)
        voteTextView.layer.cornerRadius = 10
        
        voteEndDateTimeLabel.textColor = .mainColor(.pink)
        voteEndView.backgroundColor = .solidColor(.solid12)
        voteEndView.layer.cornerRadius = 10
        voteEndDate.text = "21/07/14 00:00"
        voteEndDate.textColor = .textColor(.text100)
        
        registVoteButton.backgroundColor = .solidColor(.solid26)
        registVoteButton.setTitleColor(.textColor(.text50), for: .normal)
        registVoteButton.setTitle("투표 다 만들었어요!", for: .normal)
        registVoteButton.layer.cornerRadius = 10
    }
    
    override func setConstraints() {
        
        stepView.translatesAutoresizingMaskIntoConstraints = false
        stepView.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 14)
            .isActive = true
        stepView.leadingAnchor.constraint(equalTo: progressBar.leadingAnchor)
            .isActive = true
        stepView.trailingAnchor.constraint(equalTo: progressBar.trailingAnchor)
            .isActive = true
        stepView.heightAnchor.constraint(equalToConstant: 72)
            .isActive = true
        
        upStackView.translatesAutoresizingMaskIntoConstraints = false
        upStackView.topAnchor.constraint(equalTo: stepView.bottomAnchor, constant: 100)
            .isActive = true
        upStackView.leadingAnchor.constraint(equalTo: progressBar.leadingAnchor)
            .isActive = true
        upStackView.trailingAnchor.constraint(equalTo: progressBar.trailingAnchor)
            .isActive = true

        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.topAnchor.constraint(equalTo: upStackView.bottomAnchor, constant: 40)
            .isActive = true
        bottomStackView.leadingAnchor.constraint(equalTo: stepView.leadingAnchor)
            .isActive = true
        bottomStackView.trailingAnchor.constraint(equalTo: stepView.trailingAnchor)
            .isActive = true
        bottomStackView.bottomAnchor.constraint(lessThanOrEqualTo: registVoteButton.topAnchor,
                                                constant: -30)
            .isActive = true
        
        registVoteButton.translatesAutoresizingMaskIntoConstraints = false
        registVoteButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
            .isActive = true
        registVoteButton.leadingAnchor.constraint(equalTo: progressBar.leadingAnchor)
            .isActive = true
        registVoteButton.trailingAnchor.constraint(equalTo: progressBar.trailingAnchor)
            .isActive = true
        registVoteButton.heightAnchor.constraint(equalToConstant: 52)
            .isActive = true
    }
}

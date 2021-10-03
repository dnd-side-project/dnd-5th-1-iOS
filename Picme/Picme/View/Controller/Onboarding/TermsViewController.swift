//
//  TermsViewController.swift
//  Picme
//
//  Created by taeuk on 2021/09/04.
//

import UIKit

final class TermsViewController: BaseViewContoller {

    private var isAllCheck: Bool = false {
        didSet {
            if isAllCheck {
                allCheckButton.setImage(UIImage(named: "check"), for: .normal)
                isTermsCheck = true
                isPolicyCheck = true
                isAgreeCheck = true
                is14MoreCheck = true
            } else {
                allCheckButton.setImage(UIImage(named: "nocheck"), for: .normal)
                isTermsCheck = false
                isPolicyCheck = false
                isAgreeCheck = false
                is14MoreCheck = false
            }
        }
    }
    
    private var isTermsCheck: Bool = false {
        didSet {
            if isTermsCheck {
                termsCheckButton.setImage(UIImage(named: "check"), for: .normal)
                if isTermsCheck && isPolicyCheck && is14MoreCheck {
                    isAgreeCheck = true
                }
            } else {
                termsCheckButton.setImage(UIImage(named: "nocheck"), for: .normal)
                isAgreeCheck = false
                if isAllCheck {
                    isAllCheck = false
                    isPolicyCheck = true
                }
            }
        }
    }
    
    private var isPolicyCheck: Bool = false {
        didSet {
            if isPolicyCheck {
                policyCheckButton.setImage(UIImage(named: "check"), for: .normal)
                if isTermsCheck && isPolicyCheck && is14MoreCheck {
                    isAgreeCheck = true
                }
            } else {
                policyCheckButton.setImage(UIImage(named: "nocheck"), for: .normal)
                isAgreeCheck = false
                if isAllCheck {
                    isAllCheck = false
                    isTermsCheck = true
                }
            }
        }
    }
    
    private var is14MoreCheck: Bool = false {
        didSet {
            if is14MoreCheck {
                more14AgeButton.setImage(UIImage(named: "check"), for: .normal)
                if isTermsCheck && isPolicyCheck && is14MoreCheck {
                    isAgreeCheck = true
                }
            } else {
                more14AgeButton.setImage(UIImage(named: "nocheck"), for: .normal)
                isAgreeCheck = false
                if isAllCheck {
                    isAllCheck = false
                    isTermsCheck = true
                    is14MoreCheck = true
                }
            }
        }
    }
    
    private var isAgreeCheck: Bool = false {
        didSet {
            if isAgreeCheck {
                agreeButton.backgroundColor = .mainColor(.pink)
                agreeButton.setTitleColor(.textColor(.text100), for: .normal)
                agreeButton.isEnabled = true
            } else {
                agreeButton.backgroundColor = .solidColor(.solid26)
                agreeButton.setTitleColor(.textColor(.text50), for: .normal)
                agreeButton.isEnabled = false
            }
        }
    }
    
    @IBOutlet weak var allCheckButton: UIButton!
    @IBOutlet weak var termsCheckButton: UIButton!
    @IBOutlet weak var policyCheckButton: UIButton!
    @IBOutlet weak var more14AgeButton: UIButton!
    
    @IBOutlet weak var agreeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        agreeButton.isEnabled = false
    }
    
    @IBAction func allCheckAction(_ sender: UIButton) {
        isAllCheck = !isAllCheck
    }

    @IBAction func termsCheckAction(_ sender: UIButton) {
        isTermsCheck = !isTermsCheck
    }
    
    @IBAction func policyCheckAction(_ sender: UIButton) {
        isPolicyCheck = !isPolicyCheck
    }
    
    @IBAction func required14more(_ sender: UIButton) {
        is14MoreCheck = !is14MoreCheck
    }
    
    @IBAction func seeTermsAction(_ sender: UIButton) {
        personalInfoPath(type: .term)
    }
    
    @IBAction func seePolicyAction(_ sender: UIButton) {
        personalInfoPath(type: .policy)
    }
    
    @IBAction func agreeAction(_ sender: UIButton) {
        
        guard let onboardVC = storyboard?.instantiateViewController(withIdentifier: "OnboardingViewController") else { return }
        onboardVC.modalPresentationStyle = .fullScreen
        self.present(onboardVC, animated: true, completion: nil)
    }
    
    private func personalInfoPath(type: PersonalInfoViewContoller.Terms) {
        
        let storyboard = UIStoryboard(name: "MyPage", bundle: nil)
        guard let personalVC = storyboard.instantiateViewController(withIdentifier: "PersonalInfo") as? UINavigationController else { return }
        personalVC.modalPresentationStyle = .fullScreen
        if let infoType = personalVC.topViewController as? PersonalInfoViewContoller {
            infoType.types = type
        }
        self.present(personalVC, animated: true, completion: nil)
    }
}

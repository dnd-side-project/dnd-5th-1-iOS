//
//  GuideViewController.swift
//  Picme
//
//  Created by taeuk on 2021/09/01.
//

import UIKit

class GuideViewController: BaseViewContoller {

    @IBOutlet weak var tableView: UITableView!
    
    let guideList: [String] = ["인스타그램", "이용 약관", "개인정보 처리방침"]
    
    var myPageViewModel: MyPageViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        myPageViewModel?.seccsionDelegate = self
        tableView.separatorStyle = .none
    }

}

extension GuideViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return guideList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GuideCell = tableView.dequeueTableCell(for: indexPath)
        
        cell.setLabelText(guideList[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let leaveButton = UIButton(type: .custom)
        leaveButton.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 22)
        leaveButton.setTitle("회원 탈퇴하기", for: .normal)
        leaveButton.titleLabel?.textAlignment = .center
        leaveButton.setTitleColor(.textColor(.text50), for: .normal)
        leaveButton.titleLabel?.font = .kr(.bold, size: 14)
        leaveButton.backgroundColor = .solidColor(.solid0)
        leaveButton.addTarget(self, action: #selector(leaveAction(_:)), for: .touchUpInside)
        return leaveButton
//        let emptyView = UIView()
//        emptyView.backgroundColor = .black
//        return emptyView
    }
    
    @objc func leaveAction(_ sender: UIButton) {
        
        AlertView.instance.showAlert(using: .leave)
        AlertView.instance.actionDelegate = self
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            guard let instarVC = storyboard?.instantiateViewController(withIdentifier: "InstarWebViewController") else { return }
            self.present(instarVC, animated: true, completion: nil)
        case 1:
            personalInfoPath(type: .term)
        case 2:
            personalInfoPath(type: .policy)
        default:
            return
        }
    }
    
    private func personalInfoPath(type: PersonalInfoViewContoller.Terms) {
        
        guard let personalVC = storyboard?.instantiateViewController(withIdentifier: "PersonalInfo") as? UINavigationController else { return }
        personalVC.modalPresentationStyle = .fullScreen
        if let infoType = personalVC.topViewController as? PersonalInfoViewContoller {
            infoType.types = type
        }
        self.present(personalVC, animated: true, completion: nil)
    }
}

extension GuideViewController: UserSeccsionProtocol {
    func seccsionUserAction() {
        let presentLogin = UIStoryboard(name: "Login", bundle: nil)
        let loginVC = presentLogin.instantiateViewController(withIdentifier: "LoginViewController")
        loginVC.modalPresentationStyle = .fullScreen
        self.present(loginVC, animated: true, completion: nil)
    }
}

extension GuideViewController: AlertViewActionDelegate {
    
    func leaveActionTapped() {
        
        if LoginUser.shared.vendorID != nil {
            myPageViewModel?.requestUserSecession(SeccsionCase.loginUser)
        } else {
            myPageViewModel?.requestUserSecession(SeccsionCase.onBoardingUser)
        }
        
    }
}

extension GuideViewController {
    
    override func setConfiguration() {
        
        // Navigation
        navigationController?.navigationBar.tintColor = .white
        navigationItem.title = "문의하기"
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
}

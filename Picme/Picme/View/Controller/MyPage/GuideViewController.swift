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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            return
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

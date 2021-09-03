//
//  GuideViewController.swift
//  Picme
//
//  Created by taeuk on 2021/09/01.
//

import UIKit

class GuideViewController: BaseViewContoller {

    @IBOutlet weak var tableView: UITableView!
    
    let guideList: [String] = ["가이드라인", "개인정보 처리방침"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }

}

extension GuideViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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
            guard let personalVC = storyboard?.instantiateViewController(withIdentifier: "PersonalInfo") as? UINavigationController else { return }
            self.present(personalVC, animated: true, completion: nil)
        default:
            return
        }
    }
}

extension GuideViewController {
    
    override func setConfiguration() {
        
        // Navigation
        navigationController?.navigationBar.tintColor = .white
        navigationItem.title = "약관 및 정책"
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

//
//  OnePickViewController.swift
//  Picme
//
//  Created by taeuk on 2021/08/09.
//

import UIKit

class OnePickViewController: BaseViewContoller {

    // MARK: - Properties
    
    var userImages: [UIImage]?
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    let stepView = StepView(stepText: "STEP 2", title: "어떤 사진이 제일 마음에 드시나요?")
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        return collection
    }()
    
    let nextButton: UIButton = {
        $0.layer.cornerRadius = 10
        $0.setTitle("내 원픽은 이거에요!", for: .normal)
        $0.setTitleColor(.textColor(.text50), for: .normal)
        $0.backgroundColor = .solidColor(.solid26)
        return $0
    }(UIButton(type: .system))
    
    var selectIndex: Int?
    var isSelectPick: Bool?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerCell(OnePickCell.self)
    }
    
}

extension OnePickViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let images = userImages else { return 0 }
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let images = userImages else { return UICollectionViewCell() }
        
        let cell: OnePickCell = collectionView.dequeueCollectionCell(for: indexPath)
        cell.showUserImage(images[indexPath.row])
        
        if isSelectPick == true {
            if indexPath.item == selectIndex {
                cell.pickImage.image = UIImage(named: "onepick")
                cell.pickLayer.backgroundColor = .opacityColor(.pink80)
                nextButton.backgroundColor = .mainColor(.pink)
                nextButton.setTitleColor(.white, for: .normal)
            } else {
                cell.pickImage.image = UIImage(named: "notonepick")
                cell.pickLayer.backgroundColor = .opacityColor(.solid0)
                
            }
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectIndex = indexPath.row
        isSelectPick = true

        collectionView.reloadData()
    }
    
}

extension OnePickViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 5
        let height = collectionView.frame.height / 3 - 5
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

}

// MARK: - UI

extension OnePickViewController {
    
    override func setProperties() {
        
        nextButton.addTarget(self, action: #selector(nextView(_:)), for: .touchUpInside)
    }
    
    @objc func nextView(_ sender: UIButton) {
        guard let contentVC = storyboard?.instantiateViewController(withIdentifier: "ContentViewController") else { return }
        navigationController?.pushViewController(contentVC, animated: true)
    }
    
    override func setConfiguration() {
        
        view.backgroundColor = .solidColor(.solid0)
        
        view.addSubview(stepView)
        view.addSubview(collectionView)
        view.addSubview(nextButton)
        stepView.clipsToBounds = true
        stepView.backgroundColor = .solidColor(.solid12)
        stepView.layer.cornerRadius = 10
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

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: stepView.bottomAnchor, constant: 14)
            .isActive = true
        collectionView.leadingAnchor.constraint(equalTo: progressBar.leadingAnchor)
            .isActive = true
        collectionView.trailingAnchor.constraint(equalTo: progressBar.trailingAnchor)
            .isActive = true
        collectionView.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -20)
            .isActive = true
        
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -28)
            .isActive = true
        nextButton.leadingAnchor.constraint(equalTo: progressBar.leadingAnchor)
            .isActive = true
        nextButton.trailingAnchor.constraint(equalTo: progressBar.trailingAnchor)
            .isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 52)
            .isActive = true
        
    }
}

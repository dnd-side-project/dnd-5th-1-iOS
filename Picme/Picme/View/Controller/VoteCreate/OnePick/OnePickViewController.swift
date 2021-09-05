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
    var createUserImges: CreateUserImages?
    
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
        $0.titleLabel?.font = .kr(.bold, size: 16)
        $0.setTitle("내 원픽은 이거에요!", for: .normal)
        $0.setTitleColor(.textColor(.text50), for: .normal)
        $0.backgroundColor = .solidColor(.solid26)
        return $0
    }(UIButton(type: .system))
    
    var selectIndex: Int?
    var isSelectPick: Bool?
    
    weak var imageDelegate: ImageDelete?
    
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
                nextButton.isEnabled = true
                
                cell.pickCenterImage.isHidden = false
            } else {
                cell.pickImage.image = UIImage(named: "notonepick")
                cell.pickLayer.backgroundColor = .opacityColor(.solid0)
                cell.pickCenterImage.isHidden = true
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
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

}

// MARK: - UI

extension OnePickViewController {
    
    override func setProperties() {
        
        nextButton.addTarget(self, action: #selector(nextView(_:)), for: .touchUpInside)
        
        nextButton.isEnabled = false
    }
    
    @objc func nextView(_ sender: UIButton) {
        guard let contentVC = storyboard?.instantiateViewController(withIdentifier: "ContentViewController") else { return }
        createUserImges?.isFirstPick = selectIndex!
        print(createUserImges)
        ContentViewModel.imageMetaData = CreateCase.userImageMetadata(data: createUserImges!)
        
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
        
        // Navigation
        navigationController?.navigationBar.tintColor = .white
        navigationItem.title = "원픽 선택"
        navigationItem.hidesBackButton = true
        
        let customBackButton = UIBarButtonItem(image: UIImage(named: "leftArrow28"),
                                               style: .done,
                                               target: self,
                                               action: #selector(backAction(_:)))
        navigationItem.leftBarButtonItem = customBackButton
    }
    
    @objc func backAction(_ sender: UIBarButtonItem) {
        AlertView.instance.showAlert(using: .listRemove)
        AlertView.instance.actionDelegate = self
    }
    
    override func setConstraints() {
        
        stepView.snp.makeConstraints {
            $0.top.equalTo(progressBar.snp.bottom).offset(14)
            $0.leading.equalTo(progressBar.snp.leading)
            $0.trailing.equalTo(progressBar.snp.trailing)
            $0.height.equalTo(72)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(stepView.snp.bottom).offset(16)
            $0.leading.equalTo(progressBar.snp.leading)
            $0.trailing.equalTo(progressBar.snp.trailing)
            $0.bottom.equalTo(nextButton.snp.top).offset(-20)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.snp.bottom).offset(-28)
            $0.leading.equalTo(progressBar.snp.leading)
            $0.trailing.equalTo(progressBar.snp.trailing)
            $0.height.equalTo(52)
        }
    }
}

extension OnePickViewController: AlertViewActionDelegate {
    
    func listRemoveTapped() {
        self.imageDelegate?.removeALLImage()
        self.navigationController?.popViewController(animated: true)
    }
}

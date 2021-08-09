//
//  ImageUploadViewContoller.swift
//  Picme
//
//  Created by taeuk on 2021/08/06.
//

import UIKit

class ImageUploadViewContoller: BaseViewContoller {
    
    // MARK: - Properties
    var uploadViewModel: ImageUploadViewModel? = ImageUploadViewModel()
    
    @IBOutlet weak var testButton: UIButton!
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var progressBar: UIProgressView!
    
    let customs = StepView(stepText: "STEP 1", title: "투표받고 싶은 사진을 올려주세요!")
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        return collection
    }()
    
    let nextButton: UIButton = {
        $0.backgroundColor = .mainColor(.pink)
        $0.layer.cornerRadius = 10
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(.textColor(.text100), for: .normal)
        return $0
    }(UIButton(type: .system))
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerCell(ImageUploadCell.self)
    }
    
    @IBAction func testAction(_ sender: UIButton) {
        uploadViewModel?.buttonState.value = true
    }
    
    func viewState(_ state: Bool) {
        self.stackView.isHidden = state
        self.collectionView.isHidden = !state
        self.nextButton.isHidden = !state
    }
}

// MARK: - UI

extension ImageUploadViewContoller {
    
    override func setProperties() {
        
        view.addSubview(customs)
        view.addSubview(collectionView)
        view.addSubview(nextButton)
        
        customs.clipsToBounds = true
        customs.backgroundColor = .solidColor(.solid12)
        
        collectionView.isHidden = true
        nextButton.isHidden = true
        
        // NavigationBar
        if let navBar = navigationController?.navigationBar {
            navBar.isTranslucent = false
            navBar.barTintColor = .solidColor(.solid0)

            navBar.topItem?.title = "사진 업로드"
            navBar.titleTextAttributes = [.foregroundColor: UIColor.textColor(.text100)]
        }
        
        nextButton.addTarget(self, action: #selector(onePickChoise(_:)), for: .touchUpInside)
    }
    
    @objc func onePickChoise(_ sender: UIButton) {
         
    }
    
    override func setBind() {
        
        uploadViewModel?.buttonState.bindAndFire(listener: { state in
            self.viewState(state)
        })
    }
    
    override func setConfiguration() {
        
        view.backgroundColor = .solidColor(.solid0)
        
        testLabel.textColor = .textColor(.text100)
        
        testButton.layer.cornerRadius = 10
        testButton.setTitleColor(.textColor(.text100), for: .normal)
        testButton.backgroundColor = .mainColor(.pink)
        
    }
    
    override func setConstraints() {
        
        testButton.translatesAutoresizingMaskIntoConstraints = false
        testButton.widthAnchor.constraint(equalToConstant: view.frame.width / 2.5)
            .isActive = true
        testButton.heightAnchor.constraint(equalToConstant: 52)
            .isActive = true
        
        customs.translatesAutoresizingMaskIntoConstraints = false
        customs.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 14)
            .isActive = true
        customs.leadingAnchor.constraint(equalTo: progressBar.leadingAnchor)
            .isActive = true
        customs.trailingAnchor.constraint(equalTo: progressBar.trailingAnchor)
            .isActive = true
        customs.heightAnchor.constraint(equalToConstant: 72)
            .isActive = true
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: customs.bottomAnchor, constant: 14)
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

//
//  ImageUploadViewContoller.swift
//  Picme
//
//  Created by taeuk on 2021/08/06.
//

import UIKit
import YPImagePicker

class ImageUploadViewContoller: BaseViewContoller {
    
    // MARK: - Properties
    var uploadViewModel: ImageUploadViewModel? = ImageUploadViewModel()
    
    @IBOutlet weak var testButton: UIButton!
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var progressBar: UIProgressView!
    
    let stepView = StepView(stepText: "STEP 1", title: "투표받고 싶은 사진을 올려주세요!")
    
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
    
    // YPImagePicker Properties
    var selectedItems = [YPMediaItem]()
    var userImages = [UIImage]()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerCell(ImageUploadCell.self)
    }
    
    @IBAction func testAction(_ sender: UIButton) {
        var config = YPImagePickerConfiguration()

        config.shouldSaveNewPicturesToAlbum = false
        config.targetImageSize = .cappedTo(size: 1024)
        config.onlySquareImagesFromCamera = true
        config.startOnScreen = .library
        config.screens = [.library]
        config.wordings.libraryTitle = "Gallerys"
        config.hidesStatusBar = false
        config.hidesBottomBar = false
        config.maxCameraZoomFactor = 5.0
        config.overlayView = nil
        config.gallery.hidesRemoveButton = false
//        config.library.minNumberOfItems = 1
        config.library.maxNumberOfItems = 6
        config.library.preselectedItems = selectedItems
        config.library.mediaType = .photo
        config.library.itemOverlayType = .grid
        config.library.defaultMultipleSelection = true

        let picker = YPImagePicker(configuration: config)
        picker.imagePickerDelegate = self
        
        // 멀티 사진
        picker.didFinishPicking { [unowned picker] items, cancelled in
            for item in items {
                switch item {
                case .photo(let photos):
                    self.userImages.append(photos.image)
                    print(photos.image)
                    print(photos.image.size.width)
                    print(photos.image.size.height)
                default:
                    return
                }
            }
            picker.dismiss(animated: true) { [weak self] in
                guard let self = self else { return }
                
                guard let onePickVC = self.storyboard?.instantiateViewController(withIdentifier: "OnePickViewController") as? OnePickViewController else { return }
                onePickVC.userImages = self.userImages
                self.navigationController?.pushViewController(onePickVC, animated: true)
            }
        }
        
        present(picker, animated: true, completion: nil)
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
        
        view.addSubview(stepView)
        view.addSubview(collectionView)
        view.addSubview(nextButton)
        
        stepView.clipsToBounds = true
        stepView.backgroundColor = .solidColor(.solid12)
        stepView.layer.cornerRadius = 10
        
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
        guard let onePickVC = storyboard?.instantiateViewController(withIdentifier: "OnePickViewController") as? OnePickViewController else { return }
        navigationController?.pushViewController(onePickVC, animated: true)
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

// MARK: - YPImagePicker

extension ImageUploadViewContoller: YPImagePickerDelegate {
    
    func noPhotos() {
            
    }
    
    func shouldAddToSelection(indexPath: IndexPath, numSelections: Int) -> Bool {
        return true
    }
}

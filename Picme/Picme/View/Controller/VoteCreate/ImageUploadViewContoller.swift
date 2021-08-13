//
//  ImageUploadViewContoller.swift
//  Picme
//
//  Created by taeuk on 2021/08/06.
//

import UIKit
import SnapKit
import YPImagePicker


class ImageUploadViewContoller: BaseViewContoller {
    
    // MARK: - Properties
    var uploadViewModel: ImageUploadViewModel? = ImageUploadViewModel()
    
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var uploadLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var progressBar: UIProgressView!
    
    let stepView = StepView(stepText: "STEP 1", title: "투표받고 싶은 사진을 올려주세요!")
    
    // YPImagePicker Properties
    var selectedItems = [YPMediaItem]()
    var userImages = [UIImage]()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
}

// MARK: - UI

extension ImageUploadViewContoller {
    
    override func setProperties() {
        
        view.addSubview(stepView)
        
        stepView.clipsToBounds = true
        stepView.backgroundColor = .solidColor(.solid12)
        stepView.layer.cornerRadius = 10
        
        // NavigationBar
        if let navBar = navigationController?.navigationBar {
            navBar.isTranslucent = false
            navBar.barTintColor = .solidColor(.solid0)

            navBar.topItem?.title = "사진 업로드"
            navBar.titleTextAttributes = [.foregroundColor: UIColor.textColor(.text100)]
        }
    }
    
    override func setConfiguration() {
        
        view.backgroundColor = .solidColor(.solid0)
        
        uploadLabel.textColor = .textColor(.text100)
        
        uploadButton.layer.cornerRadius = 10
        uploadButton.setTitleColor(.textColor(.text100), for: .normal)
        uploadButton.backgroundColor = .mainColor(.pink)
        
    }
    
    override func setConstraints() {
        
        uploadButton.snp.makeConstraints {
            $0.width.equalTo(view.frame.width / 2.5)
            $0.height.equalTo(52)
        }
        
        stepView.snp.makeConstraints {
            $0.top.equalTo(progressBar.snp.bottom).offset(14)
            $0.leading.equalTo(progressBar.snp.leading)
            $0.trailing.equalTo(progressBar.snp.trailing)
            $0.height.equalTo(72)
        }
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

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
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uploadViewModel?.buttonState.bindAndFire(listener: { state in
            self.stackView.isHidden = state
        })
        
        
        
    }
    
    @IBAction func testAction(_ sender: UIButton) {
        uploadViewModel?.buttonState.value = true
    }
}

// MARK: - UI

extension ImageUploadViewContoller {
    
    override func setProperties() {
        
        view.addSubview(customs)
        customs.clipsToBounds = true
        customs.backgroundColor = .solidColor(.solid12)
        
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
        
        testLabel.textColor = .textColor(.text100)
        
        testButton.layer.cornerRadius = 10
        testButton.setTitleColor(.textColor(.text100), for: .normal)
        testButton.backgroundColor = .mainColor(.pink)
        
    }
    
    override func setConstraints() {
        
        testButton.translatesAutoresizingMaskIntoConstraints = false
        testButton.widthAnchor.constraint(equalToConstant: view.frame.width / 2.5).isActive = true
        testButton.heightAnchor.constraint(equalToConstant: 52).isActive = true
        
        customs.translatesAutoresizingMaskIntoConstraints = false
        customs.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 14).isActive = true
        customs.leadingAnchor.constraint(equalTo: progressBar.leadingAnchor).isActive = true
        customs.trailingAnchor.constraint(equalTo: progressBar.trailingAnchor).isActive = true
        customs.heightAnchor.constraint(equalToConstant: 72).isActive = true
    }
}

//
//  ImageUploadViewContoller.swift
//  Picme
//
//  Created by taeuk on 2021/08/06.
//

import UIKit
import PhotosUI

struct PostImageData: Codable {
    let imageData: Data
    let isFirstPick: Bool
    let width: Int
    let height: Int
}

@available(iOS 14, *)
class ImageUploadViewContoller: UIViewController {
    
    var configuration = PHPickerConfiguration()
    var itemProviders: [NSItemProvider] = []
    var iterator: IndexingIterator<[NSItemProvider]>?
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.contentMode = .scaleAspectFit
        
//        let images = ["3","3","3","4","5","5"]
        let images = ["4","3"]
        var imageData: [PostImageData] = []
        
        images.forEach {
            let image = UIImage(named: $0)
//            imageData.append((image?.jpegData(compressionQuality: 0.2))!)
            imageData.append(PostImageData(imageData: (image?.jpegData(compressionQuality: 1))!,
                                           isFirstPick: false,
                                           width: 1000,
                                           height: 1000))
        }
        print(imageData)
        print(imageData.count)
        
        let param = [
            "files": imageData
        ]
//        ImageAPICenter.convertImage(param)
        ImageAPICenter.createImage(param)
    }

    @IBAction func testAction(_ sender: UIButton) {
        configuration.filter = .images
        configuration.selectionLimit = 0
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func displayNextImage() {
        if let itemProvider = iterator?.next(), itemProvider.canLoadObject(ofClass: UIImage.self) {
            let previousImage = imageView.image
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                DispatchQueue.main.async {
                    guard let self = self, let image = image as? UIImage, self.imageView.image == previousImage else { return }
//                    print(images?.size.width, images?.size.height)
                    self.imageView.image = self.resizeImage(image: image, targetSize: CGSize(width: 1000, height: 1000))
                }
            }
        }
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        print(newImage?.size.width, newImage?.size.height)
        return newImage!
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        displayNextImage()
    }
}

@available(iOS 14, *)
extension ImageUploadViewContoller: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        itemProviders = results.map(\.itemProvider)
        iterator = itemProviders.makeIterator()
        displayNextImage()
    }
}

//
//  ActivityView.swift
//  Picme
//
//  Created by taeuk on 2021/09/03.
//

import UIKit

final class ActivityView: UIView {
    
    static let instance = ActivityView()
    
    private let activityIndicator: UIActivityIndicatorView = {
        $0.color = .white
        return $0
    }(UIActivityIndicatorView(style: .large))
    
    private override init(frame: CGRect) { super.init(frame: frame) }
    
    // start
    func start(controller: UIViewController, time: Double? = nil) {
        
        self.frame = controller.view.frame
        self.backgroundColor = .opacityColor(.solid0)
        controller.view.addSubview(self)
        controller.view.bringSubviewToFront(self)
        
        activityIndicator.startAnimating()
        activityIndicator.center = self.center
        self.addSubview(activityIndicator)

        if let time = time {
            DispatchQueue.main.asyncAfter(deadline: .now() + time) {
                self.stop()
            }
        }
    }

    //stop
    func stop() {
        activityIndicator.stopAnimating()
        self.removeFromSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

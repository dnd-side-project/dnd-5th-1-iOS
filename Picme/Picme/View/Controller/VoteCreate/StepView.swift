//
//  StepView.swift
//  Picme
//
//  Created by taeuk on 2021/08/09.
//

import UIKit

class StepView: UIView {
    
    // MARK: - Properties
    
    var stepText: String = ""
    var stepTitleText: String = ""
    
    let stepLabel: UILabel = {
        $0.textColor = .textColor(.text71)
        $0.font = .kr(.regular, size: 12)
        return $0
    }(UILabel())
    
    let titleLable: UILabel = {
        $0.textColor = .textColor(.text100)
        $0.font = .kr(.bold, size: 16)
        return $0
    }(UILabel())
    
    let labelStackView: UIStackView = {
        $0.alignment = .center
        $0.distribution = .fill
        $0.axis = .vertical
        $0.spacing = 4
        return $0
    }(UIStackView())
    
    // MARK: - LifeCycle
    
    init(stepText: String, title: String) {
        
        self.stepText = stepText
        self.stepTitleText = title
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        self.layer.cornerRadius = 10
        
        self.addSubview(labelStackView)
        labelStackView.addArrangedSubview(stepLabel)
        labelStackView.addArrangedSubview(titleLable)
        
        stepLabel.text = stepText
        titleLable.text = stepTitleText
        
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10)
            .isActive = true
        labelStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16)
            .isActive = true
        labelStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
            .isActive = true
        labelStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16)
            .isActive = true
    }
}

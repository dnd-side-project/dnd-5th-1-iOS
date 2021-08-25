//
//  StepView.swift
//  Picme
//
//  Created by taeuk on 2021/08/09.
//

import UIKit
import SnapKit

final class StepView: UIView {
    
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
        
        labelStackView.snp.makeConstraints {
            $0.top.equalTo(self.snp.top).offset(10)
            $0.leading.equalTo(self.snp.leading).offset(16)
            $0.trailing.equalTo(self.snp.trailing).offset(-16)
            $0.bottom.equalTo(self.snp.bottom).offset(-16)
        }
    }
}

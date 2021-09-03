//
//  GuideCell.swift
//  Picme
//
//  Created by taeuk on 2021/09/01.
//

import UIKit

class GuideCell: UITableViewCell {

    @IBOutlet weak var guideLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
        cellSetting()
        self.selectionStyle = .none
    }
    
    func setLabelText(_ text: String) {
        guideLabel.text = text
    }
    
    private func cellSetting() {
        guideLabel.layer.borderWidth = 1
        guideLabel.layer.borderColor = UIColor.white.cgColor
        guideLabel.layer.cornerRadius = 10
    }
}

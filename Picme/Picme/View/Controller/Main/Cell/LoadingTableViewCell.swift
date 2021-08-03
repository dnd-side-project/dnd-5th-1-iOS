//
//  LoadingTableViewCell.swift
//  Picme
//
//  Created by 권민하 on 2021/08/03.
//

import UIKit

class LoadingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    func start() {
        activityIndicatorView.startAnimating()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

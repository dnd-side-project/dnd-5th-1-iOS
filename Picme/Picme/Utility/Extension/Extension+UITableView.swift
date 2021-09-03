//
//  Extension+UITableView.swift
//  dnd-5th-1-iOS
//
//  Created by taeuk on 2021/07/12.
//

import UIKit

extension UITableView {
    
    func registerCell<T: UITableViewCell>(_: T.Type) {
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueTableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell: T = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("\(Date()): Generic UITableViewCell is Error")
        }
        
        return cell
    }
    
    
    func scrollToTop(isAnimated:Bool = true) {

        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .top, animated: isAnimated)
           }
        }
    }

    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
}

extension UITableViewCell: ReusableCell {}

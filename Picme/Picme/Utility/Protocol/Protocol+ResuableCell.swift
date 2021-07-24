//
//  Protocol+ResuableCell.swift
//  dnd-5th-1-iOS
//
//  Created by taeuk on 2021/07/12.
//

import Foundation

protocol ReusableCell: AnyObject {
    static var reuseIdentifier: String { get }
}

extension ReusableCell {
    static var reuseIdentifier: String { return String(describing: self) }
}

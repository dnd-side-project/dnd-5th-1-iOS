//
//  GenericDataSource.swift
//  Picme
//
//  Created by 권민하 on 2021/08/07.
//

import Foundation
import UIKit

class GenericDataSource<T>: NSObject {
    var data: Dynamic<[T]> = Dynamic([])
}

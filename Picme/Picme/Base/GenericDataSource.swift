//
//  GenericDataSource.swift
//  Picme
//
//  Created by 권민하 on 2021/08/07.
//

import Foundation
import UIKit

/// Genenic datasource class with Dynamic values
/// Auto notify and update UI on data change
/// Mapping response data in a generic object extended with tableview datasource to present data in a list


class GenericDataSource<T> : NSObject {
    var data: Dynamic<[T]> = Dynamic([])
}

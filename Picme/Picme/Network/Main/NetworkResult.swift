//
//  NetworkResult.swift
//  Picme
//
//  Created by 권민하 on 2021/08/11.
//

import Foundation

enum NetworkResult<T> {
    case success(T)
    case requestErr(T)
    case pathErr
    case serverErr
    case networkFail
}

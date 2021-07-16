//
//  Enum+HTTPMethod.swift
//  dnd-5th-1-iOS
//
//  Created by taeuk on 2021/07/14.
//

import Foundation

enum HTTPMethod<Body> {
    case get
    case post(Body)
    case put(Body)
    case delete(Body)
}

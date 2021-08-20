//
//  CreateUserImages.swift
//  Picme
//
//  Created by taeuk on 2021/08/16.
//

import Foundation

// 이미지 메타데이터

struct CreateUserImages: Codable {
    var isFirstPick: Int
    var sizes: [UserImageSize]
}

struct UserImageSize: Codable {
    let width: Int
    let height: Int
}

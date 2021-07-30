//
//  APIConstants.swift
//  Picme
//
//  Created by 권민하 on 2021/07/30.
//

import Foundation

// MARK: 해당 파일 안에는 API 관련 상수들을 추가해주세요!

struct APIConstants {
    // MARK: - Headers
    
    static let authorization = "Authorization"
    static let accept = "Accept"
    static let auth = "x-auth-token"
    static let contentType = "Content-Type"

    // MARK: - Values
    
    static let applicationJSON = "application/json"
    static let formEncoded = "application/x-www-form-urlencoded"

    // MARK: - Keys
    
    static let jwtToken = ""
    
    // MARK: - URLs
    
    // Base URL
    static let baseURL = "https://www.example.com/v1/"

    // MARK: - /Main URLs
    static let postURL = baseURL + "/posts"
}

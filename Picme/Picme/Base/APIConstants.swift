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
    static let baseURL = "http://2d63c4581cec.ngrok.io/"
    static let urlVersion = "v1/"
    
    // MARK: - /Main URLs
    
    enum Auth {
        case signIn
        case signUp
        
        var urlString: String {
            switch self {
            case .signIn:
                return "\(APIConstants.baseURL)\(APIConstants.urlVersion)/auth/signin"
            case .signUp:
                return "\(APIConstants.baseURL)\(APIConstants.urlVersion)/auth/signup"
            }
        }
    }
    
    enum Post {
        case create
        
        var urlString: String {
            switch self {
            case .create:
                return "\(APIConstants.baseURL)\(APIConstants.urlVersion)posts"
            }
        }
    }
    
}

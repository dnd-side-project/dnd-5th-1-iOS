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
    
    enum Header: String {
        case authorization = "Authorization"
        case accept = "Accept"
        case auth = "x-auth-token"
        case contentType = "Content-Type"
    }

    // MARK: - Values
    
    enum Values: String {
        case applicationJSON = "application/json"
        case formEncoded = "application/x-www-form-urlencoded"
    }

    // MARK: - Keys
    
    static let jwtToken = ""
    
    // MARK: - URLs
    
    // Base URL
    private static let baseURL = "http://2d63c4581cec.ngrok.io/"
    private static let urlVersion = "v1/"
    
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
        case main
        case voteDetail
        
        var urlString: String {
            switch self {
            case .main:
                return "\(APIConstants.baseURL)\(APIConstants.urlVersion)/posts?page=pageNum&limit=10"
            case .voteDetail:
                return "\(APIConstants.baseURL)\(APIConstants.urlVersion)/posts/:post_id"
            }
            
        }
    }
    
}

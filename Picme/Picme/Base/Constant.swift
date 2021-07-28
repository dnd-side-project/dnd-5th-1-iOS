//
//  Constant.swift
//  Picme
//
//  Created by taeuk on 2021/07/28.
//

import Foundation

struct Constant {
    
    static let baseURL = "http://2d63c4581cec.ngrok.io/"
    static let urlVersion = "v1/"
    
    enum Auth {
        case signIn
        case signUp
        
        var urlString: String {
            switch self {
            case .signIn:
                return "\(Constant.baseURL)\(Constant.urlVersion)/auth/signin"
            case .signUp:
                return "\(Constant.baseURL)\(Constant.urlVersion)/auth/signup"
            }
        }
    }
    
    enum Post {
        case create
        
        var urlString: String {
            switch self {
            case .create:
                return "\(Constant.baseURL)\(Constant.urlVersion)posts"
            }
        }
    }
}

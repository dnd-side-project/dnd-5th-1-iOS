//
//  APIConstants.swift
//  Picme
//
//  Created by 권민하 on 2021/07/30.
//

import Foundation

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
    
    static var jwtToken = ""
    
    // MARK: - URLs
    
    // Base URL
    private static let baseURL = "http://infra-pickm-cqhjwtrlxm6c-370004496.ap-northeast-2.elb.amazonaws.com"
    private static let urlVersion = "/v1"
    
    // MARK: - /Main URLs
    
    enum Auth {
        /// 로그인 URL
        case signIn
        /// 회원가입 URL
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
        /// 게시글 생성 URL
        case createPost
        /// 게시글 리스트 조회 URL
        case postListRetrieve
        /// 게시글 조회 URL
        case postRetrieve(postID: String)
        /// 게시글 삭제 URL
        case deletePost(postID: String)
        
        var urlString: String {
            switch self {
            case .createPost:
                return "\(APIConstants.baseURL)\(APIConstants.urlVersion)/posts"
            case .postListRetrieve:
                return "\(APIConstants.baseURL)\(APIConstants.urlVersion)/posts?page=pageNum&limit=10"
            case .postRetrieve(let postID):
                return "\(APIConstants.baseURL)\(APIConstants.urlVersion)/posts/\(postID)"
            case .deletePost(let postID):
                return "\(APIConstants.baseURL)\(APIConstants.urlVersion)/posts/\(postID)"
            }
        }
    }
    
    enum Vote {
        /// 투표 생성 URL
        case createVote(postID: String, postImageID: String)
        /// 투표 삭제 URL
        case deleteVote(postID: String, postImageID: String)
        
        var urlString: String {
            switch self {
            case let .createVote(postID, postImageID):
                return "\(APIConstants.baseURL)\(APIConstants.urlVersion)/votes/\(postID)/\(postImageID)"
            case let .deleteVote(postID, postImageID):
                return "\(APIConstants.baseURL)\(APIConstants.urlVersion)/votes/\(postID)/\(postImageID)"
            }
        }
    }
    
    enum Image {
        /// 이미지 생성 URL
        case createImage(postID: String)
        /// 이미지 삭제 URL
        case deleteImage(postID: String)
        
        var urlString: String {
            switch self {
            case .createImage(let postID):
                return "\(APIConstants.baseURL)\(APIConstants.urlVersion)/post-images/:\(postID)"
            case .deleteImage(let postID):
                return "\(APIConstants.baseURL)\(APIConstants.urlVersion)/post-images/:\(postID)"
            }
        }
    }
    
    enum MyPage {
        
    }
    
}

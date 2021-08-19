//
//  CreateVoteService.swift
//  Picme
//
//  Created by taeuk on 2021/08/16.
//

import Foundation
import Alamofire

struct CreateVoteService {
    
    static func fetchCreateList(_ configure: CreateCase,
                                completion: @escaping ResultModel<CreateListReponseModel>) {
        
        let url = APIConstants.Post.postListRetrieve.urlString
        
        var parameter: CreateListModel?
        let header: HTTPHeaders = [
            "Authorization": APIConstants.jwtToken
        ]
        
        switch configure {
        case let .listConfigure(title, endDate):
            parameter = CreateListModel(title: title, expireAt: endDate)
            
        default:
            return
        }
        
        guard let parameter = parameter else { return }
        print(url)
        print(parameter)
        print(header)
        
        AF.request(url,
                   method: .post,
                   parameters: parameter,
                   encoder: JSONParameterEncoder.default,
                   headers: header)
            .responseDecodable(of: CreateListReponseModel.self) { (response) in
                switch response.result {
                case .success(let data):
                    print(data)
                    completion(.success(data))
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }
    }

    static func fetchCreateMetaData(_ configure: CreateCase,
                                    completion: @escaping ResultModel<CreateListReponseModel>) {
        
        let url = APIConstants.Post.postListRetrieve.urlString
        
        var parameter: [String: Any]?
        let header: HTTPHeaders = [
            "Authorization": APIConstants.jwtToken
        ]
        
        switch configure {
        case let .userImageMetadata(data):
            parameter = [
                "isFirstPick": data.isFirstPick,
                "metadata": data.sizes
            ]
            
        default:
            return
        }
        
        guard let parameter = parameter else { return }
        print(url)
        print(parameter)
        print(header)
        
        AF.request(url,
                   method: .post,
                   parameters: parameter,
                   encoding: JSONEncoding.default,
                   headers: header)
            .responseString { response in
                print("Success", response)
            }
    }
    
    static func fetchCreateImage(_ configure: CreateCase,
                                 _ configureCase: CreateCase,
                                 completion: @escaping () -> Void) {
            
            let url = APIConstants.Post.postListRetrieve.urlString
            
            var parameter: [String: Any]?
            
            let header: HTTPHeaders = [
                "Authorization": APIConstants.jwtToken
            ]
            
            if case let .userImage(date) = configure,
               case let .userImageMetadata(data) = configureCase {
                print(data)
//                parameter = [
//                    "files": date,
//                    "isFirstPick": data.isFirstPick,
//                    "metadata": data.metaData
//                ]
                parameter = [
                    "files": date,
                    "metaData": data
                ]
            }
            
            guard let parameter = parameter else { return }
            
            print(url)
            print(parameter)
            print(header)
            
            AF.upload(multipartFormData: { muti in
                
                var count = 0
                for (key, value) in parameter {
                    print("key", key)
                    print("value", value)
                    
                    switch key {
                    case "files":
                        if let value = value as? [Data] {
                            value.forEach {
                                print($0)
                                let timeStamp = Date().timeIntervalSince1970
                                muti.append($0, withName: "files", fileName: "\(timeStamp)_123_\(count)", mimeType: "image/jpg")
                                count += 1
                            }
                        }
                    case "metaData":
                        if let value = value as? CreateUserImages {
                            print(value)
                            muti.append("\(value)".data(using: .utf8)!, withName: key)
                        }
                    default:
                        return
                    }
                    
//                    switch key {
//                    case "files":
//                        if let value = value as? [Data] {
//                            value.forEach {
//                                print($0)
//                                let timeStamp = Date().timeIntervalSince1970
//                                muti.append($0, withName: "files", fileName: "\(timeStamp)_123_\(count)", mimeType: "image/jpg")
//                                count += 1
//                            }
//                        }
//                    case "isFirstPick":
//                        if let value = value as? Int {
//                            muti.append("\(value)".data(using: .utf8)!, withName: key)
//                        }
//                    case "metadata":
//                        if let value = value as? [UserImageSize] {
//                            muti.append("\(value)".data(using: .utf8)!, withName: key)
//                        }
//                    default:
//                        return
//                    }
                    
                }
            }, to: url,
            method: .post, headers: ["Content-type": "multipart/form-data"])
            .response { response in
                print(response.response?.statusCode)
                completion()
            }
        }
}

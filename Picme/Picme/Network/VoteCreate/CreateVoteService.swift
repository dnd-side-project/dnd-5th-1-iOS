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
        
        let url = APIConstants.Post.createPost.urlString
        
        var parameter: CreateListModel?
        let header: HTTPHeaders = [
            "Authorization": APIConstants.jwtToken
        ]
        
        switch configure {
        case let .listConfigure(title, endDate):
            parameter = CreateListModel(title: title, expiredAt: endDate)
            
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

    static func fetchCreateImage(postID: String,
                                 _ configure: CreateCase,
                                 _ configureCase: CreateCase,
                                 completion: @escaping () -> Void) {
            
            let url = APIConstants.Image.createImage(postID: postID).urlString
            
            var parameter: [String: Any]?
            
            let header: HTTPHeaders = [
                "Authorization": APIConstants.jwtToken
            ]
            
            if case let .userImage(date) = configure,
               case let .userImageMetadata(data) = configureCase {
                print(data)

                parameter = [
                    "files": date,
                    "metadata": data
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
                    case "metadata":
                        print(value)
                        
                        if let value = value as? CreateUserImages,
                           let encode = try? JSONEncoder().encode(value) {
                            
                            muti.append(encode, withName: key)
                        }
                    default:
                        return
                    }
                }
            }, to: url,
            method: .post, headers: header)
            .response { response in
                print(response.response?.statusCode)
                completion()
            }
        }
}

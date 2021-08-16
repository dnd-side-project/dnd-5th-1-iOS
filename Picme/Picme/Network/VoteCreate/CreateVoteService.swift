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
        
        let url = APIConstants.Post.main.urlString
        
        var parameter: [String: Any]?
        let header: HTTPHeaders = [
            "Authorization": APIConstants.jwtToken
        ]
        
        switch configure {
        case let .listConfigure(title, endDate):
            parameter = [
                "title": title,
                "expireAt": endDate
            ]
        default:
            return 
        }
        
        print(url)
        print(parameter)
        print(header)
        
        AF.request(url,
                   method: .post,
                   parameters: parameter,
                   encoding: JSONEncoding.default,
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
        
        let url = APIConstants.Post.main.urlString
        
        var parameter: [String: Any]?
        let header: HTTPHeaders = [
            "Authorization": APIConstants.jwtToken
        ]
        
        switch configure {
        case let .userImageMetadata(data):
            parameter = [
                "isFirstPick": data.isFirstPick,
                "metadata": data.metaData
            ]
            for iasd in 0..<data.metaData.count{
                print(data.metaData[iasd].width)
            }
        default:
            return
        }
        
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
                                completion: @escaping ResultModel<CreateListReponseModel>) {
        
        let url = APIConstants.Post.main.urlString
        
        var parameter: [String: [Data]]?
        let header: HTTPHeaders = [
            "Authorization": APIConstants.jwtToken
        ]
        
        switch configure {
        case let .userImage(date):
            parameter = [
                "files": date
            ]
        default:
            return
        }
        
        print(url)
        print(parameter)
        print(header)
        
        AF.upload(multipartFormData: { muti in
            
            var count = 0
            for (key, value) in parameter! {
                print("key", key)
                print("value", value)
                
                value.forEach {
                    print($0)
                    let timeStamp = Date().timeIntervalSince1970
                    muti.append($0, withName: "files", fileName: "\(timeStamp)_123_\(count)", mimeType: "image/jpg")
                    count += 1
                }
            }
        }, to: url,
        method: .post, headers: ["Content-type": "multipart/form-data"])
        .response { response in
            print(response.response?.statusCode)
        }
    }
    
}

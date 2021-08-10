//
//  ImageAPICenter.swift
//  Picme
//
//  Created by taeuk on 2021/07/28.
//

import Foundation
import Alamofire

struct ImageAPICenter {
    
    static func convertImage(_ images: [String: [Data]]) {
        
        let urlString = "http://918b4e77b7e0.ngrok.io/v1/images?post_id=123123123123"
        
        let param = images
        
        AF.upload(multipartFormData: { muti in
            
            print(param)
            print(images)
            var count = 0
            for (key, value) in param {
                print("key", key)
                print("value", value)
                
                value.forEach {
                    print($0)
                    print("\($0)".data(using: .utf8)!)
                    let timeStamp = Date().timeIntervalSince1970
                    muti.append($0, withName: "files", fileName: "\(timeStamp)_123_\(count)", mimeType: "image/jpg")
                    count += 1
                }
            }
        }, to: urlString,
        method: .post, headers: ["Content-type": "multipart/form-data"])
        .response { response in
            print(response.response?.statusCode)
        }
    }
    
    static func createImage(_ data: [String: [Any]]) {
        
        let urlstring = "123"
        
        let param = data
        print(param)
        
        AF.upload(multipartFormData: { muti in
            var count = 0
            param.forEach { key, value in
                print(key)
                print(value)
                switch key {
                case "files":
                    guard let bytes = value as? [Data] else { return }
                    print(bytes)
                    bytes.forEach {
                        print($0)
                        let timeStamp = Date().timeIntervalSince1970
                        muti.append($0, withName: "files", fileName: "\(timeStamp)_123_\(count)", mimeType: "image/jpg")
                        count += 1
                    }
                default:
                    muti.append("\(value)".data(using: .utf8)!, withName: key)
                }
            }
            
        }, to: urlstring, method: .post, headers: ["Content-type": "multipart/form-data"])
        .response { response in
            print(response.response?.statusCode)
        }
        
//        AF.upload(multipartFormData: { muti in
//
//            var count = 0
//
//            for (key, value) in param {
//                print("key", key)
//                print("value", value)
//
//                value.forEach {
//                    print($0)
////                    print("\($0)".data(using: .utf8)!)
//                    let timeStamp = Date().timeIntervalSince1970
//                    muti.append("\($0)".data(using: .utf8)!,
//                                withName: "files",
//                                fileName: "\(timeStamp)_123_\(count)",
//                                mimeType: "image/jpg")
//
//                    count += 1
//                }
//            }
//        }, to: urlstring, method: .post, headers: ["Content-type": "multipart/form-data"])
//        .response { response in
//            print(response.response?.statusCode)
//        }
    }
}

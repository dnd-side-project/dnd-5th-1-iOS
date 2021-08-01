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
                    muti.append("\($0)".data(using: .utf8)!, withName: "files", fileName: "\(timeStamp)_123_\(count)", mimeType: "image/jpg")
                    count += 1
                }
            }
        }, to: urlString,
        method: .post, headers: ["Content-type": "multipart/form-data"])
        .response { response in
            print(response.response?.statusCode)
        }
    }
}


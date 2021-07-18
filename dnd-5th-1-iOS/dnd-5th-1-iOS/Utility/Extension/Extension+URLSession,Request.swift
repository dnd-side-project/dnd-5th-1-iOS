//
//  Extension+URLSession,Request.swift
//  dnd-5th-1-iOS
//
//  Created by taeuk on 2021/07/14.
//

import Foundation

typealias ResultModel<T> = (Result<T, APIError>) -> Void

extension URLRequest {
    
    init<Body: Encodable>(url: URL, method: HTTPMethod<Body>) {
        
        self.init(url: url)
        
        switch method {
        case .get:
            self.httpMethod = "GET"
            
        case .post(let body):
            self.httpMethod = "POST"
            self.httpBody = try? JSONEncoder().encode(body)
            
        case .put(let body):
            self.httpMethod = "PUT"
            self.httpBody = try? JSONEncoder().encode(body)
            
        case .delete(let body):
            self.httpMethod = "DELETE"
            self.httpBody = try? JSONEncoder().encode(body)
        }
    }
}

extension URLSession {
    
    func request<T: Decodable>(_ urlRequest: URLRequest,
                               completion: @escaping (Result<T, APIError>) -> Void) {
        
        dataTask(with: urlRequest) { data, response, error in
            
            if let _ = error {
                completion(.failure(.networkFailed))
            }
            
            if let response = response as? HTTPURLResponse {
                
                switch response.statusCode {
                case 200..<300:
                    if let data = data {
                        guard let decode = try? JSONDecoder().decode(T.self, from: data) else {
                            return completion(.failure(.decodingFailed))
                        }
                        completion(.success(decode))
                    }
                case 404:
                    completion(.failure(.invalidURL))
                default:
                    completion(.failure(.dataFailed))
                }
            }
            
        }.resume()
    }
}

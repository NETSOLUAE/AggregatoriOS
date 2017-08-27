//
//  WebserviceManager.swift
//  Aggregator
//
//  Created by Mac Mini on 8/27/17.
//  Copyright © 2017 Netsol. All rights reserved.
//

import UIKit
import Foundation

class WebserviceManager: NSObject {
    let constants = Constants();
    
    func login(type: String, endPoint: String, completion: @escaping (Result<[[String: AnyObject]]>) -> Void) {
        
        let urlString = endPoint
        
        guard let url = URL(string: urlString) else {
                return completion(.Error(constants.errorMessage))
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let authKey: [String: Any] = ["authentication": ["accesskey": "RMS", "secretkey": "RMS"]]
        let authData: Data
        do {
            authData = try JSONSerialization.data(withJSONObject: authKey, options: [])
            request.httpBody = authData
        } catch {
            print("Error: cannot create JSON from todo")
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else { return completion(.Error(error!.localizedDescription)) }
            
            let httpStatus = response as? HTTPURLResponse
            guard httpStatus?.statusCode == 200 else { return completion(.Error(error?.localizedDescription ?? self.constants.errorMessage))
            }
            
            guard let data = data else { return completion(.Error(error?.localizedDescription ?? self.constants.errorMessage))
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: AnyObject] {
                    if (type == "single") {
                        guard let itemsJsonArray = json["result"] as? [String: AnyObject] else {
                            return completion(.Error(error?.localizedDescription ?? self.constants.errorMessage))
                        }
                        DispatchQueue.main.async {
                            completion(.SuccessSingle(itemsJsonArray))
                        }
                    } else {
                        guard let itemsJsonArray = json["result"] as? [[String: AnyObject]] else {
                            return completion(.Error(error?.localizedDescription ?? self.constants.errorMessage))
                        }
                        DispatchQueue.main.async {
                            completion(.Success(itemsJsonArray))
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.Error(error?.localizedDescription ?? self.constants.errorMessage))
                    }
                }
            } catch let error {
                print("Localised Error \(error)")
                return completion(.Error(self.constants.errorMessage))
            }
            }.resume()
    }
    
}

enum Result<T> {
    case SuccessSingle([String: AnyObject])
    case Success([[String: AnyObject]])
    case Error(String)
}


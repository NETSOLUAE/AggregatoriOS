//
//  WebserviceManager.swift
//  Aggregator
//
//  Created by Mac Mini on 8/27/17.
//  Copyright © 2017 Netsol. All rights reserved.
//

import UIKit
import Photos
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
        
        if (endPoint.contains("netsolintl")) {
            print("Netsol Service")
        } else if (endPoint == constants.COMPANY_DETAILS) {
            
        } else {
            let authKey: [String: Any] = ["authentication": ["accesskey": "RMS", "secretkey": "RMS"]]
            let authData: Data
            do {
                authData = try JSONSerialization.data(withJSONObject: authKey, options: [])
                request.httpBody = authData
            } catch {
                print("Error: cannot create JSON from todo")
                return
            }
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
                        if (endPoint.contains("netsolintl")) {
                            DispatchQueue.main.async {
                                completion(.Success([json]))
                            }
                        } else {
                            guard let itemsJsonArray = json["result"] as? [[String: AnyObject]] else {
                                return completion(.Error(error?.localizedDescription ?? self.constants.errorMessage))
                            }
                            DispatchQueue.main.async {
                                completion(.Success(itemsJsonArray))
                            }
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
    
    func getCompanyDetails(userInfoDict: [String: String], endPoint: String, completion: @escaping (Result<[[String: AnyObject]]>) -> Void) {
        
        let urlString = endPoint
        
        guard let url = URL(string: urlString) else {
            return completion(.Error(constants.errorMessage))
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let params: [String: Any]
        let authKey: [String: Any] = ["accesskey": "RMS", "secretkey": "RMS"]
        
        let vehicleID = userInfoDict["make"]! + "^" + userInfoDict["modal"]! + "^" + userInfoDict["variant"]!;
        
        let date = Date.init(timeIntervalSinceNow: 1)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todatDate = dateFormatter.string(from: date)
        
        let string = userInfoDict["registration_date"]!
        
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let regdate = dateFormatter.date(from: string)!
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = tempLocale // reset the locale
        let regdateString = dateFormatter.string(from: regdate)
        print("EXACT_DATE : \(regdateString)")
        
//        let index = regdateString.index(regdateString.startIndex, offsetBy: 4)
//        let yom = regdateString.substring(to: index)
        
        params = ["authentication": authKey, "usageType" : userInfoDict["vehicle_usage"]!,
                  "vehicleType" : userInfoDict["usage_type"]!,
                  "vehicleId" : vehicleID,
                  "vehicleRegistrationDate" : regdateString,
                  "vehicleAge" : "0",
                  "price" : userInfoDict["price"]!,
                  "policyStartDate" : todatDate,
                  "claim" : "N",
                  "numClaims" : "0",
                  "rto" : userInfoDict["rto"]!,
                  "yom" : userInfoDict["year_of_manufacture"]!,
                  "insuredAge" : userInfoDict["age"]!]
        
        let authData: Data
        do {
            authData = try JSONSerialization.data(withJSONObject: params, options: [])
            print(params)
            request.httpBody = authData
            request.setValue(" application/json; charset=utf-8", forHTTPHeaderField:"Content-Type")
        } catch {
            print("Error: cannot create JSON from todo")
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else { return completion(.Error(error!.localizedDescription)) }
            
            let httpStatus = response as? HTTPURLResponse
            guard httpStatus?.statusCode == 200 else {
                let statusCode = httpStatus?.statusCode
                print(statusCode ?? 0)
                print(error?.localizedDescription ?? "")
                return completion(.Error(error?.localizedDescription ?? self.constants.errorMessage))
            }
            
            guard let data = data else { return completion(.Error(error?.localizedDescription ?? self.constants.errorMessage))
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: AnyObject] {
                    
                    if json["error"] == nil{
                        guard let itemsJsonArray = json["result"] as? [[String: AnyObject]] else {
                            return completion(.Error(error?.localizedDescription ?? self.constants.errorMessage))
                        }
                        DispatchQueue.main.async {
                            completion(.Success(itemsJsonArray))
                        }
                    } else {
                        let error = json["error"]
                        if (error?.contains("Invalid YOM"))! {
                            DispatchQueue.main.async {
                                completion(.Error(error as! String))
                            }
                        }
                        print(error ?? "")
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
    
    func sendDocuments (param : [UIImage] , endPoint : String, completion: @escaping (Result<[[String: AnyObject]]>) -> Void) {
        
        let urlString = endPoint
        
        guard let url = URL(string: urlString) else {
            return completion(.Error(constants.errorMessage))
        }
        
        let boundary = generateBoundaryString()
        
        var request = URLRequest(url: url as URL)
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = createBodyWithParameters(parameters: param, boundary: boundary) as Data
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else { return completion(.Error(error!.localizedDescription)) }
            
            let httpStatus = response as? HTTPURLResponse
            guard httpStatus?.statusCode == 200 else { return completion(.Error(error?.localizedDescription ?? self.constants.errorMessage))
            }
            
            guard let data = data else { return completion(.Error(error?.localizedDescription ?? self.constants.errorMessage))
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: AnyObject] {
                    DispatchQueue.main.async {
                        completion(.SuccessSingle(json))
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
    
    func createBodyWithParameters(parameters: [UIImage],boundary: String) -> NSData {
        let body = NSMutableData()
        
        var i = 0;
        for image in parameters {
            
            let resizedimage = self.resizeImage(image: image, targetSize: CGSize(width: 1500, height: 1000))
            let filename = "image\(i).jpg"
            let key = "\("license_back")\("[")\(i)\("]")"
            let data = generateJPEGRepresentation(image: resizedimage)
            let mimetype = "image/jpg"
            
            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename)\"\r\n")
            body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
            body.append(data)
            body.appendString(string: "\r\n")
            i += 1;
        }
        body.appendString(string: "--\(boundary)--\r\n")
        return body
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
        
    }
    
    func generateJPEGRepresentation(image: UIImage) -> Data {
        
        let newImage = self.copyOriginalImage(image: image)
        let newData = UIImageJPEGRepresentation(newImage, 0.3)
        
        return newData!
    }
    
    private func copyOriginalImage(image: UIImage) -> UIImage {
        UIGraphicsBeginImageContext(image.size);
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        return newImage!
    }
}

enum Result<T> {
    case SuccessSingle([String: AnyObject])
    case Success([[String: AnyObject]])
    case Error(String)
}

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}

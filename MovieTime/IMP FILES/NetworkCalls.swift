//
//  NetworkCalls.swift
//  Marriager Business
//
//  Created by Anuj  on 25/03/17.
//  Copyright © 2017 Tech Morphosis. All rights reserved.
//

import Foundation
import Alamofire
import SystemConfiguration

enum Method : String{
    case GET = "get"
    case POST = "post"
    case PUT = "put"
    case Multipart = "multipart"
}

enum ErrorType : String{
    case No_Internet = "No internet connection. Tap to try again"
    case Something_Went_Wrong = "Oops! Something went wrong!"
    case WRONG_DATA = "Wrong data"
    case NO_RESULT = "No Result"
    case webServiceError
    case WishlistGuest
    case validationError
    case retry = "Try again"
}

struct NetworkCalls {
    
    typealias Response = (_ success:AnyObject?,_ error : ErrorType?) -> Void
    
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    func callWS(method:Method,url:String,params :[String:Any]? = nil,Url:URL?=nil,reponse:@escaping Response)  {
        print(params)
        if isInternetAvailable(){

            let headers: HTTPHeaders = [
                "MAR-APP-KEY": "bWFycmlhZ2VyX3ZlbmRvcl9hcHA=",
                "Content-Type": "multipart/form-data"
            ]
            
            if method == .GET{
                
                Alamofire.request(url,headers:nil).validate().responseJSON(completionHandler: { (data) in
                    if data.error != nil {
                        print(data.error);
                        reponse(nil,ErrorType.Something_Went_Wrong)
                    }else{
                        reponse(data.result.value as AnyObject?,nil)
                    }
                    
                })
            }else if method == .PUT{
                Alamofire.request(url, method: .put, parameters: params, encoding: URLEncoding.httpBody, headers: nil).validate()
                    .responseJSON { (data) in
                        if data.error != nil {
                            reponse(nil,ErrorType.Something_Went_Wrong)
                        }else{
                            reponse(data.result.value as AnyObject?,nil)
                        }
                }
                
            }else if method == .POST{
                Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).validate()
                     .responseJSON { (data) in
                        if data.error != nil {
                            print(data.error ?? "");
                            reponse(nil,ErrorType.Something_Went_Wrong)
                        }else{
                            reponse(data.result.value as AnyObject?,nil)
                        }
                }
            }
            else if method == .Multipart{
                do{
                    let URL = try! URLRequest(url: "http://themarriager.com/vendorpanel/file_upload/server/php/", method: .post, headers: headers)
                    let fileData = try Data(contentsOf: Url!, options: Data.ReadingOptions.init(rawValue: String.Encoding.utf8.rawValue))
                    print(fileData);
                    let params = ["file_type":"enquiry",
                                  "prefix_name":"THE_WEDDING_STUDIO_INVITATIONS",
                                  "device_type​":"ios"]
                    
                    Alamofire.upload(multipartFormData: { (multipartFormData) in
                        multipartFormData.append(fileData, withName: "files[0]", fileName: "files[0]", mimeType: "text/plain")
                        for (key, value) in params
                        {
                            multipartFormData.append(value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
                        }
                    }, with: URL, encodingCompletion: { (result) in
                        print(result);
                        switch result {
                        case .success(let upload, _, _):
                            upload.uploadProgress(closure: { (progress) in
                                print("Upload Progress: \(progress.fractionCompleted)")
                            })
                            upload.responseJSON { response in
                                reponse(response.result.value as AnyObject?,nil)
                            }
                        case .failure(let encodingError):
                            print(encodingError)
                        }
                    })
                }
                catch{
                }
            }
        }
        else{
            reponse(nil,ErrorType.No_Internet)
        }
    }
    
    
    
}


//
//  KPClient.swift
//  kanpai-ios
//
//  Copyright (c) 2015年 kanpai. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

let KPClientErrorDomain = "com.kanpai.ios.error"

class KPClient {
    
    let baseURL: String
    
    enum Error {
        case Known(Int, String)
        case UnKnown
        
        var object: NSError {
            switch self {
            case .Known(let statusCode, let message):
                return NSError(domain: KPClientErrorDomain, code: statusCode, userInfo: [NSLocalizedDescriptionKey: message])
            case .UnKnown:
                return NSError(domain: KPClientErrorDomain, code: 999, userInfo: nil)
            }
        }
    }
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    private func request(method: Alamofire.Method, _ path: String, params: [String: AnyObject]?, callback: (NSError?, JSON) -> Void) {
        Alamofire.request(method, "\(self.baseURL)\(path)", parameters: params)
        .responseSwiftyJSON { (_, res, json, error) in
            if error != nil {
                return callback(error, json)
            }
            
            if res?.statusCode == 200 {
                return callback(nil, json)
            }
            
            if let msg = json["message"].string {
                return callback(Error.Known(res!.statusCode, msg).object, json)
            }
            
            callback(Error.UnKnown.object, json)
        }
    }
    
    func postParty(party: KPParty, callback: (NSError?, KPParty) -> Void) {
        var params = [
            "owner": party.name,
            "begin_at": party.ISO8601StringForBeginAt()
        ]
        
        if let loc = party.location {
            params["location"] = loc
        }
        
        if let msg = party.message {
            params["message"] = msg
        }
        
        self.request(.POST, "/parties", params: params) { (error, json) in
            if error != nil {
                return callback(error, party)
            }
            
            if json["id"].string == nil {
                return callback(Error.UnKnown.object, party)
            }
            
            party.id = json["id"].string!
            callback(error, party)
        }
    }
    
    func addGuest(guest: KPGuest, to party: KPParty, callback: (NSError?, KPGuest) -> Void) {
        if party.id == nil {
            NSException(name: KPClientErrorDomain, reason: "need a party id to add guest", userInfo: nil).raise()
            return
        }
        
        var params = [
            "name": guest.name,
            "phone_number": guest.phoneNumber
        ]

        self.request(.POST, "/parties/\(party.id!)/guests", params: params) { (error, json) in
            if error != nil {
                return callback(error, guest)
            }
            
            if json["id"].string == nil {
                return callback(Error.UnKnown.object, guest)
            }
            
            guest.id = json["id"].string!
            callback(error, guest)
        }
    }
}


// MARK: - Request for Swift JSON

extension Request {
    
    /**
    Adds a handler to be called once the request has finished.
    
    :param: completionHandler A closure to be executed once the request has finished. The closure takes 4 arguments: the URL request, the URL response, if one was received, the SwiftyJSON enum, if one could be created from the URL response and data, and any error produced while creating the SwiftyJSON enum.
    
    :returns: The request.
    */
    public func responseSwiftyJSON(completionHandler: (NSURLRequest, NSHTTPURLResponse?, SwiftyJSON.JSON, NSError?) -> Void) -> Self {
        return responseSwiftyJSON(queue:nil, options:NSJSONReadingOptions.AllowFragments, completionHandler:completionHandler)
    }
    
    /**
    Adds a handler to be called once the request has finished.
    
    :param: queue The queue on which the completion handler is dispatched.
    :param: options The JSON serialization reading options. `.AllowFragments` by default.
    :param: completionHandler A closure to be executed once the request has finished. The closure takes 4 arguments: the URL request, the URL response, if one was received, the SwiftyJSON enum, if one could be created from the URL response and data, and any error produced while creating the SwiftyJSON enum.
    
    :returns: The request.
    */
    public func responseSwiftyJSON(queue: dispatch_queue_t? = nil, options: NSJSONReadingOptions = .AllowFragments, completionHandler: (NSURLRequest, NSHTTPURLResponse?, JSON, NSError?) -> Void) -> Self {
        
        return response(queue: queue, serializer: Request.JSONResponseSerializer(options: options), completionHandler: { (request, response, object, error) -> Void in
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                
                var responseJSON: JSON
                if error != nil || object == nil{
                    responseJSON = JSON.nullJSON
                } else {
                    responseJSON = SwiftyJSON.JSON(object!)
                }
                
                dispatch_async(queue ?? dispatch_get_main_queue(), {
                    completionHandler(self.request, self.response, responseJSON, error)
                })
            })
        })
    }
}

//
//  Url.swift
//  Url Shortener
//
//  Created by Michael Peterson on 11/14/15.
//  Copyright © 2015 Michael Peterson. All rights reserved.
//

import Foundation
import Alamofire

class Url: CustomStringConvertible, Hashable {
    var originalUrl: String = ""
    var shortUrl: String = ""
    var numClicks: Int = 0
    
    init() {
    }
    
    convenience init(originalUrl: String, shortUrl: String, numClicks: Int) {
        self.init()
        self.originalUrl = originalUrl
        self.shortUrl = shortUrl
        self.numClicks = numClicks
    }
    
    convenience init(json: AnyObject) {
        if let
            dict = json as? Dictionary<String, AnyObject>,
            originalUrl = dict["originalUrl"] as? String,
            shortUrl = dict["shortUrl"] as? String,
            numClicks = dict["numClicks"] as? Int {
                self.init(originalUrl: originalUrl, shortUrl: shortUrl, numClicks: numClicks)
        }
            
            
        else {
            self.init()
        }
    }
    
    func setData(json: AnyObject) {
        if let
            dict = json as? Dictionary<String, AnyObject>,
            originalUrl = dict["originalUrl"] as? String,
            shortUrl = dict["shortUrl"] as? String,
            numClicks = dict["numClicks"] as? Int {
                self.originalUrl = originalUrl
                self.shortUrl = shortUrl
                self.numClicks = numClicks
        }
    }
    
    func getFullShortUrl(baseUrl: String) -> String {
        return "\(baseUrl)/\(shortUrl)"
    }
    
    func getInfo(baseUrl: String, callback: () -> Void) {
        Alamofire.request(.GET, "\(getFullShortUrl(baseUrl))/info")
            .responseJSON(completionHandler: {response in
                if let json = response.result.value {
                    self.setData(json)
                    callback()
                }
            })
    }
    
    static func putNewUrl(baseUrl: String, originalUrl: String, callback: (url: Url) -> Void) {
        Alamofire.request(.PUT, baseUrl, parameters: ["originalUrl": originalUrl], encoding: .JSON)
            .responseJSON(completionHandler: {response in
                if let json = response.result.value {
                    let newUrl = Url(json: json)
                    callback(url: newUrl)
                }
            });
    }
    
    var hashValue: Int {
        get {
            return shortUrl.hashValue
        }
    }
    
    var description: String {
        get {
            return "originalUrl: \(originalUrl), shortUrl: \(shortUrl), numClicks: \(numClicks)"
        }
    }
}

func ==(lhs: Url, rhs: Url) -> Bool {
    return lhs.shortUrl == rhs.shortUrl
}
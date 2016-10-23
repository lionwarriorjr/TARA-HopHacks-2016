//
//  MedchatClient.swift
//  Medchat
//
//  Created by Srihari Mohan on 10/22/16.
//  Copyright © 2016 Srihari Mohan. All rights reserved.
//

import Foundation

class MedchatClient {
    
    var sessionID : String? = nil
    
    static func taskForGETMethod(method: String, parameters: [String:AnyObject], completionHandlerForGET: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        /* 1. Set the parameters */
        var parametersWithApiKey = parameters
        parametersWithApiKey[ParameterKeys.ApiKey] = Constants.ApiKey
        parametersWithApiKey[ParameterKeys.UserKey] = Constants.UserKey
        parametersWithApiKey[ParameterKeys.BotName] = Constants.BotName
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(URL: URLFromParameters(parametersWithApiKey, withPathExtension: method))
        request.HTTPMethod = "GET"
        
        /* 4. Make the request */
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(result: nil, error: NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        /* 7. Start the request */
        task.resume()
        return task;
    }
    
    // MARK: POST
    
    static func taskForPOSTMethod(method: String, parameters: [String:AnyObject], completionHandlerForPOST: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let request = MedchatClient.setupBotRequest(method, parameters: parameters)
        return MedchatClient.setupTask(request, completionHandlerForPOST: completionHandlerForPOST);
    }
    
    static func taskForPOSTSpeech(method: String, parameters: [String:AnyObject], completionHandlerForPOST: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        let request = MedchatClient.setupSTTRequest(method, parameters: parameters)
        return MedchatClient.setupTask(request, completionHandlerForPOST: completionHandlerForPOST);
    }
    
    static func setupSTTRequest(method: String, parameters: [String:AnyObject]) -> NSMutableURLRequest {
        let loginString = NSString(format: "%@:%@", Constants.SpeechUserKey, Constants.SpeechPassKey)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.init(rawValue: 0))
        let url = NSURL(string: "https://stream.watsonplatform.net/speech-to-text/api/v1/recognize")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        request.addValue("audio/l16;rate=16000", forHTTPHeaderField: "content-type")
        request.HTTPBody = NSData(contentsOfURL: ChatViewController.getFileURL())
        print(request)
        return request;
    }
    
    static func setupBotRequest(method: String, parameters: [String:AnyObject]) -> NSMutableURLRequest {
        
        var parametersWithApiKey = parameters
        parametersWithApiKey[ParameterKeys.ApiKey] = Constants.ApiKey
        parametersWithApiKey[ParameterKeys.UserKey] = Constants.UserKey
        parametersWithApiKey[ParameterKeys.BotName] = Constants.BotName
        
        let request = NSMutableURLRequest(URL: URLFromParameters(parametersWithApiKey, withPathExtension: method))
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request;
    }
    
    static func setupTask(request: NSMutableURLRequest, completionHandlerForPOST: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(error: String) {
                NSLog(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(result: nil, error: NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
            }
            
            if error == nil {
                
                guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where
                    statusCode >= 200 && statusCode <= 299 else {
                        sendError("Status code not of form 2xx")
                        return
                }
                
                guard let data = data else {
                    sendError("No data was returned by the request")
                    return
                }
                
                NSLog("Status Code OK -> Data Parsed")
                
                self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
                
            } else {
                sendError("There was an error with your request \(error)")
                return
            }
        }
        
        task.resume()
        return task;
    }
    
    static func URLFromParameters(parameters: [String:AnyObject], withPathExtension: String? = nil) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = Constants.ApiScheme
        components.host = Constants.ApiHost
        components.path = (withPathExtension ?? "")
        components.queryItems = [NSURLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.URL!
    }
    
    static func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(result: parsedResult, error: nil)
    }
    
    class func sharedInstance() -> MedchatClient {
        struct Singleton {
            static var sharedInstance = MedchatClient()
        }
        return Singleton.sharedInstance
    }
}
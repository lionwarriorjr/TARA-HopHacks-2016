//
//  Constants.swift
//  Medchat
//
//  Created by Srihari Mohan on 10/22/16.
//  Copyright © 2016 Srihari Mohan. All rights reserved.
//

import Foundation

extension MedchatClient {
    
    struct Constants {
    
        // MARK: API Key
        static let ApiKey : String = "1409612731603"
        static let SpeechUserKey : String = "5e793dce-e0ac-4182-8b6e-ecce139f1999"
        static let UserKey : String = "1d73aa646ec7c0ba7335e6e96eb9c3e0"
        static let SpeechPassKey : String = "IuaGvzu4kGgK"
        static let BotName : String = "flochat"
        
    
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "aiaas.pandorabots.com"
        static let SpeechApiHost = "stream.watsonplatform.net/speech-to-text/api"
    }
    
    // MARK: Methods
    struct Methods {
        
        // MARK: Account
        static let Talk = "/talk/{app_id}/{botname}"
        /* For speech-to-text (SST) IBM Watson */
        static let STT = "/v1/recognize"
    }
    
    // MARK: URL Keys
    struct URLKeys {
        static let AppID = "app_id"
        static let BotName = "botname"
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        static let ApiKey = "app_id"
        static let UserKey = "user_key"
        static let BotName = "botname"
        static let SessionID = "sessionid"
        static let Input = "input"
        static let ClientName = "client_name"
        static let Recent = "recent"
        /* For speech-to-text (STT) IBM Watson */
        static let SpeechUserKey = "username"
        static let SpeechPassKey = "password"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: General
        static let Responses = "responses"
        
        // MARK: Authorization
        static let SessionID = "sessionid"
        
        // MARK: SST
        static let Results = "results"
        static let Alternatives = "alternatives"
        static let Transcript = "transcript"
    }
}
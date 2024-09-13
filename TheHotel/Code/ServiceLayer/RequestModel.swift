//
//  RequestModel.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 12/6/24.
//

import Foundation

struct RequestModel  {
    let endpoint : Endpoints
    var queryItems : [String:String]?
    var paramItems : [String:String]?
    var jsonBody : [String:Any]?
    var httpMethod : HttpMethod = .GET
    var baseUrl : URLBase = .urlBase
    var queryparam : String?
    private let Kapikey: String = "apikey"
    private let apiKeyValue: String = NetworkConstants.shared.apikey
    
    
    func getURL() -> String{
        var endpointString = endpoint.rawValue
        
        if let param = queryparam {
            endpointString = endpointString.replacingOccurrences(of: "%@", with: param)
        }else {
            endpointString = endpointString.replacingOccurrences(of: "/%@", with: "")
        }
        
        
        return baseUrl.rawValue + endpointString
    }
    
    enum HttpMethod : String{
        case GET
        case POST
    }

    enum Endpoints : String   {
        case empty = ""
    }

    enum URLBase {
        case urlBase

        var rawValue: String {
            switch self {
            case .urlBase:
                return NetworkConstants.shared.baseURLApi
            }
        }
    }
    
   
}

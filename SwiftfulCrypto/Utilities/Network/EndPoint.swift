//
//  EndPoint.swift
//  sm_gai_driver
//
//  Created by omarmattr on 13/08/2022.
//

enum EndPoint :Equatable {
    
    case markets, customURL,global,coinDetail(_:String)
    
    var stringValue: String {
        switch self {
        case .markets:
            return  "api/v3/coins/markets"
        case .customURL:
            return ""
        case .global:
            return "api/v3/global"
        case .coinDetail(let name):
            return "api/v3/coins/\(name)"
        }
    }
}

//
//  Result.swift
//  sm_gai_driver
//
//  Created by OmarMattr on 29/07/2022.
//

import Foundation

public class Result<T>  {
    let status: Status!
    let message: String?
    let data: T?
    
    private init( _ status: Status,_ message: String?,_ data: T?){
        self.status = status
        self.message = message
        self.data = data
    }
    
    enum  Status {
        case SUCCESS, ERROR, LOADING, EMPTY
    }
    
    static func success(_ data: T)-> Result<T> {
        return Result(.SUCCESS, nil, data)
    }
    
    static func  success(_ data: T,_ message: String?)-> Result<T> {
        return Result(.SUCCESS, message, data)
    }
    
    static func  error(_ msg: String?) ->  Result<T> {
        return Result(.ERROR, msg, nil)
    }
    
    static func  loading(_ data: T?)-> Result<T> {
        return Result(.LOADING, nil, data)
    }
    
    static  func  empty(_ data: T)-> Result<T> {
        return Result(.EMPTY, nil, data)
    }
    
}


enum Response <T: Codable > :Codable {
    case success(T)
    case failure(String?)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            let userData = try container.decode(T.self)
            self = .success(userData)
        } catch DecodingError.typeMismatch {
            if let errorData = try? container.decode(Int.self){
                self = .failure(String(errorData))
                
            }
            let errorData = try container.decode(String.self)
            self = .failure(String(errorData))
            
        }
    }
}

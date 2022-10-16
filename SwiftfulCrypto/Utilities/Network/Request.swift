//
//  Request.swift
//  sm_gai_driver
//
//  Created by omarmattr on 13/08/2022.
//

fileprivate let BASE_URL = "https://api.coingecko.com/"
import Foundation

struct Request {
    var endPoint: EndPoint!
    var method : HTTPMethod = .post
    var headers  =  [String: String]()
    var parameters = [String: Any]()
    var otherPath = ""
    var path : String {
        get {
            if endPoint == .customURL {
                return self.otherPath
            }
            return BASE_URL + endPoint.rawValue
        }
        
    }
    var request : URLRequest? {
        get{
            guard let url = URL(string: path) else { return nil }
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue

                if method == .get {
                    var queryItems : [URLQueryItem] = []
                    parameters.forEach {  (key , value)  in
                        queryItems.append(URLQueryItem(name: key, value: "\(value)"))
                    }
                    var urlComps = URLComponents(string: path)!
                    urlComps.queryItems = queryItems
                    request.url = urlComps.url!
                   
                }else {
                    do {
                        request.httpBody =  try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                    } catch let error {
                        print(error.localizedDescription)
                    }
                }
            headers.forEach { (key , value) in
                request.addValue(value, forHTTPHeaderField: key)
            }

            return request
        }
    }
    
}
enum HTTPMethod :String{
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    
}

struct Convert<T:Codable>{
    func convertToData(data: T)->Data?{
        do {
            return try JSONEncoder().encode(data)
        } catch {
            return nil
        }
    }
    func convertFromData(data: Data)->T?{
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            return nil
        }
    }
}

//
//  NetworkingManager.swift
//  SwiftfulCrypto
//
//  Created by OmarMattr on 12/10/2022.
//

import Foundation
import Combine

class NetworkingManager {
    static var network = NetworkingManager()
    
    var subscription: AnyCancellable?
    
    private init() {
    }
    func download <T: Codable>(_ request: Request,decodeToType type: T.Type,completionHandler: @escaping (T) -> ()){
        guard let request = initRequest(request) else {return}
        subscription =  download(request: request)
            .decode (type: T.self, decoder: JSONDecoder ())
            .sink(receiveCompletion: handleCompletion, receiveValue: { [weak self] (data) in
               
                completionHandler(data)
                self?.subscription?.cancel()
            })
        
    }
    
     func download (request: URLRequest) -> AnyPublisher<Data,Error> {
        return URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap{ (output) -> Data in
                guard let response = output.response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .receive (on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
    }
    
    func handleCompletion (completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print (error.localizedDescription)
        }
    }
    
    private func initRequest(_ request: Request) -> URLRequest? {
        guard let url = URL(string: request.path) else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        request.headers.forEach { (key , value) in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        if request.method == .get {
            var queryItems : [URLQueryItem] = []
            request.parameters.forEach {  (key , value)  in
                queryItems.append(URLQueryItem(name: key, value: "\(value)"))
            }
            var urlComps = URLComponents(string: request.path)!
            urlComps.queryItems = queryItems
            urlRequest.url = urlComps.url!
            
        }else {
            do {
                urlRequest.httpBody =  try JSONSerialization.data(withJSONObject: request.parameters, options: .prettyPrinted)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        return urlRequest
    }
    
}



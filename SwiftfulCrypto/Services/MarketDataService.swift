//
//  MarketDataService.swift
//  SwiftfulCrypto
//
//  Created by OmarMattr on 18/10/2022.
//

import Foundation
import Combine

class MarketDataService {
    private let network = NetworkingManager()
    private var request = Request()
    @Published var data : MarketDataModel? = nil
    private var subscription: AnyCancellable?
    init(){
        getData()
    }
    
    func getData(){
        request.endPoint = .global
        request.method  = .get
        network.download(request,decodeToType: GlobalData.self) { data in
            self.data = data.data
        }
    }
 
    
}

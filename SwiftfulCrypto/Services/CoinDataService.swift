//
//  CoinDataService.swift
//  SwiftfulCrypto
//
//  Created by OmarMattr on 12/10/2022.
//

import Foundation
import Combine

class CoinDataService {
    private let network = NetworkingManager()
    private  var request = Request()
    @Published var coins : [CoinModel] = []
        
    init(){
        getCoins()
    }
    
    func getCoins() -> Void{
        request.endPoint = .markets
        request.method = .get
        request.parameters = ["vs_currency":"usd","order":"market_cap_desc","per_page":250,"page":1,"sparkline":true,"price_change_percentage":"24h"]
        network.download(request,decodeToType: [CoinModel].self) { data in
            self.coins = data
        }
        
    }
    
}

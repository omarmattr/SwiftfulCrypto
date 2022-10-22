//
//  CoinDetailDataService.swift
//  SwiftfulCrypto
//
//  Created by OmarMattr on 22/10/2022.
//

import Foundation
import Combine

class CoinDetailDataService {
    @Published var data : CoinDetailModel? = nil

    private let coinName:String
    private let network = NetworkingManager()
    private  var request = Request()
    
    init(coinName:String){
        self.coinName = coinName
        getData()
    }
    
    func getData() -> Void{
        request.endPoint = .coinDetail(coinName)
        request.method = .get
        request.parameters = ["localization":false,"tickers":false,"market_data":false,"community_data":false,"developer_data":false,"sparkline":false]
        network.download(request,decodeToType: CoinDetailModel.self) { data in
            self.data = data
            print(data)
        }
        
    }
    
}

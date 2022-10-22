//
//  DetailViewModel.swift
//  SwiftfulCrypto
//
//  Created by OmarMattr on 22/10/2022.
//

import Foundation
import Combine

class DetailViewModel:ObservableObject{
    @Published var data : CoinDetailModel?

    private let coinService : CoinDetailDataService
    private var cancellables = Set<AnyCancellable> ()

    init(coinName:String) {
        self.coinService = CoinDetailDataService(coinName: coinName)
    }
    func addSubscribers() {
        coinService.$data.sink { data in
            self.data = data
        }
        .store(in: &cancellables)
    }
}

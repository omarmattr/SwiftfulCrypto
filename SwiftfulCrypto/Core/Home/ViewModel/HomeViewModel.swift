//
//  HomeViewModel.swift
//  SwiftfulCrypto
//
//  Created by OmarMattr on 12/10/2022.
//

import Foundation
import Combine

class HomeViewModel : ObservableObject {
    @Published var allCoins : [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchText = ""
    
    private let dataService = CoinDataService()
    private var cancellables = Set<AnyCancellable> ()
    
    init(){
        addSubscribers()
    }
    func downloadData(){
        
    }
    func addSubscribers() {
        $searchText.combineLatest(dataService.$coins)
            .debounce(for: 0.5 , scheduler: DispatchQueue.main)
            .map{(text,coins) -> [CoinModel] in
                guard !text.isEmpty else {
                    return coins
                }
                return coins.filter { coin in
                    return coin.name.contains(text.lowercased()) ||
                    coin.symbol.contains(text.lowercased()) ||
                    coin.id.contains(text.lowercased())
                }
            }
            .sink{ [weak self] (coins) in
                self?.allCoins = coins
            }
            .store(in: &cancellables)
            
    }
}

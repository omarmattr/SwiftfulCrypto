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
        dataService.$coins
            .sink{ [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
    }
}

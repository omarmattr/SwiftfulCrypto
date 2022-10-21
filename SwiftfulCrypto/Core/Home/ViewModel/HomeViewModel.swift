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
    @Published var statistics: [StatisticModel] = []
    @Published var loading  =  false
    @Published var sortOption:SortOption = .holdings
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cancellables = Set<AnyCancellable> ()
    
    init(){
        addSubscribers()
    }
    func reloadData(){
        loading = true
        coinDataService.getCoins()
        marketDataService.getData()
        HapticManager.notification(type: .success   )
    }
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.update(coin: coin, amount: amount)
    }
    func addSubscribers() {
        
        $searchText.combineLatest(coinDataService.$coins,$sortOption)
        .debounce(for: 0.5 , scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink{ [weak self] (coins) in
                self?.allCoins = coins
                self?.loading = false                
            }
            .store(in: &cancellables)
        
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map{ (coinModels, portfolioEntities) -> [CoinModel] in
                coinModels
                    .compactMap { (coin) -> CoinModel? in
                        guard let entity = portfolioEntities.first (where: { $0.coinID == coin.id }) else {
                            return nil}
                        return coin.updateHoldings (amount: entity.amount)
                    }
            }
            .sink { [weak self] (returnedCoins) in
                var returnedCoins = returnedCoins
                self?.sortPortfolioCoinsIfNeeded(coins: &returnedCoins)
                self?.portfolioCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        marketDataService.$data
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData).sink { data in
                self.statistics = data
            }
            .store(in: &cancellables)
        
        
        
    }
    private func filterAndSortCoins (text: String, coins: [CoinModel], sort: SortOption) -> [CoinModel]{
        var updatedCoins = filterCoins (text: text, coins: coins)

        sortCoins (sort: sort, coins: &updatedCoins)
        return updatedCoins
    }
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
          guard !text.isEmpty else {
            return coins
        }
        let lowercasedText = text.lowercased()
        return coins.filter { (coin) -> Bool in
            return coin.name.lowercased () . contains (lowercasedText) ||
            coin.symbol.lowercased() .contains (lowercasedText) || coin.id.lowercased () .contains (lowercasedText)
        }
    }
    private func sortCoins (sort: SortOption, coins: inout [CoinModel])  {
        switch sort {
        case .rank, .holdings:
            coins.sort(by: { $0.rank < $1.rank })
        case .rankReversed, .holdingsReversed:
            coins.sort(by: { $0.rank > $1.rank })
        case .price:
            coins.sort(by: { $0.currentPrice > $1.currentPrice })
        case .priceReversed:
            coins.sort(by: { $0.currentPrice < $1.currentPrice })
        }
    }
    private func sortPortfolioCoinsIfNeeded (coins: inout  [CoinModel]) {
        // will only sort by holdings or reversedholdings if needed
        switch sortOption {
        case .holdings:
             coins.sort(by: { $0.currentHoldingsValue > $1.currentHoldingsValue })
        case  .holdingsReversed:
             coins.sort(by: { $0.currentHoldingsValue < $1.currentHoldingsValue })
        default:
            return
        }
    }
    private func mapGlobalMarketData(data:MarketDataModel?,coins:[CoinModel])->[StatisticModel]{
        var  stats : [StatisticModel] = []
        guard  let data = data else {
            return stats
        }
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange:data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        let bcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        let portfolioValue = (coins.map { $0.currentHoldingsValue}).reduce(0, +)
        
        let previousValue =
        coins.map { (coin) -> Double in
            let currentValue = coin.currentHoldingsValue
            let percentChange = coin.priceChangePercentage24H! / 100
            return currentValue / (1 + percentChange)
        }.reduce(0, +)
        let percentageChange = ((portfolioValue - previousValue) / previousValue) * 100
        
        let portfolio = StatisticModel(title: "Portfolio Value",value: portfolioValue.asCurrencyWith2Decimals(), percentageChange: percentageChange)
        
        stats.append(contentsOf: [marketCap, volume, bcDominance, portfolio])
        return stats
    }
    enum SortOption {
        case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
    }
}


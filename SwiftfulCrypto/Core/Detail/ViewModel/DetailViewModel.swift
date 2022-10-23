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
    @Published var overviewStatistic : [StatisticModel] = []
    @Published var additionalStatistics : [StatisticModel] = []
    @Published var coinDescription : String? = nil
    @Published var websiteURL : String? = nil
    @Published var redditURL : String? = nil
    
    @Published var coin: CoinModel
    
    private let coinService : CoinDetailDataService
    private var cancellables = Set<AnyCancellable> ()
    
    init(coin: CoinModel) {
        self.coin = coin
        self.coinService = CoinDetailDataService(coinName: coin.id)
        addSubscribers()
    }
    func addSubscribers() {
        coinService.$data
            .combineLatest($coin)
            .map(mapDataToStatistics)
            .sink { data in
                self.overviewStatistic  = data.overview
                self.additionalStatistics  = data.additional
            }
            .store(in: &cancellables)
        
        coinService.$data
            .sink {[weak self] (returnedCoinDetails) in
                self?.coinDescription = returnedCoinDetails?.readableDescription
                self?.websiteURL = returnedCoinDetails?.links?.homepage?.first
                self?.redditURL = returnedCoinDetails?.links?.subredditURL
            }
            . store(in: &cancellables)
    }
        func mapDataToStatistics(data:CoinDetailModel?, coin : CoinModel )-> (overview : [StatisticModel], additional : [StatisticModel]){
            let price = coin.currentPrice.asCurrencyWith6Decimals()
            let pricePercentChange = coin.priceChangePercentage24H
            
            let priceStat = StatisticModel(title: "Current Price", value: price, percentageChange: pricePercentChange)
            let marketCap = "$" + (coin.marketCap?.formattedWithAbbreviations() ?? "")
            
            let marketCapHercentChange = coin.marketCapChangePercentage24H
            let marketCapStat = StatisticModel(title: "Market Capitalization", value: marketCap, percentageChange:
                                                marketCapHercentChange)
            
            let rank = "\(coin.rank)"
            let rankStat = StatisticModel(title: "Rank", value: rank)
            
            let volume = "$" + (coin.totalVolume?.formattedWithAbbreviations () ?? "")
            let volumeStat = StatisticModel (title: "Volume", value: volume)
            
            // additional
            
            let high = coin.high24H?.asCurrencyWith6Decimals() ?? "n/a"
            let highStat = StatisticModel(title: "24h High", value: high)
            
            let low = coin.low24H?.asCurrencyWith6Decimals()  ?? "n/a"
            let lowStat = StatisticModel(title: "24h Low", value: low)
            
            let priceChange = coin.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
            let pricePercentChange2 = coin.priceChangePercentage24H
            let priceChangeStat = StatisticModel(title: "24h Price Change", value: priceChange, percentageChange: pricePercentChange2)
            
            let marketCapChange = "$" + (coin.marketCapChange24H?.formattedWithAbbreviations() ?? "")
            let marketCapPercentChange2 = coin.marketCapChangePercentage24H
            let marketCapChangeStat=StatisticModel(title:"24h Market Cap Change", value: marketCapChange, percentageChange:
                                                    marketCapPercentChange2)
            
            let blockTime = data?.blockTimeInMinutes ?? 0
            let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
            let blockStat = StatisticModel(title: "Block Time", value: blockTimeString)
            
            let hashing = data?.hashingAlgorithm ?? "n/a"
            let hashingStat = StatisticModel(title: "Hashing Algorithm", value: hashing)
            
            return ([priceStat, marketCapStat, rankStat, volumeStat],[highStat, lowStat, priceChangeStat, marketCapChangeStat, blockStat, hashingStat])
            
        }
    }

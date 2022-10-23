//
//  PreviewProvider.swift
//  SwiftfulCrypto
//
//  Created by Nick Sarno on 5/9/21.
//

import Foundation
import SwiftUI

extension PreviewProvider {
    
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
    
}

class DeveloperPreview {
    
    static let instance = DeveloperPreview()
    private init() {
        homeVM.allCoins = [coin]
    }
    
    let homeVM = HomeViewModel()
    
    
    let stat1 = StatisticModel(title: "Market Cap", value: "$12.5Bn", percentageChange: 25.34)
    let stat2 = StatisticModel(title: "Total Volume", value: "$1.23Tr")
    let stat3 = StatisticModel(title: "Portfolio Value", value: "$50.4k", percentageChange: -12.34)
    
    let coin = CoinModel(
        id: "bitcoin",
        symbol: "btc",
        name: "Bitcoin",
        image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579",
        currentPrice: 61408,
        marketCap: 1141731099010,
        marketCapRank: 1,
        fullyDilutedValuation: 1285385611303,
        totalVolume: 67190952980,
        high24H: 61712,
        low24H: 56220,
        priceChange24H: 3952.64,
        priceChangePercentage24H: 6.87944,
        marketCapChange24H: 72110681879,
        marketCapChangePercentage24H: 6.74171,
        circulatingSupply: 18653043,
        totalSupply: 21000000,
        maxSupply: 21000000,
        ath: 61712,
        athChangePercentage: -0.97589,
        athDate: "2021-03-13T20:49:26.606Z",
        atl: 67.81,
        atlChangePercentage: 90020.24075,
        atlDate: "2013-07-06T00:00:00.000Z",
        lastUpdated: "2021-03-13T23:18:10.268Z",
        sparklineIn7D: SparklineIn7D(price:[19155.117811593547,19182.69153042117,19126.116118137073,19147.511212753012,19133.660229066776,19130.72198492508,19109.447580075503,19128.201866565036,19101.504982458206,19095.300858664385,19074.771421880847,19072.122652041628,19072.780513358884,19126.552320075007,19149.61908538506,19119.86185208045,19123.185811934487,19142.80280327335,19146.540336102124,19132.776972301806,19135.333208505253,19170.061536656907,19144.832244439614,19129.923892576495,19138.264616297172,19139.83923818251,19134.72402486814,19126.722216849274,19160.86332202918,19141.29630435813,19127.597696793342,19121.881237442118,19334.24835173174,19334.63933843128,19244.151692289328,19331.759403141215,19274.21494495987,19210.62602860393,19207.061038346048,19186.51353085701,19180.102975640068,19224.736974075167,19265.908824413542,19253.11945649304,19265.688323690378,19265.305089428162,19345.203573031315,19391.506330441614,19454.14655117412,19515.480952537582,19601.539194645306,19500.428455484052,19550.386605346102,19502.87364837517,19522.29765467499,19516.112024301474,19532.01873421546,19535.676712352968,19519.808748695992,19502.8226459347,
        ]),
        priceChangePercentage24HInCurrency: 3952.64,
        currentHoldings: 1.5)
    
}


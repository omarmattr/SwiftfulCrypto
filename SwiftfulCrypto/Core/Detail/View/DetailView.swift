//
//  DetailView.swift
//  SwiftfulCrypto
//
//  Created by OmarMattr on 21/10/2022.
//

import SwiftUI
struct DetailView: View {
    @StateObject private var vm : DetailViewModel
    var coin : CoinModel
    init(coin: CoinModel) {
        self.coin = coin
        _vm = StateObject(wrappedValue: DetailViewModel(coinName: coin.id))
        
    }
    var body: some View {
        ZStack{}
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(coin: dev.coin)
    }
}


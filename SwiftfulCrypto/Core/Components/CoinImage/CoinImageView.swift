//
//  CoinImageView.swift
//  SwiftfulCrypto
//
//  Created by OmarMattr on 14/10/2022.
//

import SwiftUI

struct CoinImageView: View {
    @StateObject private var vm : CoinImageViewModel
    init(coin:CoinModel) {
        self._vm = StateObject(wrappedValue: CoinImageViewModel(coin: coin))
    }
    var body: some View {
        ZStack{
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }else if vm.loading {
                ProgressView()
            }else{
                Image(systemName: "questionmark" )
                    .foregroundColor (Color.theme.secondaryText)
            }
        }
    }
}

struct CoinImageView_Previews: PreviewProvider {
    static var previews: some View {
        CoinImageView(coin: dev.coin)
            .previewLayout(.sizeThatFits)
    }
}

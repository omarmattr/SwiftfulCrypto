//
//  PortfolioView.swift
//  SwiftfulCrypto
//
//  Created by OmarMattr on 18/10/2022.
//

import SwiftUI

struct PortfolioView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var vm:HomeViewModel
    @State private var selectedCoin: CoinModel? = nil
    @State private var quantityText: String = ""
    @State private var showCheckmark =  false
    
    var body: some View {
        NavigationView {
            ScrollView{
                VStack(alignment: .leading, spacing: 0){
                    SearchBarView(text: $vm.searchText)
                    listView
                    if selectedCoin != nil {
                        portfolioInputSection
                    }
                }
                
            }
            .navigationTitle("Edit Portfolio")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {  Button {  dismiss() } label: { XMarkView()}}
                ToolbarItem(placement: .navigationBarTrailing) {  trailingNavBarButtons }
                
                
            }
            .onChange(of: vm.searchText) { text in
                if text == "" {
                    removeSelectedCoin()
                }
            }
        }
        
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
            .environmentObject(dev.homeVM)
    }
}

extension PortfolioView  {
    private func updateSelectedCoin (coin: CoinModel) {
        selectedCoin = coin
        if let portfolioCoin = vm.portfolioCoins.first (where: { $0.id == coin.id }) ,let amount = portfolioCoin.currentHoldings{
            quantityText = "\(amount)"
        }else{
            quantityText = ""
        }
        
    }
    private func getCurrentValue ( ) -> Double {
        if let quantity = Double (quantityText) {
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
    private var portfolioInputSection : some View {
        VStack(spacing: 20) {
            HStack {
                Text ("Current price of \(selectedCoin?.symbol.uppercased () ?? ""):")
                Spacer ()
                Text (selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
            }
            Divider()
            HStack {
                Text ("Amount in your portfolio:")
                Spacer ()
                TextField("Ex: 1.4", text: $quantityText)
                    .multilineTextAlignment (.trailing)
                    .keyboardType(.decimalPad)
            }
            Divider ()
            HStack {
                Text ("Current value:")
                Spacer ()
                Text (getCurrentValue().asCurrencyWith2Decimals())
            }
            
        }
        .padding()
        .font (.headline)
        
    }
    
    private  var listView : some View {
        ScrollView(.horizontal,showsIndicators: true){
            LazyHStack(spacing: 10){
                ForEach(vm.searchText.isEmpty ? vm.portfolioCoins : vm.allCoins){ coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .onTapGesture {
                            withAnimation {
                              updateSelectedCoin(coin: coin)
                            }
                        }
                        .background(RoundedRectangle(cornerRadius: 10)
                            .stroke(selectedCoin?.id  == coin.id ? Color.theme.green :Color.clear,lineWidth: 1))
                    
                }
            }
            .frame(height: 120)
            .padding(.vertical,4)
            
        }
    }
    private var trailingNavBarButtons: some View {
        HStack(spacing: 10) {
            Image( systemName: "checkmark" )
                .opacity (showCheckmark ? 1.0 : 0.0)
            Button (action: {
                saveButtonPressed()
            }, label: {
                Text ("Save".uppercased())
                    .opacity ((selectedCoin != nil && selectedCoin?.currentHoldings != Double (quantityText)) ? 1.0: 0.0)
                    .font (.headline)
            })
        }
    }
    private func saveButtonPressed() {
        guard let coin = selectedCoin ,let amount = Double(quantityText) else { return }
        vm.updatePortfolio(coin: coin, amount: amount)
        
        withAnimation (.easeIn) {
            showCheckmark = true
            removeSelectedCoin()
            
        }
        UIApplication.shared.endEditing()
        
        DispatchQueue.main.asyncAfter (deadline: .now() + 2.0) {
            withAnimation (.easeOut) {
                showCheckmark = false
            }
        }
    }
    private func removeSelectedCoin() {
        selectedCoin = nil
        vm.searchText = ""
        
    }
    
}

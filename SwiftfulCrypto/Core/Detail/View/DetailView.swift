//
//  DetailView.swift
//  SwiftfulCrypto
//
//  Created by OmarMattr on 21/10/2022.
//

import SwiftUI
struct DetailView: View {
    
    @StateObject private var vm : DetailViewModel
    @State private var showMoreDes = false
    private let columns = [GridItem(.flexible()),GridItem(.flexible())]
    private let spacing : CGFloat = 30
    
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    
    var body: some View {
        ScrollView{
            VStack() {
                ChartView(coin: vm.coin)
                    .padding(.vertical)
                VStack(spacing: 20) {
                    overviewTitle
                    Divider()
                    desSection
                    overviewGrid
                    additionalTitle
                    Divider()
                    additionalGrid
                    websiteSection
                    
                }
                .padding(.horizontal,10)
            }
        }
        .navigationTitle(vm.coin.name)
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                navigationBarTrailingItems
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(coin: dev.coin)
        }
        
    }
}
extension DetailView{
    private var navigationBarTrailingItems: some View {
        HStack {
            Text (vm.coin.symbol.uppercased())
                . font (.headline)
                .foregroundColor (Color.theme.secondaryText)
            CoinImageView (coin: vm.coin)
                .frame (width: 25, height: 25)
        }
    }
    
    private var overviewTitle : some View{
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity,alignment: .leading)
    }
    
    private var additionalTitle  : some View{
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity,alignment: .leading)
    }
    
    private var overviewGrid : some View{
        LazyVGrid(columns: columns,alignment: .leading, spacing: spacing) {
            ForEach(vm.overviewStatistic){ stat in
                StatisticView(stat: stat)
            }
        }
    }
    
    private var additionalGrid : some View{
        LazyVGrid(columns: columns,alignment: .leading, spacing: spacing) {
            ForEach(vm.additionalStatistics){ stat in
                StatisticView(stat: stat)
            }
        }
    }
    private var desSection:some View {
        ZStack{
            if let des = vm.coinDescription , !des.isEmpty{
                VStack(alignment: .leading){
                    Text(des)
                        .lineLimit(showMoreDes ? nil : 3 )
                        .font(.callout)
                        .foregroundColor(Color.theme.secondaryText)
                    
                    Button {
                        withAnimation(.easeInOut){
                            showMoreDes.toggle()
                        }
                    } label: {
                        Text(showMoreDes ? "Less" : "Read more...")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.vertical,4)
                    }
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .accentColor(.blue)
                    
                }
                
            }
        }
    }
    
    private var websiteSection: some View {
        VStack(alignment: .leading,spacing: 20){
            if let link = vm.websiteURL ,  let url = URL(string: link) {
                Link("website", destination: url)
            }
            if let link = vm.redditURL ,  let url = URL(string: link) {
                Link("Reddit", destination: url)
            }
            
        }
        .accentColor(.blue)
        .frame(maxWidth: .infinity,alignment: .leading)
        .font(.headline)
    }
}


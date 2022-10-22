//
//  HomeView.swift
//  SwiftfulCrypto
//
//  Created by OmarMattr on 12/10/2022.
//

import SwiftUI

struct HomeView: View {
    
    @State private var showPortfolio: Bool = false
    @State private var showPortfolioView: Bool = false
    
    @EnvironmentObject private var vm : HomeViewModel
    var body: some View {
        ZStack{
            Color.theme.background.ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView) {
                    PortfolioView()
                        .environmentObject(vm)
                }
            VStack{
                headerView
                HomeStatsView(showPortfolio: $showPortfolio)
                SearchBarView(text: $vm.searchText)
                columnTitles
                if !showPortfolio {
                    allCoinsListView
                        .transition(.move(edge: .leading))
                    
                }else{
                    portfolioCoinsList
                        .transition(.move(edge: .trailing))
                    
                }
                Spacer(minLength: 0)
                
            }
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
        }
        .navigationBarHidden(true)
        .environmentObject(dev.homeVM)
    }
}
extension HomeView {
    private var headerView : some View {
        HStack{
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .animation(.none,value: showPortfolio)
                .background(CircleButtonAnimationView(animate: $showPortfolio))
                .onTapGesture {
                    showPortfolioView.toggle()
                }
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
                .animation(.none)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
    private var allCoinsListView : some View {
        List{
            ForEach(vm.allCoins){ coin in
                
                CoinRowView(coin:coin, showHoldingsColumn: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .background(
                        NavigationLink(destination: DetailView(coin: coin)){
                            EmptyView()}
                            .opacity(0))
                
            }
        }
        .listStyle(.plain)
    }
    
    private var portfolioCoinsList : some View {
        List{
            ForEach(vm.portfolioCoins){ coin in
                CoinRowView(coin:coin, showHoldingsColumn: true)
                    .background(
                        NavigationLink{DetailView(coin: coin)} label: {EmptyView()}
                            .opacity(0)
                    )
            }
        }
        .listStyle(.plain)
    }
    private var columnTitles: some View {
        HStack {
            HStack(spacing: 4){
                Text ("Coin")
                Image(systemName: "chevron.down")
                    .opacity(vm.sortOption == .rank || vm.sortOption == .rankReversed ? 1 : 0)
                    .rotationEffect(.degrees(vm.sortOption == .rank ? 0 :  180))
            }
            .onTapGesture {
                vm.sortOption  =  vm.sortOption == .rank ? .rankReversed :  .rank
            }
            Spacer()
            if showPortfolio {
                HStack(spacing: 4){
                    Text ("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity(vm.sortOption == .holdings || vm.sortOption == .holdingsReversed ? 1 : 0)
                        .rotationEffect(.degrees(vm.sortOption == .holdings ? 0 :  180))
                    
                    
                }
                .onTapGesture {
                    vm.sortOption  =  vm.sortOption == .holdings ? .holdingsReversed :  .holdings
                }
            }
            HStack(spacing: 4){
                Text("Price")
                    .frame (width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
                Image(systemName: "chevron.down")
                    .opacity(vm.sortOption == .price || vm.sortOption == .priceReversed ? 1 : 0)
                    .rotationEffect(.degrees(vm.sortOption == .price ? 0 :  180))
            }
            .onTapGesture {
                vm.sortOption  =  vm.sortOption == .price ? .priceReversed :  .price
            }
            Button {
                withAnimation(.linear(duration: 2)){
                    vm.reloadData()
                }
            } label: {
                Image(systemName: "goforward")
            }
            .rotationEffect(.degrees(vm.loading ? 360 : 0),anchor: .center)
            
        }
        .font (.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
        
    }
}

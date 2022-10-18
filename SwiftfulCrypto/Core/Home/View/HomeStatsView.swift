//
//  HomeStatsView.swift
//  SwiftfulCrypto
//
//  Created by OmarMattr on 16/10/2022.
//

import SwiftUI

struct HomeStatsView: View {
    @EnvironmentObject private var vm: HomeViewModel
    
    @Binding var showPortfolio: Bool
    
    var body: some View {
        HStack{
            ForEach(vm.statistics) { statistics in
                StatisticView(stat: statistics)
                    .frame(width: UIScreen.main.bounds.width/3)
            }
           
        }
        .frame(width: UIScreen.main.bounds.width,alignment: showPortfolio ? .trailing : .leading)
    }
}

struct HomeStatsView_Previews: PreviewProvider {
    static var previews: some View {
        HomeStatsView(showPortfolio: .constant(true))
            .environmentObject(dev.homeVM)
           
    }
}

//
//  LaunchView.swift
//  SwiftfulCrypto
//
//  Created by OmarMattr on 23/10/2022.
//

import SwiftUI

struct LaunchView: View {
    @Binding var showLaunchView: Bool
    let timer = Timer.publish(every: 0.1, on: .main, in: .common) .autoconnect ()
    @State private var degrees = 0.0
    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea()
            Image("logo-transparent")
                .resizable()
                .frame(width: 100,height: 100)
                .rotationEffect(.degrees(degrees))
                .onReceive(timer) { _ in
                    withAnimation(.linear){
                        degrees +=  10
                        if degrees == 250 {
                            showLaunchView = false
                        }
                    }
                    
                }
            
            
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView(showLaunchView: .constant(true))
    }
}

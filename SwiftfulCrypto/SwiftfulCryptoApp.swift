//
//  SwiftfulCryptoApp.swift
//  SwiftfulCrypto
//
//  Created by OmarMattr on 12/10/2022.
//

import SwiftUI

@main
struct SwiftfulCryptoApp: App {
    @StateObject private var vm  = HomeViewModel()
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
                
            }
            .environmentObject(vm)
            
        }
    }
}

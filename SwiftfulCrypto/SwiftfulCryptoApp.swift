//
//  SwiftfulCryptoApp.swift
//  SwiftfulCrypto
//
//  Created by OmarMattr on 12/10/2022.
//

import SwiftUI

@main
struct SwiftfulCryptoApp: App {
    init() {
        UINavigationBar.appearance () .largeTitleTextAttributes = [.foregroundColor : UIColor (Color.theme.accent) ]
        UINavigationBar.appearance () .titleTextAttributes = [.foregroundColor : UIColor (Color.theme.accent) ]
    }
    @StateObject private var vm  = HomeViewModel()
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
                    .navigationBarTitle("", displayMode: .inline)

                
            }
            .environmentObject(vm)
            
        }
    }
}

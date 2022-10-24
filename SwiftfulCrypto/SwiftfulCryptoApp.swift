//
//  SwiftfulCryptoApp.swift
//  SwiftfulCrypto
//
//  Created by OmarMattr on 12/10/2022.
//

import SwiftUI

@main
struct SwiftfulCryptoApp: App {
    @State private var showLaunchView: Bool = true
    init() {
        UINavigationBar.appearance () .largeTitleTextAttributes = [.foregroundColor : UIColor (Color.theme.accent) ]
        UINavigationBar.appearance () .titleTextAttributes = [.foregroundColor : UIColor (Color.theme.accent) ]
    }
    @StateObject private var vm  = HomeViewModel()
    var body: some Scene {
        WindowGroup {
            ZStack{
                NavigationView {
                    HomeView()
                        .navigationBarHidden(true)
                        .navigationBarTitle("", displayMode: .inline)
                    
                    
                }
                .navigationViewStyle(.stack)
                .environmentObject(vm)
                ZStack{
                    if  showLaunchView {
                        LaunchView(showLaunchView: $showLaunchView)
                            .transition(.move(edge: .leading))
                    }
                }
                .zIndex(2)
            }
        }
    }
}

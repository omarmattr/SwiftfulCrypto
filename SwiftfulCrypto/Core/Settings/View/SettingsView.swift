//
//  SettingView.swift
//  SwiftfulCrypto
//
//  Created by OmarMattr on 23/10/2022.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    let defaultURL = URL(string: "https://www.google.com")!
    var body: some View {
        NavigationView {
            List{
                applicationSection
            }
            .font(.headline)
            .accentColor (.blue)
            .listStyle(.grouped)
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem (placement: .navigationBarLeading){
                    Button {  dismiss() } label: { XMarkView()}
                }
            }
        }
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
extension SettingsView{
    private var applicationSection: some View {
        Section (header: Text ("Application")) {
            Link("Terms of Service", destination: defaultURL)
            Link("Privacy Policy", destination: defaultURL)
            Link("Company Website", destination: defaultURL)
            Link("Learn More", destination: defaultURL)
        }
        
    }
}

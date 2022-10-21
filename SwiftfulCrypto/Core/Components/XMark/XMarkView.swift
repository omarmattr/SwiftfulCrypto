//
//  XMarkView.swift
//  SwiftfulCrypto
//
//  Created by OmarMattr on 18/10/2022.
//

import SwiftUI

struct XMarkView: View {
    var body: some View {
        Image(systemName: "xmark")
            .padding(8)
            .foregroundColor(Color.theme.accent)
            .background(Color.theme.background)
            .cornerRadius(6)
            .shadow(color: Color.theme.accent.opacity(0.1), radius: 2,x: 0,y: 2)
    }
}

struct XMarkView_Previews: PreviewProvider {
    static var previews: some View {
        XMarkView()
            .previewLayout(.sizeThatFits)
    }
}

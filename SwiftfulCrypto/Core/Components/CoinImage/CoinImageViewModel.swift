//
//  CoinImageViewModel.swift
//  SwiftfulCrypto
//
//  Created by OmarMattr on 14/10/2022.
//

import Foundation
import SwiftUI
import Combine

class CoinImageViewModel : ObservableObject{
    @Published var image:UIImage? = nil
    
    @Published var loading = false
    
    let coin : CoinModel
    init(coin : CoinModel) {
        self.coin = coin
        loading = true
        getImage()
        
    }
    private let dataService = CoinImageService()
    private var cancellables = Set<AnyCancellable> ()
    
    func getImage(){
        dataService.getImage(coin: coin)
        dataService.$image.sink { [weak self] image in
            self?.image = image
           self?.loading = false
        }.store(in: &cancellables)
    }
    
}

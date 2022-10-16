//
//  CoinImageService.swift
//  SwiftfulCrypto
//
//  Created by OmarMattr on 14/10/2022.
//

import Foundation
import SwiftUI
import Combine

class CoinImageService {
    private let network = NetworkingManager.network
    private var request = Request()
    @Published var image : UIImage? = nil
    
    private var imageSubscription: AnyCancellable?
    private let fileManager = LocalFileManager.instance
    private let folderName = "coin_images"
    private var imageName : String!
    func getImage(coin:CoinModel) {
        imageName = coin.id
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName){
            image = savedImage
        }else{
            guard let url = URL(string: coin.image) else {
                return
            }
            downloadImage(url: url)
        }
    }
    
    private func downloadImage(url:URL) {
        imageSubscription =
        network.download(request: URLRequest(url: url))
            .tryMap({ (data) -> UIImage? in return UIImage(data: data)
            })
            .sink(receiveCompletion:
                    network.handleCompletion, receiveValue: { [weak self](returnedImage) in
                
                guard let self = self, let downloadedImage = returnedImage else { return   }
                
                self.image = downloadedImage
                self.imageSubscription?.cancel ()
                self.fileManager.saveImage(image: downloadedImage, imageName: self.imageName, folderName: self.folderName)
                
            })
        
    }
    
}

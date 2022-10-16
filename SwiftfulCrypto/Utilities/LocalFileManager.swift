//
//  LocalFileManager.swift
//  SwiftfulCrypto
//
//  Created by OmarMattr on 16/10/2022.
//

import Foundation
import SwiftUI

class LocalFileManager {
    static let instance = LocalFileManager()
    private init(){
        
    }
    func saveImage(image:UIImage,imageName:String,folderName:String){
        createFolderIfNeeded(folderName: folderName)
        guard let data = image.pngData(), let url = getUrl(ForImagae: imageName, folderName: folderName) else {return}
        do{
            try data.write(to: url)
        }catch let error{
            print("Error saving image. ImageName: \(imageName). \(error)")
            
        }
        
    }
    func getImage(imageName:String,folderName:String) -> UIImage? {
        guard let url  = getUrl(ForImagae: imageName, folderName: folderName) else {
            return nil
        }
        return UIImage(contentsOfFile: url.path)
    }
    
    private func createFolderIfNeeded(folderName:String){
        guard let url = getUrl(ForFolder: folderName) else {return}
        if !FileManager.default.fileExists(atPath: url.path) {
            do{
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
            }catch let error{
                print("Error creating directory. FolderName: \(folderName). \(error)")
                
            }
            
        }
    }
    private func getUrl(ForFolder name:String) -> URL? {
        guard let url  = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {return nil }
        return url.appendingPathComponent(name)
    }
    private func getUrl(ForImagae name:String,folderName:String) -> URL? {
        guard let folderUrl = getUrl(ForFolder: folderName) else { return nil}
        return folderUrl.appendingPathComponent(name + ".png")
    }
}

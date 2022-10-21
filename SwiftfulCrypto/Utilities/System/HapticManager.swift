//
//  HapticManager.swift
//  SwiftfulCrypto
//
//  Created by OmarMattr on 21/10/2022.
//

import Foundation
import SwiftUI
class HapticManager {
    static private let generator = UINotificationFeedbackGenerator ()
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType){
        generator.notificationOccurred(type)
    }
    
}

//
//  Item.swift
//  deemo
//
//  Created by Zhibek Nasipbekova on 12.03.2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

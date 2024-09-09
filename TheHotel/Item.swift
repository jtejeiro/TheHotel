//
//  Item.swift
//  TheHotel
//
//  Created by Jaime Tejeiro on 9/9/24.
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

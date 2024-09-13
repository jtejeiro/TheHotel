//
//  MenuTableModel.swift
//  TheHotel
//
//  Created by Jaime Tejeiro on 9/9/24.
//

import Foundation
import SwiftData

@Model
class MenuTableModel {
    @Attribute(.unique) var idMenun: UUID
    var publicationDay:Date
    var listPlace:[UUID] = []
    var createDate:Date
    
    init(id: UUID = UUID(), publicationDay: Date, listPlace: [UUID]) {
        self.idMenun = id
        self.publicationDay = publicationDay
        self.listPlace = listPlace
        self.createDate = Date.now
    }
    
}


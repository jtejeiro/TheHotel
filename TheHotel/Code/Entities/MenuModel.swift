//
//  MenuModel.swift
//  TheHotel
//
//  Created by Jaime Tejeiro on 11/9/24.
//

import Foundation
import SwiftUI

@Observable
class MenuModel:Identifiable{
    var id: UUID
    var publicationDay:Date
    var listPlace:[PlaceModel] = []
    
    init(id: UUID, publicationDay: Date, listPlace: [PlaceModel]) {
        self.id = id
        self.publicationDay = publicationDay
        self.listPlace = listPlace
    }
    
    func getDayWeek() -> String {
        debugPrint("publicationDay")
        debugPrint(publicationDay)
       return Utils.getDayOfTheWeek(publicationDay)
    }
    
    func getDay() -> String {
        return Utils.getDay(publicationDay)
    }
    
}

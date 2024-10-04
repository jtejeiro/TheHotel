//
//  PlaceTableModel.swift
//  TheHotel
//
//  Created by Jaime Tejeiro on 9/9/24.
//

import Foundation
import SwiftData

@Model
class PlaceTableModel {
    @Attribute(.unique) var idPlace: UUID
    var title:String
    var comment:String
    var typePlace:TypePlace
    var price:String
    var createDate:Date
    
    init(id: UUID = UUID() , title: String, comment: String, typePlace: TypePlace, price:String) {
        self.idPlace = id
        self.title = title
        self.comment = comment
        self.typePlace = typePlace
        self.price = price
        self.createDate = Date.now
    }
    
    func getPlaceMapModel() -> PlaceModel {
        return PlaceModel(id: self.idPlace, title: self.title, comment: self.comment, typePlace: self.typePlace, price: self.price)
    }
}

enum TypePlace: String, Codable, CaseIterable{
    case Starters
    case firstCourse
    case dessert
    case drinks
    
    var localizable: String {
        switch self {
        case .Starters:
            return "Entrante"
        case .firstCourse:
            return "Primer Plato"
        case .dessert:
            return "Postres"
        case .drinks:
            return "Bebidas"
        }
    }
    
    var position: Int {
        switch self {
        case .Starters:
            return 0
        case .firstCourse:
            return 1
        case .dessert:
            return 2
        case .drinks:
            return 3
        }
    }
    
    static func getFormStringList() -> [ListFormString] {
        return self.allCases.map{ item in
            ListFormString(id: item.position , name: item.localizable)
        }
    }
    
    static func getLocalizable(text:String) -> Self {
        return Self.allCases.first { type in
            type.localizable == text
        } ?? .Starters
    }
    
    static func getRawValue(text:String) -> Self {
        return Self.allCases.first { type in
            type.rawValue == text
        } ?? .Starters
    }
}

//
//  PlaceModel.swift
//  TheHotel
//
//  Created by Jaime Tejeiro on 10/9/24.
//

import Foundation
import SwiftUI

@Observable
class PlaceModel:Identifiable{
    var id: UUID
    var title:String
    var comment:String
    var typePlace: TypePlace
    var price:String
    public var isCheck:Bool = false
    
    var priceCoin:String {
        return price + " " + "€"
    }
    
    init(id: UUID, title: String, comment: String, typePlace: TypePlace, price: String, isCheck: Bool = false) {
        self.id = id
        self.title = title
        self.comment = comment
        self.typePlace = typePlace
        self.price = price
        self.isCheck = isCheck
    }
    
    static var test: PlaceModel {
        PlaceModel(id: UUID(), title: "Sopa de pollo", comment: "Sopa de pollo con maiz", typePlace: .Starters, price: "5,0" )
    }
}

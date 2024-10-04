//
//  DatabaseService.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 8/7/24.
//

import Foundation
import SwiftData

enum TypeBaseBase{
    case product
    case preview
}

@Observable
class DatabaseService{
    static let schema = Schema([MenuTableModel.self,PlaceTableModel.self])
    static let configuration = ModelConfiguration(isStoredInMemoryOnly: false)
    let container: ModelContainer = try! ModelContainer(for: schema, configurations: [configuration])
    
    @MainActor
    var modelContext:ModelContext {
     return container.mainContext
    }
    
    @MainActor 
    func modelContextPreview() {
        let placeUuid = UUID()
        let menuTableModel = MenuTableModel(publicationDay: .now, listPlace: [placeUuid])
        
        let placeTableModel = PlaceTableModel(id: placeUuid, title: "sopa", comment: "sopa de pollo", typePlace: .Starters, price: "5.0")
        container.mainContext.insert(placeTableModel)
        container.mainContext.insert(menuTableModel)
    }
    
    
    init() {
    }
    
    
    
}



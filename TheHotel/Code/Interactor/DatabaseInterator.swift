//
//  DatabaseInterator.swift
//  TheHotel
//
//  Created by Jaime Tejeiro on 26/9/24.
//

import Foundation
import SwiftData

protocol DatabaseInterator{
    var schema: Schema {get}
    var configuration: ModelConfiguration {get}
    var container:ModelContainer  {get}
    var modelContext: ModelContext {get}
}


extension DatabaseInterator {
    
    var schema : Schema { Schema([MenuTableModel.self,PlaceTableModel.self]) }
    var configuration : ModelConfiguration { ModelConfiguration(isStoredInMemoryOnly: false) }
    
    @MainActor
    var container: ModelContainer {
        try! ModelContainer(for: schema, configurations: [configuration])
    }
}

struct DatabaseProvider: DatabaseInterator {
    
    @MainActor
    var modelContext: ModelContext {
        container.mainContext
    }
    
}

struct DatabasePreview: DatabaseInterator {
    
    @MainActor
    var modelContext: ModelContext {
        let placeUuid = UUID()
        let menuTableModel = MenuTableModel(publicationDay: .now, listPlace: [placeUuid])
        
        let placeTableModel = PlaceTableModel(id: placeUuid, title: "sopa", comment: "sopa de pollo", typePlace: .Starters, price: "5.0")
        container.mainContext.insert(placeTableModel)
        container.mainContext.insert(menuTableModel)
        return container.mainContext
    }
    
}

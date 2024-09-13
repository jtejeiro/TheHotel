//
//  DatabaseService.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 8/7/24.
//

import Foundation
import SwiftData

@Observable
class DatabaseService {
    let container = try! ModelContainer(for: MenuTableModel.self,PlaceTableModel.self )
    
    @MainActor
    var modelContext:ModelContext {
        container.mainContext
    }
}

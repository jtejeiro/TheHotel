//
//  PlaceTableLogic.swift
//  TheHotel
//
//  Created by Jaime Tejeiro on 10/9/24.
//

import Foundation
import SwiftData

@Observable
final class PlaceTableLogic:DatabaseService {
    let interactor : DatabaseInterator
    static let sharer = PlaceTableLogic()
    var placeTableList : [PlaceTableModel]
    
    @MainActor
    func getPlaceTableModel() {
        let fetchDescriptor = FetchDescriptor<PlaceTableModel>(predicate: nil,
                                                               sortBy: [SortDescriptor<PlaceTableModel>(\.createDate)])
        placeTableList = try! modelContext.fetch(fetchDescriptor)
        
        print(placeTableList)
    }
    
    @MainActor
    func fetchPlace(by id: UUID) -> PlaceTableModel? {
        let request = FetchDescriptor<PlaceTableModel>(predicate: #Predicate<PlaceTableModel>{ item in
            item.idPlace == id
        })
            
            do {
                let results = try modelContext.fetch(request)
                return results.first
            } catch {
                print("Error al buscar el PlaceModel: \(error)")
                return nil
            }
    }
    
    
    @MainActor
    func insert(model:PlaceTableModel) {
        modelContext.insert(model)
        placeTableList = []
        getPlaceTableModel()
    }
    
    @MainActor
    func deleteAllData() {
        placeTableList.forEach { model in
            modelContext.delete(model)
        }
        try? modelContext.save()
        placeTableList = []
        getPlaceTableModel()
    }
    
    init(interactor: DatabaseInterator = DatabaseProvider()) {
        self.interactor = interactor
        self.placeTableList = []
    }
    
    @MainActor
    func getPlaceListModel()  async -> [PlaceModel] {
        getPlaceTableModel()
        return placeTableList.map { model in
            return PlaceModel(id: model.idPlace, title: model.title, comment: model.comment, typePlace: model.typePlace, price: model.price)
        }
    }
}

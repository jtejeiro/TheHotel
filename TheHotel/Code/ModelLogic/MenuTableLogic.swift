//
//  MenuTableLogic.swift
//  TheHotel
//
//  Created by Jaime Tejeiro on 9/9/24.
//

import Foundation
import SwiftData

@Observable
final class MenuTableLogic:DatabaseService {
    static let sharer = MenuTableLogic()
    var menuTableList : [MenuTableModel]
    
    @MainActor
    func getMenuTableModel() {
        let fetchDescriptor = FetchDescriptor<MenuTableModel>(predicate: nil,
                                                              sortBy: [SortDescriptor<MenuTableModel>(\.publicationDay)])
        menuTableList = try! modelContext.fetch(fetchDescriptor)
        
        print(menuTableList)
    }
    
    @MainActor
    func insert(model:MenuTableModel) {
        modelContext.insert(model)
        menuTableList = []
        getMenuTableModel()
    }
    
    @MainActor
    func deleteAllData() {
        menuTableList.forEach { model in
            modelContext.delete(model)
        }
        try? modelContext.save()
        menuTableList = []
        getMenuTableModel()
    }
    
    override init() {
        self.menuTableList =  []
    }
    
    @MainActor
    func getMenuListModel()  async -> [MenuModel] {
        getMenuTableModel()
        var menuModel:[MenuModel] = []
        for item in menuTableList {
            var placeModel:[PlaceModel] = []
            item.listPlace.forEach { id in
                if let model = fetchPlace(by: id)?.getPlaceMapModel() {
                    placeModel.append(model)
                }
            }
            debugPrint(item.publicationDay)
            menuModel.append(MenuModel(id: item.idMenun, publicationDay: item.publicationDay, listPlace: placeModel))
        }
        return menuModel
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
   
}

struct PlaceString:Identifiable {
    let id: Int
    let name:String
    var icono:String = ""
}

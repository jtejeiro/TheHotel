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
    let interactor : DatabaseInterator
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
    func update(model:MenuTableModel) throws {
        self.insert(model: model)
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
    
    init(interactor: DatabaseInterator = DatabaseProvider()) {
        self.interactor = interactor
        self.menuTableList = []
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
    
    @MainActor
    func deleteIdMenu(by id: UUID) async {
        menuTableList.forEach { model in
            if model.idMenun == id {
                modelContext.delete(model)
            }
        }
        try? modelContext.save()
        menuTableList = []
        getMenuTableModel()
    }
    
//    @MainActor
//    func loadIdMenu(model:MenuTableModel) {
//        let request = FetchDescriptor<MenuTableModel>(predicate: #Predicate<MenuTableModel>{ item in
//            item.idMenun == model.idMenun
//        })
//        do {
//            let results = try interactor.modelContext.fetch(request)
//            interactor.modelContext.insert(re)
//        } catch {
//            print("Error al buscar el PlaceModel: \(error)")
//        }
//        
//        menuTableList = []
//        getMenuTableModel()
//    }
   
}

struct PlaceString:Identifiable {
    let id: Int
    let name:String
    var icono:String = ""
}

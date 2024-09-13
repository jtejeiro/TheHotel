//
//  MenuAddModelView.swift
//  TheHotel
//
//  Created by Jaime Tejeiro on 9/9/24.
//

import Foundation

@Observable
final class MenuAddModelView:BaseViewModel {
    var menuFormList: [FormDataModel]  = []
    let menuTableLogic : MenuTableLogic
    let placeTableLogic : PlaceTableLogic
    var listPlaceModel: [PlaceModel] = []
    var showMainView: Bool = false
    
    init(menuTableLogic: MenuTableLogic =  MenuTableLogic.sharer, placeTableLogic: PlaceTableLogic = PlaceTableLogic.sharer ) {
        self.menuTableLogic = menuTableLogic
        self.placeTableLogic = placeTableLogic
    }
    
    // MARK: - Config
    func configViewModel() {
        Task {
            do {
                await setMenuFormList()
            }
        }
    }
    
    // MARK: - Set Data
    
    private func setMenuFormList() async {
        if menuFormList.count != 0 {
            return
        }
        
        menuFormList.append(FormDataModel(id: .publicationDay , titleBox: "Selecciona el día de publicación del Menu", isRequire: true))
        await listPlaceModel = placeTableLogic.getPlaceListModel().sorted(by: { $0.typePlace.position < $1.typePlace.position })
    }
    
    func getMenuFormList(_ type:FormDataTypes)-> FormDataModel{
        guard let list = menuFormList.first(where: {$0.id == type}) else {
            return FormDataModel(id: Optional.none, titleBox: "", isRequire: false)
        }
        
        return list
    }
    // MARK: - Load Data
    func loadMenuFormList(_ id:Int) async {
       
    }
    
    // MARK: - Validate
    
    func ValideMenuFormList() async -> Bool {
        var isValidate:Bool = true
        
        menuFormList.forEach { model in
            if !model.getValide() {
                debugPrint(model.errorMsg)
                self.displayAlertMessage(title:"falta selecionar un elemento requerido", mesg: model.errorMsg)
                isValidate = false
                return
            }
        }
        
        if  !listPlaceModel.contains(where: { model in
            model.isCheck == true
        }){
            self.displayAlertMessage(title:"falta selecionar un elemento requerido", mesg: "falta selecionar Platos")
        }
        
        return isValidate
    }
    
    // MARK: - Fech Save dat
    func insertMenuFormList() async {
        let publicationDay =  self.getMenuFormList(.publicationDay).inputDate
        debugPrint(publicationDay)

        let listPlace = listPlaceModel.filter 
        { model in
            model.isCheck == true }
        .map{ model in
            model.id
        }
        let menuTableModel = MenuTableModel(publicationDay: publicationDay, listPlace: listPlace)
        await menuTableLogic.insert(model: menuTableModel)
    }
    
    @MainActor
    func fechSaveData(){
        Task {
            do {
                if await ValideMenuFormList() {
                    await insertMenuFormList()
                    showMainView.toggle()
                }
            }
        }
    }
}

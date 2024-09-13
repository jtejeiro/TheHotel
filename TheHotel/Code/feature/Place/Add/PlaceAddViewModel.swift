//
//  PlaceAddViewModel.swift
//  TheHotel
//
//  Created by Jaime Tejeiro on 10/9/24.
//

import Foundation

@Observable
final class PlaceAddViewModel:BaseViewModel {
    var placeFormList: [FormDataModel]  = []
    
    // MARK: - Config
    func configViewModel() {
        Task {
            do {
                await setPlaceFormList()
            }
        }
    }
    
    // MARK: - Set Data
    
    private func setPlaceFormList() async {
        if placeFormList.count != 0 {
            return
        }
        
        placeFormList.append(FormDataModel(id: .titlePlace , titleBox: "Titulo del plato", isRequire: true))
        placeFormList.append(FormDataModel(id: .commentPlace, titleBox: "Comentario del plato", isRequire: false))
        placeFormList.append(FormDataModel(id: .typePlace, titleBox: "Selecciona la categoria de plato", isRequire: false, listFormString: TypePlace.getFormStringList()))
        placeFormList.append(FormDataModel(id: .pricePlace, titleBox: "Precio", isRequire: true,typeTextfield: .number))
    }
    
    func getPlaceFormList(_ type:FormDataTypes)-> FormDataModel{
        guard let list = placeFormList.first(where: {$0.id == type}) else {
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
        
        placeFormList.forEach { model in
            if !model.getValide() {
                debugPrint(model.errorMsg)
                self.displayAlertMessage(title:"falta selecionar un elemento requerido", mesg: model.errorMsg)
                isValidate = false
                return
            }
        }
        
        return isValidate
    }
    
}

//
//  PlaceAddViewModel.swift
//  TheHotel
//
//  Created by Jaime Tejeiro on 10/9/24.
//

import Foundation

@Observable
final class PlaceAddViewModel:BaseViewModel {
    let placeTableLogic : PlaceTableLogic
    var placeFormList: [FormDataModel]  = []
    var showloadingView: Bool = false
    
    init(placeTableLogic: PlaceTableLogic = PlaceTableLogic.sharer) {
        self.placeTableLogic = placeTableLogic
    }
    
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
        placeFormList.append(FormDataModel(id: .typePlace, titleBox: "Selecciona la categoria de plato", isRequire: true, listFormString: TypePlace.getFormStringList()))
        placeFormList.append(FormDataModel(id: .pricePlace, titleBox: "Precio", isRequire: true,typeTextfield: .number,limitChart: 6))
    }
    
    func getPlaceFormList(_ type:FormDataTypes)-> FormDataModel{
        guard let list = placeFormList.first(where: {$0.id == type}) else {
            return FormDataModel(id: Optional.none, titleBox: "", isRequire: false)
        }
        
        return list
    }
    
    // MARK: - Validate
    
    func ValidePlaceFormList() async -> Bool {
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
    
    // MARK: - Fech Save dat
    func insertPlaceFormList() async {
        let titlePlace =  self.getPlaceFormList(.titlePlace).inputText
        let commentPlace =  self.getPlaceFormList(.commentPlace).inputText
        let typePlace =  TypePlace.getLocalizable(text: self.getPlaceFormList(.typePlace).inputText)
        let pricePlace = self.getPlaceFormList(.pricePlace).inputText
        
        
        let placeTableList = PlaceTableModel(title: titlePlace , comment: commentPlace, typePlace: typePlace, price: pricePlace)
        await placeTableLogic.insert(model: placeTableList)
    }
    
    @MainActor
    func fechSaveData(){
        Task {
            do {
                self.displayLoading(true)
                if await ValidePlaceFormList() {
                    await insertPlaceFormList()
                    showloadingView.toggle()
                    removePlaceFormList()
                }
                self.displayLoading()
            }
        }
    }
    
    func removePlaceFormList(){
        DispatchQueue.main.async {
            self.placeFormList.forEach { model in
                model.resetInputData()
            }
        }
    }
}

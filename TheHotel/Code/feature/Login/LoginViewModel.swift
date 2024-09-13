//
//  LoginViewModel.swift
//  TheHotel
//
//  Created by Jaime Tejeiro on 12/9/24.
//

import Foundation
import FirebaseAuth

@Observable
final class LoginViewModel:BaseViewModel {
    var loginFormList: [FormDataModel]  = []
    var showMainView: Bool = false
    
    // MARK: - Config
    func configViewModel() {
        Task {
            do {
                await setLoginFormList()
            }
        }
    }
    
    // MARK: - Set Data
    
    private func setLoginFormList() async {
        if loginFormList.count != 0 {
            return
        }
        
        loginFormList.append(FormDataModel(id: .userName , titleBox: "Usuario", isRequire: true,typeTextfield: .email))
        loginFormList.append(FormDataModel(id: .Password , titleBox: "Contraseña", isRequire: true,limitChart: 6))
    }
    
    func getLoginFormList(_ type:FormDataTypes)-> FormDataModel{
        guard let list = loginFormList.first(where: {$0.id == type}) else {
            return FormDataModel(id: Optional.none, titleBox: "", isRequire: false)
        }
        
        return list
    }
    // MARK: - Load Data
    func loadMenuFormList(_ id:Int) async {
       
    }
    
    // MARK: - Validate
    
    func ValideLoginFormList() async -> Bool {
        var isValidate:Bool = true
        
        loginFormList.forEach { model in
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
    func insertMenuFormList() async {
        let email = getLoginFormList(.userName).inputText
        let password = getLoginFormList(.Password).inputText
        
        Auth.auth().signIn(withEmail: email, password: password) { result , error in
            if let result = result, error == nil {
                debugPrint(result.user)
                Globals.sharer.userName = result.user.email ?? email
            } else {
                self.displayAlertMessage(title: "Usuario no registrado")
            }
        }
    }
    
    func fechLoginData() async {
        self.showMainView.toggle()
//        Task {
//            do {
//                if await ValideLoginFormList() {
//                    await insertMenuFormList()
//                    self.showMainView.toggle()
//                }
//            }
//        }
    }
}

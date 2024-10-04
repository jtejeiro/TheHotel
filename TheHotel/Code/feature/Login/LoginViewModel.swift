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
    func configViewModel() async {
        Task {
            do {
                await setLoginFormList()
                await loadMockMenuFormList()
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
    
    // MARK: - Validate
    
    func ValideLoginFormList() async -> Bool {
        var isValidate:Bool = true
        
        loginFormList.forEach { model in
            if !model.getValide() {
                self.displayAlertMessage(title:"falta usuario o contraseña", mesg: model.errorMsg)
                isValidate = false
                return
            }
        }
        
        return isValidate
    }
    
    // MARK: - Fech Save dat
    func insertLoginFormList() async {
        let email = getLoginFormList(.userName).inputText
        let password = getLoginFormList(.Password).inputText
        
        Auth.auth().signIn(withEmail: email, password: password) { result , error in
            if let resultSu = result, error == nil {
                debugPrint(resultSu.user.email ?? email)
                Globals.sharer.userName = resultSu.user.email ?? email
                self.showMainView.toggle()
            } else {
                self.displayAlertMessage(title: "Usuario no registrado")
            }
        }
    }
    
    func loadMockMenuFormList() async {
        getLoginFormList(.userName).inputText = "usern@gmail.com"
        getLoginFormList(.Password).inputText = "123456"
    }
    
    func fechLoginData() async {
        Task {
            do {
                if await ValideLoginFormList() {
                    await insertLoginFormList()
                }
            }
        }
    }
}

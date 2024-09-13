//
//  MenuListViewModel.swift
//  TheHotel
//
//  Created by Jaime Tejeiro on 11/9/24.
//

import Foundation

@Observable
final class MenuListViewModel:BaseViewModel {
    let menuTableLogic : MenuTableLogic
    var listMenuModel: [MenuModel] = []
    
    init(menuTableLogic: MenuTableLogic =  MenuTableLogic.sharer) {
        self.menuTableLogic = menuTableLogic
    }
    
    // MARK: - Config
    func configViewModel() {
        Task {
            do {
                await setMenuModelList()
            }
        }
    }
    
    // MARK: - Set Data
    private func setMenuModelList() async {
        if listMenuModel.count != 0 {
            return
        }
        
        await listMenuModel = menuTableLogic.getMenuListModel().sorted(by: { $0.publicationDay<$1.publicationDay})
    }
    
    

}

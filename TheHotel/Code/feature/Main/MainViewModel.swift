//
//  MainViewModel.swift
//  TheHotel
//
//  Created by Jaime Tejeiro on 13/9/24.
//

import Foundation

@Observable
final class MainViewModel:BaseViewModel {
    let weatherStatusLogic:WeatherStatusLogic
    var tempDay:String = "00 Cº"
    var rainText:String = "100 %"
    var terraceStatus:TerraceStatus = .nullTerrace
    var isRefresh:Bool = true
    
    init(weatherStatusLogic: WeatherStatusLogic =  WeatherStatusLogic.sharer) {
        self.weatherStatusLogic = weatherStatusLogic
    }
    
    // MARK: - Config
    func configViewModel() {
        Task {
            do {
                try await fechWeatherStatusData()
            }
        }
    }
    
    // MARK: - Set Data
    func fechWeatherStatusData() async throws {
        do {
            let weatherModel = try await weatherStatusLogic.fechWeatherStatus()
            debugPrint(weatherModel.forecast.forecastday[0].day.avgtempc)
            let temp = weatherModel.forecast.forecastday[0].day.avgtempc
            let rainChance = weatherModel.forecast.forecastday[0].day.dailyChanceOfRain
            self.setWeatherStatus(temp, rainChance: rainChance)
        } catch {
            debugPrint(error)
            throw error
        }
    }
    
    func setWeatherStatus(_ temp:Double,rainChance:Double){
        self.tempDay = String(temp) + " " + "Cº"
        self.rainText = String(rainChance) + " " + "%"
        
        if temp > 12.0 && rainChance < 30.0 {
            self.terraceStatus = .openTerrace
        } else if temp < 12.0 {
            self.terraceStatus = .snowTerrace
        } else {
            self.terraceStatus = .closeTerrace
        }
    }

}

enum TerraceStatus {
    case openTerrace
    case closeTerrace
    case snowTerrace
    case nullTerrace
    
    var localizable: String {
        switch self {
        case .openTerrace:
            return "Abrir Terraza"
        case .closeTerrace:
            return "Cerrar Terraza"
        case .nullTerrace:
            return "Revisar clima"
        case .snowTerrace:
            return "Cerrar Terraza"
        }
    }
}

//
//  WeatherInteractor.swift
//  TheHotel
//
//  Created by Jaime Tejeiro on 12/9/24.
//

import Foundation

protocol WeatherInteractor {
    func loadWeatherStatus(params:[String:String]) async throws -> WeatherModel
  
}
struct WeatherProvider: WeatherInteractor {
    func loadWeatherStatus(params:[String:String]) async throws -> WeatherModel {
        
        let requestModel = RequestModel(endpoint: .empty,queryItems: params)
        
        do{
            let model = try await ServiceLayer.callService(requestModel,WeatherModel.self)
            return model
        }catch{
            print(error)
            throw error
        }
    }
    
    
}
struct WeatherMock: WeatherInteractor {
    
    func loadWeatherStatus(params:[String:String]) async throws -> WeatherModel {
        
        let bundleURL: URL = Bundle.main.url(forResource: "weathers", withExtension: "json")!
        let docURL: URL = URL.documentsDirectory.appending(path: "weathers.json")
        
        var url = docURL
        if !FileManager.default.fileExists(atPath: url.path()) {
            url = bundleURL
        }
        
        do{
            let data = try Data(contentsOf: url)
            let model = try JSONDecoder().decode(WeatherModel.self, from: data)
            return model
        }catch{
            print(error)
            throw error
        }
    }
    
}

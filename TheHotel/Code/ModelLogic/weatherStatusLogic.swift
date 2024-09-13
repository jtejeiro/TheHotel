//
//  weatherStatusLogic.swift
//  TheHotel
//
//  Created by Jaime Tejeiro on 12/9/24.
//

import Foundation

@Observable
final class WeatherStatusLogic {
    static let sharer = WeatherStatusLogic()
    let interactor : WeatherInteractor
    var weatherModel:[WeatherModel]
    
    
    init(_ interactor: WeatherInteractor = WeatherMock()) {
        self.interactor = interactor
        self.weatherModel = []
    }
    
    func fechWeatherStatus() async throws -> WeatherModel {
        do {
            let model = try await interactor.loadWeatherStatus(params: ["key":"b407607505f44abe97d73008241209","q":"Madrid","days":"1"])
            return model
        } catch {
            debugPrint(error)
            throw error
        }
    }
    
}

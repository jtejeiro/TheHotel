//
//  weatherModel.swift
//  TheHotel
//
//  Created by Jaime Tejeiro on 12/9/24.
//

import Foundation

struct WeatherModel: Codable {
    let forecast: Forecast
}

struct Forecast: Codable {
    let forecastday: [ForecastDay]
}

struct ForecastDay: Codable {
    let day: Day
}

struct Day: Codable {
    let dailyChanceOfRain: Double
    let avgtempc: Double
    
    enum CodingKeys: String, CodingKey {
        case avgtempc = "avgtemp_c"
        case dailyChanceOfRain = "daily_chance_of_rain"
    }
}

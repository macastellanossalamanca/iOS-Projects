//
//  WeatherModel.swift
//  Clima
//
//  Created by Miguel Angel Castellanos Salamanca on 13/09/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    let cityName: String
    let temperature: Double
    let conditionId: Int
    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}

struct WeatherData: Decodable {
    let cityName: String
    let main: MainModel
    let weather: [WeatherInfo]
    
    enum CodingKeys: String, CodingKey {
        case cityName = "name"
        case main
        case weather
    }
}

struct MainModel: Decodable {
    let temperature: Double
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
    }
}

struct WeatherInfo: Decodable {
    let id: Int
}

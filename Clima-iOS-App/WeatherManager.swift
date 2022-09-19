//
//  WeatherManager.swift
//  Clima
//
//  Created by Miguel Angel Castellanos Salamanca on 15/09/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

struct WeatherManager {
    
    let APIurl: String = "https://api.openweathermap.org/data/2.5/weather?units=metric&appid=7241c511099db33048201d1e4cc20198"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(APIurl)&q=\(cityName)"
        performRequest(url: urlString)
    }
    
    func fetchWeather(latitud: CLLocationDegrees, longitud: CLLocationDegrees) {
        let urlString = "\(APIurl)&lat=\(latitud)&lon=\(longitud)"
        performRequest(url: urlString)
    }
    
    func performRequest(url: String) {
        if let validUrl: URL = URL(string: url) {
            let session: URLSession = URLSession(configuration: .default)
            let task = session.dataTask(with: validUrl) {
                (data, response, error)  in
                if let safeData = data, let weather = parseJson(data: safeData) {
                    delegate?.didUpdateWeather(weather: weather)
                }
            }
            task.resume()
        }
    }
    
    func parseJson(data: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        var weatherModel: WeatherModel?
        do {
            let model = try decoder.decode(WeatherData.self, from: data)
            weatherModel = WeatherModel(cityName: model.cityName,
                                        temperature: model.main.temperature,
                                        conditionId: model.weather[0].id)
        } catch {}
        return weatherModel
    }
}

protocol WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherModel)
}

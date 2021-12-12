//
//  WeatherData.swift
//  Clima Api
//
//  Created by Mohamed on 04/09/2021.
//

import Foundation

struct WeatherData: Decodable {
    let name : String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
}

struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

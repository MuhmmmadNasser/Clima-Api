//
//  WeatherManager.swift
//  Clima Api
//
//  Created by Mohamed on 04/09/2021.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager , weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {

    let url = "https://api.openweathermap.org/data/2.5/weather?appid=6ef9d8c3d8ec9c1d73092faf30c46fb6&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    
    func fetchWeather(cityName: String){
        let urlString  = "\(url)&q=\(cityName)"
        //print(urlString)
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlstring = "\(url)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlstring)
    }
    
    func performRequest(with urlString: String){
        //1.Create a URL
        if let url = URL(string: urlString){
            //2.Create a URLSession
            let session = URLSession(configuration: .default)
            
            //3.Give the session task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data{
                    if let weather = self.parseJson(safeData){
                        self.delegate?.didUpdateWeather(self, weather: weather)
                        
                    }
                }
            }
            //4.Start the task
            task.resume()
        }
    }
  
    func parseJson(_ weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
            let decodeData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodeData.weather[0].id
            let temp = decodeData.main.temp
            let name = decodeData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, tempreture: temp)
            return weather
        }
        catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
    
    
    
}

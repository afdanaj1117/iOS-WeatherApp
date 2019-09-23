//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Austin Danaj on 9/23/19.
//

import Foundation
import UIKit

/// Extension for Notification Names
extension Notification.Name {
    static let ACTION_CURRENT_WEATHER = Notification.Name(rawValue: "ACTION_CURRENT_WEATHER")
    static let ACTION_FIVE_DAY_FORECAST = Notification.Name(rawValue: "ACTION_FIVE_DAY_FORECAST")
}

/// Weather API Manager
class WeatherManager : NSObject {
    
    /// Static shared reference to manager class
    static let shared = WeatherManager()
    
    /// API Key to access weather API
    static let API_KEY = "e517096056d3efc0cd3ab105e78fe7c8"
    
    /// Key for passing weather data over dictionary
    static let WEATHER_DATA = "WEATHER_DATA"
    
    /// Key for passing forecast data over dictionary
    static let FORECAST_DATA = "FORECAST_DATA"
    
    /**
        Get current weather at a location
        - Parameters:
            - lat: Latitude
            - lon: Longitute
        - Remark: Result is posted via notificaion center .ACTION CURRENT WEATHER
     */
    func getCurrentWeather(lat: Double, lon: Double){
        let api = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&APPID=\(WeatherManager.API_KEY)&units=imperial")!
        
        let task = URLSession.shared.dataTask(with: api) {(data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)

            guard let currentWeather = try? JSONDecoder().decode(CurrentWeather.self, from: data) else{
                print("Error: Could't decode data to Current Weather")
                return
           }
            var userInfo = [AnyHashable: Any]()
            userInfo[WeatherManager.WEATHER_DATA] = currentWeather
            self.postNotification(notificaion: .ACTION_CURRENT_WEATHER, data: userInfo)
        }
        task.resume()
    }
    
    /**
       Get five day forecast at a location
       - Parameters:
           - lat: Latitude
           - lon: Longitute
       - Remark: Result is posted via notificaion center .ACTION FIVE DAY FORECAST
    */
    func getFiveDayForecast(lat: Double, lon: Double){
        let api = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&APPID=\(WeatherManager.API_KEY)&units=imperial")!
     
        let task = URLSession.shared.dataTask(with: api) {(data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)

            guard let forecast = try? JSONDecoder().decode(Forecast.self, from: data) else{
                print("Error: Could't decode data to Forecast")
                return
            }
            var userInfo = [AnyHashable: Any]()
            userInfo[WeatherManager.FORECAST_DATA] = forecast
            self.postNotification(notificaion: .ACTION_FIVE_DAY_FORECAST, data: userInfo)
        }
        task.resume()
    }
    
    /**
        Post a notification to notification center
        - Parameters:
            - notifcation: Notification name
            - data: Data to send with notification
     */
    func postNotification(notificaion: Notification.Name, data: [AnyHashable: Any]?){
        NotificationCenter.default.post(name: notificaion, object: self, userInfo: data)
    }
}

// #################################################
// Below are JSON objects to decode from weather API
// #################################################

struct CurrentWeather : Codable {
    var coord : Coordinate?
    var weather: [Weather]?
    var base: String?
    var main: Main?
    var wind: Wind?
    var dt: Int?
    var timezone: Int?
    var id: Int?
    var name: String?
    var cod: Int?
}

struct FiveDayForecast : Codable {
    var code: Int?
    var message: Double?
    var city : City?
    var cnt: Int?
    var list: [Forecast]?
    
}

struct City : Codable {
    var id : Int?
    var name : String?
    var coord : Coordinate
    var country: String?
    var timezone: Int
}

struct Coordinate : Codable {
    var lat: Double?
    var lon: Double?
}

struct Forecast : Codable {
    var dt: Int?
    var main: Main?
    var weather: [Weather]?
    var clouds: Clouds?
    var wind: Wind?
    var dt_txt: String?
}

struct Main : Codable {
    var temp: Double?
    var temp_min: Double?
    var temp_max: Double?
    var pressure: Double?
    var grnd_level: Double?
    var sea_level: Double?
    var humidity: Double?
    var temp_kf: Double?
}

struct Weather: Codable {
    var id: Int?
    var main: String?
    var description: String?
    var icon: String?
}

struct Clouds: Codable {
    var all: Int?
}

struct Wind: Codable {
    var speed: Double?
    var deg: Double?
}



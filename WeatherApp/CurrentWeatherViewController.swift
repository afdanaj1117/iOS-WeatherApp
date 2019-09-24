//
//  CurrentWeatherViewController.swift
//  WeatherApp
//
//  Created by Austin Danaj on 9/23/19.
//

import UIKit

class CurrentWeatherViewController: UIViewController {

    /// Label for user location
    @IBOutlet weak var lblCity: UILabel!
    
    /// Label for temperature
    @IBOutlet weak var lblTemperature: UILabel!
    
    /// Label for time of day
    @IBOutlet weak var lblDateTime: UILabel!
    
    /// Label for weather descriptions
    @IBOutlet weak var lblWeatherInfo: UILabel!
    
    /// icon for displaying weather icon
    @IBOutlet weak var imageIcon: UIImageView!
    
    /// Wind speed label
    @IBOutlet weak var lblWind: UILabel!
    
    /// Humidity label
    @IBOutlet weak var lblHumidity: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Populate UI in case of no update
        if let currentWeatherJSON = UserDefaults.standard.string(forKey: "weatherData") {
              
           guard let currentWeather = try? JSONDecoder().decode(CurrentWeather.self, from: currentWeatherJSON.data(using: .utf8)!) else{
               print("Error: Could't decode data to Current Weather")
               return
            }
            updateUI(currentWeather)
        }
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(currentWeatherUpdated(_:)), name: .ACTION_CURRENT_WEATHER, object: nil)
    }
    
    /**
        Current weather updated callback
        - Parameter notification: Notifcation
     */
   @objc func currentWeatherUpdated(_ notifcation: Notification){
        if let userInfo = notifcation.userInfo {
            let weatherData = userInfo[WeatherManager.WEATHER_DATA] as! CurrentWeather
            // update UI
            self.updateUI(weatherData)
            
            print(weatherData)
        }
    }
    

    /**
     Update User interface with current weather data
        - Parameter currentWeather: Current weather JSON object
     */
    func updateUI(_ currentWeather: CurrentWeather){
        DispatchQueue.main.async {
            self.getWeatherIcon(id: currentWeather.weather![0].icon!)
            self.lblCity.text = currentWeather.name
            self.lblWind.text = "\(currentWeather.wind!.speed!) mph"
            self.lblHumidity.text = "\(currentWeather.main!.humidity!)%"
            self.lblWeatherInfo.text = currentWeather.weather![0].description
            self.lblTemperature.text = "\(round(currentWeather.main!.temp!))°F"
            let dateTime = Date.init(timeIntervalSince1970: TimeInterval(currentWeather.dt!))
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "MMM. dd, yyyy hh:mm:ss a"
            self.lblDateTime.text = "\(dateformatter.string(from: dateTime))"
        }
    }
    
    /**
        Get weather icon from API
        - Parameter id: Icon id
     */
    func getWeatherIcon(id: String){
      
        print("Download Started")
        let imageUrl = URL(string: "https://openweathermap.org/img/wn/\(id)@2x.png")!
        let task = URLSession.shared.dataTask(with: imageUrl) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? imageUrl.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.imageIcon.image = UIImage(data: data)
            }
        }
        task.resume()
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

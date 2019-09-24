//
//  CurrentWeatherViewController.swift
//  WeatherApp
//
//  Created by Austin Danaj on 9/23/19.
//

import UIKit

class CurrentWeatherViewController: UIViewController {

    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblTemperature: UILabel!
    
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblWeatherInfo: UILabel!
    @IBOutlet weak var imageIcon: UIImageView!
    
    @IBOutlet weak var lblWind: UILabel!
    @IBOutlet weak var lblHumidity: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
   @objc func currentWeatherUpdated(_ notifcation: Notification){
        if let userInfo = notifcation.userInfo {
            let weatherData = userInfo[WeatherManager.WEATHER_DATA] as! CurrentWeather
            
            print(weatherData)
        }
    }
    

    func updateUI(_ currentWeather: CurrentWeather){
        getWeatherIcon(id: currentWeather.weather![0].icon!)
        lblCity.text = currentWeather.name
        lblWind.text = "\(currentWeather.wind!.speed!)"
        lblHumidity.text = "\(currentWeather.main!.humidity!)%"
        lblWeatherInfo.text = currentWeather.weather![0].description
        lblTemperature.text = "\(round(currentWeather.main!.temp!))°F"
        let dateTime = Date.init(timeIntervalSince1970: TimeInterval(currentWeather.dt!))
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMM. dd, yyyy hh:mm:ss"
        lblDateTime.text = "\(dateformatter.string(from: dateTime))"
    }
    
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

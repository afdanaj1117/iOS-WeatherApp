//
//  ForecastViewController.swift
//  WeatherApp
//
//  Created by Austin Danaj on 9/23/19.
//

import UIKit

class ForecastViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let forecastJSON = UserDefaults.standard.string(forKey: "forecastData"){
                             
           guard let forecastData = try? JSONDecoder().decode(FiveDayForecast.self, from: forecastJSON.data(using: .utf8)!) else{
                print("Error: Could't decode data to Current Weather")
                return
            }
            self.updateUI(forecastData)
        }
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(fiveDayForecastUpdated(_:)), name: .ACTION_FIVE_DAY_FORECAST, object: nil)
    }
    
    @objc func fiveDayForecastUpdated(_ notifcation: Notification){
        if let userInfo = notifcation.userInfo {
            let fiveDayForecast = userInfo[WeatherManager.FORECAST_DATA] as! FiveDayForecast
            
            print(fiveDayForecast)
        }
    }
    
    func updateUI(_ forecastData : FiveDayForecast){
        
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

//
//  ForecastViewController.swift
//  WeatherApp
//
//  Created by Austin Danaj on 9/23/19.
//

import UIKit

class ForecastViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
 
    /// Collection view to display five day forecast
    @IBOutlet weak var collectionView: UICollectionView!
    
    /// Label for displaying current location
    @IBOutlet weak var lblCity: UILabel!
    
    /// Forecast reference
    var forecast : FiveDayForecast?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        /// Get forecast from userdefaults in case update doesnt happen
        if let forecastJSON = UserDefaults.standard.string(forKey: "forecastData"){
                             
           guard let forecastData = try? JSONDecoder().decode(FiveDayForecast.self, from: forecastJSON.data(using: .utf8)!) else{
                print("Error: Could't decode data to Forecast")
                return
            }
            //update UI
            self.updateUI(forecastData)
        }
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(fiveDayForecastUpdated(_:)), name: .ACTION_FIVE_DAY_FORECAST, object: nil)
    }
    /**
        Forecast updated callback
        - Parameter notification: Notification from update
     */
    @objc func fiveDayForecastUpdated(_ notifcation: Notification){
        if let userInfo = notifcation.userInfo {
            let fiveDayForecast = userInfo[WeatherManager.FORECAST_DATA] as! FiveDayForecast
            // Update UI
            updateUI(fiveDayForecast)
            print(fiveDayForecast)
        }
    }
    
    /**
        Update the user interface
        - Parameter forecastData: Five Day JSON Decoded data
     */
    func updateUI(_ forecastData : FiveDayForecast){
        //save forecast data
        self.forecast = forecastData
        DispatchQueue.main.async {
            // Set the city
            self.lblCity.text = self.forecast?.city?.name
            // Reload forecast
            self.collectionView.reloadData()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.forecast?.list?.count ?? 0
     }
     
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "forecastCell", for: indexPath) as! ForecastCollectionViewCell
        let temp = self.forecast?.list![indexPath.row].main?.temp
        let imageId = self.forecast?.list![indexPath.row].weather![0].icon
        let dateTime = Date.init(timeIntervalSince1970: TimeInterval((self.forecast?.list![indexPath.row].dt!)!))
            
        cell.prepare(temperature: temp!, imageId: imageId!, dateTime: dateTime)
        return cell
        
        
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

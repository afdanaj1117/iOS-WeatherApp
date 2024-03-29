//
//  ForecastCollectionViewCell.swift
//  WeatherApp
//
//  Created by Austin Danaj on 9/23/19.
//

import UIKit

class ForecastCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var lblTemperature: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    
    /**
        Initialize UI for cell
        - Parameters:
            - temperature: Temperaure in Faherenheit
            - imageId: Id of icon from API
            - dateTime: DateTime of weather
     */
    func prepare(temperature: Double, imageId: String, dateTime: Date){
        
        lblTemperature.text = "\(round(temperature))°F"
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMM. dd, yyyy hh:mm:ss a"
        lblDateTime.text = "\(dateformatter.string(from: dateTime))"
        
        self.getWeatherIcon(id: imageId)
    }
    
    /**
        Get weather icon from API
        - Parameter id: Id of icon from API
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
}

//
//  MainTabBarViewController.swift
//  WeatherApp
//
//  Created by Austin Danaj on 9/23/19.
//

import UIKit
import CoreLocation

extension Notification.Name {
    static let LOCATION_UPDATED = Notification.Name(rawValue: "LOCATION_UPDATED")
}
class MainTabBarViewController: UITabBarController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    
    static let LATITUDE = "LATITUDE"
    static let LONGITUDE = "LONGITUDE"
    
    let weatherManager = WeatherManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        var userInfo = [AnyHashable:Any]()
        userInfo[MainTabBarViewController.LATITUDE] = locValue.latitude
        userInfo[MainTabBarViewController.LONGITUDE] = locValue.longitude
        
        NotificationCenter.default.post(name: .LOCATION_UPDATED, object: self, userInfo: userInfo)
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

//
//  WeatherManagerTests.swift
//  WeatherAppTests
//
//  Created by Austin Danaj on 9/23/19.
//

import XCTest
@testable import WeatherApp

class WeatherManagerTests: XCTestCase {

    var sut: URLSession!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        sut = URLSession(configuration: .default)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        super.tearDown()
    }

    func testCurrentWeather() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let api = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(57.0)&lon=\(-2.15)&APPID=\(WeatherManager.API_KEY)&units=imperial")!
        
        let promise = expectation(description: "Status code: 200")
        
        let task = sut.dataTask(with: api) {(data, response, error) in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            }else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    promise.fulfill()
                }else{
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        task.resume()
        
        wait(for: [promise], timeout: 5)
    }

    
    func testFiveDayForecast() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let api = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(57.0)&lon=\(-2.15)&APPID=\(WeatherManager.API_KEY)&units=imperial")!
        
        let promise = expectation(description: "Status code: 200")
        
        let task = sut.dataTask(with: api) {(data, response, error) in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            }else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    promise.fulfill()
                }else{
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        task.resume()
        
        wait(for: [promise], timeout: 5)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

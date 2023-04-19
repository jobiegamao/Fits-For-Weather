//
//  MainViewController.swift
//  simpleWeatherApp
//
//  Created by may on 4/19/23.
//

import UIKit
import MapKit
import Alamofire

class MainViewController: UIViewController {
	
	let locationManager = CLLocationManager()
	var coordinates = CLLocationCoordinate2D(latitude: 0, longitude: 0)
	
	@IBOutlet var skinBtnLabel: UIButton!
	@IBOutlet var timezoneBtnLabel: UIButton!
	var timezone: String = Globals().getTimeZone() {
		didSet {
			timezoneBtnLabel.setTitle(timezone, for: .normal)
		}
	}
	
	var weatherData: WeatherResponse?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		locationManager.delegate = self
		locationManager.requestWhenInUseAuthorization()
		
		// default values on load
		timezoneBtnLabel.setTitle(Globals().getTimeZone(), for: .normal)
		skinBtnLabel.setTitle(Globals().getSkinType(), for: .normal)
		
	}
	
	@IBAction func didTapChangeSkin(_ sender: Any) {
		let ac = UIAlertController(title: "Select your skin type", message: nil, preferredStyle: .actionSheet)
		
		for key in 1...Constants().skintype.count{
			if let type = Constants().skintype[key] {
				ac.addAction(UIAlertAction(title: type, style: .default, handler: { [weak self] _ in
					
					self?.skinBtnLabel.setTitle(type, for: .normal)
					Globals().setSkinType(value: type)
	
				}))
			}
		}
		
		present(ac, animated: true)
	}
	
	@IBAction func didTapChangeTimeZone(_ sender: Any) {
		let ac = UIAlertController(title: "Select your time zone", message: nil, preferredStyle: .actionSheet)
		
		_ = Constants().timezone.map({ [weak ac] zone in
			ac?.addAction(UIAlertAction(title: zone, style: .default, handler: { [weak self] _ in
				self?.timezone = zone
				Globals().setTimeZone(value: zone)
			}))
			
		})
		
		present(ac, animated: true)
		
	}
	
	private func showAlert(title: String, message: String){
		let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let ok = UIAlertAction(title: "Ok", style: .default)
		ac.addAction(ok)
		present(ac, animated: true)
	}
	
	private func getWeatherData(){
		let url = Weather_Api_URL(lat: String(coordinates.latitude), long: String(coordinates.longitude), timezone: timezone).getAPI_URL()
		print(url)
		
		
		let decoder = JSONDecoder()
		
		AF.request(url).responseDecodable(of: WeatherResponse.self, decoder: decoder) { [weak self] response in
			if let data = response.data {
				print(String(data: data, encoding: .utf8)!)
			}
			if let error = response.error {
				print("Error: \(error.localizedDescription)")
				return
			}
			
			guard let weatherResponse = response.value else {
				print("Error: no response from weather API")
				return
			}
			
			self?.weatherData = weatherResponse
			self?.giveAdvice()
		}
		
	}

	func giveAdvice(){
		print(weatherData?.daily.time.last)
	}
}

// LOCATION / COORDINATES
extension MainViewController: CLLocationManagerDelegate {
	
	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		print("location changed")
		switch manager.authorizationStatus{
			case .notDetermined:
				break
			case .authorizedWhenInUse, .authorizedAlways:
				getLocation()
			default:
				showAlert(title: "Error", message: "Go to settings and allow location services for this app.")
				
		}
		
	}
	
	
	func getLocation(){
		guard let loc = locationManager.location?.coordinate else { return }
		
		coordinates = loc
		getWeatherData()
		
	}
}


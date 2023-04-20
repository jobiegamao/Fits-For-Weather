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
	
	var url: String = ""
	var weatherData: WeatherResponse?
	

	var computerAdvice: String = Globals().getAdvice()
	
	@IBOutlet var activityIndicator: UIActivityIndicatorView!
	@IBOutlet var activityStatusLabel: UILabel!
	
	
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
	
	private func getWeatherData(completion: @escaping () -> Void){
		activityIndicator.startAnimating()
		activityStatusLabel.isHidden = false

		let APIurl = Weather_Api_URL(lat: String(coordinates.latitude), long: String(coordinates.longitude), timezone: timezone).getAPI_URL()
		
		guard url != APIurl else { return }
		url = APIurl
		print(url)
		
		
		let decoder = JSONDecoder()
		
		AF.request(url).responseDecodable(of: WeatherResponse.self, decoder: decoder) { [weak self] response in
		
			guard let weatherResponse = response.value else {
				print("Error: no response from weather API")
				self?.updateUI(isSuccessful: false)
				return
			}
			
			self?.weatherData = weatherResponse
			self?.giveAdvice()
			DispatchQueue.main.async {
				self?.updateUI(isSuccessful: true)
				completion()
			}
			
			
		}
		
	}

	
	
	
	
	@IBAction func showAdviceBtn(_ sender: Any) {
		activityIndicator.startAnimating()
		activityStatusLabel.isHidden = false
		getWeatherData{
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			let viewController = storyboard.instantiateViewController(withIdentifier: "AdviceViewController") as! AdviceViewController
			viewController.text = self.computerAdvice
			print(self.computerAdvice)
			self.present(viewController, animated: true, completion: nil)
		}
		
		
	}
	
	func updateUI(isSuccessful: Bool) {
		switch isSuccessful {
			case false:
				activityStatusLabel.text = "Failed.."

				return
			case true:
				activityIndicator.stopAnimating()
				activityStatusLabel.isHidden = true
		}
	}
	
	func giveAdvice(){
		guard let data = weatherData else { return }
		var text = ""
		
		text += data.current_weather.is_day == 1 ? "Morning sis! " : "What a fun night ahead! "
		
		text += data.current_weather.temperature > 28.0 ? "Wear some light clothes as it will be toasty today! " : "Cover up lil and wear those pricy jackets. "
		
		text += data.hourly.rain.last! > 0.0 ? "Remember to bring your umbrella to as it most likey to rain. ": ""
		
		computerAdvice = text
		print(computerAdvice)
		
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
		
	}
}


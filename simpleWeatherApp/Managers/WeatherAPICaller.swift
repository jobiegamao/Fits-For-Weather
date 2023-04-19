//
//  WeatherAPICaller.swift
//  simpleWeatherApp
//
//  Created by may on 4/19/23.
//

import Foundation

struct Weather_Api_URL {
	private let baseURL = "https://api.open-meteo.com/v1/forecast?"
	private let datas = "&daily=apparent_temperature_max,sunrise,sunset,uv_index_max,precipitation_sum,rain_sum&hourly=apparent_temperature,rain,uv_index&forecast_days=1&current_weather=true"
	private var timezone = ""
	private var coords = ""
	
	init(lat: String, long: String, timezone: String) {
		self.coords = "latitude=\(lat)&longitude=\(long)"
		self.timezone = "&timezone=" + timezone.replacingOccurrences(of: " / ", with: "%2F")
	}
	
	func getAPI_URL() -> String {
		return baseURL + coords + datas + timezone
	}
}

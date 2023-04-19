//
//  CurrentWeather.swift
//  simpleWeatherApp
//
//  Created by may on 4/19/23.
//

import Foundation

struct WeatherResponse: Codable {
	let latitude: Double
	let longitude: Double
	let timezone: String
	let current_weather: CurrentWeather
	let daily: Daily
	let hourly: Hourly
	
}

struct CurrentWeather: Codable  {
	let temperature: Double
	let windspeed: Double
	let winddirection: Double
	let is_day: Int
	let time: String
}

struct Daily: Codable  {
	let time: [String]
	let apparent_temperature_max: [Double]
	let sunrise: [String]
	let sunset: [String]
	let uv_index_max: [Double]
	let precipitation_sum: [Double]
	let rain_sum: [Double]
	
}

struct Hourly : Codable {
	let time: [String]
   let apparent_temperature: [Double]
   let rain: [Double]
   let uv_index: [Double]
}


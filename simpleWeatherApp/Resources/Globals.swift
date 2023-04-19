//
//  Globals.swift
//  simpleWeatherApp
//
//  Created by may on 4/19/23.
//

import Foundation

class Globals {
	
	func getStorage() -> UserDefaults {
		return UserDefaults.standard
	}
	
	func getTimeZone() -> String{
		let defaults = getStorage()
		if let result = defaults.string(forKey: UserDefaultsKeys.timezone){
			return result
		}
		
		return Constants().timezone[0]
	}
	
	func setTimeZone(value: String){
		let defaults = getStorage()
		defaults.set(value, forKey: UserDefaultsKeys.timezone)
		defaults.synchronize()
	}
	
	func getSkinType() -> String{
		let defaults = getStorage()
		if let result = defaults.string(forKey: UserDefaultsKeys.skinType){
			return result
		}
		
		return Constants().skintype[1] ?? " "
	}
	
	func setSkinType(value: String){
		let defaults = getStorage()
		defaults.set(value, forKey: UserDefaultsKeys.skinType)
		defaults.synchronize()
	}
}

struct Constants {
	let skintype: [Int: String] = [
		1: "Type 1 - Pale / Light",
		2: "Type 2 - White / Fair",
		3: "Type 3 - Medium",
		4: "Type 4 - Olive Brown",
		5: "Type 5 - Dark Brown",
		6: "Type 6 - Black",
	]
	
	let timezone = [
		"America / Los_Angeles", "Asia / Singapore", "Asia / Bangkok"
	]
}



struct UserDefaultsKeys {
	static let skinType = "skinType"
	static let timezone = "timezone"
}

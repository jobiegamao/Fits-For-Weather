//
//  AdviceViewController.swift
//  simpleWeatherApp
//
//  Created by may on 4/20/23.
//

import UIKit

class AdviceViewController: UIViewController {

	var data: WeatherResponse!
	
	@IBOutlet var adviceTextView: UITextView!
	var text: String = ""
	
	override func viewDidLoad() {
        super.viewDidLoad()
		adviceTextView.text = text
	
    }
    
	
    

}

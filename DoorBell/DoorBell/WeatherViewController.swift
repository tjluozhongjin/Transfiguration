//
//  WeatherViewController.swift
//  DoorBell
//
//  Created by Yang Li on 04/06/2017.
//  Copyright © 2017 Yang Li. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController {
  @IBOutlet weak var temp: UILabel!
  @IBOutlet weak var pressure: UILabel!
  @IBOutlet weak var humidity: UILabel!
  @IBOutlet weak var noiselevel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.setNavigationBarHidden(false, animated: true)
    
    Alamofire.request("https://demo100.chinacloudsites.cn/getSensor", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseString { (response) in
      let responseData = response.result.value!
      let responseJson = JSON(data: responseData.data(using: String.Encoding.utf8)!)
      print(responseJson)
      let temperature = Double(responseJson["temperature"].stringValue)
      self.temp.text = String(temperature! - 3) + "℃"
      self.pressure.text = responseJson["pressure"].stringValue
      self.humidity.text = responseJson["humidity"].stringValue
      self.noiselevel.text = responseJson["noiselevel"].stringValue
      
    }
  }
  
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  
}

//
//  VisitorViewController.swift
//  DoorBell
//
//  Created by Yang Li on 04/06/2017.
//  Copyright © 2017 Yang Li. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class VisitorViewController: UIViewController, SlideButtonDelegate {
  @IBOutlet weak var visitorView: UIWebView!
  @IBOutlet weak var currentTime: UILabel!
  @IBOutlet weak var similarityText: UILabel!
  @IBOutlet weak var unlockButton: MMSlidingButton!
  
  var visit = UserDefaults.standard
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.setNavigationBarHidden(false, animated: true)
    self.unlockButton.delegate = self
    
    visitorView.scalesPageToFit = true
    visitorView.contentMode = .scaleAspectFit
    visitorView.loadRequest(URLRequest(url: URL(string: "http://60.205.206.174:3000/getFile")!))
    let now = Date()
    if now != visit.object(forKey: "visitTime") as? Date {
      let dformatter = DateFormatter()
      dformatter.dateFormat = "HH:mm"
      currentTime.text = String(describing: dformatter.string(from: now))
    }
    
    Alamofire.request("http://60.205.206.174:3000/getData", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseString { (response) in
      if let responseData = response.result.value {
        let responseJson = JSON(data: responseData.data(using: String.Encoding.utf8)!)
        let similarity  = UILabel(frame: CGRect(x: 2 * super.view.frame.midX - self.similarityText.frame.midX, y: self.similarityText.frame.minY, width: 100, height: 21))
        similarity.text = responseJson["confidence"].stringValue
        similarity.textColor = UIColor.darkGray
        self.view.addSubview(similarity)
        
        if let similarityData: Double = Double(responseJson["confidence"].stringValue) {
          self.updateVisit(now, similarityData)
          
          if similarityData < 0.7 {
            let alertController = UIAlertController(title: "Hola", message: "Having a new Stranger!", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
          }
        } else {
          print("Oops! Could not get confidence data.")
        }
      } else {
        print("Oops! There has some problems in network.")
      }
    }
  }
  
  func updateVisit(_ now: Date, _ similarityData: Double) {
    visit.set(now, forKey: "visitTime")
    visit.set(similarityData, forKey: "visitSimilarity")
  }
  
  func buttonStatus(status: String, sender: MMSlidingButton) {
    if status == "Unlocked" {
      unlockDoor()
      Alamofire.request("http://60.205.206.174:3000/getUnlock", method: .get).responseString(completionHandler: { (response) in
        if response.result.value == "false" {
          self.unlockButton.reset()
        }
      })
    }
  }
  
}

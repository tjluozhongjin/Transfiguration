//
//  FamilyViewController.swift
//  DoorBell
//
//  Created by Yang Li on 04/06/2017.
//  Copyright © 2017 Yang Li. All rights reserved.
//

import UIKit
import Koloda
import Alamofire
import SwiftyJSON

private var memberNo: Int = 4

class FamilyViewController: UIViewController {
  @IBOutlet weak var remindBtn: UIButton!
  @IBOutlet weak var familyMember: KolodaView!
  @IBOutlet weak var avatarImage0: UIImageView!
  @IBOutlet weak var avatarImage1: UIImageView!
  @IBOutlet weak var avatarImage2: UIImageView!
  @IBOutlet weak var avatarImage3: UIImageView!
  @IBOutlet weak var avatarLabel0: UILabel!
  @IBOutlet weak var avatarLabel1: UILabel!
  @IBOutlet weak var avatarLabel2: UILabel!
  @IBOutlet weak var avatarLabel3: UILabel!
  var avatarImage = [UIImageView]()
  var avatarLabel = [UILabel]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.setNavigationBarHidden(false, animated: true)
    remindBtn.setImage(UIImage(named: "heartSelected"), for: .selected)
    remindBtn.setImage(UIImage(named: "heartUnselected"), for: .normal)
    
    familyMember.delegate = self
    familyMember.dataSource = self
    
    avatarImage = [avatarImage0, avatarImage1, avatarImage2, avatarImage3]
    avatarLabel = [avatarLabel0, avatarLabel1, avatarLabel2, avatarLabel3]
    
    updatePresent()
  }
  
  fileprivate var dataSource: [UIImage] = {
    var array: [UIImage] = []
    for index in 0..<memberNo {
      array.append(UIImage(named: "memberPhoto_\(index + 1)")!)
    }
    return array
  }()
  
  @IBAction func remindBtn(_ sender: UIButton) {
    sender.isSelected = !sender.isSelected
  }
  
  func updatePresent() {
    Alamofire.request("http://60.205.206.174:3000/getPresent").responseString { (response) in
      let present = JSON(parseJSON: response.value!)
      for i in 0..<memberNo {
        if present[i] == "true" {
          self.avatarImage[i].alpha = 1
          self.avatarLabel[i].textColor = UIColor.black
        } else {
          self.avatarImage[i].alpha = 0.4
          self.avatarLabel[i].textColor = UIColor.lightGray
        }
      }
    }
  }
}

extension FamilyViewController: KolodaViewDelegate, KolodaViewDataSource {
  func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
    let position = familyMember.currentCardIndex
    for index in 1...memberNo {
      dataSource.append(UIImage(named: "memberPhoto_\(index)")!)
    }
    familyMember.insertCardAtIndexRange(position..<position + memberNo, animated: true)
  }
  
  func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
    return .default
  }
  
  func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
    return dataSource.count
  }
  
  func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
    return UIImageView(image: dataSource[Int(index)])
  }
  
  func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
    return (Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)?[0] as? OverlayView)!
  }
  
}

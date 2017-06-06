//
//  FamilyViewController.swift
//  DoorBell
//
//  Created by Yang Li on 04/06/2017.
//  Copyright © 2017 Yang Li. All rights reserved.
//

import UIKit
import Koloda

private var memberNo: Int = 4

class FamilyViewController: UIViewController {
  @IBOutlet weak var remindBtn: UIButton!
  @IBOutlet weak var familyMember: KolodaView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.setNavigationBarHidden(false, animated: true)
    remindBtn.setImage(UIImage(named: "heartSelected"), for: .selected)
    remindBtn.setImage(UIImage(named: "heartUnselected"), for: .normal)
    
    familyMember.delegate = self
    familyMember.dataSource = self
  }
  
  fileprivate var dataSource: [UIImage] = {
    var array: [UIImage] = []
    for index in 0..<memberNo {
      array.append(UIImage(named: "memberPhoto_\(index + 1)")!)
    }
    return array
  }()
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func remindBtn(_ sender: UIButton) {
    sender.isSelected = !sender.isSelected
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

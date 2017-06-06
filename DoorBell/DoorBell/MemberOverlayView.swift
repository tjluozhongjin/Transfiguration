//
//  MemberOverlayView.swift
//  DoorBell
//
//  Created by Yang Li on 04/06/2017.
//  Copyright © 2017 Yang Li. All rights reserved.
//

import UIKit
import Koloda

class MemberOverlayView: OverlayView {
  @IBOutlet lazy var overlayImageView: UIImageView! = {
    [unowned self] in
    
    var imageView = UIImageView(frame: self.bounds)
    self.addSubview(imageView)
    
    return imageView
    }()
}


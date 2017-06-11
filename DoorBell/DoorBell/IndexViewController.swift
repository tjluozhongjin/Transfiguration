//
//  IndexViewController.swift
//  DoorBell
//
//  Created by Yang Li on 04/06/2017.
//  Copyright © 2017 Yang Li. All rights reserved.
//

import UIKit
import PhotosUI
import MobileCoreServices
import LocalAuthentication

class IndexViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  @IBOutlet weak var backgroundView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    touchID()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: true)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func chose(_ sender: UIButton) {
    let alertController = UIAlertController(title: "chose photo", message: nil, preferredStyle: .actionSheet)
    let alertActionLib = UIAlertAction(title: "Album", style: .default) { (_) in
      if #available(iOS 9.1, *) {
        self.imagePickerController.mediaTypes = [kUTTypeLivePhoto as String, kUTTypeImage as String]
      } else {
        self.imagePickerController.mediaTypes = [kUTTypeImage as String]
      }
      self.imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
      self.present(self.imagePickerController, animated: true, completion: nil)
    }
    let alertActionCamera = UIAlertAction(title: "Camera", style: .default) { (_) in
      if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
        self.imagePickerController.sourceType = .camera
        self.present(self.imagePickerController, animated: true, completion: nil)
      }
    }
    let alertActionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    
    alertController.addAction(alertActionLib)
    alertController.addAction(alertActionCamera)
    alertController.addAction(alertActionCancel)
    self.present(alertController, animated: true, completion: nil)
  }

  private lazy var imagePickerController: UIImagePickerController = {
    let imagePickerController = UIImagePickerController()
    imagePickerController.delegate = self
    return imagePickerController
  }()
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    let livePhoto: PHLivePhoto? = info[UIImagePickerControllerLivePhoto] as? PHLivePhoto
    if (livePhoto != nil) {
      let livePhotoView = PHLivePhotoView(frame: backgroundView.frame)
      livePhotoView.livePhoto = info[UIImagePickerControllerLivePhoto] as? PHLivePhoto
      livePhotoView.startPlayback(with: .full)
      livePhotoView.contentMode = .scaleAspectFill
      backgroundView.addSubview(livePhotoView)
    } else {
      let staticPhotoView = UIImageView(frame: backgroundView.frame)
      staticPhotoView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
      staticPhotoView.contentMode = .scaleAspectFill
      backgroundView.addSubview(staticPhotoView)
    }
    picker.dismiss(animated: true, completion: nil)
  }
  
  func touchID() {
    let context = LAContext()
    var error: NSError?
    
    if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
      context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Please unlock with fingerprints", reply: { (success, error) in
        if success {
          print("success")
          // do the success thing
        } else {
          if (error as NSError?) != nil {
            print("error")
            // do the error thing
          }
        }
      })
    }
  }
  
  @IBAction func visitor(_ sender: UIButton) {
    
  }
  
  @IBAction func family(_ sender: UIButton) {
    
  }
  
  @IBAction func agenda(_ sender: UIButton) {
    
  }
  
  @IBAction func weather(_ sender: UIButton) {
    
  }
}


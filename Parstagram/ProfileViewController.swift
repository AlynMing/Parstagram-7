//
//  ProfileViewController.swift
//  Parstagram
//
//  Created by Evelyn Hasama on 10/29/20.
//

import UIKit
import AlamofireImage
import Parse

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var profiles = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = PFUser.current()?["username"] as? String
        
        let query = PFQuery(className:"Profiles")
        query.whereKey("user", equalTo: PFUser.current())
        query.findObjectsInBackground(block: { (userprofiles, error) in
            if userprofiles != nil {
                print("hi")
                self.profiles = userprofiles!
                if self.profiles.count > 0 {
                    self.loadImage()
                }
            } else {
                print("error")
            }
        })
                
        // Do any additional setup after loading the view.
    }
    

    func loadImage() {
        let profile = profiles[0]
        if profile["picture"] == nil {
            print("no photo")
        } else {
            print("")
            let imageFile = profile["picture"] as! PFFileObject
            let urlString = imageFile.url!
            let url = URL(string: urlString)!
            imageView.af_setImage(withURL: url)
        }

    }
    
    

    @IBAction func onSaveButton(_ sender: Any) {
        let profile = PFObject(className: "Profiles")
        
        profile["user"] = PFUser.current()!
        
        
        let imageData = imageView.image!.pngData()
        let file = PFFileObject(data: imageData!)
        
        profile["picture"] = file
        
        
        profile.saveInBackground { (success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
                print("saved")
            } else {
                print("error")
            }
        }
        
    }
    
    @IBAction func onCameraButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af_imageAspectScaled(toFill: size)
        
        imageView.image = scaledImage
        
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

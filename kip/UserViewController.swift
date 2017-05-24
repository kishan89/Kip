//
//  UserViewController.swift
//  kip
//
//  Created by Kishan Patel on 1/13/17.
//  Copyright © 2017 Kishan Patel. All rights reserved.
//

import UIKit
import RealmSwift

class UserViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var user: User?
    var imagePicker = UIImagePickerController()
    var source: UIViewController?
    var channel: Channel?

    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUser()
        // Do any additional setup after loading the view.
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(img:)))
        profilePicture.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func getUser() {
        let realm = try! Realm()
        let userAccount = realm.object(ofType: User.self, forPrimaryKey: (self.user?.username)!)
        self.user = userAccount
        let profileImage = UIImage(data: self.user?.profilePictureData as! Data)
        profilePicture.image = profileImage
        profilePicture.layer.cornerRadius = profilePicture.frame.size.width/10
        profilePicture.clipsToBounds = true
        usernameLabel.text = "@" + (self.user?.username)!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imageTapped(img: AnyObject) {
        /*
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Choose from Library", style: .default, handler: nil))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
        */
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum) {
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func saveUser(imageData: NSData?) {
        let realm = try! Realm()
        try! realm.write {
            self.user!.profilePictureData = imageData!
            realm.add(self.user!, update: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!) {
        self.dismiss(animated: true, completion: { () -> Void in })
        profilePicture.image = image
        let imageData = UIImageJPEGRepresentation(image, 0.9) as NSData?
        saveUser(imageData: imageData)
    }
        
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "backToChannels") {
            let destination = segue.destination as! ChannelViewController
            let realm = try! Realm()
            destination.university = realm.object(ofType: University.self, forPrimaryKey: (self.user?.university)!)
            destination.user = self.user
            print((self.user?.university)!)
        }
        else if (segue.identifier == "backToChannel") {
            let destination = segue.destination as! DetailViewController
            let realm = try! Realm()
            destination.university = realm.object(ofType: University.self, forPrimaryKey: (self.user?.university)!)
            destination.user = self.user
            destination.channel = self.channel!
        }
    }
    
    
}
    

    



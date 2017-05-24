//
//  OtherUserViewController.swift
//  kip
//
//  Created by Kishan Patel on 1/22/17.
//  Copyright © 2017 Kishan Patel. All rights reserved.
//

import UIKit
import RealmSwift

class OtherUserViewController: UIViewController {
    
    var otherUserUsername: String?
    var loggedInUserUsername: String?
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var userImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()
        let otherUser = realm.object(ofType: User.self, forPrimaryKey: otherUserUsername)
        
        usernameLabel.text = otherUserUsername
        let profileImage = UIImage(data: otherUser?.profilePictureData as! Data)
        userImage.image = profileImage
        userImage.layer.cornerRadius = userImage.frame.size.width/10
        userImage.clipsToBounds = true
        
        /* Go To UserViewController? */
        //if (otherUserUsername == loggedInUserUsername) {
            //self.performSegue(withIdentifier: <#T##String#>, sender: <#T##Any?#>)
        //}

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

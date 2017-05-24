//
//  EntryViewController.swift
//  kip
//
//  Created by Kishan Patel on 1/10/17.
//  Copyright © 2017 Kishan Patel. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class EntryViewController: UIViewController {
    
    @IBOutlet weak var logInButton: UIButton!
    
    var realm: Realm!
    var notificationToken: NotificationToken!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.realm = try! Realm()
        
        let realm = try! Realm()
        self.realm = realm

        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        print(RLMRealmConfiguration.default())
        
//        logInButton.layer.cornerRadius = 5
//        logInButton.layer.borderWidth = 1
//        logInButton.layer.borderColor = UIColor(red: 236.0/255.0, green: 183.0/255.0, blue: 171.0/255.0, alpha: 1.0).cgColor
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    


    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueToCreateAccount") {
            let destinationViewController = segue.destination as! CreateAccountViewController
            destinationViewController.realm = self.realm
        }
        else if (segue.identifier == "segueToLogIn") {
           let destinationViewController = segue.destination as! LogInViewController
            destinationViewController.realm = self.realm
        }
    }
    

}

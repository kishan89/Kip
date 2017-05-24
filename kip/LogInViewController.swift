//
//  LogInViewController.swift
//  kip
//
//  Created by Kishan Patel on 1/10/17.
//  Copyright © 2017 Kishan Patel. All rights reserved.
//

import UIKit
import RealmSwift

class LogInViewController: UIViewController {
    
    var realm: Realm!
    var notificationToken: NotificationToken!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //initializeUniversities()
        // Do any additional setup after loading the view.
    }
    
    func initializeUniversities() {
        let bostonUniversity = University()
        bostonUniversity.universityName = "Boston University"
        let bostonCollege = University()
        bostonCollege.universityName = "Boston College"
        try! self.realm.write {
            self.realm.add(bostonUniversity)
            self.realm.add(bostonCollege)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!


    @IBAction func logInPress() {
        
        let user = self.realm.object(ofType: User.self, forPrimaryKey: usernameTextField.text!)
        if (user != nil) {
            if (user!.password == passwordTextField.text!) {
                
            
                /*
                SyncUser.logIn(with: .usernamePassword(username: user!.username, password: user!.password, register: false), server: URL(string: "http://138.197.89.139:9080")!) { user, error in
                    guard let user = user else {
                        fatalError(String(describing: error))
                    }

                    DispatchQueue.main.async {
                        // Open Realm
                        let configuration = Realm.Configuration(
                            syncConfiguration: SyncConfiguration(user: user, realmURL: URL(string: "realm://138.197.89.139:9080")!)
                        )
                        
                        //Realm.Configuration.defaultConfiguration = configuration
                        self.realm = try! Realm(configuration: configuration)
                    
                    }
                }
                */
                
                
                self.performSegue(withIdentifier: "segueLogIn", sender: nil)
            }
            else {
            }
        }
        else {
            print("no user found")
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let realm = try! Realm()
        let user = realm.object(ofType: User.self, forPrimaryKey: usernameTextField.text!)
        //print(user?.username)
        if (segue.identifier == "segueLogIn") {
            //let splitVC = segue.destination as! UISplitViewController
            let navigationController = segue.destination as! UINavigationController
            //print(navigationController?.viewControllers)
            //let masterViewController = splitVC.viewControllers[0].childViewControllers[0] as! ChannelViewController
            
            /*
            let detailViewController = splitVC.viewControllers[1] as! DetailViewController
            detailViewController.university = realm.object(ofType: University.self, forPrimaryKey: user!.university)
            detailViewController.realm = self.realm
            */
            
            let masterViewController = navigationController.topViewController as! ChannelViewController
            masterViewController.user = user
            masterViewController.university = realm.object(ofType: University.self, forPrimaryKey: user!.university)
            masterViewController.realm = self.realm
            //splitVC.preferredDisplayMode = UISplitViewControllerDisplayMode.allVisible

        }

    }
}

//
//  CreateAccountViewController.swift
//  kip
//
//  Created by Kishan Patel on 1/10/17.
//  Copyright © 2017 Kishan Patel. All rights reserved.
//

import UIKit
import RealmSwift

class CreateAccountViewController: UIViewController {
    
    @IBOutlet weak var createAccountButton: UIButton!
        
    var realm: Realm!
    var notificationToken: NotificationToken!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initializeUniversities()

        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
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
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var usernameTextField: UITextField!

    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var reenterPasswordTextField: UITextField!
    
    @IBOutlet weak var universityTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    // still needs to check if account already exists
    @IBAction func createAccountPress() {
        if (isValidUsername(Input: usernameTextField.text!) && isValidPasswordAndPasswordsMatch(Pass1: passwordTextField.text!, Pass2: reenterPasswordTextField.text!) && isValidEmail(testStr: emailTextField.text!))
        {
            addAccount()
            queryAccounts()
            self.performSegue(withIdentifier: "segueCreateAccount", sender: nil)
        }
        else {
            print("Not valid username or password")
        }
    }
    
    func addAccount() {
        let userAccount = User()
        userAccount.username = usernameTextField.text!
        userAccount.password = passwordTextField.text!
        userAccount.email = emailTextField.text!
        userAccount.university = universityTextField.text!
        
        let realm = try! Realm()
        
        /*SyncUser.logIn(with: .usernamePassword(username: userAccount.username, password: userAccount.password, register: true), server: URL(string: "http://138.197.89.139:9080")!) { user, error in
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
        }*/
        
        try! realm.write {
            realm.add(userAccount)
            print("added account")
        }
    }
    
    func queryAccounts() {
        let realm = try! Realm()
        let allAccounts = realm.objects(User.self)
        for account in allAccounts {
            print("\(account.username) and \(account.password) and \(account.email)")
        }
    }
    
    //No special characters (e.g. @,#,$,%,&,*,(,),^,<,>,!,±)
    //Only letters, underscores and numbers allowed
    //Length should be 18 characters max and 7 characters minimum
    func isValidUsername(Input: String) -> Bool {
        let RegEx = "\\A\\w{7,18}\\z"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: Input)
    }
    
    func isValidPasswordAndPasswordsMatch(Pass1: String, Pass2: String) -> Bool {
        if ((Pass1 == Pass2) && (Pass1.characters.count >= 8)) {
            return true
        }
        else { return false }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(usernameTextField.text!)
        let user = self.realm.object(ofType: User.self, forPrimaryKey: usernameTextField.text!)
        if (segue.identifier == "segueCreateAccount") {
            let navigationController = segue.destination as! UINavigationController
            let masterViewController = navigationController.childViewControllers[0] as! ChannelViewController
            masterViewController.user = user
            masterViewController.university = self.realm.object(ofType: University.self, forPrimaryKey: universityTextField.text!)
            masterViewController.realm = self.realm
            print(masterViewController.university ?? "nap")
        }
    }
 

}

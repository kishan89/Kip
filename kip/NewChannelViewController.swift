//
//  NewChannelViewController.swift
//  kip
//
//  Created by Kishan Patel on 1/12/17.
//  Copyright © 2017 Kishan Patel. All rights reserved.
//

import UIKit
import RealmSwift

class NewChannelViewController: UIViewController, UITextFieldDelegate {
    
    var channel: Channel?
    var user: User?
    var university: University?
    
    var realm: Realm!
    
    @IBOutlet weak var channelNameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        channelNameTextField.delegate = self
        createButton.isEnabled = false
        
        channelNameTextField.autocorrectionType = .no
        
        //channelNameTextField.addTarget(self, action: #selector(textFieldDidChange(textfield:)), for: UIControlEvents.editingChanged)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelPress(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var createButton: UIBarButtonItem!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        createButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let text = channelNameTextField.text ?? ""
        createButton.isEnabled = !text.isEmpty
        createButton.isEnabled = validChannelName(name: channelNameTextField.text!)
        if !text.isEmpty {
            navigationItem.title = "#" + (channelNameTextField.text?.lowercased())!
        }
        else {
            navigationItem.title = "New Channel"
        }
        
        if (!createButton.isEnabled) {
            print("Names must be less than 25 characters, lowercase, and no special characters except underscores.")
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentCharacterCount = textField.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.characters.count - range.length
        return newLength <= 25
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let button = sender as? UIBarButtonItem, button === createButton else {
            return
        }
        
        //check if valid channel name
        if (validChannelName(name: channelNameTextField.text!))
        {
            self.channel = Channel()
            self.channel!.name = channelNameTextField.text!.lowercased()
            self.channel!.userWhoCreatedChannel = self.user!.username
            self.channel!.userCount += 1
            self.channel!.users.append(self.user!)

            try! self.realm.write {
                
                self.realm.add(channel!)
                self.university!.channels.append(channel!)
                self.user!.channels.append(channel!)
                //self.realm.add(self.university!, update: true)
            }


        }
        else {
            print("Names must be less than 25 characters, lowercase, and no special characters except underscores.")
        }
        

    }
    
    func validChannelName(name: String) -> Bool {
        let RegEx = "\\A\\w{0,25}\\z"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: name)
    }
}

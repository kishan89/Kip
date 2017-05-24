//
//  AddChannelViewController.swift
//  kip
//
//  Created by Kishan Patel on 3/4/17.
//  Copyright © 2017 Kishan Patel. All rights reserved.
//

import UIKit
import RealmSwift

class AddChannelViewController: UIViewController {
    
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    @IBOutlet weak var channelNameTextField: UILabel!
    
    @IBOutlet weak var channelDescriptionTextField: UILabel!
    
    var user: User?
    
    var channel: Channel?
    
    var realm: Realm!

    override func viewDidLoad() {
        super.viewDidLoad()

        channelNameTextField.text = self.channel?.name ?? ""
        channelDescriptionTextField.text = self.channel?.description ?? ""
        
        navigationItem.title = "#" + (self.channel?.name ?? "")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let button = sender as? UIBarButtonItem, button === addButton else {
            return
        }
        try! self.realm.write {
            if (!self.user!.channels.contains(self.channel!)) {
                self.user!.channels.append(self.channel!)
                
                self.channel!.users.append(self.user!)
                self.channel!.userCount += 1
            }
            //self.realm.add(user!, update: true)
        }
    }
    

}

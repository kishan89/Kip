//
//  ChannelViewController.swift
//  kip
//
//  Created by Kishan Patel on 2/8/17.
//  Copyright © 2017 Kishan Patel. All rights reserved.
//

import UIKit
import RealmSwift

class ChannelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var user : User?
    var university: University?
    
    var realm: Realm!
    var notificationToken: NotificationToken!
    //var lastChannel: Channel?    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var peakDetail: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.user = nil
    }
    
    func rChannelQuery() {
        //let realm = try! Realm()
        let allChannels = self.realm.objects(Channel.self)
        for channel in allChannels {
            print("\(channel.name)")
        }
    }
    
    func addChannel(channel: Channel) {
        //let realm = try! Realm()
        //realm.beginWrite()

        //DispatchQueue.main.async {
            do {
            try self.university?.realm?.write ({
                
                self.realm.add(channel)
                self.university!.channels.append(channel)
                self.user!.channels.append(channel)
                //self.realm.add(self.university!, update: true)
            })
            }
            catch _ {
                print("poopy diaper")
            }

       //}
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("realm1")
        print(self.realm)
        
        /*
        SyncUser.logIn(with: .usernamePassword(username: self.user!.username, password: self.user!.password, register: false), server: URL(string: "http://138.197.89.139:9080")!) { user, error in
            guard let user = user else {
                fatalError(String(describing: error))
            }
            
            print(self.realm.configuration.fileURL)
            
            /*
            DispatchQueue.main.async {
                let configuration = Realm.Configuration(
                    syncConfiguration: SyncConfiguration(user: user, realmURL: URL(string: "realm://138.197.89.139:9080")!)
                    )
                    
                    //Realm.Configuration.defaultConfiguration = config
                    self.realm = try! Realm(configuration: configuration)
            }
            */
        }
        */
        
        print("realm2")
        print(self.realm)
        
        print(self.university)
        
        navigationItem.title = "Channels"
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapPeakDetail))
        self.peakDetail.addGestureRecognizer(tap)
        
        print("HELLLLLLOOOOO")
        print(self.user ?? "no user exists")
    }
    
    func tapPeakDetail(_ sender: UITapGestureRecognizer) {
        //self.performSegue(withIdentifier: "ShowDetailSegue", sender: nil)
        print("peak")
    }
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(self.user!.channels.count)
        return self.user!.channels.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelCell", for: indexPath)
        
        // Configure the cell...
        
        let channel = self.user!.channels[indexPath.row]
        cell.textLabel!.text = "#" + channel.name
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailSegue" {
            //saveChannels()
            let detailViewController = segue.destination as! DetailViewController
            // Get the cell that generated this segue.
            if let selectedChannelCell = sender {
                let indexPath = tableView.indexPath(for: selectedChannelCell as! UITableViewCell)!
                self.tableView.deselectRow(at: indexPath, animated: true)
                let selectedChannel = user!.channels[indexPath.row]
                detailViewController.realm = self.realm
                detailViewController.channel = selectedChannel
                detailViewController.user = self.user
                detailViewController.university = self.university
            }
        }
        else if segue.identifier == "createNewChannelSegue" {
            let destination = segue.destination as! NewChannelViewController
            destination.user = self.user
        }
        else if segue.identifier == "showUserSegue" {
            let userViewController = segue.destination as! UserViewController
            //let userViewController = navigationController.viewControllers[0] as! UserViewController
            userViewController.user = self.user
            userViewController.source = segue.source
        }
        else if segue.identifier == "segueToAllChannels" {
            let destination = segue.destination as! AllChannelsViewController
            destination.user = self.user
            destination.university = self.university
            destination.realm = self.realm
        }
    }
    
    @IBAction func unwindToChannels(sender: UIStoryboardSegue) {
        print("reached unwindtochannel func")

        if let sourceViewController = sender.source as? NewChannelViewController {
            //if let newChannel = sourceViewController.channel {
                //let newIndexPath = IndexPath(row: university!.channels.count, section: 0)
                //addChannel(channel: newChannel)
                //print(newChannel)
                //self.tableView.insertRows(at: [newIndexPath], with: .automatic)
            //}
            self.realm = sourceViewController.realm
            tableView.reloadData()
            
        }
        else if sender.source is UserViewController {
            //stuff
        }
        else if sender.source is AddChannelViewController {
            print("unwinding from add channel vc")
            tableView.reloadData()
        }

    }
    
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
}

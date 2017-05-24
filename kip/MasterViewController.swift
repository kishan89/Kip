//
//  MasterViewControllerTableViewController.swift
//  kip
//
//  Created by Kishan Patel on 1/8/17.
//  Copyright © 2017 Kishan Patel. All rights reserved.
//

import UIKit
import RealmSwift

class MasterViewController: UITableViewController {
    
    var user : User?
    var university: University?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.user = nil
    }
    
    func rChannelQuery() {
        let realm = try! Realm()
        let allChannels = realm.objects(Channel.self)
        for channel in allChannels {
            print("\(channel.name)")
        }
    }
    
    private func addChannel(channel: Channel) {
        let realm = try! Realm()
        try! realm.write {
            university!.channels.append(channel)
            realm.add(channel)
        }
    }
    
    private func loadChannels() {
        let realm = try! Realm()
        for channel in realm.objects(Channel.self) {
            university!.channels.append(channel)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //addChannels()
        //loadChannels()
        print(self.user ?? "no user exists")
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.university!.channels.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelCell", for: indexPath)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none

        // Configure the cell...
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero

        let channel = self.university!.channels[indexPath.row]
        cell.textLabel?.text = "#" + channel.name

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailSegue" {
            //saveChannels()
            let detailViewController = segue.destination as! DetailViewController
            // Get the cell that generated this segue.
            if let selectedChannelCell = sender {
                let indexPath = tableView.indexPath(for: selectedChannelCell as! UITableViewCell)!
                let selectedChannel = university!.channels[indexPath.row]
                detailViewController.channel = selectedChannel
                detailViewController.user = self.user
                detailViewController.university = self.university
            }
        }
        else if segue.identifier == "createNewChannelSegue" {
            let navigationController = segue.destination as! UINavigationController
            let newChannelViewController = navigationController.viewControllers[0] as! NewChannelViewController
            newChannelViewController.user = self.user
        }
        else if segue.identifier == "showUserSegue" {
            let navigationController = segue.destination as! UINavigationController
            let userViewController = navigationController.viewControllers[0] as! UserViewController
            userViewController.user = self.user
        }
    }
    
//    @IBAction func unwindToChannelList(sender: UIStoryboardSegue) {
//        print("reached unwindtochannel func")
//        
//        //does not reach this IF statement
//        if let sourceViewController = sender.source as? NewChannelViewController {
//            if let newChannel = sourceViewController.channel {
//                let newIndexPath = IndexPath(row: university!.channels.count, section: 0)
//            addChannel(channel: newChannel)
//            print(newChannel)
//            tableView.insertRows(at: [newIndexPath], with: .automatic)
//            }
//        }
//        else if sender.source is UserViewController {
//            //stuff
//        }
//    }
    
 

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

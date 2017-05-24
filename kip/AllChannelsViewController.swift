//
//  AllChannelsViewController.swift
//  kip
//
//  Created by Kishan Patel on 2/14/17.
//  Copyright © 2017 Kishan Patel. All rights reserved.
//

import UIKit
import RealmSwift

class AllChannelsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var channels = List<Channel>()
        
    var filteredChannels = List<Channel>()
    
    var shouldShowSearchResults = false
    var searchController = UISearchController()
    
    var user: User?
    var university: University?
    
    var realm: Realm!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //searchController.searchBar.showsCancelButton = false
        
        tableView.delegate = self
        tableView.dataSource = self
        
        channels.removeAll(keepingCapacity: true)
        
        for channel in self.university!.channels {
            if (!(self.user!.channels.contains(channel))) {
                channels.append(channel)
            }
        }
        
        
        //print(self.university!.channels)
        print(channels)
        
        //configureSearchController()
        navigationItem.title = "Add Channels"
        
        
//        self.searchController = ({
//            let controller = UISearchController(searchResultsController: nil)
//            controller.searchResultsUpdater = self
//            controller.dimsBackgroundDuringPresentation = false
//            controller.searchBar.sizeToFit()
//            
//            self.tableView.tableHeaderView = controller.searchBar
//            
//            return controller
//        })()
        
        self.searchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.hidesNavigationBarDuringPresentation = false
            tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        tableView.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchController.isActive {
            return self.filteredChannels.count
        } else {
            print("COUNT:")
            print(self.channels.count)
            return self.channels.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelCell", for: indexPath) as! ChannelTableViewCell

        if self.searchController.isActive {
            let channel = self.filteredChannels[indexPath.row]
            cell.channelNameLabel.text = "#" + channel.name
            cell.memberCountLabel.text = "\(channel.userCount)"
            
            return cell
        }
        else {
            let channel = self.channels[indexPath.row]
            cell.channelNameLabel.text = "#" + channel.name
            cell.memberCountLabel.text = "\(channel.userCount)"
            
            return cell
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        self.tableView.reloadData()
        self.filteredChannels.removeAll(keepingCapacity: false)
        
        guard let searchText = searchController.searchBar.text else {
            return
        }
        
        print(searchText)
        
        let filtered = self.channels.filter {
            return $0.name.range(of: searchText) != nil
            //can add more with || $0.....
        }
        
        var arrayFiltered = List<Channel>()
        
        for f in filtered {
            arrayFiltered.append(f)
        }
        
        self.filteredChannels = arrayFiltered
        
        self.tableView.reloadData()
        
        print(filteredChannels)
        
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showChannel") {
            let dest = segue.destination as! AddChannelViewController
            
            if let selectedChannelCell = sender {
                let indexPath = tableView.indexPath(for: selectedChannelCell as! UITableViewCell)!
                self.tableView.deselectRow(at: indexPath, animated: true)
                let selectedChannel = self.channels[indexPath.row]
                
                dest.realm = self.realm
                dest.user = self.user!
                dest.channel = selectedChannel
            }
        }
        else if (segue.identifier == "createNewChannel") {
            let dest = segue.destination as! NewChannelViewController
            
            dest.user = self.user!
            dest.realm = self.realm
            dest.university = self.university!
        }
    }
}

    /*
 
    
    func configureSearchController() {
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Search " + (self.university?.universityName ?? "") + " Channels"
        self.searchController.searchBar.delegate = self

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            tableView.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }
    
    
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text!
        self.filteredChannels = self.university?.channels.filter({( aChannel: Channel) -> Bool  in
            return aChannel.name.lowercased().range(of: searchString.lowercased()) != nil
        })

    }
    
    
    
//    func filterContentForSaarchText(searchText: String) {
//        if (self.university?.channels == nil) {
//            self.filteredChannels = nil
//            return
//        }
//            }
//    
//    func searchController(_ controller: UISearchController, shouldReloadTableForSearch searchString: String?) -> Bool {
//        self.filteredContent
//        self.filterContentForSaarchText(searchText: searchString!)
//        return true
//    }
    
    

 
 
 

} */

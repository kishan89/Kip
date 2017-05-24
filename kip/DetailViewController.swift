//
//  DetailViewController.swift
//  kip
//
//  Created by Kishan Patel on 1/8/17.
//  Copyright © 2017 Kishan Patel. All rights reserved.
//

import UIKit
import RealmSwift

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIActionSheetDelegate,
UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var user : User?
    var channel: Channel
    var university: University?
    
    var realm: Realm!
    var notificationToken: NotificationToken!
    
    var allChannels = [String]()
    var allUsers = [String]()
        
    var imagePicker = UIImagePickerController()
    
    var imageSelected: Bool = false
    
    @IBOutlet weak var userTableView: UITableView!
  
    @IBOutlet weak var channelTableView: UITableView!
    
    @IBOutlet weak var postsTableView: UITableView!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func addImagePress() {
        let alert = UIActionSheet(title: "Add Media", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil)
        alert.delegate = self

        alert.addButton(withTitle: "Choose From Library")
        alert.show(in: self.view)
    }
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        if (buttonIndex == 1) {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum) {
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }

        }
    }
    
    var imageDataForImagePost: NSData?
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!) {
        self.dismiss(animated: true, completion: { () -> Void in })
        
        self.imageSelected = true
        let image = image
        self.imageDataForImagePost = UIImageJPEGRepresentation(image!, 0.6) as NSData!
    }
    
    @IBAction func sendButtonPress() {
        userTableView.isHidden = true
        channelTableView.isHidden = true
        
        if (self.imageSelected == false) {
            addPost()
            textField.text = ""
        }
        
        if (self.imageSelected == true) {
            addImagePost()
            print("hiya")
            textField.text = ""
        }
    }
    
    func addImagePost() {
        let post = Post()
        post.text = textField.text!
        post.userWhoCreatedPost = self.user!.username
        post.isImagePost = true
        textField.resignFirstResponder()
        
        //handle the image
        post.imageData = self.imageDataForImagePost!

        //save to Realm
        try! self.channel.realm?.write {
//        let realm = try! Realm()
//        try! realm.write {
            self.realm.add(post)
            self.channel.posts.append(post)
        }
        
        //insert Post to table
        let indexPath = NSIndexPath(row: self.channel.posts.count-1, section: 0) as IndexPath
        postsTableView.beginUpdates()
        postsTableView.insertRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        postsTableView.endUpdates()
        
        self.postsTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    func addPost() {
        let post = Post()
        if (textField.text != "") {
            textField.resignFirstResponder()
            post.text = textField.text!
            post.userWhoCreatedPost = self.user!.username
            //let realm = try! Realm()
            try! self.realm.write {
                self.realm.add(post)
                self.channel.posts.append(post)
            }
            let indexPath = NSIndexPath(row: self.channel.posts.count-1, section: 0) as IndexPath
            postsTableView.beginUpdates()
            postsTableView.insertRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            postsTableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    @objc(tableView:heightForRowAtIndexPath:) func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(self.bottomConstraint.constant)
        
        self.bottomConstraint.constant = 8
        for post in self.channel.posts {
            print(post)
        }
        navigationItem.title = "#" + self.channel.name
        
        for channel in (self.university!.channels) {
            self.allChannels.append(channel.name)
        }
        
        //let realm = try! Realm()
        print(self.university!.universityName)
        let users = self.realm.objects(User.self).filter("university == '\(self.university!.universityName)'")
        for user in users {
            self.allUsers.append(user.username)
        }
        print(users)
        
        let channelPath = UIBezierPath(roundedRect: channelTableView.bounds,
                                byRoundingCorners:[.topRight, .topLeft],
                                cornerRadii: CGSize(width: 10, height:  10))
        let channelMaskLayer = CAShapeLayer()
        channelMaskLayer.path = channelPath.cgPath
        channelTableView.layer.mask = channelMaskLayer
        
        let userPath = UIBezierPath(roundedRect: userTableView.bounds,
                                    byRoundingCorners: [.topRight, .topLeft],
                                    cornerRadii: CGSize(width: 10, height: 10))
        let userMaskLayer = CAShapeLayer()
        userMaskLayer.path = userPath.cgPath
        userTableView.layer.mask = userMaskLayer
        
        postsTableView.delegate = self
        postsTableView.dataSource = self
        channelTableView.delegate = self
        channelTableView.dataSource = self
        userTableView.delegate = self
        userTableView.dataSource = self
        textField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        textField.addTarget(self, action: #selector(textFieldDidChange(textfield:)), for: UIControlEvents.editingChanged)
        
        let userTap = UITapGestureRecognizer(target: self, action: #selector(userTapped))
        userTableView.addGestureRecognizer(userTap)
        
        let channelTap = UITapGestureRecognizer(target: self, action: #selector(channelTapped))
        channelTableView.addGestureRecognizer(channelTap)
        
        channelTableView.isHidden = true
        userTableView.isHidden = true
        
        if (self.channel.posts.count > 0) {
            let indexPath = NSIndexPath(row: self.channel.posts.count-1, section: 0) as IndexPath
        self.postsTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
        
    }
    
    func textFieldDidChange(textfield: UITextField) {
        if (textfield.text?.characters.last == "@") {
            channelTableView.isHidden = true
            userTableView.isHidden = false
            
        }
        else if (textfield.text?.characters.last == "#") {
            userTableView.isHidden = true
            channelTableView.isHidden = false
        }
        else {
            userTableView.isHidden = true
            channelTableView.isHidden = true
        }
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView == self.userTableView) {
            print("user table")
        }
        else if (tableView == self.channelTableView) {
            print("channel table")
        }
    }

//    
//    if let selectedChannelCell = sender {
//        let indexPath = tableView.indexPath(for: selectedChannelCell as! UITableViewCell)!
//        let selectedChannel = university!.channels[indexPath.row]
//        detailViewController.channel = selectedChannel
//        detailViewController.user = self.user
//        detailViewController.university = self.university
//    }

    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let frame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        print(frame.height)
        self.bottomConstraint.constant = 266
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let frame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        self.bottomConstraint.constant = 8
    }
    
    func keyboardDidHide(notification: NSNotification) {
        let indexPath = NSIndexPath(row: self.channel.posts.count-1, section: 0) as IndexPath
        //self.postsTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //userOrChannelTableView.isHidden = true
        textField.resignFirstResponder()
        self.bottomConstraint.constant = 8
        return true
    }
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
//    func keyboardWasShown(notification: NSNotification) {
//        let info = notification.userInfo!
//        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
//        
//        UIView.animate(withDuration: 0.1, animations: { () -> Void in
//            self.bottomConstraint.constant = keyboardFrame.size.height + 20
//        })
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    required init?(coder aDecoder: NSCoder) {
        self.channel = Channel()
        self.user = nil
        super.init(coder: aDecoder)
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (tableView == self.postsTableView) {
            return self.channel.posts.count
        }
        else if (tableView == self.channelTableView) {
            let tableHeight = CGFloat(44*(self.allChannels.count))
            let heightConstraint = NSLayoutConstraint(item: channelTableView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: tableHeight)
            channelTableView.addConstraint(heightConstraint)
            return self.allChannels.count
        }
        else if (tableView == self.userTableView) {
            let tableHeight = CGFloat(44*(self.allUsers.count))
            let heightConstraint = NSLayoutConstraint(item: userTableView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: tableHeight)
            userTableView.addConstraint(heightConstraint)
            return self.allUsers.count
        }
        else {
            return 0
        }
    }
    
    var otherUserUsername: String?
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == self.postsTableView) {
            let post = self.channel.posts[indexPath.row]
            if (post.isImagePost == false) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
                
                let postUserTap = UITapGestureRecognizer(target: self, action: #selector(postUserTapped))
                cell.postImage.addGestureRecognizer(postUserTap)
                cell.postUserLabel.addGestureRecognizer(postUserTap)
                
                // Configure the cell...
                cell.postLabel.text = post.text
                cell.postUpvotesLabel.text = "\(post.upvotes)"
                //let realm = try! Realm()
                let postUser = self.realm.object(ofType: User.self, forPrimaryKey: post.userWhoCreatedPost)
                cell.postUserLabel.text = postUser!.username
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM-dd-yy HH:mm"
                let stringDate = dateFormatter.string(from: post.timestamp as Date)
                cell.postTimeLabel.text = stringDate
                cell.postImage.image = UIImage(data: postUser!.profilePictureData as Data)
                
                cell.postImage.layer.cornerRadius = cell.postImage.frame.size.width/10
                cell.postImage.clipsToBounds = true
                if (post.likers.contains(self.user!)) {
                    cell.likeButton.setImage(#imageLiteral(resourceName: "heart filled"), for: .normal)
                }
                
                return cell
            }
                
            //cell for post with image
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ImagePostCell", for: indexPath) as! ImagePostTableViewCell
                
                let postUserTap = UITapGestureRecognizer(target: self, action: #selector(postUserTapped))
                cell.postProfileImage.addGestureRecognizer(postUserTap)
                cell.usernameLabel.addGestureRecognizer(postUserTap)
                
                //tableView.rowHeight.addco
                // Configure the image cell
                cell.upvotesLabel.text = "\(post.upvotes)"
                //let realm = try! Realm()
                let postUser = self.realm.object(ofType: User.self, forPrimaryKey: post.userWhoCreatedPost)
                
                cell.usernameLabel.text = postUser!.username
                cell.postProfileImage.image = UIImage(data: postUser!.profilePictureData as Data)
                cell.postProfileImage.layer.cornerRadius = cell.postProfileImage.frame.size.width/10
                cell.postProfileImage.clipsToBounds = true
                
                cell.postImage.image = UIImage(data: post.imageData as Data)
                cell.postTextField.text = post.text
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM-dd-yy HH:mm"
                let stringDate = dateFormatter.string(from: post.timestamp as Date)
                cell.postTimeLabel.text = stringDate
                
                if (post.likers.contains(self.user!)) {
                    cell.likeButton.setImage(#imageLiteral(resourceName: "heart filled"), for: .normal)
                }
                
                //set image post height constraint
                let imageHeight = UIImage(data: post.imageData as Data)?.size.height
                let imageWidth = UIImage(data: post.imageData as Data)?.size.width
                let ratio = imageHeight!/imageWidth!
            
                let heightConstraint = NSLayoutConstraint(item: cell, attribute: .height, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 255*ratio)
                cell.addConstraint(heightConstraint)
            
                let imageHeightConstraint = NSLayoutConstraint(item: cell.postImage, attribute: .height, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute,  multiplier: 1.0, constant: 255*ratio)
                cell.postImage.addConstraint(imageHeightConstraint)
            
                let widthConstraint = NSLayoutConstraint(item: cell.postImage, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 255)
                cell.postImage.addConstraint(widthConstraint)
                
                self.imageSelected = false
                return cell
            }
        }
            
        //Channel cell
        else if (tableView == self.channelTableView) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelCell", for: indexPath)
            cell.textLabel!.text = self.allChannels[indexPath.row]
            return cell
        }
            
        //User cell
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
            cell.textLabel!.text = self.allUsers[indexPath.row]
            return cell
        }
        
    }
    
    func postUserTapped(_ sender: UITapGestureRecognizer) {
        print("suppp")
        let tapLocation = sender.location(in: self.postsTableView)
        if let tappedIndexPath = postsTableView.indexPathForRow(at: tapLocation) {
            if let tappedCell = self.postsTableView.cellForRow(at: tappedIndexPath) as? PostTableViewCell
            {
                otherUserUsername = tappedCell.postUserLabel.text
                
                if (self.user?.username == otherUserUsername) {
                    self.performSegue(withIdentifier: "segueToMe", sender: nil)
                }
                else {
                    self.performSegue(withIdentifier: "SegueToOtherUser", sender: nil)
                }
            }
            else if let tappedCell = self.postsTableView.cellForRow(at: tappedIndexPath) as? ImagePostTableViewCell
            {
                otherUserUsername = tappedCell.usernameLabel.text
                
                if (self.user?.username == otherUserUsername) {
                    self.performSegue(withIdentifier: "segueToMe", sender: nil)
                }
                else {
                    self.performSegue(withIdentifier: "SegueToOtherUser", sender: nil)
                }
            }
        }

    }
    
    func userTapped(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: self.userTableView)
        if let tappedIndexPath = userTableView.indexPathForRow(at: tapLocation) {
            if let tappedCell = self.userTableView.cellForRow(at: tappedIndexPath) {
                let username = tappedCell.textLabel?.text
                self.textField.text = self.textField.text! + username! + " "
                userTableView.isHidden = true
            }
        }
    }
    
    func channelTapped(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: self.channelTableView)
        if let tappedIndexPath = channelTableView.indexPathForRow(at: tapLocation) {
            if let tappedCell = self.channelTableView.cellForRow(at: tappedIndexPath) {
                let channelname = tappedCell.textLabel?.text
                self.textField.text = self.textField.text! + channelname! + " "
                channelTableView.isHidden = true
            }
        }
    }
    
    // DOES NOT WORK
    @IBAction func upvotePress(_ sender: UIButton) {
        print("upvote press")
        let button = sender
        let view = button.superview!
        //let realm = try! Realm()
        

        //never reaches
        if (view.superview!.isKind(of: PostTableViewCell.self)) {
            let cell = view.superview as! PostTableViewCell
            let indexPath = postsTableView.indexPath(for: cell)
            let post = self.channel.posts[indexPath!.row]
            
            let index = post.likers.index(of: self.user!)
            
            if (index == nil) {
                button.setImage(#imageLiteral(resourceName: "heart filled") as UIImage, for: .normal)
                try! self.realm.write {
                    post.likers.append(self.user!)
                    post.upvotes += 1
                }
            }
            else {
                button.setImage(#imageLiteral(resourceName: "heart") as UIImage, for: .normal)
                try! self.realm.write {
                    post.likers.remove(objectAtIndex: index!)
                    post.upvotes -= 1
                }
            }
            cell.postUpvotesLabel.text = "\(post.upvotes)"

        }
            
        //never reaches
        else if (view.superview!.isKind(of: ImagePostTableViewCell.self)) {
            let cell = view.superview as! ImagePostTableViewCell
            let indexPath = postsTableView.indexPath(for: cell)
            let post = self.channel.posts[indexPath!.row]
            
            let index = post.likers.index(of: self.user!)
            
            if (index == nil) {
                button.setImage(#imageLiteral(resourceName: "heart filled") as UIImage, for: .normal)
                try! self.realm.write {
                    post.likers.append(self.user!)
                    post.upvotes += 1
                }
            }
            else {
                button.setImage(#imageLiteral(resourceName: "heart") as UIImage, for: .normal)
                try! self.realm.write {
                    post.likers.remove(objectAtIndex: index!)
                    post.upvotes -= 1
                }
            }
            cell.upvotesLabel.text = "\(post.upvotes)"
        }
    }
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func sortPosts(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            print("0")
        case 1:
            print("1")
        default:
            break
        }
    }
    
    @IBAction func unwindToChannel(sender: UIStoryboardSegue) {
        
    }
    
    
     // MARK: - Navigation
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "SegueToOtherUser") {
            let destinationViewController = segue.destination as! OtherUserViewController
            destinationViewController.otherUserUsername = self.otherUserUsername
            destinationViewController.loggedInUserUsername = self.user?.username
        }
        else if (segue.identifier == "segueToMe") {
            let userViewController = segue.destination as! UserViewController
            //let userViewController = navigationController.viewControllers[0] as! UserViewController
            userViewController.channel = self.channel
            userViewController.user = self.user
            userViewController.source = segue.source
        }
     }
    

}

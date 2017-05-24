//
//  AllRealmObjects.swift
//  kip
//
//  Created by Kishan Patel on 1/9/17.
//  Copyright © 2017 Kishan Patel. All rights reserved.
//

import Foundation
import RealmSwift

class Channel: Object {
    dynamic var name = ""
    let posts = List<Post>()
    dynamic var userWhoCreatedChannel = ""
    dynamic var userCount = 0
    let university = LinkingObjects(fromType: University.self, property: "channels").first
    let users = List<User>()
    override class func primaryKey() -> String? {
        return "name"
    }
    let user = LinkingObjects(fromType: User.self, property: "channels")
    
    //dynamic var description = ""
    
}

class Post: Object {
    let channel = LinkingObjects(fromType: Channel.self, property: "posts").first
    dynamic var text = ""
    dynamic var upvotes = 0
    dynamic var timestamp = NSDate()
    dynamic var userWhoCreatedPost = ""
    dynamic var imageData = NSData()
    dynamic var isImagePost = false
    
    let likers = List<User>()
}

class User: Object {
    dynamic var username = ""
    dynamic var password = ""
    dynamic var email = ""
    dynamic var profilePictureData = NSData()
    dynamic var university = ""
    let channels = List<Channel>()
    //dynamic var numberOfPosts = 0
    
    override class func primaryKey() -> String? {
        return "username"
    }
    let channel = LinkingObjects(fromType: Channel.self, property: "users")
}

class University: Object {
    dynamic var universityName = ""
    //dynamic var universityAcronym = ""
    let channels = List<Channel>()
    
    override class func primaryKey() -> String? {
        return "universityName"
    }
}

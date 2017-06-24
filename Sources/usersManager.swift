//
//  usersManager.swift
//  YouAreBeautifulKitura
//
//  Created by Oscar Mendoza Ochoa on 5/20/17.
//
//

import Foundation
import MongoDB
import SwiftyJSON

class usersManager {
    var client: MongoClient
    var collection: MongoCollection

    
    init() {
        client = try! MongoClient(uri: "mongodb://localhost")
        collection = MongoCollection(
            client: client,
            databaseName: "test",
            collectionName: "movies"
        )
    }
    
    public func save(_ user: JSON) -> Bool {
        do {
            let mybson
            collection.save(document: BSON(json: {
                do {
                    return user.stringValue
                } catch {
                    
                }
                return ""
            } ))
        
//        collection.rename(
//            newDbName: "YAB",
//            newCollectionName: "user",
//            dropExisting:true
//        )
        } catch {
        
        }
        return false
    }
    
//    public func find(_ facebook_id: String) -> userProfile? {
        
//        return userProfile()
//    }
}

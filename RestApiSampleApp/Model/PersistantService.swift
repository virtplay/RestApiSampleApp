//
//  PersistantService.swift
//  RestApiSampleApp
//
//  Created by Karthik on 27/12/18.
//  Copyright © 2018 k4. All rights reserved.
//

import Foundation
import CoreData

class PersistantService {
    
    static var context : NSManagedObjectContext = persistentContainer.viewContext


    private init(){
    
    }
    //Call this function to save a page to core data
    static func saveObj(userObj: UserInfo){
        
        if(!checkIfExist(identifier: userObj.emailId!)){
            // If not present only then insert
            var tempUserObj = userObj
            let itemToSave: UserData = NSEntityDescription.insertNewObject(forEntityName: "UserData", into: context) as! UserData
            
            itemToSave.emailId = tempUserObj.emailId
            itemToSave.imageUrl = tempUserObj.imageUrl
            itemToSave.firstName = tempUserObj.firstName
            itemToSave.lastName = tempUserObj.lastName
            itemToSave.image = tempUserObj.downloadPhotoData(tempUserObj.imageUrl)
            do {
                try context.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        
    }
    
    //Function to get saved page list from core data
    static func getSavedObjets()->[UserInfo] {
        
        let fetchRequest = NSFetchRequest<UserData>(entityName: "UserData")
        var userDataArray = [UserData]()
        var userInfoArray = [UserInfo]()
        
        do {
            userDataArray = try context.fetch(fetchRequest)
            for obj in userDataArray {
                userInfoArray.append(UserInfo.init(emailId: obj.emailId, imageUrl: obj.imageUrl, firstName: obj.firstName, lastName: obj.lastName, image: obj.image))
                
            }
//            print(userInfoArray)
            
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        return userInfoArray
    }
    
    //Call this function to delete already added entries from core data
    static func deleteAllEntries() {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "UserInfo")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
        
    }
    
    //Call this function to check if info already exists
    static func checkIfExist(identifier:String)->Bool{
        let fetchRequest = NSFetchRequest<UserData>(entityName: "UserData")
        var imgsArray = [UserData]()
        var res = false
        
        do {
            imgsArray = try context.fetch(fetchRequest)
            res = imgsArray.contains { (image) -> Bool in
                return image.emailId == identifier
            }
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        return res
    }
    
    // MARK: - Core Data stack
    
    static var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "RestApiSampleApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    static func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

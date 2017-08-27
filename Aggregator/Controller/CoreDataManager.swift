//
//  CoreDataManager.swift
//  Aggregator
//
//  Created by Mac Mini on 8/27/17.
//  Copyright © 2017 Netsol. All rights reserved.
//
import Foundation
import CoreData

class CoreDataManager: NSObject {
    
    static let sharedInstance = CoreDataManager()
    private override init() {}
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Aggregator")
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
    
    func saveContext () {
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
    
    // Start of Vehicle Usage Transactions
    func clearVehicleUsage() {
        do {
            let context = persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: VEHICLE_USAGE.self))
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                self.saveContext()
            } catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }
    
    func saveInVehicleUsageWith(array: [[[String: AnyObject]]]) {
        for array in array {
            let data = array as [[String:Any]]
            _ = data.map{self.createVehicleUsageEntityFrom(dictionary: $0 as [String : AnyObject])}
            do {
                try persistentContainer.viewContext.save()
            } catch let error {
                print(error)
            }
        }
    }
    
    private func createVehicleUsageEntityFrom(dictionary: [String: AnyObject]) -> NSManagedObject? {
        
        let context = persistentContainer.viewContext
        if let usageEntity = NSEntityDescription.insertNewObject(forEntityName: String(describing: VEHICLE_USAGE.self), into: context) as? VEHICLE_USAGE {
            usageEntity.usageID = dictionary["id"] as? String
            usageEntity.usageName = dictionary["name"] as? String
            return usageEntity
        }
        return nil
    }
    // End of Vehicle Usage Transactions
    
    // Start of Vehicle Make Transactions
    func clearVehicleMake() {
        do {
            let context = persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: VEHICLE_MAKE.self))
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                self.saveContext()
            } catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }
    
    func saveInVehicleMakeWith(array: [[[String: AnyObject]]]) {
        for array in array {
            let data = array as [[String:Any]]
            _ = data.map{self.createVehicleMakeEntityFrom(dictionary: $0 as [String : AnyObject])}
            do {
                try persistentContainer.viewContext.save()
            } catch let error {
                print(error)
            }
        }
    }
    
    private func createVehicleMakeEntityFrom(dictionary: [String: AnyObject]) -> NSManagedObject? {
        
        let context = persistentContainer.viewContext
        if let makeEntity = NSEntityDescription.insertNewObject(forEntityName: String(describing: VEHICLE_MAKE.self), into: context) as? VEHICLE_MAKE {
            makeEntity.makeID = dictionary["id"] as? String
            makeEntity.makeName = dictionary["name"] as? String
            return makeEntity
        }
        return nil
    }
    // End of Vehicle Make Transactions
    
    // Start of Vehicle Model Transactions
    func clearVehicleModel() {
        do {
            let context = persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: VEHICLE_MODEL.self))
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                self.saveContext()
            } catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }
    
    func saveInVehicleModelWith(array: [[[String: AnyObject]]]) {
        for array in array {
            let data = array as [[String:Any]]
            _ = data.map{self.createVehicleModelEntityFrom(dictionary: $0 as [String : AnyObject])}
            do {
                try persistentContainer.viewContext.save()
            } catch let error {
                print(error)
            }
        }
    }
    
    private func createVehicleModelEntityFrom(dictionary: [String: AnyObject]) -> NSManagedObject? {
        
        let context = persistentContainer.viewContext
        if let modelEntity = NSEntityDescription.insertNewObject(forEntityName: String(describing: VEHICLE_MODEL.self), into: context) as? VEHICLE_MODEL {
            modelEntity.makeID = dictionary["make_id"] as? String
            modelEntity.makeName = dictionary["make_name"] as? String
            modelEntity.modelID = dictionary["model_id"] as? String
            modelEntity.modelName = dictionary["model_name"] as? String
            return modelEntity
        }
        return nil
    }
    // End of Vehicle model Transactions
    
    // Start of RTO Transactions
    func clearRto() {
        do {
            let context = persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: VEHICLE_RTO.self))
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                self.saveContext()
            } catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }
    
    func saveInRtoWith(array: [[[String: AnyObject]]]) {
        for array in array {
            let data = array as [[String:Any]]
            _ = data.map{self.createRtoEntityFrom(dictionary: $0 as [String : AnyObject])}
            do {
                try persistentContainer.viewContext.save()
            } catch let error {
                print(error)
            }
        }
    }
    
    private func createRtoEntityFrom(dictionary: [String: AnyObject]) -> NSManagedObject? {
        
        let context = persistentContainer.viewContext
        if let rtoEntity = NSEntityDescription.insertNewObject(forEntityName: String(describing: VEHICLE_RTO.self), into: context) as? VEHICLE_RTO {
            rtoEntity.rtoID = dictionary["id"] as? String
            rtoEntity.rtoName = dictionary["name"] as? String
            return rtoEntity
        }
        return nil
    }
    // End of RTO Transactions
    
    // Start of Vehicle Type Transactions
    func clearVehicleType() {
        do {
            let context = persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: VEHICLE_TYPE.self))
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                self.saveContext()
            } catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }
    
    func saveInVehicleTypeWith(array: [[[String: AnyObject]]]) {
        for array in array {
            let data = array as [[String:Any]]
            _ = data.map{self.createVehicleTypeEntityFrom(dictionary: $0 as [String : AnyObject])}
            do {
                try persistentContainer.viewContext.save()
            } catch let error {
                print(error)
            }
        }
    }
    
    private func createVehicleTypeEntityFrom(dictionary: [String: AnyObject]) -> NSManagedObject? {
        
        let context = persistentContainer.viewContext
        if let typeEntity = NSEntityDescription.insertNewObject(forEntityName: String(describing: VEHICLE_TYPE.self), into: context) as? VEHICLE_TYPE {
            typeEntity.usageID = dictionary["usageCode"] as? String
            typeEntity.usageName = dictionary["usageType"] as? String
            typeEntity.typeID = dictionary["vehicleCode"] as? String
            typeEntity.typeName = dictionary["vehicleType"] as? String
            typeEntity.gvw = dictionary["gvwRequired"] as? String
            return typeEntity
        }
        return nil
    }
    // End of Vehicle Type Transactions
    
    // Start of Vehicle Variant Transactions
    func clearVehicleVariant() {
        do {
            let context = persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: VEHICLE_VARIANT.self))
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                self.saveContext()
            } catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }
    
    func saveInVehicleVariantWith(array: [[[String: AnyObject]]]) {
        for array in array {
            let data = array as [[String:Any]]
            _ = data.map{self.createVehicleVariantEntityFrom(dictionary: $0 as [String : AnyObject])}
            do {
                try persistentContainer.viewContext.save()
            } catch let error {
                print(error)
            }
        }
    }
    
    private func createVehicleVariantEntityFrom(dictionary: [String: AnyObject]) -> NSManagedObject? {
        
        let context = persistentContainer.viewContext
        if let variantEntity = NSEntityDescription.insertNewObject(forEntityName: String(describing: VEHICLE_VARIANT.self), into: context) as? VEHICLE_VARIANT {
            variantEntity.makeID = dictionary["makeId"] as? String
            variantEntity.modelID = dictionary["modelId"] as? String
            variantEntity.variantID = dictionary["variantId"] as? String
            variantEntity.makeName = dictionary["makeName"] as? String
            variantEntity.variantName = dictionary["variantName"] as? String
            variantEntity.attribute = dictionary["vehicleAttr"] as? String
            variantEntity.startYear = dictionary["startYear"] as? String
            variantEntity.endYear = dictionary["endYear"] as? String
            variantEntity.sc = dictionary["sc"] as? String
            variantEntity.vehicleType = dictionary["vehicleType"] as? String
            variantEntity.numCycle = dictionary["numCyl"] as? String
            variantEntity.price = dictionary["price"] as? String
            return variantEntity
        }
        return nil
    }
    // End of Vehicle Variant Transactions
}

extension CoreDataManager {
    
    func applicationDocumentsDirectory() {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "yo.BlogReaderApp" in the application's documents directory.
        if let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last {
            print(url.absoluteString)
        }
    }
}






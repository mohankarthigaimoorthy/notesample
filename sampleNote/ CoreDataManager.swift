//
//   CoreDataManager.swift
//  sampleNote
//
//  Created by Mohan K on 14/03/23.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager(modelName: "Sample")
    
    let persistentContainer: NSPersistentContainer
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
        
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores{(description, error) in guard error == nil else {
            fatalError(error!.localizedDescription)
            
        }
            completion?()
        }
    }
        func creatNote() ->Sample {
            let sample = Sample(context: viewContext)
            sample.self.title = ""
            sample.text = ""
            sample.id = UUID().uuidString
            sample.date = Date()
            save()
            return sample
        }
    func save() {
        if viewContext.hasChanges {
            do{
                try viewContext.save()
                
            }
            catch {
                print("Error occured while saving data: \(error.localizedDescription) ")
            }
        }
    }
    
    func fetchNotes(filter: String? = nil) -> [Sample] {
        let  request: NSFetchRequest<Sample> = Sample.fetchRequest()
        let SortDescriptor = NSSortDescriptor(keyPath: \Sample.date,ascending: false)
        request.sortDescriptors = [SortDescriptor]
        
        if let filter = filter {
            let pr1 = NSPredicate(format: "title contains[cd] %@", filter)
            let pr2 = NSPredicate(format: "text contains[cd] %@", filter)
            let predicate = NSCompoundPredicate(type: .or, subpredicates: [pr1, pr2])
            request.predicate = predicate
        }
        return (try? viewContext.fetch(request)) ?? []
    }
    func deleteNote(_ sample: Sample) {
        viewContext.delete(sample)
        save()
    }
    
}

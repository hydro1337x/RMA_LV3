//
//  PersonsTableViewModel.swift
//  Inspiring
//
//  Created by Benjamin Mecanovic on 21/04/2020.
//  Copyright © 2020 hydro1337x. All rights reserved.
//

import UIKit
import CoreData

protocol PeopleTableViewModelDelegate: class {
    
}

class PeopleTableViewModel {
    
    // MARK: - Properties
    private let container: NSPersistentContainer = AppDelegate.persistentContainer
    private let context: NSManagedObjectContext = AppDelegate.persistentContainer.viewContext
    private var fetchedResultsController: NSFetchedResultsController<Person>?
    private weak var delegate: PeopleTableViewModelDelegate?
    
    // MARK: - Init
    init(delegate: PeopleTableViewModelDelegate?) {
        self.delegate = delegate
    }
    
    // MARK: - Methods
    final func numberOfRows(in section: Int) -> Int {
         if let sections = fetchedResultsController?.sections, sections.count > 0 {
                   return sections[section].numberOfObjects
               } else {
                   return 0
               }
    }
    
    var heightOfRow: CGFloat {
        return 175
    }
    
     final func fetchPerson(at indexPath: IndexPath) -> Person? {
           return fetchedResultsController?.object(at: indexPath)
       }
    
    final func removePerson(at indexPath: IndexPath) {
        if let person = fetchedResultsController?.object(at: indexPath) {
            container.performBackgroundTask({ [weak self] (context) in
                guard self != nil else { return }
                context.delete(person)
                try? context.save()
            })
        }
    }
    
    final func postNotification(withPersonAt indexPath: IndexPath) {
        if let person = fetchedResultsController?.object(at: indexPath) {
            NotificationCenter.default.post(name: .editUser, object: nil, userInfo: ["person": person])
        }
    }
    
    final func fetchPeople() {
        let request: NSFetchRequest<Person> = Person.fetchRequest()
        let selector = #selector(NSString.caseInsensitiveCompare(_:))
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true, selector: selector)]
        fetchedResultsController = NSFetchedResultsController<Person>(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        try? fetchedResultsController?.performFetch()
    }
    
}

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
    var fetchedResultsController: NSFetchedResultsController<Person>?
    private weak var delegate: PeopleTableViewModelDelegate?
    
    // MARK: - Init
    init(delegate: PeopleTableViewModelDelegate?) {
        self.delegate = delegate
    }
    
    // MARK: - Methods
    final var numberOfRows: Int {
        return fetchedResultsController?.fetchedObjects?.count ?? 1
    }
    
    var heightOfRow: CGFloat {
        return 175
    }
    
     final func fetchPerson(at indexPath: IndexPath) -> Person? {
           return fetchedResultsController?.object(at: indexPath)
       }
    
    final func removePerson(at indexPath: IndexPath) {
        if let person = fetchedResultsController?.object(at: indexPath) {
            AppDelegate.container.viewContext.delete(person)
            do {
                try AppDelegate.container.viewContext.save()
                fetchPeople() // fetches the updated database in order to update to numberOfRows return value
            } catch {
                print(error)
            }
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
        fetchedResultsController = NSFetchedResultsController<Person>(fetchRequest: request, managedObjectContext: AppDelegate.container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        try? fetchedResultsController?.performFetch()
    }
    
}

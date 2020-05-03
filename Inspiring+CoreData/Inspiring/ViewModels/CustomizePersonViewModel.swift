//
//  CustomizePersonViewModel.swift
//  Inspiring
//
//  Created by Benjamin Mecanovic on 21/04/2020.
//  Copyright © 2020 hydro1337x. All rights reserved.
//

import UIKit
import CoreData

enum CustomizationState {
    case edit
    case create
}

protocol CustomizePersonViewModelDelegate: class {
    func didStateChange(person: Person?)
}

extension CustomizePersonViewModelDelegate {
    func didStateChange(person: Person? = nil) {
        return didStateChange(person: person)
    }
}

class CustomizePersonViewModel {
    
    // MARK: - Properties
    private weak var delegate: CustomizePersonViewModelDelegate?
    private var state: CustomizationState = .create {
        didSet {
            delegate?.didStateChange(person: person)
        }
    }
    private var person: Person?
    private var personIndex: Int?
    private var quoteMessages: [String] = []
    private var imageUrl: String = ""
    
    // MARK: - Init
    init(delegate: CustomizePersonViewModelDelegate?) {
        self.delegate = delegate
        registerOberver()
    }
    
    // MARK: - Methods
    
    private func registerOberver() {
        NotificationCenter.default.addObserver(forName: .editUser, object: nil, queue: nil) { [weak self] (notification) in
            if let person = notification.userInfo?["person"] as? Person {
                self?.person = person
                if let quotes = person.quotes?.allObjects as? [Quote] {
                    var quoteMsgs = [String]()
                    for quote in quotes {
                        if let quoteMsg = quote.quoteMessage {
                            quoteMsgs.append(quoteMsg)
                        }
                    }
                    self?.quoteMessages = quoteMsgs
                }
                self?.imageUrl = person.imageUrl ?? ""
            }
            self?.state = .edit
        }
    }
    
    private func removeQuotes(for person: Person) {
        guard let quotes = person.quotes as? Set<Quote> else { return }
            for quote in quotes {
                person.managedObjectContext?.delete(quote)
            }
        try? AppDelegate.container.viewContext.save()
    }

    final func resetData() {
        person = nil
        personIndex = nil
        quoteMessages = []
        imageUrl = ""
        state = .create
    }
    
    private func createPerson(name: String, dateOfBirth: String, dateOfDeath: String, description: String) {
        AppDelegate.container.performBackgroundTask {  [weak self] context in
            guard let welf = self else { return }
            let person = Person(context: context)
            person.name = name
            person.dob = dateOfBirth
            person.dod = dateOfDeath
            person.imageUrl = welf.imageUrl
            person.personDescription = description
            var quotes = [Quote]()
            if let managedObjCtx = person.managedObjectContext {
                for quoteMessage in welf.quoteMessages {
                    let quote = Quote(context: managedObjCtx)
                    quote.quoteMessage = quoteMessage
                    quotes.append(quote)
                }
            }
            person.quotes = NSSet(array: quotes)
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
    
    private func editPerson(name: String, dateOfBirth: String, dateOfDeath: String, description: String) {
        DispatchQueue.main.async { [weak self] in
            guard let welf = self else { return }
            guard let oldPerson = welf.person else { return }
            oldPerson.name = name
            oldPerson.dob = dateOfBirth
            oldPerson.dod = dateOfDeath
            oldPerson.imageUrl = welf.imageUrl
            oldPerson.personDescription = description
            var quotes = [Quote]()
            if let managedObjCtx = oldPerson.managedObjectContext {
                for quoteMessage in welf.quoteMessages {
                    let quote = Quote(context: managedObjCtx)
                    quote.quoteMessage = quoteMessage
                    quotes.append(quote)
                }
            }
            welf.removeQuotes(for: oldPerson)
            oldPerson.quotes = NSSet(array: quotes)
            try? oldPerson.managedObjectContext?.save()
        }
    }
    
    final func saveImageTemporary(image: UIImage) -> URL {
        let imageName = UUID().uuidString + ".jpeg"
        let tempDirectory = NSTemporaryDirectory()
        let path = tempDirectory.appending(imageName)
        let data = image.jpegData(compressionQuality: 1) as NSData?
        data?.write(toFile: path, atomically: true)
        return URL(fileURLWithPath: path)
    }
    
    final func customizePerson(name: String, dateOfBirth: String, dateOfDeath: String, description: String) {
        if state == .create {
            createPerson(name: name,
                         dateOfBirth: dateOfBirth,
                         dateOfDeath: dateOfDeath,
                         description: description)
        } else {
            editPerson(name: name,
                       dateOfBirth: dateOfBirth,
                       dateOfDeath: dateOfDeath,
                       description: description)
        }
    }
    
    final var numberOfRows: Int {
        return quoteMessages.count
    }
    
    var heightOfRow: CGFloat {
        return UITableView.automaticDimension
    }
    
    final func add(quoteMessage: String) {
        quoteMessages.append(quoteMessage)
    }
    
    final func add(imageUrl: String) {
        self.imageUrl = imageUrl
    }
    
    final func getQuoteMessage(at index: Int) -> String? {
        return quoteMessages[index]
    }
    
    final func removeQuote(at index: Int) {
        quoteMessages.remove(at: index)
    }
}

extension Notification.Name {
    static let editUser = Notification.Name("EditUser")
}

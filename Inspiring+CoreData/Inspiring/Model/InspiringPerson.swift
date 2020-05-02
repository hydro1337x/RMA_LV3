//
//  InspiringPerson.swift
//  Inspiring
//
//  Created by Benjamin Mecanovic on 21/04/2020.
//  Copyright © 2020 hydro1337x. All rights reserved.
//

import Foundation

class PeopleRepository {
    
    static let shared = PeopleRepository()
    private var people: [InspiringPerson] = []
    
    private init() {}
    
    final func append(person: InspiringPerson) {
        people.append(person)
    }
    
    final func get(personAt index: Int) -> InspiringPerson {
        return people[index]
    }
    
    final func remove(personAt index: Int) {
        people.remove(at: index)
    }
    
    final var numberOfPeople: Int {
        return people.count
    }
}

class InspiringPerson {
    
    var name: String
    var description: String
    var imageUrl: URL
    var dateOfBirth: String
    var dateOfDeath: String
    var quotes: [String]
    
    init(name: String = "", description: String = "", imageUrl: URL = URL(fileURLWithPath: ""), dateOfBirth: String = "", dateOfDeath: String = "", quotes: [String] = []) {
        self.name = name
        self.description = description
        self.imageUrl = imageUrl
        self.dateOfBirth = dateOfBirth
        self.dateOfDeath = dateOfDeath
        self.quotes = quotes
    }
    
    final func update(newPerson: InspiringPerson) {
        self.name = newPerson.name
        self.description = newPerson.description
        self.imageUrl = newPerson.imageUrl
        self.dateOfBirth = newPerson.dateOfBirth
        self.dateOfBirth = newPerson.dateOfBirth
        self.quotes = newPerson.quotes
    }
    
    final var randomQuote: String {
        if quotes.count == 0 {
            return "No quotes"
        }
        let quoteIndex = Int.random(in: 0 ... (quotes.count - 1))
        return quotes[quoteIndex]
    }
}

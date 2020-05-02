//
//  Person.swift
//  Inspiring
//
//  Created by Benjamin Mecanovic on 30/04/2020.
//  Copyright © 2020 hydro1337x. All rights reserved.
//

import UIKit
import CoreData

class Person: NSManagedObject {
    
    final var randomQuote: String {
        guard let quotes = quotes as? Set<Quote> else {return "No quotes"}
        if quotes.count == 0 {
            return "No quotes"
        }
        return quotes.randomElement()?.quoteMessage ?? ""
    }
    
}

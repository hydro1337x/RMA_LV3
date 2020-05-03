//
//  BOViewModel.swift
//  BirdObserver
//
//  Created by Benjamin Mecanovic on 03/05/2020.
//  Copyright © 2020 hydro1337x. All rights reserved.
//

import Foundation

protocol BOViewModelDelegate: class {
    func updateUI(with color: BOViewModel.BirdColor, and counter: Int)
    func resetUI()
}

class BOViewModel {
    
    // MARK: - Constants
    private let UDKey = "saveBirdData"
    private let colorKey = "colorKey"
    private let counterKey = "counterKey"
    
    // MARK: - Properties
    private let userDefaults = UserDefaults.standard
    private var birdCounter: Int = 0
    private var currentColor: BirdColor? {
        didSet {
            if let color = currentColor {
                delegate?.updateUI(with: color, and: birdCounter)
            }
        }
    }
    private weak var delegate: BOViewModelDelegate?
    
    enum BirdColor: Int, CaseIterable {
        case red = 1
        case green = 2
        case blue = 3
        case yellow = 4
        
    }
    
    // MARK: - Init
    init(with delegate: BOViewModelDelegate?) {
        self.delegate = delegate
        fetch()
    }
    
    // MARK: - Methods
    final func setBirdColor(to color: BirdColor) {
        birdCounter += 1
        currentColor = color
        save()
    }
    
    final func reset() {
        currentColor = nil
        birdCounter = 0
        delegate?.resetUI()
        delete()
    }
    
    private func save() {
        guard let color = currentColor?.rawValue else { return }
        let data: [String: Any] = [colorKey: color, counterKey: birdCounter]
        userDefaults.set(data, forKey: UDKey)
    }
    
    private func fetch() {
        let dict = userDefaults.dictionary(forKey: UDKey)
        if let data = dict, let color = data[colorKey] as? Int, let counter = data[counterKey] as? Int {
            birdCounter = counter
            currentColor = BirdColor(rawValue: color)
        }
    }
    
    private func delete() {
        userDefaults.removeObject(forKey: UDKey)
    }
}

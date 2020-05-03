//
//  ViewController.swift
//  BirdObserver
//
//  Created by Benjamin Mecanovic on 03/05/2020.
//  Copyright © 2020 hydro1337x. All rights reserved.
//

import UIKit

class BOViewController: UIViewController {
    
    // MARK: - Properties
    private var viewModel: BOViewModel!
    
    // MARK: - Outlets
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private var colorButtons: [UIButton]!
    @IBOutlet private weak var resetButton: UIButton!
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = BOViewModel(with: self)
        setupUI()
    }
    
    private func setupUI() {
        for button in colorButtons {
            button.pairColor()
        }
    }

    // MARK: - Actions
    @IBAction private func colorButtonTapped(_ sender: UIButton) {
        viewModel.setBirdColor(to: BOViewModel.BirdColor(rawValue: sender.tag)!)
    }
    @IBAction private func resetButtonTapped(_ sender: UIButton) {
        viewModel.reset()
    }
}

extension BOViewController: BOViewModelDelegate {
    func updateUI(with color: BOViewModel.BirdColor, and counter: Int) {
        counterLabel.text = "\(counter)"
        counterLabel.setBackgroundColor(with: color)
    }
    
    func resetUI() {
        counterLabel.text = "0"
        counterLabel.backgroundColor = .white
    }
    
    
}

extension UIButton {
    func pairColor() {
        switch self.tag {
        case 1:
            self.backgroundColor = .red
        case 2:
            self.backgroundColor = .green
        case 3:
            self.backgroundColor = .blue
        case 4:
            self.backgroundColor = .yellow
        default:
            break
        }
    }
}

extension UIView {
    func setBackgroundColor(with color: BOViewModel.BirdColor) {
        switch color {
        case .red:
            self.backgroundColor = .red
        case .green:
            self.backgroundColor = .green
        case .blue:
            self.backgroundColor = .blue
        case .yellow:
            self.backgroundColor = .yellow
        }
    }
}


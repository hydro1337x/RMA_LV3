//
//  QuoteTableViewCell.swift
//  Inspiring
//
//  Created by Benjamin Mecanovic on 22/04/2020.
//  Copyright © 2020 hydro1337x. All rights reserved.
//

import UIKit

class QuoteTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var quoteLabel: UILabel!
    
    // MARK: - Properties
    
    // MARK: - Init
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        quoteLabel.text = ""
    }
    
    final func config(quote: String?) {
        self.quoteLabel.text = quote
    }
}

//
//  CartTableViewCell.swift
//  Il Giardino
//
//  Created by Christian Luarca on 4/25/19.
//  Copyright © 2019 Surilis Labs. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var orderName: UILabel!
    @IBOutlet weak var orderQuantity: UILabel!
    @IBOutlet weak var orderPrice: UILabel!
    @IBOutlet weak var orderDecreaseButton: UIButton!
    @IBOutlet weak var orderIncreaseButton: UIButton!
    @IBOutlet weak var orderRemoveButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//
//  VariantTableViewCell.swift
//  Synup_Assignment
//
//  Created by cronycle on 25/08/2019.
//  Copyright © 2019 Apoorv. All rights reserved.
//

import UIKit

class VariantTableViewCell: UITableViewCell, Cell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblInstock: UILabel!
    typealias DataType = Variant
    func configure(data: Variant) {
        lblName.text = data.name
        lblPrice.text = "Price: " + "\(data.price)$"
        var inStockSting : NSAttributedString
        if data.inStock {
            inStockSting = NSAttributedString.init(string: "In stock " + "Yes", attributes: [NSAttributedString.Key.foregroundColor : UIColor.green])
        } else {
            inStockSting = NSAttributedString.init(string: "In stock " + "No", attributes: [NSAttributedString.Key.foregroundColor : UIColor.red])
        }
        lblInstock.attributedText = inStockSting
    }
}

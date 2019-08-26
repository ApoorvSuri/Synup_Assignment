//
//  Cell.swift
//  Synup_Assignment
//
//  Created by cronycle on 25/08/2019.
//  Copyright © 2019 Apoorv. All rights reserved.
//

import Foundation
import UIKit

protocol Cell {
    associatedtype DataType
    func configure(data : DataType)
}

protocol CellConfigurator {
    static var reuseId : String { get }
    func configure(cell: UIView)
}

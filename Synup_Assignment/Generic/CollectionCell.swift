//
//  CollectionCell.swift
//  Synup_Assignment
//
//  Created by cronycle on 25/08/2019.
//  Copyright © 2019 Apoorv. All rights reserved.
//

import Foundation
import UIKit

class CollectionCellConfigurator<CellType: Cell, DataType>: CellConfigurator where CellType.DataType == DataType, CellType: UICollectionViewCell {
    static var reuseId: String { return String(describing: CellType.self) }
    let item: DataType
    init(item: DataType) {
        self.item = item
    }
    func configure(cell: UIView) {
        (cell as! CellType).configure(data: item)
    }
}

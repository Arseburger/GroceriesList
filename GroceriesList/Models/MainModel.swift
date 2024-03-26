//
//  MainModel.swift
//  GroceriesList
//
//  Created by Александр Королёв on 19.03.2024.
//

import Foundation
import UIKit

final class ContainerList {
    
    static var defaultItem = ContainerList(items: [.defaultContainer])
    var items: [Storage] = []
    
    init(items: [Storage]) {
        self.items = items
    }
}

struct Storage {
    static var defaultContainer: Storage = .init(name: "Холодильник", image: UIImage(named: "fridge"), expiredProducts: [.defaultProduct])
    
    var name: String
    var image: UIImage?
    var expiredProducts: [Product]
}

struct Product {
    static var defaultProduct: Product = .init(
        name: "Огурцы",
        expDate: DateComponents.init(year: 2024, month: 3, day: 29),
        quantity: 3,
        image: UIImage.init(named: "circle.grid.cross")
    )
    
    var name: String
    var expDate: DateComponents?
    var quantity: Double
    var image: UIImage?
}

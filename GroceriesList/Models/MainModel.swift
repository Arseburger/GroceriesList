//
//  MainModel.swift
//  GroceriesList
//
//  Created by Александр Королёв on 19.03.2024.
//

import Foundation
import UIKit

class MainModel {
    var containers: [ContainerList] = [.defaultItem]
    var hasExpiringProducts: Bool {
        var result = false
        containers.forEach { container in
            result += !container.hasExpiringProducts
        }
        return result
    }
}

struct ContainerList {
    
    static var defaultItem = ContainerList(items: Array.init(repeating: .defaultContainer, count: 5))
    var items: [Storage] = []
    var hasExpiringProducts: Bool {
        var hasExpProds = false
        items.forEach { container in
            hasExpProds += !container.expiredProducts.isEmpty
        }
        return hasExpProds
    }
    
    init(items: [Storage]) {
        self.items = items
    }
}

struct Storage {
    static var defaultContainer: Storage = .init(
        name: "Холодильник",
        image: UIImage(named: "fridge"),
        expiredProducts: [.defaultProduct]
    )
    
    var name: String
    var image: UIImage?
    var expiredProducts: [Product]
    
    init(name: String, image: UIImage?, expiredProducts: [Product]) {
        self.name = name
        self.image = image
        self.expiredProducts = expiredProducts
    }
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
    
    init(name: String, expDate: DateComponents?, quantity: Double, image: UIImage?) {
        self.name = name
        self.expDate = expDate
        self.quantity = quantity
        self.image = image
    }
}

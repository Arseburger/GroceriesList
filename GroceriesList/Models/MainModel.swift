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
    
    var containers: [Storage] = []
    var hasExpiringProducts: Bool {
        var hasExpProds = false
        containers.forEach { container in
            hasExpProds += !container.expiredProducts.isEmpty
        }
        return hasExpProds
    }
    
    init(items: [Storage]) {
        self.containers = items
    }
}

struct Storage {
    static var defaultContainer: Storage = .init(
        name: "Холодильник",
        image: UIImage(named: "fridge"),
        products: [.defaultProduct]
    )
    
    var name: String
    var image: UIImage?
    var products: [Product]
    var expiredProducts: [Product] {
        var result: [Product] = []
        products.forEach { product in
            if let date = product.expDate {
                if date.distance(to: Date.now) > 0 {
                    result.append(product)
                }
            }
        }
        return result
    }
    
    init(name: String, image: UIImage?, products: [Product]) {
        self.name = name
        self.image = image
        self.products = products
    }
}

struct Product {
    static var defaultProduct: Product = .init(
        name: "Огурцы",
        expDate: "24/5/2024",
        quantity: 3,
        image: UIImage.init(named: "circle.grid.cross"),
        measureUnit: ("штук", "шт")
    )
    
    var name: String
    var expDate: Date?
    var quantity: Double
    var image: UIImage?
    var measureUnit: (full: String?, short: String?)
    
    init(name: String, expDate: String?, quantity: Double, image: UIImage?, measureUnit: (String?, String?)) {
        self.name = name
        self.quantity = quantity
        self.image = image
        self.measureUnit = measureUnit
        if let date = expDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            self.expDate = dateFormatter.date(from: date)
        }
    }
}

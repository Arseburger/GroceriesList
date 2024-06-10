//
//  MainModel.swift
//  GroceriesList
//
//  Created by Александр Королёв on 19.03.2024.
//

import UIKit

public typealias MeasureUnit = (full: String?, short: String?)

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
        products: [.defaultProduct, .tomato, .water, .pasta, .cake]
    )
    
    var name: String
    var image: UIImage?
    var products: [Product] {
        didSet {
            sortedProducts = products
        }
    }
    
    var sortedProducts: [Product]
    
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
        self.sortedProducts = self.products
    }
}

struct Product {
    
    var name: String
    var expDate: Date?
    var quantity: Double
    var image: UIImage?
    var measureUnit: MeasureUnit
    
    init(name: String, expDate: Date, quantity: Double, image: UIImage?, measureUnit: MeasureUnit) {
        self.name = name
        self.quantity = quantity
        self.image = image
        self.measureUnit = measureUnit
        self.expDate = expDate
    }
}

extension Product {
    static let defaultProduct: Product = .init(
        name: "Огурцы",
        expDate: .shortDate(day: 24, month: 5, year: 2024),
        quantity: 3,
        image: UIImage.init(systemName: "die.face.5.fill"),
        measureUnit: ("штук", "шт")
    )
    static let tomato = Product.init(
        name: "Помидоры",
        expDate: .shortDate(day: 21, month: 4, year: 2024),
        quantity: 3,
        image: .init(systemName: "die.face.1"),
        measureUnit: ("штук", "шт")
    )
    static let water = Product.init(
        name: "Вода",
        expDate: .shortDate(day: 30, month: 6, year: 2024),
        quantity: 1.4,
        image: .init(systemName: "die.face.2"),
        measureUnit: ("литра", "л")
    )
    static let cake = Product.init(
        name: "Торт",
        expDate: .shortDate(day: 29, month: 5, year: 2024),
        quantity: 0.5,
        image: .init(systemName: "die.face.3"),
        measureUnit: ("куска", "кус")
    )
    static let pasta = Product.init(
        name: "Макароны",
        expDate: .shortDate(day: 27, month: 5, year: 2024),
        quantity: 350,
        image: .init(systemName: "die.face.4"),
        measureUnit: ("граммов", "гр")
    )
}

class MeasureUnitStorage {
    static let shared = MeasureUnitStorage()
    var units: [MeasureUnit] = [("Штук","шт"), ("Грамм","гр"), ("куска", "кус"), ("литра", "л")]
}

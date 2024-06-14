//
//  MainModel.swift
//  GroceriesList
//
//  Created by Александр Королёв on 19.03.2024.
//

import UIKit

public typealias MeasureUnit = (full: String?, short: String?)

public let threeDays = 3.0 * 86440

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
    var filteredProducts: [Product] = []  // TO-DO
    
    init(items: [Storage]) {
        self.containers = items
    }
    
    func getExpProds() -> [Product] {
        var products: [Product] = []
        containers.forEach {
            products.append(contentsOf: $0.expiredProducts)
            products.append(contentsOf: $0.expiringProducts)
        }
        return products
    }
    
    static func randomItem() -> ContainerList {
        let num = Int.random(in: 2...7)
        var items: [Storage] {
            var items = [Storage]()
            for _ in 0...num {
                items.append(.randomContainer())
            }
            return items
        }
        return ContainerList(items: items)
    }
}

// MARK: -Storage (Container)

struct Storage {
    static var defaultContainer: Storage = .init(
        name: "Холодильник",
        image: UIImage(named: "fridge"),
        products: [.defaultProduct, .tomato, .water, .pasta, .cake]
    )
    
    static var counter = 0
    
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
            if product.expDate < Date.now {
                result.append(product)
            }
        }
        return result
    }
    
    var expiringProducts: [Product] {
        var result: [Product] = []
        products.forEach { product in
            if product.expDate < Date.now.advanced(by: threeDays) && product.expDate > Date.now {
                result.append(product)
            }
        }
        return result
    }
    
    init(name: String, image: UIImage?, products: [Product]) {
        self.name = name
        self.image = image
        self.products = products.sorted(by: {
            $0.expDate > $1.expDate
        })
        self.sortedProducts = self.products
        Storage.counter += 1
    }
    
    static func randomContainer() -> Storage {
        var products: [Product] {
            var products = [Product]()
            for _ in 0...Int.random(in: 3...8) {
                products.append(.randomProduct())
            }
            return products
        }
        return Storage(name: "Container #\(Storage.counter + 1)", image: UIImage(named: "fridge"), products: products)
    }
}



// MARK: -Product

struct Product {
    
    var name: String
    var expDate: Date
    var quantity: Double
    var image: UIImage?
    var measureUnit: MeasureUnit
    var color: UIColor
    var qtyStr: String {
        NSString(format:"%.3f", self.quantity).standardizingPath
    }
    
    init(name: String, expDate: Date, quantity: Double, image: UIImage?, measureUnit: MeasureUnit) {
        self.name = name
        self.quantity = quantity
        self.image = image
        self.measureUnit = measureUnit
        self.expDate = expDate
        self.color = .randomColor()
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
    
    static func randomProduct() -> Product {
        
        var name: String = ""
        let letters = "qwertyuiopasdfghjklzxcvbnm"
        let stringLength = Int.random(in: 3...10)
        
        for _ in 0 ..< stringLength {
            let num  = Int.random(in: 0 ..< "qwertyuiopasdfghjklzxcvbnm".count)
            let char = letters[letters.index(letters.startIndex, offsetBy: num)]
            name.append(char)
        }
        
        let date: (day: Int, month: Int, year: Int) = (
            Int.random(in: 1...28),
            6,//Int.random(in: 1...12),
            2024// Int.random(in: 2022...2027))
        )
        
        let image = UIImage.init(systemName: "die.face.\(Int.random(in: 1...6))")
        
        let product: Product = .init(
            name: name,
            expDate: .shortDate(day: date.day, month: date.month, year: date.year),
            quantity: Double.random(in: 0.1...3.0),
            image: image,
            measureUnit: MeasureUnitStorage.shared.units.randomElement()!
        )
        return product
    }
}

class MeasureUnitStorage {
    static let shared = MeasureUnitStorage()
    var units: [MeasureUnit] = [("Штук","шт"), ("Грамм","гр"), ("куска", "кус"), ("литра", "л")]
}

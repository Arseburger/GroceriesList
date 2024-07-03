//
//  MainModel.swift
//  GroceriesList
//
//  Created by Александр Королёв on 19.03.2024.
//

import UIKit

public typealias MeasureUnit = (full: String?, short: String?)

class MeasureUnitStorage {
    
    static let shared = MeasureUnitStorage()
    var units: [MeasureUnit] = [("Штук","шт"), ("Грамм","гр"), ("куска", "кус"), ("литра", "л")]
    
    func getIdOf(_ item: MeasureUnit) -> Int? {
        guard self.units.contains(where: {
            $0.full == item.full
        }) else { return nil }
        
        let id = units.firstIndex(where: {
            $0.full == item.full
        })
        return id
    }
}

public let threeDays = 3.0 * 86440

struct ContainerList {
    
    static var defaultItem = ContainerList(items: Array.init(repeating: .defaultContainer(false), count: 5))
    
    var containers: [Storage] = []
    var hasExpiringProducts: Bool {
        var hasExpProds = false
        containers.forEach { container in
            hasExpProds += !container.expiredProducts.isEmpty
        }
        return hasExpProds
    }
    var filteredProducts: [Product] = []
    
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

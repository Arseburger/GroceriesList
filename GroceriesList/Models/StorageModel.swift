//
//  ItemModel.swift
//  GroceriesList
//
//  Created by Александр Королёв on 19.03.2024.
//

import UIKit

struct Storage {
   
    static private var ids: UInt8 = 10
    static var counter = 0
    
    var id: UInt8
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
    
    init(name: String, image: UIImage?, products: [Product], shoulGetNewId: Bool = true) {
        
        Storage.ids += shoulGetNewId ? 1 : 0
        self.id = Storage.ids
        
        Storage.counter += 1
        
        self.name = name
        self.image = image
        self.products = products.sorted(by: {
            $0.expDate > $1.expDate
        })
        
        self.sortedProducts = self.products
    }
    
    static func defaultContainer(_ flag: Bool) -> Storage {
        .init(
            name: "Холодильник",
            image: UIImage(named: "fridge"),
            products: [.defaultProduct],
            shoulGetNewId: flag
        )
    }
    
    static func randomContainer() -> Storage {
        var products: [Product] {
            var products = [Product]()
            for _ in 0...Int.random(in: 3...8) {
                var prod = Product.randomProduct()
                prod = prod.attachContainer(with: self.ids + 1)
                products.append(prod)
            }
            return products
        }
        let container = Storage(name: "Container #\(Storage.counter + 1)", image: UIImage(named: "fridge"), products: products)
        return container
    }
}

extension Array where Element == Storage {
    func getContainer(by id: UInt8) -> Storage? {
//        var container: Storage?
//        for item in self {
//            if item.id == id {
//                container = item
//                break
//            }
//        }
//        return container
        return self.first {
            $0.id == id
        }
    }
}

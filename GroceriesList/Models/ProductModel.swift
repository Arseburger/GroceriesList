//
//  ProductModel.swift
//  GroceriesList
//
//  Created by Александр Королёв on 18.06.2024.
//

import UIKit

struct Product {
    
    static private var ids: UInt32 = 1000
    
    var id: UInt32
    var name: String
    var expDate: Date
    var quantity: Double
    var image: UIImage?
    var measureUnit: MeasureUnit
    var containerId: UInt8? = 10
    var color: UIColor
    var qtyStr: String {
        NSString(format:"%.2f", self.quantity).standardizingPath
    }
    
    init(name: String, expDate: Date, quantity: Double, image: UIImage?, measureUnit: MeasureUnit, containerId: UInt8? = 0) {
        Product.ids += 1
        self.name = name
        self.quantity = quantity
        self.image = image
        self.measureUnit = measureUnit
        self.expDate = expDate
        self.color = .randomColor()
        self.containerId = containerId
        self.id = Product.ids
    }
    
    mutating func attachContainer(with id: UInt8) -> Product {
        var copy = self
        copy.containerId = id
        return copy
    }
    
}

extension Array where Element == Product {
    func getProduct(by id: UInt32) -> Product? {
        var product: Product?
        for item in self {
            if item.id == id {
                product = item
                break
            }
        }
        return product
    }
}

extension Product: Equatable {
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
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
    
    static func randomProduct(_ containerId: UInt8 = 0) -> Product {
        
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
            7,//Int.random(in: 1...12),
            2024// Int.random(in: 2022...2027))
        )
        
        let image = UIImage.init(systemName: "die.face.\(Int.random(in: 1...6))")
        
        let product: Product = .init(
            name: name.capitalized,
            expDate: .shortDate(day: date.day, month: date.month, year: date.year),
            quantity: Double.random(in: 0.1...3.0),
            image: image,
            measureUnit: MeasureUnitStorage.shared.units.randomElement()!,
            containerId: containerId
        )
        return product
    }
}




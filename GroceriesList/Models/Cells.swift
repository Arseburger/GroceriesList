//
//  Cells.swift
//  GroceriesList
//
//  Created by Александр Королёв on 18.06.2024.
//

import UIKit.UINib

struct TableView {
    struct Cells {
        struct searchCell {
            static let identifier = "searchCell"
            static let nib = UINib(nibName: "SearchTVCell", bundle: .main)
        }
        struct expiredProdCell {
            static let identifier = "expiredProductCell"
            static let nib = UINib(nibName: "ExpiredProductTVCell", bundle: .main)
        }
        struct editContainerCell {
            static let identifier = "editProductsCell"
            static let nib = UINib(nibName: "EditContainerProdsTVCell", bundle: .main)
        }
        struct expiringProdsCell {
            static let identifier = "expiredTVCell"
            static let nib = UINib(nibName: "ExpiringProductsTVCell", bundle: .main)
        }
        struct containerCell {
            static let identifier = "containerTVCell"
            static let nib = UINib(nibName: "ContainerTVCell", bundle: .main)
        }
        struct nothingFoundCell {
            static let identifier = "nothingFoundCell"
            static let nib = UINib(nibName: "NothingFoundTVCell", bundle: .main)
        }
    }
}

struct CollectionView {
    struct Cells {
        struct newItemCell {
            static let identifier = "newProductCell"
            static let nib = UINib(nibName: "AddNewItemCollectionViewCell", bundle: .main)
        }
        struct detailIemCell {
            static let identifier = "productCell"
            static let nib = UINib(nibName: "DetailItemCollectionViewCell", bundle: .main)
        }
    }
}

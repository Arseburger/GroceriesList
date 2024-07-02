//
//  Cells.swift
//  GroceriesList
//
//  Created by Александр Королёв on 18.06.2024.
//

import UIKit.UINib
struct TableView {
    struct Cells {
        let identifier: String
        let nib: UINib
        
        static let SearchCell = Cells(
            identifier: "searchCell",
            nib: UINib(nibName: "SearchTVCell", bundle: .main)
        )
        static let ExpiredProdCell = Cells(
            identifier: "expiredProductCell",
            nib: UINib(nibName: "ExpiredProductTVCell", bundle: .main)
        )
        static let EditContainerCell = Cells(
            identifier: "editProductsCell",
            nib: UINib(nibName: "EditContainerProdsTVCell", bundle: .main)
        )
        static let ExpiringProdsCell = Cells(
            identifier: "expiredTVCell",
            nib: UINib(nibName: "ExpiringProductsTVCell", bundle: .main)
        )
        static let ContainerCell = Cells(
            identifier: "containerTVCell",
            nib: UINib(nibName: "ContainerTVCell", bundle: .main)
        )
        static let NothingFoundCell = Cells(
            identifier: "nothingFoundCell",
            nib: UINib(nibName: "NothingFoundTVCell", bundle: .main)
        )
        static let SettingsMeasureUnitCell = Cells(
            identifier: "settingsMUTVCell",
            nib: UINib(nibName: "SettingsMUTVCell", bundle: .main)
        )
        
///  searchCell – SearchTVCell
///  expiredProdCell – ExpiredProductTVCell
///  editContainerCell – EditContainerProdsTVCell
///  expiringProdsCell – ExpiringProductsTVCell
///  containerCell – ContainerTVCell
///  nothingFoundCell – NothingFoundTVCell
///  settingsMeasureUnitCell – SettingsMUTVCell
    }
    
    func register(_ cell: TableView.Cells, in tableView: UITableView) {
        tableView.register(cell.nib, forCellReuseIdentifier: cell.identifier)
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

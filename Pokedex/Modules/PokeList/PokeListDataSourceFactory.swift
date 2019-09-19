//
//  PokeListDataSourceFactory.swift
//  Pokedex
//
//  Created by Laura Sarmiento on 18/09/19.
//  Copyright © 2019 Medrar. All rights reserved.
//

import Foundation
import RxDataSources

typealias PokeListSectionModel = AnimatableSectionModel<String, Pokemon>
typealias PokeListDataSource = RxTableViewSectionedAnimatedDataSource<PokeListSectionModel>

enum PokeListDataSourceFactory {
    
    static func create() -> RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<String, Pokemon>> {
        RxTableViewSectionedAnimatedDataSource(configureCell: { (_, tableView: UITableView, indexPath: IndexPath, item: Pokemon) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.pokeListItemTableViewCell, for: indexPath)!
            cell.configure(with: item)
            return cell
        })
    }
}

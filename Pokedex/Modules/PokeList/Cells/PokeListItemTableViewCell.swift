//
//  PokeListItemTableViewCell.swift
//  Pokedex
//
//  Created by Laura Sarmiento on 18/09/19.
//  Copyright © 2019 Medrar. All rights reserved.
//

import UIKit
import RxSwift

class PokeListItemTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var typesLabel: UILabel!
    @IBOutlet private weak var pokeImageView: UIImageView!
    
    func configure(with pokemon: Pokemon) {
        nameLabel.text = pokemon.name.capitalized
        typesLabel.text = pokemon.types.map { $0.capitalized }.joined(separator: ", ")
        if let url = pokemon.image {
            pokeImageView.setImage(with: url)
                .subscribe()
                .disposed(by: disposeBag)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.text = nil
        typesLabel.text = nil
        pokeImageView.image = nil
        
        // Dispose all subscriptions of cell
        disposeBag  = DisposeBag()
    }
}

//
//  PokemonDetailViewController.swift
//  Pokedex
//
//  Created by Laura Sarmiento on 19/09/19.
//  Copyright (c) 2019 Medrar. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import UIKit
import RxSwift
import RxCocoa

final class PokemonDetailViewController: UIViewController {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var backgroundColor: UIView!
    @IBOutlet private weak var pokemonImageView: UIImageView!
    @IBOutlet private weak var backButton: UIButton! {
        didSet {
            backButton.rx.tap
                .subscribe(onNext: { [unowned self] in
                    self.navigationController?.popViewController(animated: true)
                })
                .disposed(by: disposeBag)
        }
    }
    
    // MARK: - Public properties -

    var presenter: PokemonDetailPresenterInterface!

    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemonImageView.layer.cornerRadius = 8.0
        
        presenter.loadDetailData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

// MARK: - Extensions -

extension PokemonDetailViewController: PokemonDetailViewInterface {
    
    func drawPokemonInfo(pokemon: Pokemon) {
        nameLabel.transition {
            $0.text = pokemon.name.capitalized
        }
        if let imageUrl = pokemon.image {
            pokemonImageView.setImage(with: imageUrl)
                .subscribe(onNext: { [weak self] (image: UIImage) in
                    self?.backgroundColor.transition {
                        $0.backgroundColor = image.averageColor
                    }
                })
                .disposed(by: disposeBag)
        }
    }
}
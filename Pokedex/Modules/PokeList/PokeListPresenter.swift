//
//  PokeListPresenter.swift
//  Pokedex
//
//  Created by Laura Sarmiento on 17/09/19.
//  Copyright (c) 2019 Medrar. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import UIKit
import RxSwift
import RxRelay

final class PokeListPresenter {

    // MARK: - Private properties -

    private let disposeBag = DisposeBag()
    
    private unowned let view: PokeListViewInterface
    private let interactor: PokeListInteractorInterface
    private let wireframe: PokeListWireframeInterface

    private let searchCriteria = BehaviorRelay<String>(value: "")
    private let pokemons = BehaviorRelay<[Pokemon]>(value: [])
    // MARK: - Lifecycle -

    init(view: PokeListViewInterface, interactor: PokeListInteractorInterface, wireframe: PokeListWireframeInterface) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
    }
    
    private func loadPokemonInfo(result: PokemonList.Result) {
        interactor.loadPokemon(result: result)
            .subscribe(onNext: { [weak self] (pokemon: Pokemon) in
                var pokemons = self?.pokemons.value ?? []
                pokemons.append(pokemon)
                self?.pokemons.accept(pokemons.sorted { $0.id < $1.id })
            })
            .disposed(by: disposeBag)
    }
    
    private func bintToTableData() {
        let dataSource = PokeListDataSourceFactory.create()
        
        let pokemonsObservable = pokemons.asObservable()
        let searchCriteriaObservable = searchCriteria.asObservable()
        
        let source = Observable<[Pokemon]>.combineLatest(pokemonsObservable, searchCriteriaObservable) { (all: [Pokemon], criteria: String) -> [Pokemon] in
            all.filter { (pokemon: Pokemon) -> Bool in
                if criteria.isEmpty {
                    return true
                }
                return pokemon.name.lowercased().contains(criteria.lowercased()) ||
                    pokemon.types.contains { $0.lowercased().contains(criteria.lowercased()) }
            }
        }.map { (pokemons: [Pokemon]) -> [PokeListSectionModel] in
            [.init(model: "Rokemons", items: pokemons)]
        }
        
        view.bindTableViewData(source, withDataSource: dataSource)
    }
}

// MARK: - Extensions -

extension PokeListPresenter: PokeListPresenterInterface {
    
    func searchPokemon(withCriteria criteria: String) {
        searchCriteria.accept(criteria)
    }
    
    func showPokemonDetail(pokemonId: Int) {
        wireframe.showPokemonDetail(pokemonId: pokemonId)
    }
        
    func loadPokemonList() {
        interactor.loadPokemonList()
            .subscribe(onNext: { [weak self] (pokemons: PokemonList) in
                pokemons.results.forEach { self?.loadPokemonInfo(result: $0) }
            })
            .disposed(by: disposeBag)
        
        bintToTableData()
    }
}

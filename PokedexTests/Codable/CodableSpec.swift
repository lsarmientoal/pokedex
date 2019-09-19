//
//  CodableSpec.swift
//  PokedexTests
//
//  Created by Laura Sarmiento on 17/09/19.
//  Copyright © 2019 Medrar. All rights reserved.
//

@testable import Pokedex
import Quick
import Nimble
import OHHTTPStubs
import RxTest
import Moya

class CodableSpec: QuickSpec {

    var scheduler: TestScheduler!
    
    override func spec() {
        
        beforeEach {
            self.scheduler = TestScheduler(initialClock: 0)
            OHHTTPStubs.removeAllStubs()
        }
        
        describe("Mock Pokémon decode") {
            context("call list all pokemon service") {
                it("when the response is successful") {
                    StubsService.mock(forTarget: PokeApiTarget.listAllPokemons, responseType: .succeeded)
                    
                    let observer = self.scheduler.createObserver(PokemonList.self)
                    
                    _ = Api.httpServices.request(to: .listAllPokemons)
                        .mapObject(PokemonList.self)
                        .subscribe(observer)
                    
                    self.scheduler.start()
                    
                    expect(observer.events.count).toEventually(equal(2))
                    
                    let list = observer.events.first?.value.element
                    
                    // Check results
                    expect(list?.count).toEventually(equal(964))
                    expect(list?.next).toEventually(equal(URL(string: "https://pokeapi.co/api/v2/pokemon/?offset=20&limit=20")))
                    expect(list?.previous).toEventually(beNil())
                    expect(list?.results.count).toEventually(equal(20))
                    
                    // Check first element
                    expect(list?.results.first?.name).toEventually(equal("bulbasaur"))
                    expect(list?.results.first?.url).toEventually(equal(URL(string: "https://pokeapi.co/api/v2/pokemon/1/")))
                    
                    // Check last element
                    expect(list?.results.last?.name).toEventually(equal("raticate"))
                    expect(list?.results.last?.url).toEventually(equal(URL(string: "https://pokeapi.co/api/v2/pokemon/20/")))
                }
            }
            
            context("call pokemon detail service") {
                it("when the response is successful") {
                    StubsService.mock(forTarget: PokeApiTarget.pokemonInfo(id: 1), responseType: .succeeded)
                    
                    let observer = self.scheduler.createObserver(Pokemon.self)
                    
                    _ = Api.httpServices.request(to: .pokemonInfo(id: 1))
                        .mapObject(Pokemon.self)
                        .subscribe(observer)
                    
                    self.scheduler.start()
                    
                    expect(observer.events.count).toEventually(equal(2))
                    
                    let pokemon = observer.events.first?.value.element
                    expect(pokemon?.name).toEventually(equal("bulbasaur"))
                    expect(pokemon?.id).toEventually(equal(1))
                    expect(pokemon?.image).toEventually(equal(URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")))
                    expect(pokemon?.types).toEventually(equal(["poison", "grass"]))
                }
            }
        }
    }
}

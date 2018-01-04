//
//  Pokemon.swift
//  pokedex
//
//  Created by Andy Vainauskas on 10/2/17.
//  Copyright © 2017 Andy Vainauskas. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _pokemonURL: String!
    
    var name: String {
        if _name == nil {
            _name = ""
        }
        return _name
    }
    
    var pokedexId: Int {
        if _pokedexId == nil {
            _pokedexId = 1
        }
        return _pokedexId
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var nextEvolutionTxt: String {
        if _nextEvolutionTxt == nil {
            _nextEvolutionTxt = ""
        }
        return _nextEvolutionTxt
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: @escaping DownloadComplete) {
        Alamofire.request(_pokemonURL).responseJSON { (response) in
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                if let weight = dict["weight"] {
                    self._weight = "\(weight)"
                }
                
                if let height = dict["height"] {
                    self._height = "\(height)"
                }
                
                // Fetches the attack and defense value
                guard let statsNode = dict["stats"] as? [[String: Any]] else { return }
                
                for (index, statNode) in statsNode.enumerated() {
                    
                    guard let statValue = statNode["base_stat"] as? Int else { continue }
                    
                    switch index {
                    case 0:
                        self._defense = "\(statValue)"
                    case 1:
                        self._attack = "\(statValue)"
                    default:
                        break
                    }
                }
             
                // Fetches the type value
                if let types = dict["types"] as? [Dictionary<String, AnyObject>], types.count > 0 {
                    if let type = types[0]["type"] as? Dictionary<String, String> {
                        if let name = type["name"] {
                            self._type = name.capitalized
                        }
                    }
                    
                    // Extra logic required if there is more than one type
                    if types.count > 1 {
                        for x in 1..<types.count {
                            if let type = types[x]["type"] as? Dictionary<String, String> {
                                if let name = type["name"] {
                                    self._type! += "/\(name.capitalized)"
                                }
                            }
                        }
                    }
                } else {
                    self._type = ""
                }
                
                // Fetches the description value
                if let descArr = dict["description"] as? [Dictionary<String, String>], descArr.count > 0 {
                    if let url = descArr[0]["resource_uri"] {
                        Alamofire.request(url).responseJSON(completionHandler: { (response) in
                            
                        })
                    }
                }
            }
            
            completed()
        }
    }
}

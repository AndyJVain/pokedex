//
//  PokemonDetailVC.swift
//  pokedex
//
//  Created by Andy Vainauskas on 10/6/17.
//  Copyright © 2017 Andy Vainauskas. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

    var pokemon: Pokemon!
    
    @IBOutlet weak var nameLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLbl.text = pokemon.name
    }
}

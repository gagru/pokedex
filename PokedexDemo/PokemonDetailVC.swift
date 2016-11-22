//
//  PokemonDetailVC.swift
//  PokedexDemo
//
//  Created by Administrator on 11/19/16.
//  Copyright © 2016 Administrator. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

    @IBOutlet weak var namelbl: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgMain: UIImageView!
    @IBOutlet weak var lbldescription: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblDefense: UILabel!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var lblHeight: UILabel!
    @IBOutlet weak var lblPokedexId: UILabel!
    @IBOutlet weak var imgCurrentEvo: UIImageView!
    @IBOutlet weak var imgNextEvo: UIImageView!
    @IBOutlet weak var lblEvo: UILabel!
    @IBOutlet weak var lblAttack: UILabel!
    
    var pokemon: Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        namelbl.text = pokemon.name
        let img = UIImage(named: "\(pokemon.pokedexId)")
        
        imgMain.image = img
        imgCurrentEvo.image = img
        
        pokemon.downloadPokemonDetails { () -> () in
            self.updateUI()
        }
    }
    
    func updateUI() {
        lbldescription.text = pokemon.description
        lblType.text = pokemon.type
        lblDefense.text = pokemon.defense
        lblHeight.text = pokemon.height
        lblPokedexId.text = "\(pokemon.pokedexId)"
        lblWeight.text = pokemon.weight
        lblAttack.text = pokemon.attack
        
        if pokemon.nextEvoId == "" {
            lblEvo.text = "No Evolutions"
            imgNextEvo.hidden = true
        } else {
            imgNextEvo.hidden = false
            imgNextEvo.image = UIImage(named: pokemon.nextEvoId)
            
            var str = "Next Evolution: \(pokemon.nextEvo)"
            
            if pokemon.nextEvoLevel != "" {
                str += " - LVL \(pokemon.nextEvoLevel)"
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnBackPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

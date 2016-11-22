//
//  Pokemon.swift
//  PokedexDemo
//
//  Created by Administrator on 11/19/16.
//  Copyright © 2016 Administrator. All rights reserved.
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
    private var _nextEvo: String!
    private var _nextEvoId: String!
    private var _nextEvoLevel: String!
    private var _url: String!
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    var description: String {
        get {
        if _description == nil {
          _description  = ""
        }
            return _description
        }
    }
    
    var type: String {
        get {
        if _type == nil {
          _type  = ""
        }
            return _type
        }
    }

    var defense: String {
        get {
        if _defense == nil {
           _defense = ""
        }
            return _defense
        }
    }

    var height: String {
        get {
        if _height == nil {
           _height = ""
        }
            return _height
        }
    }

    var weight: String {
        get {
        if _weight == nil {
           _weight = ""
        }
            return _weight
        }
    }

    var attack: String {
        get {
        if _attack == nil {
           _attack = ""
        }
            return _attack
        }
    }

    var nextEvo: String {
        get {
        if _nextEvo == nil {
          _nextEvo  = ""
        }
            return _nextEvo
        }
    }

    var nextEvoId: String {
        get {
        if _nextEvoId == nil {
          _nextEvoId  = ""
        }
        return _nextEvoId
        }
    }

    var nextEvoLevel: String {
        get {
        if _nextEvoLevel == nil {
           _nextEvoLevel = ""
        }
            return _nextEvoLevel
        }
    }

    var url: String {
        get {
            if _url == nil {
               _url = ""
            }
            return _url
        }
    }

    init() {
    
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        
        _url = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)"
    }
    
    func downloadPokemonDetails(complete: DownloadComplete) {
        
        let url = NSURL(string: _url)!
        
        Alamofire.request(.GET, url).responseJSON { (response: Response<AnyObject, NSError>) in
            
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                if let types = dict["types"] as? [Dictionary<String, String>] where types.count > 0 {
                    if let name = types[0]["name"] {
                        self._type = name
                    }
                    
                    if types.count > 1 {
                        for i in 1  ..< types.count {
                            if let name = types[i]["name"] {
                                self._type! += "/\(name)"
                            }
                        }
                    }
                } else {
                    self._type = ""
                }
                
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>] where descArr.count > 0 {
                    if let url = descArr[0]["resource_uri"] {
                        let nsURL = NSURL(string:  "\(URL_BASE)\(url)")!
                        Alamofire.request(.GET, nsURL).responseJSON { (response: Response<AnyObject, NSError>) in
                            if let descDict = response.result.value as? Dictionary<String, AnyObject> {
                                if let description = descDict["description"] as? String {
                                    self._description = description
                                }
                            }
                            complete()
                        }
                    }
                } else {
                    self._description = ""
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] where evolutions.count > 0 {
                    if let to = evolutions[0]["to"] as? String {
                        // Can't support mega pokemon right now bit api still has mega data
                        if to.rangeOfString("mega") == nil {
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                let newStr = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon", withString: "")
                                
                                let num = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                
                                self._nextEvoId = num
                                self._nextEvo = to
                                
                                if let lvl = evolutions[0]["level"] as? Int {
                                    self._nextEvoLevel = "\(lvl)"
                                }
                            }
                        }
                    }
                }
            }
        }
    }

}
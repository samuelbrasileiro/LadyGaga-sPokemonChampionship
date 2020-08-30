//
//  EggGroupBank.swift
//  Lady Gaga's Pokemon Championship
//
//  Created by Samuel Brasileiro on 27/08/20.
//  Copyright © 2020 Samuel Brasileiro. All rights reserved.
//

import Foundation

protocol EggGroupBankDelegate{
    func updateImage(from data: Data)
    
}

class EggGroupBank{
    var eggGroupList: EggGroupList?
    var eggGroups: [EggGroup] = []
    
    var delegate: EggGroupBankDelegate?
    
    var isReady: Bool{
        didSet{
            if isReady == true{
                let index: Int = .random(in: 0...14)
                print(eggGroups.count)
                let eggGroup = eggGroups[index]
                
                DispatchQueue.global(qos: .background).async {
                    
                    do{
                        
                        
                        let pokemonSpecies = eggGroup.pokemonSpecies!.randomElement()
                        let pokemonURL = pokemonSpecies!.url!.replacingOccurrences(of: "-species", with: "")
                        let url = URL(string: pokemonURL)
                        let data = try Data(contentsOf: url!)
                        
                        let pokemon = try JSONDecoder().decode(Pokemon.self, from: data)
                        
                        DispatchQueue.main.async {
                            let sprites = pokemon.sprites
                            
                            do{
                                
                                let url = URL(string: sprites!.frontDefault!)
                                let data = try Data(contentsOf: url!)
                                
                                self.delegate?.updateImage(from: data)
                                
                            }catch{
                                print("eita n deu pra pegar a foto")
                            }
                            
                            
                        }
                    }catch{
                        print("eita n deu pra pegar ele")
                    }
                }
            }
        }
    }
    
    init(){
        isReady = false
        
    }
    
    
    public func downloadEggGroups(){
        isReady = false
        
        let URLString = "https://pokeapi.co/api/v2/egg-group"
        let url = URL(string: URLString)
        
        DispatchQueue.global(qos: .background).async {
            
            do{
                
                let data = try Data(contentsOf: url!)
                
                self.eggGroupList = try JSONDecoder().decode(EggGroupList.self, from: data)
                
                DispatchQueue.main.async {
                    for result in self.eggGroupList!.results!{
                        print(result.name!)
                        
                        let eggGroupURL = URL(string: result.url!)
                        
                        do{
                            let data = try Data(contentsOf: eggGroupURL!)
                            
                            let eggGroup = try JSONDecoder().decode(EggGroup.self, from: data)

                            self.eggGroups.append(eggGroup)
                            
                        }catch{
                            DispatchQueue.main.async {
                                print("Não foi possível encontrar esse pokemon")
                            }
                        }
                        
                    }
                    
                    self.isReady = true
                    
                }
                
            } catch{
                DispatchQueue.main.async {
                    print("Não foi possível baixar a lista de pokemon")
                }
            }
            
        }
        
    }
}

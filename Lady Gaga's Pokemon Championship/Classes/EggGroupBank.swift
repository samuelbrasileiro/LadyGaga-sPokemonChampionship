//
//  EggGroupBank.swift
//  Lady Gaga's Pokemon Championship
//
//  Created by Samuel Brasileiro on 27/08/20.
//  Copyright © 2020 Samuel Brasileiro. All rights reserved.
//

import Foundation
import Vision
protocol EggGroupBankDelegate{
    func updatePokemonInfo(from data: Data, pokemon: Pokemon)
    
}

struct Detection {
    let category: String
    let confidence: Float
}

class EggGroupBank{
    var eggGroupList: EggGroupList?
    var eggGroups: [EggGroup] = []
    
    var delegate: EggGroupBankDelegate?
    
    var detectorDelegate: DetectorToEggGroupBankDelegate?
    
    var isReady: Bool{
        didSet{
            
            if isReady == true{
                
                while detectorDelegate?.setDetections() == nil{print("ss")}
                
                let detections = detectorDelegate?.setDetections()
                
                let detectionArray = detections!.map({$0.labels.map({Detection(category: $0.identifier, confidence: $0.confidence)})})
                
//                let simplerDetections:Set = ["glasses", "barba", "chain", "mascara", "bone", "brinco"]
                let harderDetections:Set = ["sunglasses", "chapeu", "gorro", "colarGrande", "boina"]
                
                var pokedexArray: [Int] = []
                
                for detection in detections! {
                    
                    print(detection.labels.map({"\($0.identifier) confidence: \($0.confidence)"}).joined(separator: "\n"))
                    print("------------")
                    
                }
                
                if (detectionArray.isEmpty) {
                    pokedexArray = [19, 10, 129, 16]
                } else if (detectionArray.count == 1) {
                    pokedexArray = [12, 15, 20, 23, 24, 27, 29, 43, 48, 98, 49, 50, 52, 133, 54, 60, 41, 69, 72, 75, 88, 90, 112, 116, 161, 163, 172, 178, 190, 258]
                } else if (detectionArray.count == 2) {
                    if (harderDetections.contains(detectionArray[0][0].category) || harderDetections.contains(detectionArray[1][0].category)) {
                        pokedexArray = [118, 122, 124, 125, 126, 127, 128, 141, 143, 147, 2, 5, 8, 26, 34, 36, 38, 45, 59, 64, 67, 80, 93, 97, 95]
                    } else {
                     pokedexArray = [1, 4, 7, 18, 25, 27, 35, 37, 39, 44, 46, 53, 58, 61, 63, 66,  77, 79, 83, 86, 92, 96, 102, 104, 108, 113]
                    }
                } else {
                    pokedexArray = [3, 6, 9, 65, 68, 78, 80, 94, 105, 130, 131, 132, 134, 135, 136, 148, 149, 151, 157, 160, 381, 373, 392, 445]
                }
                
                let index: Int = pokedexArray.randomElement()!
//                print(eggGroups.count)
//                let eggGroup = eggGroups[index]
                
                DispatchQueue.global(qos: .background).async {
                    
                    do{
                        
                        
//                        let pokemonSpecies = eggGroup.pokemonSpecies!.randomElement()
                        let pokemonURL = "https://pokeapi.co/api/v2/pokemon/" + String(index)
                        let url = URL(string: pokemonURL)
                        let data = try Data(contentsOf: url!)
                        
                        let pokemon = try JSONDecoder().decode(Pokemon.self, from: data)
                        
                        DispatchQueue.main.async {
                            let sprites = pokemon.sprites
                            
                            do{
                                
                                let url = URL(string: sprites!.frontDefault!)
                                let data = try Data(contentsOf: url!)
                                
                                self.delegate?.updatePokemonInfo(from: data, pokemon: pokemon)
                                
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
        self.eggGroups.removeAll()
        
        let URLString = "https://pokeapi.co/api/v2/egg-group"
        let url = URL(string: URLString)
        DispatchQueue.global(qos: .background).async {
            
            do{
                let data = try Data(contentsOf: url!)
                
                self.eggGroupList = try JSONDecoder().decode(EggGroupList.self, from: data)
                
                //essafuncao so eh p demorar 1 pouco ok
                for result in self.eggGroupList!.results!{
                    print(result.name!)
                    
                    let eggGroupURL = URL(string: result.url!)
                    
                    do{
                        let data = try Data(contentsOf: eggGroupURL!)
                        
                        let eggGroup = try JSONDecoder().decode(EggGroup.self, from: data)
                        
                        DispatchQueue.main.async {
                            self.eggGroups.append(eggGroup)
                        }
                        
                    }catch{
                        DispatchQueue.main.async {
                            print("Não foi possível encontrar esse pokemon")
                        }
                    }
                }
                
                self.isReady = true
                
            } catch{
                DispatchQueue.main.async {
                    print("Não foi possível baixar a lista de pokemon")
                }
            }
            
        }
        
    }
}

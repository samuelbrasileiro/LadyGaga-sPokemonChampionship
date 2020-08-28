//
//  EggGroupBank.swift
//  Lady Gaga's Pokemon Championship
//
//  Created by Samuel Brasileiro on 27/08/20.
//  Copyright © 2020 Samuel Brasileiro. All rights reserved.
//

import Foundation

class EggGroupBank{
    var eggGroupList: EggGroupList?
    var eggGroups: [EggGroup] = []
    
    init(){
        downloadEggGroups()
        
    }
    
    
    
    
    
    func downloadEggGroups(){
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
                            
                            DispatchQueue.main.async {
                                
                                self.eggGroups.append(eggGroup)
                            }
                            
                        }catch{
                            DispatchQueue.main.async {
                                print("Não foi possível encontrar esse pokemon")
                            }
                        }
                        
                    }
                }
            } catch{
                DispatchQueue.main.async {
                    print("Não foi possível baixar a lista de pokemon")
                }
            }
        }
    }
}

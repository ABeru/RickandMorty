//
//  EpViewModel.swift
//  rickMorty
//
//  Created by Alexandre on 09.07.21.
//

import Foundation
class EpsViewModel {
    public var fetch = { (completion: @escaping (Episodes) -> ()) in
        APIService.fetchEpisodes(){ response in
                completion(response)
    
            }
        
    }
   

}

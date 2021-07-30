//
//  CharactersViewModel.swift
//  rickMorty
//
//  Created by Alexandre on 09.07.21.
//

import Foundation
class CharactersViewModel {
    public var fetch = { (ids: [Int], completion: @escaping ([CharactersM]) -> ()) in
        APIService.fetchCharacters(ids: ids){ response in
                completion(response)
            }
        
    }
}

//
//  epViewModel.swift
//  rickMorty
//
//  Created by Alexandre on 12.07.21.
//

import Foundation
class EpViewModel {
    public var fetch = { (ids: [Int], completion: @escaping ([EpisodeRes]) -> ()) in
        APIService.fetchEpisode(ids: ids){ response in
                completion(response)
            }

    }
    public var fetchSingle = { (id: Int, completion: @escaping (EpisodeRes) -> ()) in
        APIService.fetchSingleEpisode(id: id){ response in
                completion(response)
    
            }
        
    }
}

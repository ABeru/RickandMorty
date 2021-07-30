//
//  FilterViewModel.swift
//  rickMorty
//
//  Created by Alexandre on 13.07.21.
//

import Foundation
class FilterVmChar {
    public var fetch = { (query: String, completion: @escaping (FilterM) -> ()) in
        APIService.fetchFilterChar(query: query){ response in
                completion(response)
            }
        
    }
}
class FilterVmEp {
    public var fetch = { (query: String, completion: @escaping (Episodes) -> ()) in
        APIService.fetchFilterEp(query: query){ response in
                completion(response)
            }
        
    }
}

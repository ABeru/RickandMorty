//
//  ApiServices.swift
//  rickMorty
//
//  Created by Alexandre on 09.07.21.
//

import Foundation
class APIService {
    static func fetchEpisodes(completion: @escaping (Episodes) -> ()) {
        
    guard let url = URL(string: "https://rickandmortyapi.com/api/episode") else {return}
    let request = URLRequest(url: url)
    URLSession.shared.dataTask(with: request) { (data, res, err) in
        
        guard let data = data else {return}
        
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(Episodes.self, from: data)
            
            
            completion(response)
        } catch let err {
            debugPrint(err)
        }
    }.resume()
}
    static func fetchCharacters(ids: [Int],completion: @escaping ([CharactersM]) -> ()) {
        let idsList = ids.map{String($0)}.joined(separator: ",")
    guard let url = URL(string: "https://rickandmortyapi.com/api/character/\(idsList)") else {return}
    let request = URLRequest(url: url)

    URLSession.shared.dataTask(with: request) { (data, res, err) in
        
        guard let data = data else {return}
        
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode([CharactersM].self, from: data)
            
            
            completion(response)
        } catch let err {
            debugPrint(err)
        }
    }.resume()
}
    static func fetchEpisode(ids: [Int],completion: @escaping ([EpisodeRes]) -> ()) {
        let idList = ids.map{String($0)}.joined(separator: ",")
    guard let url = URL(string: "https://rickandmortyapi.com/api/episode/\(idList)") else {return}
    let request = URLRequest(url: url)
    print(request)
    URLSession.shared.dataTask(with: request) { (data, res, err) in
        
        guard let data = data else {return}
        
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode([EpisodeRes].self, from: data)
            
            
            completion(response)
        } catch let err {
            debugPrint(err)
        }
    }.resume()
}
    static func fetchFilterChar(query: String,completion: @escaping (FilterM) -> ()) {
        
    guard let url = URL(string: "https://rickandmortyapi.com/api/character/?name=\(query)") else {return}
    let request = URLRequest(url: url)
    URLSession.shared.dataTask(with: request) { (data, res, err) in
        
        guard let data = data else {return}
        
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(FilterM.self, from: data)
            
            
            completion(response)
        } catch let err {
            debugPrint(err)
        }
    }.resume()
}
    static func fetchFilterEp(query: String,completion: @escaping (Episodes) -> ()) {
        
    guard let url = URL(string: "https://rickandmortyapi.com/api/episode/?name=\(query)") else {return}
    let request = URLRequest(url: url)
    URLSession.shared.dataTask(with: request) { (data, res, err) in
        
        guard let data = data else {return}
        
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(Episodes.self, from: data)
            
            
            completion(response)
        } catch let err {
            debugPrint(err)
        }
    }.resume()
}
    static func fetchSingleEpisode(id: Int, completion: @escaping (EpisodeRes) -> ()) {
        
    guard let url = URL(string: "https://rickandmortyapi.com/api/episode/\(id)") else {return}
    let request = URLRequest(url: url)
    URLSession.shared.dataTask(with: request) { (data, res, err) in
        
        guard let data = data else {return}
        
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(EpisodeRes.self, from: data)
            
            
            completion(response)
        } catch let err {
            debugPrint(err)
        }
    }.resume()
}
}

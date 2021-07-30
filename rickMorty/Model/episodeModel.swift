//
//  episodeModel.swift
//  rickMorty
//
//  Created by Alexandre on 09.07.21.
//

import Foundation
struct Episodes: Codable {
    let results: [EpisodeRes]
}
struct EpisodeRes: Codable {
    let id: Int
    let name, airDate, episode: String
    let characters: [String]
    let url: String
    let created: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case airDate = "air_date"
        case episode, characters, url, created
    }
}

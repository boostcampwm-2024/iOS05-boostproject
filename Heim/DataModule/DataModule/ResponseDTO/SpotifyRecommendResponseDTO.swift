//
//  SpotifyRecommendResponseDTO.swift
//  DataModule
//
//  Created by 정지용 on 11/25/24.
//

import Domain

struct SpotifyRecommendResponseDTO: Codable {
  let tracks: [SpotifyTrack]
  let seeds: [Seed]
}
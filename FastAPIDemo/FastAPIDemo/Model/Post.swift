//
//  Post.swift
//  FastAPIDemo
//
//  Created by Patrik Cesnek on 07/12/2025.
//

import Foundation

struct Post: Identifiable, Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}


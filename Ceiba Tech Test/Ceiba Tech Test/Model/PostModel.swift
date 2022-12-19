//
//  PostModel.swift
//  Ceiba Tech Test
//
//  Created by Miguel Angel Castellanos Salamanca on 16/12/22.
//

import Foundation

struct PostModel: Decodable{
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

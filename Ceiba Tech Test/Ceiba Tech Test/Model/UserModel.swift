//
//  UsersModel.swift
//  Ceiba Tech Test
//
//  Created by Miguel Angel Castellanos Salamanca on 16/12/22.
//

import Foundation

struct UserModel: Decodable {
    let id: Int
    let name: String
    let email: String
    let phone: String
}

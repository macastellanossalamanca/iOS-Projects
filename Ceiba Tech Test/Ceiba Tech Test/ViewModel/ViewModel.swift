//
//  UsersViewModel.swift
//  Ceiba Tech Test
//
//  Created by Miguel Angel Castellanos Salamanca on 16/12/22.
//

import Foundation
class ViewModel: ObservableObject, DataManagerDelegate {
    @Published var users: [UserModel]?
    @Published var posts: [PostModel]?
    var manager: DataManager = DataManager()
    
    init() {
        manager.delegate = self
        manager.loadUsers()
        manager.loadPosts()
    }
    
    func handleUsers(users: [UserModel]) {
        self.users = users
    }
    
    func handlePosts(posts: [PostModel]) {
        self.posts = posts
    }
}

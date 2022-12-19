//
//  DataManager.swift
//  Ceiba Tech Test
//
//  Created by Miguel Angel Castellanos Salamanca on 16/12/22.
//

import Foundation
import CoreData

struct DataManager {
    
    weak var delegate: DataManagerDelegate?
    let persistentContainer: NSPersistentContainer
    
    init() {
        persistentContainer = NSPersistentContainer(name: "DataModel")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Core Data Store Failed \(error.localizedDescription)")
            }
        }
    }
    
    func loadUsers() {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        var users: [User]
        var modelUsers: [UserModel] = [UserModel]()
        do {
            users = try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            users = []
        }
        if users.isEmpty{
            print("Users Info | Obtained from API | \(#function)")
            fetchUsers()
        } else {
            print("Users Info | Obtained from CoreData | \(#function)")
            users.forEach { user in
                if let safeName = user.name, let safeEmail = user.email, let safePhone = user.phone {
                    modelUsers.append(UserModel(id: Int(user.id), name: safeName, email: safeEmail, phone: safePhone))
                }
            }
            delegate?.handleUsers(users: modelUsers)
        }
    }
    
    func loadPosts() {
        let fetchRequest: NSFetchRequest<Post> = Post.fetchRequest()
        var posts: [Post]
        var modelPosts: [PostModel] = [PostModel]()
        do {
            posts = try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            posts = []
        }
        if posts.isEmpty {
            print("Posts Info | Obtained from API | \(#function)")
            fetchPosts()
        } else {
            print("Posts Info | Obtained from CoreData | \(#function)")
            posts.forEach { post in
                if let safeTitle = post.title, let safeBody = post.body{
                    modelPosts.append(PostModel(userId: Int(post.userId), id: Int(post.id), title: safeTitle, body: safeBody))
                }
            }
            delegate?.handlePosts(posts: modelPosts)
        }
    }
    
    func saveUsers(users: [UserModel]) {
        users.forEach { user in
            let DBUser = User(context: persistentContainer.viewContext)
            DBUser.id = Int16(user.id)
            DBUser.name = user.name
            DBUser.email = user.email
            DBUser.phone = user.phone
        }
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Failed to save users data \(error)")
        }
    }
    
    func savePosts(posts: [PostModel]) {
        posts.forEach { post in
            let DBPost = Post(context: persistentContainer.viewContext)
            DBPost.id = Int16(post.id)
            DBPost.userId = Int16(post.userId)
            DBPost.title = post.title
            DBPost.body = post.body
        }
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Failed to save users data \(error)")
        }
    }
    
    
    func fetchUsers() {
        if let url = URL(string: "https://jsonplaceholder.typicode.com/users") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error == nil {
                    let decoder = JSONDecoder()
                    if let safeData = data {
                        do {
                            let users = try decoder.decode([UserModel].self, from: safeData)
                            DispatchQueue.main.async {
                                saveUsers(users: users)
                                delegate?.handleUsers(users: users)
                            }
                        } catch {
                            print(error)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func fetchPosts() {
        if let url = URL(string: "https://jsonplaceholder.typicode.com/posts") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error == nil {
                    let decoder = JSONDecoder()
                    if let safeData = data {
                        do {
                            let posts = try decoder.decode([PostModel].self, from: safeData)
                            DispatchQueue.main.async {
                                savePosts(posts: posts)
                                delegate?.handlePosts(posts: posts)
                            }
                        } catch {
                            print(error)
                        }
                    }
                }
            }
            task.resume()
        }
    }
}

protocol DataManagerDelegate: AnyObject {
    func handleUsers(users: [UserModel])
    func handlePosts(posts: [PostModel])
}

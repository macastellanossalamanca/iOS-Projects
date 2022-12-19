//
//  PostsView.swift
//  Ceiba Tech Test
//
//  Created by Miguel Angel Castellanos Salamanca on 18/12/22.
//

import SwiftUI

struct PostsView: View {
    
    @State var user: UserModel?
    @State var posts: [PostModel]?
    
    var userPosts: [PostModel] {
        return posts?.filter{$0.userId == user?.id} ?? []
    }
    
    var body: some View {
        if let safeUser = user {
            VStack{
                VStack(alignment: .leading){
                    Text(safeUser.name)
                        .font(.headline)
                        .foregroundColor(Color.black)
                    HStack{
                        Image(systemName: "phone.fill")
                            .foregroundColor(Color.green)
                        Text(safeUser.phone)
                    }
                    HStack{
                        Image(systemName: "envelope.fill")
                            .foregroundColor(Color.green)
                        Text(safeUser.email)
                    }
                }
            }
            List {
                ForEach(userPosts, id: \.id) { post in
                    VStack(alignment: .leading){
                        Text(post.title)
                            .font(.title)
                        Text(post.body)
                            .font(.body)
                    }
                }
            }
        }
    }
}


struct PostsView_Previews: PreviewProvider {
    static var previews: some View {
        PostsView()
    }
}

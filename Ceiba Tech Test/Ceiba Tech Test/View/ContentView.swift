//
//  ContentView.swift
//  Ceiba Tech Test
//
//  Created by Miguel Angel Castellanos Salamanca on 16/12/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ViewModel = ViewModel()
    @State var searchText: String = ""
    
    var users: [UserModel] {
        if searchText.isEmpty {
            return viewModel.users ?? []
        } else {
            return viewModel.users?.filter{$0.name.lowercased().contains(searchText.lowercased())} ?? []
        }
    }
    
    var body: some View {
        NavigationStack{
            List {
                if users.isEmpty {
                    Text("List is empty")
                        .font(.subheadline)
                        .fontWeight(.thin)
                        .multilineTextAlignment(.center)
                } else {
                    ForEach(users, id: \.id) { user in
                        NavigationLink(destination: PostsView(user: user, posts: viewModel.posts)) {
                            VStack(alignment: .leading){
                                Text(user.name)
                                    .font(.headline)
                                    .foregroundColor(Color.black)
                                HStack{
                                    Image(systemName: "phone.fill")
                                        .foregroundColor(Color.green)
                                    Text(user.phone)
                                }
                                HStack{
                                    Image(systemName: "envelope.fill")
                                        .foregroundColor(Color.green)
                                    Text(user.email)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Ceiba Tech Test")
        }
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .automatic),
            prompt: "Ingresa el nombre de usuario")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

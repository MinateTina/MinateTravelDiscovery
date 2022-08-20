//
//  CreatorDetailsView.swift
//  TravelDiscoveryLBTA
//
//  Created by Minate on 7/5/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct CreatorDetails: Decodable {
    let username, firstName, lastName, profileImage: String
    let followers, following: Int
    let posts: [Post]
}

struct Post: Decodable, Hashable {
    let title, imageUrl, views: String
    let hashtags: [String]
}


class CreatorDetailsViewModel: ObservableObject {
    
    @Published var creatorDetails: CreatorDetails?
    
    init(creatorId: Int) {
        
        guard let url = URL(string: "https://travel.letsbuildthatapp.com/travel_discovery/user?id=\(creatorId)") else { return }
        
                URLSession.shared.dataTask(with: url) { data, response, err in
                    guard let data = data else { return }
                    
                    DispatchQueue.main.async {
                        do {
                            self.creatorDetails = try? JSONDecoder().decode(CreatorDetails.self, from: data)
                            
                        } catch let jsonErr {
                            print("Decoding failed for creatorDetails", (jsonErr))
                        }
                        print(data)
                    }
                    
                }.resume()
        
    }
    
}

struct CreatorDetailsView: View {
    
    @ObservedObject var vm: CreatorDetailsViewModel
    
    let creator: TrendingCreator
    
    init(creator: TrendingCreator) {
        self.creator = creator
        self.vm = .init(creatorId: creator.id)
        
    }

    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                Image(creator.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60)
                    .clipShape(Circle())
                    .shadow(radius: 10)
                    .padding(.horizontal)
                    .padding(.top)
                
                Text(creator.name)
                    .font(.system(size: 14, weight: .semibold))
          
                
                HStack {
                    Text("@\(creator.name) •")
                    Image(systemName: "hand.thumbsup.fill")
                        .font(.system(size: 10, weight: .semibold))
                    Text("2541")
                }
                .font(.system(size: 12, weight: .regular))
                
                Text("YouTuber, Vlogger, Travel Creator")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Color(.lightGray))
                
                HStack(spacing: 12) {
                    VStack {
                        Text("59,394")
                            .font(.system(size: 13, weight: .semibold))
                        Text("\(vm.creatorDetails?.followers ?? 0)")
                            .font(.system(size: 9, weight: .regular))
                    }
                    
                    Spacer()
                        .frame(width: 0.5, height: 12)
                        .background(Color(.lightGray))
                    
                    VStack {
                        Text("\(vm.creatorDetails?.following ?? 0)")
                            .font(.system(size: 13, weight: .semibold))
                        Text("Following")
                            .font(.system(size: 9, weight: .regular))
                    }
                }
                
                HStack(spacing: 12) {
                    Button(action: {}, label: {
                        HStack {
                            Spacer()
                            Text("Follow")
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.vertical, 8)
                            .background(Color.orange)
                        .cornerRadius(100)
                    })
                    
                    Button {
                        
                        
                    } label: {
                        HStack {
                            Spacer()
                            Text("Contact")
                                .foregroundColor(.black)
                            Spacer()
                        }
                        .padding(.vertical, 8)
                        .background(Color(white: 0.9))
                        .cornerRadius(100)
                        }
                    
                    
                    }.font(.system(size: 11, weight: .semibold))
                
                ForEach(vm.creatorDetails?.posts ?? [], id: \.self) { post in
                    VStack(alignment: .leading, spacing: 12) {
                        
                        WebImage(url: URL(string: post.imageUrl))
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .clipped()
                        
                        HStack {
                            Image(creator.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 34)
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading) {
                                
                                Text("\(post.title)")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.black)
                                
                                Text("\(post.views) views")
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundColor(.gray)
                            }
                        }.padding(.horizontal, 12)
                        
                        HStack {
                            ForEach(post.hashtags, id: \.self) { hashtag in
                                Text("#\(hashtag)")
                                    .foregroundColor(Color(#colorLiteral(red: 0.07797152549, green: 0.513774395, blue: 0.9998757243, alpha: 1)))
                                    .font(.system(size: 14, weight: .semibold))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 4)
                                    .background(Color(#colorLiteral(red: 0.9057956338, green: 0.9333867431, blue: 0.9763537049, alpha: 1)))
                                    .cornerRadius(20)
                            }
                        }.padding(.bottom)
                        .padding(.horizontal, 12)
                        
                    }
//                        .frame(height: 200)
                    .background(Color(white: 1))
                    .cornerRadius(12)
                    .shadow(color: .init(white: 0.8), radius: 5, x: 0, y: 4)
                }
             
            }.padding(.horizontal)
            
        }.navigationBarTitle(creator.name, displayMode: .inline)
    }
}

struct CreatorDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CreatorDetailsView(creator: .init(id: 0, name: "Lily Peony", imageName: "LilyPeony"))
        }
    }
}

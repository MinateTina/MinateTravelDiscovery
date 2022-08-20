//
//  RestaurantDetailsView.swift
//  TravelDiscoveryLBTA
//
//  Created by Minate on 7/2/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct RestaurantDetails: Decodable {
    let description: String
    let popularDishes: [Dish]
    let photos: [String]
    let reviews: [Review]
}

struct Review: Decodable, Hashable {
    let user: ReviewUser
    let rating: Int
    let text: String
}

struct ReviewUser: Decodable, Hashable {
    let id: Int
    let username, firstName, lastName, profileImage: String
    
}

struct Dish: Decodable, Hashable{
    let name, price, photo: String
    let numPhotos: Int
}

class RestaurantDetailsViewModel: ObservableObject {
    @Published var isLoading = true
    @Published var details: RestaurantDetails?
    
    init() {
        //Fetch my nested JSON here
        let urlString = "https://travel.letsbuildthatapp.com/travel_discovery/restaurant?id=0"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, err in
            
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                self.details = try? JSONDecoder().decode(RestaurantDetails.self, from: data)
            }
            
        }.resume()
    }
    
}

struct RestaurantDetailsView: View {
    
    @ObservedObject var vm = RestaurantDetailsViewModel()
    
    let restaurant: Restaurant
    
    var body: some View {

        ScrollView {
            ZStack(alignment: .bottomLeading) {
                
                Image(restaurant.imageName)
                    .resizable()
                    .scaledToFill()

                LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black]), startPoint: .center, endPoint: .bottom)
                
                HStack {
                    VStack(alignment: .leading, spacing: 4){
                        Text(restaurant.name)
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .bold))
                        
                        HStack{
                            ForEach(0..<5, id:\.self) { num in
                                Image(systemName: "star.fill")
                                    .foregroundColor(.orange)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    NavigationLink {
                        RestaurantPhotosView()
                    } label: {
                        Text("See more photos")
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .regular))
                            .frame(width: 80)
                            .multilineTextAlignment(.trailing)
                    }

                }.padding()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Location & Description")
                    .font(.system(size: 16, weight: .bold))
                Text("Tokyo, Japan")
                HStack {
                    ForEach(0..<3, id:\.self) { num in
                        Image(systemName: "dollarsign.circle.fill")
                            
                    }.foregroundColor(.orange)
                }
                Text(vm.details?.description ?? "")
                
            }.padding()
            
            HStack {
                Text("Popular Dishes")
                    .font(.system(size: 16, weight: .bold))
                Spacer()
            }.padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16){
                    ForEach(vm.details?.popularDishes ?? [], id:\.self) { popularDish in
                        DishTile(popularDish: popularDish)
                    }
                }.padding(.horizontal)
            }
            
            if let reviews = vm.details?.reviews {
                ReviewsList(reviews: reviews)
            }
            
        }.navigationBarTitle("Restaurant Details", displayMode: .inline)
    }
    
}

struct ReviewsList: View {
    
    let reviews: [Review]
    
    var body: some View {
        
        HStack {
            Text("Customer Reviews")
                .font(.system(size: 16, weight: .bold))
            Spacer()
        }.padding()
        
//        if let reviews = vm.details?.reviews {
            ForEach(reviews, id:\.self) { review in
                VStack(alignment: .leading) {
                    HStack {
                        WebImage(url: URL(string: review.user.profileImage))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .cornerRadius(40)
                            .shadow(radius: 5)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(review.user.firstName) \(review.user.lastName)")
                                .font(.system(size: 14, weight: .bold))
                            HStack(spacing: 2) {
                                ForEach(0..<review.rating, id:\.self) { num in
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.orange)
                                        
                                }
                                ForEach(0..<5 - review.rating, id:\.self) { num in
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.gray)
                                        
                                }
                            }
                            .font(.system(size: 12))
                        }
                        Spacer()
                        Text("Dec 2020")
                            .font(.system(size: 14, weight: .regular))
                        
                        
                    }.padding(.horizontal, 4)
                       
                    
                    Text(review.text)
                }.padding(.horizontal)
                .padding(.bottom)
                
            }
    
        }
}

struct DishTile: View {
    
    let popularDish: Dish
    
    var body: some View {
        VStack (alignment: .leading){
            ZStack(alignment: .bottomLeading) {
                WebImage(url: URL(string: popularDish.photo))
                    .resizable()
                    .scaledToFill()
                    .cornerRadius(5)
//                                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray))
                    .shadow(radius: 2)
                    .padding(.vertical, 2)
                LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black]), startPoint: .center, endPoint: .bottom)
                Text(popularDish.price)
                    .foregroundColor(.white)
                    .font(.system(size: 12, weight: .bold))
                    .padding(.horizontal, 4)
            }.frame(height: 120)
                .cornerRadius(5)
          
            Text(popularDish.name)
                .font(.system(size: 14, weight: .bold))
            Text("\(popularDish.numPhotos.description) photos")
                .foregroundColor(.gray)
                .font(.system(size: 12, weight: .regular))
        }
        
    }
}

struct RestaurantDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RestaurantDetailsView(restaurant: .init(name: "Japan's Best Ramen", imageName: "ramen", rate: "4.8 • Ramen • $$", location: "Tokyo", country: "Japan"))
        }
    }
}

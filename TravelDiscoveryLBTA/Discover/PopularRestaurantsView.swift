//
//  PopularRestaurantsView.swift
//  TravelDiscoveryLBTA
//
//  Created by Minate on 6/25/22.
//

import SwiftUI

struct PopularRestaurantsView: View {
    
    let restaurants: [Restaurant] = [
        .init(name: "Japan's Best Ramen", imageName: "ramen", rate: "4.8 • Ramen • $$", location: "Tokyo", country: "Japan"),
        .init(name: "New York's Coolest Bar", imageName: "BarGrill", rate: "4.5 • Grill • $", location: "New York", country: "US")
        
    ]
    var body: some View {
        VStack {
            HStack {
                Text("Popular places to eat")
                    .font(.system(size: 16, weight: .semibold))
                Spacer()
                Text("See all")
                    .font(.system(size: 14, weight: .semibold))
            }.padding(.horizontal)
                .padding(.top)
                
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(restaurants, id: \.self) { restaurant in
                        
                        NavigationLink {
                            RestaurantDetailsView(restaurant: restaurant)
                        } label: {
                            RestaurantTile(restaurant: restaurant)
                                .foregroundColor(Color(.label))
                                .padding(.bottom)
                        }
                        
                    }

                }.padding(.horizontal)
                    .padding(.top, 8)
            }
        }
        
    }
}

struct RestaurantTile: View {
    
    let restaurant: Restaurant
    
    var body: some View {
        HStack(spacing: 8) {
            Image(restaurant.imageName)
                .resizable()
                .scaledToFill()
                .clipped()
                .frame(width: 60, height: 60)
                .cornerRadius(5)
                .padding(.leading, 6)
                .padding(.vertical, 6)
            VStack(alignment: .leading) {
                HStack {
                    Text(restaurant.name)
                    Spacer()
                    Button {
                        
                    } label: {
                        Image(systemName: "ellipsis").foregroundColor(.gray)
                    }

                }
                HStack {
                    Image(systemName: "star.fill")
                    Text(restaurant.rate)
                }
                
                Text("\(restaurant.location), \(restaurant.country)")
            }.font(.system(size: 12, weight: .semibold))
            
            Spacer()
            
        }
        .frame(width: 240)
        .modifier(TileModifier())
        
    }
}


struct PopularRestaurantsView_Previews: PreviewProvider {
    static var previews: some View {
        PopularRestaurantsView()
   
    }
}

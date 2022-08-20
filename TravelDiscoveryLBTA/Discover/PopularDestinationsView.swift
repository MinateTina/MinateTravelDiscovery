//
//  PopularDestinationsView.swift
//  TravelDiscoveryLBTA
//
//  Created by Minate on 6/25/22.
//

import SwiftUI
import MapKit


struct PopularDestinationsView: View {
   
    let destinations : [Destination] = [
        .init(name: "Paris", country: "France", imageName: "Paris", latitude: 48.859565, longitude: 2.353235),
        .init(name: "Tokyo", country: "Japan", imageName: "Japan", latitude: 35.652832, longitude: 139.839478),
        .init(name: "New York", country: "US", imageName: "NewYork", latitude: 40.730610, longitude: -73.935242)
    ]
    
    
    var body: some View {
            VStack {
                HStack {
                    Text("Popular destinations")
                        .font(.system(size: 16, weight: .semibold))
                    Spacer()
                    Text("See all")
                        .font(.system(size: 14, weight: .semibold))
                }.padding(.horizontal)
                    .padding(.top)
                    
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(destinations, id: \.self) { destination in
                            NavigationLink(destination: PopularDestinationDetailsView(destination: destination)) {
                                PopularDestinationTile(destination: destination)
                                    .padding(.bottom)
                            }
                        }
                        
                        
                    }.padding(.horizontal)
                        .padding(.top, 8)
                }
            }
    }
}



struct PopularDestinationTile: View {
    
    let destination: Destination
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            Image(destination.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 125, height: 125)
                .clipped()
                .cornerRadius(4)
                .padding(.horizontal, 6)
                .padding(.vertical, 6)

            Text(destination.name)
                .foregroundColor(Color(.label))
                .font(.system(size: 12, weight: .semibold))
                .padding(.horizontal, 12)
            
            Text(destination.country)
                .foregroundColor(.gray)
                .font(.system(size: 12, weight: .semibold))
                .padding(.horizontal, 12)
                .padding(.bottom, 8)
        
        }.modifier(TileModifier())
    }
    
}

struct PopularDestinationsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PopularDestinationDetailsView(destination: .init(name: "Paris", country: "France", imageName: "Paris", latitude: 48.859565, longitude: 2.353235 ))
        }
        DiscoverView()
        PopularDestinationsView()

    }
}

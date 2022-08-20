//
//  ContentView.swift
//  TravelDiscoveryLBTA
//
//  Created by Minate on 6/23/22.
//

import SwiftUI


extension Color {
    static let discoverBackground = Color(.init(white: 0.95, alpha: 1))
    static let defaultBackground = Color("defaultBackground")
}



struct DiscoverView: View {
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    var body: some View {
        NavigationView {
            
            ZStack {
                //bottom layer
                LinearGradient(gradient: Gradient(colors: [Color.orange, Color.pink]), startPoint: .top, endPoint: .center)
                    .ignoresSafeArea()
                
                //middle layer
                Color.discoverBackground
                    .offset(y: 500)
                
                //top layer
                ScrollView (showsIndicators: false) {
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                        Text("Where do you want to go?")
                        Spacer()
                        
                    }.font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(.init(white: 1, alpha: 0.3)))
                    .cornerRadius(10)
                    .padding(16)
                    
                    
                   DiscoverCategoriesView ()
                    
                    VStack {
                        PopularDestinationsView()
                        PopularRestaurantsView()
                        TrendingCreatorsView()
            
                    }.background(Color.defaultBackground)
                        .cornerRadius(16)
                        .padding(.top)
                    
                }
            }.navigationTitle("Discover")
   
        }
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
            .colorScheme(.light)
        DiscoverView()
            .colorScheme(.dark)
    }
}


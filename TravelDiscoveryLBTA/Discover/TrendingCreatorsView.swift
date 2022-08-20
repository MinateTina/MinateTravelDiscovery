//
//  TrendingCreatorsView.swift
//  TravelDiscoveryLBTA
//
//  Created by Minate on 6/25/22.
//

import SwiftUI

struct TrendingCreatorsView: View {
    let trendingCreators : [TrendingCreator] = [
        .init(id: 0, name: "Adam King", imageName: "AdamKing"),
        .init(id: 1, name: "Jack Tuck", imageName: "JackTuck"),
        .init(id: 2, name: "Lily Peony", imageName: "LilyPeony")
    ]
    
    
    var body: some View {
       
        HStack {
            Text("Trending Creators")
                .font(.system(size: 16, weight: .semibold))
            Spacer()
            Text("See all")
                .font(.system(size: 14, weight: .semibold))
        }.padding(.horizontal)
            .padding(.top)
        
        ScrollView(.horizontal, showsIndicators: false) {
          
            HStack(alignment:.top, spacing: 16) {
                ForEach(trendingCreators, id:\.self) { trendingCreator in
                    NavigationLink {
                        NavigationLazyView(CreatorDetailsView(creator: trendingCreator))
                    } label: {
                            CreatorsView(Creator: trendingCreator)
                    }
                }
            }
            .padding()
        }
    }
}

struct CreatorsView: View {
    
    let Creator: TrendingCreator
    
    var body: some View {
        VStack {
            Image(Creator.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .cornerRadius(.infinity)
            Text(Creator.name)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(Color(.label))
                .multilineTextAlignment(.center)
        }.frame(width: 64)
            .shadow(color: .gray, radius: 2, x: 0.0, y: 2)
            
    }
}

struct TrendingCreatorsView_Previews: PreviewProvider {
    static var previews: some View {
        TrendingCreatorsView()

    }
}

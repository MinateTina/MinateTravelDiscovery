//
//  DiscoverCategoriesView.swift
//  TravelDiscoveryLBTA
//
//  Created by Minate on 6/25/22.
//

import SwiftUI
import SDWebImageSwiftUI


struct NavigationLazyView<Content: View>: View {
    
    let build: () -> Content
    
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    
    var body: Content {
        build()
    }
}

struct DiscoverCategoriesView: View {

    let categories : [Category] = [
        .init(name: "Art", imageName: "paintpalette.fill"),
        .init(name: "Sports", imageName: "sportscourt.fill"),
        .init(name: "Live Events", imageName: "music.mic"),
        .init(name: "Food", imageName: "music.mic"),
        .init(name: "History", imageName: "music.mic")
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 20){
                ForEach(categories, id:\.self) { category in
                    NavigationLink(
                        destination: NavigationLazyView(CategoryDetailsView(name: category.name)),
                    label: {
                        
                        VStack(spacing: 8) {
                            Image(systemName: category.imageName)
                                .font(.system(size: 20))
                                .foregroundColor(Color(#colorLiteral(red: 1, green: 0.4220819175, blue: 0.127248764, alpha: 1)))
                                .frame(width: 64, height: 64)
                                .background(Color.white)
                                .cornerRadius(64)

                            Text(category.name)
                                .foregroundColor(.white)
                                .font(.system(size: 12, weight: .semibold))
                                .multilineTextAlignment(.center)
                        }.frame(width: 64)

                    })
                }
            }
            .padding(.horizontal)
            .padding(.vertical)
        }
    }
}

 


struct DiscoverCategoriesView_Previews: PreviewProvider {
    static var previews: some View {

        DiscoverCategoriesView()
    }
}

//
//  CategoryDetailsView.swift
//  TravelDiscoveryLBTA
//
//  Created by Minate on 6/27/22.
//

import SwiftUI
import SDWebImageSwiftUI

class CategoryDetailsViewModel: ObservableObject {
 
    @Published var isLoading = true
    @Published var places = [Place]()
    @Published var errMessage = ""

    init(name: String) {
        
        let urlString = "https://travel.letsbuildthatapp.com/travel_discovery/category?name=\(name.lowercased())".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        guard let url = URL(string: urlString) else {
            self.isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, err in

            if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 400 {
                self.errMessage = "Bad status: \(statusCode)"
                self.isLoading = false
                return
            }
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                guard let data = data else { return }
                
                do {
                    self.places = try JSONDecoder().decode([Place].self, from: data)
                } catch {
                    print("Failed to decode JSON:", err)
                    
                }
                self.isLoading = false
            }
   
        }.resume()

    }
 
}


struct CategoryDetailsView: View {
    
    private let name: String
    
    @ObservedObject private var vm: CategoryDetailsViewModel

    init(name: String) {
        self.name = name
        self.vm = .init(name: name)
    }
    
    var body: some View {
        ZStack {
            if vm.isLoading {
                VStack {
                    ActivityIndicatorView()
                    Text("Loading")
                        .foregroundColor(.white)
                        .font(.system(size: 14, weight: .semibold))
                }.padding()
                .background(Color.black)
                .cornerRadius(8)
               
            } else {
                ZStack {
                    if !vm.errMessage.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "xmark.octagon.fill")
                                .font(.system(size: 64, weight: .semibold))
                                .foregroundColor(.red)
                            Text(vm.errMessage)
                        }
                       
                    } else {
                        ScrollView(showsIndicators: false) {
                            ForEach(vm.places, id:\.self) { place in
                                VStack(alignment: .leading, spacing: 0) {
                              
                                    WebImage(url: URL(string: place.thumbnail))
                                        .resizable()
                                        .indicator(.activity)
                                        .transition(.fade(duration: 0.5))
                                        .scaledToFill()
                                      
                                    Text(place.name)
                                        .font(.system(size: 12, weight: .semibold))
                                        .padding()
                               
                                }.modifier(TileModifier())
                                .padding()
                            }
                        }
                        
                    }
                    
                }
             
            }
        }
        .navigationBarTitle(name, displayMode: .inline)
    }
}


struct CategoryDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CategoryDetailsView(name: "Food")
        }        
    }
}

//
//  PopularDestinationDetailsView.swift
//  TravelDiscoveryLBTA
//
//  Created by Minate on 6/29/22.
//

import SwiftUI
import MapKit

class DestinationDetailsViewModel: ObservableObject {
    
    @Published var isLoading = true
    @Published var destinationDetails: DestinationDetails?
    
    init(name: String) {
        
        let urlString = "https://travel.letsbuildthatapp.com/travel_discovery/destination?name=\(name.lowercased())".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        guard let url = URL(string: urlString) else { return }
        
       
            URLSession.shared.dataTask(with: url) { data, response, err in
                DispatchQueue.main.async {
                    guard let data = data else { return }
      
                    do {
                        self.destinationDetails = try JSONDecoder().decode(DestinationDetails.self, from: data)

                    } catch {
                        print("Failed to decode JSON:", error)
                    }
                }
                
            }.resume()
    }
}

struct DestinationDetails: Decodable {
    let description: String
    let photos: [String]
}

struct PopularDestinationDetailsView: View {
    
    @ObservedObject var vm: DestinationDetailsViewModel
    
    let destination: Destination
    
    @State var region: MKCoordinateRegion
    @State var isShowingAttractions = true
    
    
    init(destination: Destination) {
        self.destination = destination
        self._region = State(initialValue: MKCoordinateRegion(center: .init(latitude: destination.latitude, longitude: destination.longitude), span: .init(latitudeDelta: 0.05, longitudeDelta: 0.05)))
        
        self.vm = .init(name: destination.name)
        
    }
    
    let attractions: [Attraction] = [
        .init(name: "Eiffel Tower", imageName: "Paris", latitude: 48.859565, longitude: 2.353235),
        .init(name: "Champs-Elysees", imageName: "Champs", latitude: 48.866867, longitude: 2.311780),
        .init(name:"Louvre Museum", imageName: "Louvre", latitude: 48.860288, longitude: 2.337789)
    ]
    
    let imageUrlStrings = [
        "https://letsbuildthatapp-videos.s3-us-west-2.amazonaws.com/2240d474-2237-4cd3-9919-562cd1bb439e",
        "https://letsbuildthatapp-videos.s3-us-west-2.amazonaws.com/b1642068-5624-41cf-83f1-3f6dff8c1702",
        "https://letsbuildthatapp-videos.s3-us-west-2.amazonaws.com/6982cc9d-3104-4a54-98d7-45ee5d117531"
    ]
    
    
    var body: some View {
        ScrollView {
            if let photos = vm.destinationDetails?.photos{
                DestinationHeaderContainer(imageUrlStrings: photos)
                    .frame(height: 300)
            }
    
            VStack (alignment: .leading){
                Text(destination.name)
                    .font(.system(size: 18, weight: .bold))
                Text(destination.country)
                HStack {
                    ForEach(0..<5, id:\.self) { num in
                        Image(systemName: "star.fill")
                            .foregroundColor(.orange)
                    }
                }.padding(.top, 2)
                    .font(.system(size: 14))
            
                HStack { Spacer() }
                
                Text("The Eiffel Tower was built by Gustave Eiffel for the 1889 Exposition Universelle, which was to celebrate the 100th year anniversary of the French Revolution. Its construction in 2 years, 2 months and 5 days was a veritable technical and architectural achievement. Utopia achieved, a symbol of technological prowess, at the end of the 19th Century it was a demonstration of French engineering, and a defining moment of the industrial era. As France’s symbol in the world, and the showcase of Paris, today it welcomes almost 7 million visitors a year, making it the most visited monument that you have to pay for in the world.")
                    .padding(.vertical, 4)
                
                VStack{
                    HStack{
                        Text("Location")
                            .font(.system(size: 18, weight: .bold))
                        Spacer()
                        Button {
                            isShowingAttractions.toggle()
                        } label: {
                            Text("\(isShowingAttractions ? "Hide" : "Show") Attractions")
                                .font(.system(size: 12, weight: .semibold))
                        }

                        Toggle("", isOn: $isShowingAttractions)
                            .labelsHidden()
                    }.padding(.horizontal, 2)
   
                }
                
            }.padding(.horizontal)
                .padding(.top)
          
            Map(coordinateRegion: $region, annotationItems: isShowingAttractions ? attractions : []) { attraction in
                MapAnnotation(coordinate: .init(latitude: attraction.latitude, longitude: attraction.longitude)) {
                    VStack(spacing: 4) {
                        Image(attraction.imageName)
                            .resizable()
                            .frame(width: 80, height: 60)
                            .cornerRadius(5)
                        Text(attraction.name)
                            .font(.system(size: 12, weight: .semibold))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 4)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color(.init(white: 0.3, alpha: 1))))
                        
                    }.shadow(radius: 5)
                }
//                MapMarker(coordinate: .init(latitude: attraction.latitude, longitude: attraction.longitude), tint: .purple)
            }.frame(height: 300)
 
        }.navigationBarTitle(destination.name, displayMode: .inline)
    }
}


struct PopularDestinationDetailsView_Previews: PreviewProvider {
    static var previews: some View {
            DiscoverView()
    }
}

//
//  ContentView.swift
//  SwiftUI_CAMP__FinalProject
//
//  Created by ณัฐภัทร บัวเพชร on 16/6/2567 BE.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @State private var cameraPosition: MapCameraPosition = .region(.userRegion)
    @State var isPressToggleLetgo : Bool = false
    @State var isPressToggleList : Bool = false
    @State var searchText = ""
    
    @State var results = [MKMapItem]()
    @State var mapSelection: MKMapItem?
    
    var body: some View {
        Map(position: $cameraPosition, selection: $mapSelection) {
            Marker("My location", systemImage: "map.circle", coordinate: .userLocation).tint(.blue)
            
            ForEach (results, id: \.self) {item in
                let placemark = item.placemark
                Marker(placemark.name ?? "", coordinate: placemark.coordinate)
            }
        }
        .overlay(alignment: .bottom, content: {
            TextField("Search", text: $searchText)
                .font(.subheadline)
                .padding(12)
                .background(.white)
                .shadow(radius: 10)
                .padding()
                .foregroundStyle(Color.black)
            
            .padding()
        })
        
        .onSubmit(of: /*@START_MENU_TOKEN@*/.text/*@END_MENU_TOKEN@*/) {
            Task {
                await RequestThis()
            }
        }
        .mapControls {
            MapUserLocationButton()
            MapCompass()
        }
        .onChange(of: mapSelection, {oldValue, newValue in
            isPressToggleLetgo = newValue != nil
        })
        .sheet(isPresented: $isPressToggleLetgo) {
            LocationDetailView(mapSelection: $mapSelection, show: $isPressToggleLetgo)
                .presentationDetents([.height(350)])
                .presentationBackgroundInteraction(.enabled(upThrough: .height(350)))
        }
        .sheet(isPresented: $isPressToggleList, content: {
            WantToGoLay()
        })
        
        
        
        ZStack (alignment: .top, content: {
            Button("My List", action: {
                isPressToggleList.toggle()
            })
        })
    }
}

extension ContentView {
    func RequestThis () async {
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = searchText
            request.region = .userRegion
            
            let results = try? await MKLocalSearch(request: request).start()
            self.results = results?.mapItems ?? []
    }
}

extension CLLocationCoordinate2D {
    static var userLocation : CLLocationCoordinate2D {
        return .init(latitude: 13.7357569, longitude: 100.5338507)
    }
}


extension MKCoordinateRegion {
    static var userRegion: MKCoordinateRegion {
        return .init(center:.userLocation,
                     latitudinalMeters: 10000,
                     longitudinalMeters: 10000)
    }
}
#Preview {
    ContentView()
}

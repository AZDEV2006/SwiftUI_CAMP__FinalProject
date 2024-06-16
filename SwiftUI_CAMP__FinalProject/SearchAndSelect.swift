//
//  SearchAndSelect.swift
//  SwiftUI_CAMP__FinalProject
//
//  Created by ณัฐภัทร บัวเพชร on 16/6/2567 BE.
//

import SwiftUI
import MapKit

struct SearchAndSelect: View {
    @StateObject var searchOb = Search()
    @Binding var searchText : String
    var body: some View {
        NavigationStack {
            List {
                TextField("Where you go ?", text: $searchText)
            }
            
//            Button("Submit", action: {
//                await RequestThis()
//            })
            .navigationTitle("Where you Go ?")
        }
    }
}

extension SearchAndSelect {
    func RequestThis ()async {
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = searchText
            request.region = .userRegion
            
            let results = try? await MKLocalSearch(request: request).start()
            searchOb.results = results?.mapItems ?? []
    }
}

#Preview {
    SearchAndSelect(searchText: .constant(""))
}

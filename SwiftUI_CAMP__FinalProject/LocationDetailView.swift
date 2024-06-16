//
//  LocationDetailView.swift
//  SwiftUI_CAMP__FinalProject
//
//  Created by ณัฐภัทร บัวเพชร on 16/6/2567 BE.
//

import SwiftUI
import MapKit
import SwiftData
import Foundation

struct LocationDetailView: View {
    @Environment(\.modelContext) var context
    @Binding var mapSelection: MKMapItem?
    @Binding var show : Bool
    @State private var newPlace = wantToGo()
    
    private func scheduleNotification(for item: wantToGo) {
        let content = UNMutableNotificationContent()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short

        let formattedDate = dateFormatter.string(from: item.go)
        
        content.title = "WantToGO"
        content.body = "\(formattedDate) Are U Ready for going to \(item.place) | \(item.placeDescription)"
        content.sound = UNNotificationSound.default
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: item.go)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
        
        
        private func requestNotificationPermission() {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
            { granted, error in
                if let error = error{
                    print("Error requesting notification permission: \(error)")
                    
                } else if granted{
                    print("Notification permission granted.")
                } else {
                    print("Notification permission denied.")
                }
                
            }
        }
        
        var body: some View {
            VStack () {
                HStack {
                    VStack(alignment: .leading) {
                        Text(mapSelection?.placemark.name ?? "Test")
                            .font(.title)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        Text(mapSelection?.placemark.title ?? "Test")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .lineLimit(12)
                            .padding(.trailing)
                    }
                    
                    Spacer()
                    
                    Button {
                        show.toggle()
                        mapSelection = nil
                    } label : {
                        Image(systemName: "x.square")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.gray)
                    }
                }
                Spacer()
                VStack {
                    DatePicker("Date going", selection: $newPlace.go)
                    DatePicker("Date coming back", selection: $newPlace.back, displayedComponents: .date)
                    TextField("Descriptions, e.g. Why you want to go", text: $newPlace.why)
                }
                Spacer()
                HStack {
                    Button("Add To List", systemImage: "list.bullet") {
                        context.insert(newPlace)
                        scheduleNotification(for: newPlace)
                        show.toggle()
                        try! context.save()
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.black)
                            .shadow(color: .gray, radius: 2, x: 0, y: 2))
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
                }
            }
            .padding()
            .onAppear {
                newPlace.place = mapSelection?.placemark.name ?? ""
                newPlace.placeDescription = mapSelection?.placemark.title ?? ""
                
                requestNotificationPermission()
            }
            
        }
    }



#Preview {
    do{
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: wantToGo.self)
        
        var preview = wantToGo()

        container.mainContext.insert(preview)
        
        return LocationDetailView(mapSelection: .constant(nil), show: .constant(false))
        
    }catch{
        fatalError("ERROR")
    }
}

//
//  WeatherMapView.swift
//  TheHotel
//
//  Created by Jaime Tejeiro on 13/9/24.
//

import SwiftUI
import MapKit

struct WeatherMapView: View {
    // Configura la región centrada en Madrid
       @State private var region = MKCoordinateRegion(
           center: CLLocationCoordinate2D(latitude: 40.4168, longitude: -3.7038), // Coordenadas de Madrid
           span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1) // Nivel de zoom
       )
       
       var body: some View {
           // Muestra el mapa
           NavegationBarView {
               Map(initialPosition: .region(region))
                   .edgesIgnoringSafeArea(.all) // Hace que el mapa ocupe toda la pantalla
               
           }
       }
}

#Preview {
    WeatherMapView()
}

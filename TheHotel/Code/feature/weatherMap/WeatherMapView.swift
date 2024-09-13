//
//  WeatherMapView.swift
//  TheHotel
//
//  Created by Jaime Tejeiro on 13/9/24.
//

import SwiftUI
import MapKit

struct WeatherMapView: View {
    @State var viewModel: WeatherMapViewModel
    
    // Configura la región centrada en Madrid
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40.4168, longitude: -3.7038), // Coordenadas de Madrid
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1) // Nivel de zoom
    )
    
    init() {
        let viewModel = WeatherMapViewModel()
        self._viewModel =  State(wrappedValue: viewModel)
    }
    
    
    var body: some View {
        // Muestra el mapa
        NavegationBarView {
            ZStack(alignment: .top) {
                Map(initialPosition: .region(region))
                    .mapStyle(.hybrid)
                    .edgesIgnoringSafeArea(.all) // Hace que el mapa ocupe toda la pantalla
                
                WeatherTempView()
                    .environment(viewModel)
                
            }.onAppear{
                Task {
                    viewModel.configViewModel()
                }
            }
        }
    }
}

struct WeatherTempView: View {
    @Environment(WeatherMapViewModel.self) private var viewModel
    
    var body: some View{
        ZStack {
            VStack(spacing: 15){
                HStack {
                    Spacer()
                    switch viewModel.terraceStatus {
                    case .openTerrace:
                        Image(systemName: "sun.max.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                    case .closeTerrace:
                        Image(systemName: "cloud.rain.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                    case .snowTerrace:
                        Image(systemName: "snowflake")
                            .resizable()
                            .frame(width: 20, height: 20)
                    case .nullTerrace:
                        Image(systemName: "thermometer.variable.and.figure")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                    Spacer()
                    Text(viewModel.tempDay)
                        .font(.title)
                        .foregroundStyle(.black)
                    Spacer()
                }
                Color.green.frame(height: 1)
                HStack {
                    Spacer()
                    Text("Probabilidad")
                        .font(.title3)
                        .foregroundStyle(.black)
                    Text(viewModel.rainText)
                        .font(.title3)
                        .foregroundStyle(.black)
                    Spacer()
                }
                HStack {
                    Spacer()
                    Text(viewModel.terraceStatus.localizable)
                        .font(.title3)
                        .foregroundStyle(.white)
                    Spacer()
                }
                .padding(.vertical,2)
                .background(Color.green)
                
                
            }
            .background {
                RoundedRectangle(cornerRadius: 0.0)
                    .stroke(lineWidth: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.green)
            }
            .padding(.all, 30)
            .background(Color.white.opacity(0.8))
            .padding(.all, 30)
        }
        
    }
}


#Preview {
    WeatherMapView()
}

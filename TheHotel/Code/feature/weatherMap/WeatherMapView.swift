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
    @Environment(\.dismiss) private var dismiss
    @State var showBackView: Bool = false
    
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
            ZStack(alignment: .top) {
                Map(initialPosition: .region(region))
                    .mapStyle(.hybrid)
                    .edgesIgnoringSafeArea(.all) // Hace que el mapa ocupe toda la pantalla
                
                WeatherTempView()
                    .environment(viewModel)
                
            }.onAppear{
                Task {
                   await viewModel.configViewModel()
                }
            }
            .toolbar {
                
                ToolbarItem(placement: .navigation) {
                        Button(action: {
                            dismiss()
                        }) {
                            HStack(alignment: .center,spacing: 2) {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.green)
                                    .frame(width: 35, height: 35)
                            }
                        }
                }
                
                ToolbarItem(placement: .principal) {
                    Button(action: {
                        print("button pressed")
                    }) {
                        Text("The Hotel")
                            .font(.title)
                            .bold()
                            .foregroundStyle(.green)
                    }.disabled(true)
                }
            }
            .navigationBarBackButtonHidden(true)
    }
}

struct WeatherTempView: View {
    @Environment(WeatherMapViewModel.self) private var viewModel
    
    var body: some View{
        ZStack {
            VStack(spacing: 15){
                Spacer().frame(height: 1)
                Button {
                    Task {
                        do {
                            try await viewModel.fechWeatherStatusData()
                        }
                    }
                } label: {
                    HStack {
                        Spacer()
                        Spacer()
                        Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .foregroundStyle(.black)
                        Spacer().frame(width: 20)
                    }
                }
                HStack {
                    Spacer()
                    Image(systemName: viewModel.terraceStatus.ImgName)
                        .resizable()
                        .frame(width: 20, height: 20)
                    Spacer()
                    Text(viewModel.tempDay)
                        .font(.title)
                        .foregroundStyle(.black)
                    Spacer()
                }
                Color.init(viewModel.terraceStatus.color).frame(height: 1)
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
                .background(viewModel.terraceStatus.color)
                
                
            }
            .background {
                RoundedRectangle(cornerRadius: 0.0)
                    .stroke(lineWidth: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                    .foregroundColor(viewModel.terraceStatus.color)
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

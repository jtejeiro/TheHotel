//
//  MainView.swift
//  TheHotel
//
//  Created by Jaime Tejeiro on 9/9/24.
//

import SwiftUI

struct MainView: View {
    @State var viewModel: MainViewModel
    @State public var hiddenBackButton: Bool = true
    
    init() {
        let viewModel = MainViewModel()
        self._viewModel =  State(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavegationBarView($hiddenBackButton) {
            ZStack {
                Color.white.ignoresSafeArea()
                ScrollView {
                    VStack{
                        HeaderView
                        WeatherStatusView()
                            .environment(viewModel)
                        MenuListView()
                    }
                }
            }.onAppear{
                Task {
//                    viewModel.configViewModel()
                }
            }
        }
    }
    
    var HeaderView: some View {
        VStack(alignment: .center, spacing: 5) {
            Color.green.frame(height: 1)
            HStack(alignment: .center) {
                Spacer()
                Text("Hola")
                    .font(.title)
                    .foregroundStyle(.black)
                Spacer()
            }.frame(height: 30)
            HStack(alignment: .center) {
                Spacer()
                Text(Globals.sharer.userName)
                    .font(.title)
                    .foregroundStyle(.black)
                Spacer()
            }.frame(height: 30)
            Color.green.frame(height: 1)
        }.padding(.all,20)
    }
    
}

struct WeatherStatusView: View {
    @Environment(MainViewModel.self) private var viewModel
    @State var showMapPage:Bool = false
    
    var body: some View{
        VStack(spacing: 15){
            Color.clear.frame(height: 1)
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
            
            Button {
                showMapPage.toggle()
            } label: {
                HStack {
                    Spacer()
                    Text("Mostra Mapa del tiempo")
                        .font(.title3)
                        .underline()
                        .foregroundStyle(.green)
                    Spacer()
                }
            }

           
        }
        .background {
            RoundedRectangle(cornerRadius: 0.0)
                .stroke(lineWidth: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                .foregroundColor(.green)
        }
        .padding(.all, 20)
        .navigationDestination(isPresented: $showMapPage) {
            WeatherMapView()
        }
        
    }
}


#Preview {
    MainView()
}

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
    @State public var editButton: Bool = false
    
    init() {
        let viewModel = MainViewModel()
        self._viewModel =  State(wrappedValue: viewModel)
    }
    
    var body: some View {
            ZStack {
                Color.white.ignoresSafeArea()
                ScrollView {
                    VStack{
                        HeaderView
                        WeatherStatusView()
                            .environment(viewModel)
                        MenuListView(editButton: $editButton)
                    }
                }
            }.onAppear{
                Task {
                    await viewModel.configViewModel()
                }
            }.toolbar {
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
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        print("button pressed")
                        self.editButton.toggle()
                    }) {
                        HStack(alignment: .center,spacing: 2) {
                            Image(systemName: "pencil.tip.crop.circle")
                                .foregroundColor(.green)
                                .frame(width: 35, height: 35)
                        }
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
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
        VStack(spacing: 10){
            Color.clear.frame(height: 1)
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
        .padding(.all, 20)
        .navigationDestination(isPresented: $showMapPage) {
            WeatherMapView()
        }
        
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
}


#Preview {
    MainView()
}

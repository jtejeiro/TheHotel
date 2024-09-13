//
//  PlaceAddView.swift
//  TheHotel
//
//  Created by Jaime Tejeiro on 10/9/24.
//

import SwiftUI

struct PlaceAddView: View {
    @State var viewModel: PlaceAddViewModel
    @State public var hiddenBackButton: Bool = false
    @State var showMainView: Bool = false
    
    init() {
        let viewModel = PlaceAddViewModel()
        self._viewModel =  State(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavegationBarView(hiddenBackButton: $hiddenBackButton) {
            ZStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(alignment: .center) {
                            Spacer()
                            Text("Crea un Plato")
                                .font(.title)
                                .foregroundStyle(.white)
                            Spacer()
                        }.background(Color.green)
                            .padding(.all,20)
                        
                        VStack(spacing: 15) {
                           
                            
                            FormTextDataCamp()
                                .environmentObject(viewModel.getPlaceFormList(.titlePlace))
                            FormSpinnerCamp()
                                .environmentObject(viewModel.getPlaceFormList(.typePlace))
                            
                            FormTextDataCamp()
                                .environmentObject(viewModel.getPlaceFormList(.commentPlace))
                            
                            FormTextDataCamp()
                                .environmentObject(viewModel.getPlaceFormList(.pricePlace))
                               
                        } .padding(.horizontal,20)
                        
                    }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                }
                
                ZStack(alignment: .bottom) {
                    ButtonSaveMenu
                }
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .onAppear{
            viewModel.configViewModel()
        }
    }
    
    
   
    
    var ButtonSaveMenu: some View {
        Button {
            showMainView.toggle()
        } label: {
            ZStack {
                HStack(spacing: 20) {
                    Spacer()
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 20,height: 20)
                        .foregroundStyle(.white)

                    Text("Cargar Plato")
                        .font(.title2)
                        .foregroundStyle(.white)
                    Spacer()
                }
            }
            .frame(height: 40)
            .background {
                RoundedRectangle(cornerRadius: 5.0)
                    .foregroundColor(.green)
            }
            .padding(.vertical,10)
            .padding(.horizontal,20)
        }
        .navigationDestination(isPresented: $showMainView) {
            MainView()
        }
    }
    
}

#Preview {
    PlaceAddView()
}

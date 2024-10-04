//
//  PlaceAddView.swift
//  TheHotel
//
//  Created by Jaime Tejeiro on 10/9/24.
//

import SwiftUI

struct PlaceAddView: View {
    @State var viewModel: PlaceAddViewModel
    @Environment(\.dismiss) private var dismiss
    
    init() {
        let viewModel = PlaceAddViewModel()
        self._viewModel =  State(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack {
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
                VStack {
                    ButtonSaveMenu
                }.ignoresSafeArea(.keyboard,edges: .bottom)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .onAppear{
                viewModel.configViewModel()
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
    
    
   
    
    var ButtonSaveMenu: some View {
        Button {
            Task {
                await viewModel.fechSaveData()
    
            }
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
        .navigationDestination(isPresented: $viewModel.showloadingView) {
            MenuAddView()
        }
    }
    
}

#Preview {
    PlaceAddView()
}

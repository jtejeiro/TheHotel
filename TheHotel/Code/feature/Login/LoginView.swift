//
//  LoginView.swift
//  TheHotel
//
//  Created by Jaime Tejeiro on 12/9/24.
//

import SwiftUI

struct LoginView: View {
    @State var viewModel: LoginViewModel
    @State var hiddenButton: Bool = true
    
    init() {
        let viewModel = LoginViewModel()
        self._viewModel =  State(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 0) {
                VStack(spacing:15){
                    Spacer()
                    HStack(alignment: .center) {
                        Spacer()
                        Text("The Hotel")
                            .font(.title)
                            .foregroundStyle(.green)
                            .bold()
                        Spacer()
                    }.padding(.all,20)
                    HStack(alignment: .center) {
                        Spacer()
                        Text("Coloca tu usuario")
                            .font(.title2)
                            .foregroundStyle(.black)
                        Spacer()
                    }.padding(.horizontal,20)
                    
                    FormTextDataCamp()
                        .environmentObject(viewModel.getLoginFormList(.userName))
                    FormSecureFieldCamp()
                        .environmentObject(viewModel.getLoginFormList(.Password))
                    ButtonSaveMenu
                    Spacer()
                }.padding(.all,20)
                Spacer()
                Spacer()
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        
        .onAppear{
            Task {
                await viewModel.configViewModel()
            }
        }
        .alert(isPresented: $viewModel.isAlertbox) {
            Alert(
                title: Text(viewModel.alertTitle),
                message: Text(viewModel.alertMessage),
                dismissButton: .cancel(Text(viewModel.alertButton)))
        }
    }
    
    var ButtonSaveMenu: some View {
        @Bindable var show = viewModel
        return Button {
            Task {
                await viewModel.fechLoginData()
            }
        } label: {
            ZStack {
                HStack(spacing: 20) {
                    Spacer()
                    Text("Iniciar Sesion")
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
        }
        .navigationDestination(isPresented: $show.showMainView) {
            MainView()
        }
    }
    
    
}

#Preview {
    LoginView()
}

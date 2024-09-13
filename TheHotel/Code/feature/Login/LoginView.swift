//
//  LoginView.swift
//  TheHotel
//
//  Created by Jaime Tejeiro on 12/9/24.
//

import SwiftUI

struct LoginView: View {
    @State var viewModel: LoginViewModel
    
    init() {
        let viewModel = LoginViewModel()
        self._viewModel =  State(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavegationBarView() {
            ZStack {
                Color.white.ignoresSafeArea()
                VStack(spacing:15){
                    Spacer()
                    FormTextDataCamp()
                        .environmentObject(viewModel.getLoginFormList(.userName))
                    FormSecureFieldCamp()
                        .environmentObject(viewModel.getLoginFormList(.Password))
                    ButtonSaveMenu
                    Spacer()
                }.padding(.all,20)
            }.onAppear{
                viewModel.configViewModel()
            }
            .alert(isPresented: $viewModel.isAlertbox) {
                Alert(
                    title: Text(viewModel.alertTitle),
                    message: Text(viewModel.alertMessage),
                    dismissButton: .cancel(Text(viewModel.alertButton)))
            }
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

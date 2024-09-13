//
//  MenuAddView.swift
//  TheHotel
//
//  Created by Jaime Tejeiro on 11/9/24.
//

import SwiftUI

struct MenuAddView: View {
    @State var viewModel: MenuAddModelView
    @State public var hiddenBackButton: Bool = false
    
    init() {
        let viewModel = MenuAddModelView()
        self._viewModel =  State(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavegationBarView($hiddenBackButton) {
            ZStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .center) {
                        Spacer()
                        Text("Crea Menú")
                            .font(.title)
                            .foregroundStyle(.white)
                        Spacer()
                    }.background(Color.green)
                     .padding(.all,20)
                    
                    FormDateCamp(timetype: .BeforeNow)
                        .environmentObject(viewModel.getMenuFormList(.publicationDay))
                        .padding(.all,20)
                    
                    PlaceListView()
                        .environment(viewModel)
                }
                
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        }
        .onAppear{
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

struct PlaceListView: View {
    @Environment(MenuAddModelView.self) private var viewModel
    
    @State var showSecondView: Bool = false
    
    var body: some View {
        VStack {
            ZStack(alignment: .top) {
                VStack {
                    HStack(alignment: .center) {
                        Spacer()
                        Text("Platos")
                            .font(.title)
                            .foregroundStyle(.white)
                        Spacer()
                    }.background(Color.green)
                        .padding(.vertical,10)
                        .padding(.horizontal,20)
                    ButtonAddPlace
                    ListPlaceView.onAppear {
                        Task {
                            viewModel.placeTableLogic.getPlaceTableModel
                        }
                    }
                }
            }
            ZStack(alignment: .bottom) {
                ButtonSaveMenu
            }
        }
    }
    
    var ButtonAddPlace: some View {
        Button {
            showSecondView.toggle()
        } label: {
            ZStack {
                HStack(spacing: 20) {
                    Spacer()
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 20,height: 20)
                        .foregroundStyle(.green)

                    Text("Crear un Plato")
                        .font(.title2)
                        .foregroundStyle(.green)
                    Spacer()
                }
            }
            .frame(height: 40)
            .background {
                RoundedRectangle(cornerRadius: 5.0)
                    .stroke(lineWidth: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.green)
            }
            .padding(.vertical,10)
            .padding(.horizontal,20)
        }
        .navigationDestination(isPresented: $showSecondView) {
            PlaceAddView()
        }
    }
    
    var ListPlaceView: some View {
        FormListCamp()
            .environment(viewModel.getMenuFormList(.listPlace))
    }
    
    var ButtonSaveMenu: some View {
        @Bindable var show = viewModel
        
        return Button {
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

                    Text("Cargar Menu ")
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
        .navigationDestination(isPresented: $show.showMainView) {
            MainView()
        }
    }
    
}

struct FormListCamp: View {
    @Environment(MenuAddModelView.self) var viewModel
    
    var body: some View {
        ScrollView {
            ForEach(0..<viewModel.listPlaceModel.count, id: \.self){ model in
                @Bindable var index = viewModel.listPlaceModel[model]
                
                let firstCategoriId = viewModel.listPlaceModel.first{$0.typePlace == index.typePlace}?.id ?? UUID()
                
                let lastCategoriId = viewModel.listPlaceModel.last{$0.typePlace == index.typePlace}?.id ?? UUID()
                
                VStack {
                   if  firstCategoriId == index.id{
                        HStack(alignment: .center) {
                            Spacer()
                            Text(index.typePlace.localizable)
                                .font(.callout)
                                .bold()
                                .italic()
                                .foregroundStyle(.green)
                            Spacer()
                        }.padding(.all, 10)
                    }
                    VStack  {
                        Toggle(isOn: $index.isCheck) {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Text(index.title)
                                        .font(.body)
                                        .bold()
                                        .foregroundStyle(Color.black)
                                    
                                    Spacer()
                                    Text(index.priceCoin)
                                        .font(.body)
                                        .italic()
                                        .foregroundStyle(Color.black)
                                }
                                if index.comment != "" {
                                    Text(index.comment)
                                        .font(.caption)
                                        .foregroundStyle(Color.black)
                                }
                            }
                            .padding(.horizontal,20)
                        }.toggleStyle(FormCheckBoxTextView())
                         .padding(.all,10)
                           
                        
                        if lastCategoriId == index.id {
                            Color.black
                                .frame(height: 1)
                                .padding(.all,20)
                        }
                    }
                }
            }
        }
    }
    
}




struct FormCheckBoxTextView: ToggleStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            HStack
            {
                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "checkmark.square")
                    .resizable()
                    .frame(width: 20,height: 20)
                    .foregroundStyle(configuration.isOn ? Color.green: Color.black)
                    .padding(.horizontal,10)
                configuration.label
            }
        }
    }
}


#Preview {
    MenuAddView()
}

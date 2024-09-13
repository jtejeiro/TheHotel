//
//  MenuView.swift
//  TheHotel
//
//  Created by Jaime Tejeiro on 9/9/24.
//

import SwiftUI

struct MenuListView: View {
    @State var showSecondView: Bool = false
    
    
    var body: some View {
        ZStack(alignment:.top) {
            VStack(alignment: .center, spacing: 0)  {
                HStack(alignment: .center) {
                    Spacer()
                    Text("El Restaurante")
                        .font(.title)
                        .foregroundStyle(.white)
                    Spacer()
                }.frame(height: 30)
                 .background(Color.green)
                 .padding(.all,20)
                VStack(alignment: .center, spacing: 5) {
                    Color.green.frame(height: 1)
                    HStack(alignment: .center) {
                        Spacer()
                        Text("Menu del día")
                            .font(.title2)
                            .foregroundStyle(.black)
                        Spacer()
                    }.frame(height: 30)
                    Color.green.frame(height: 1)
                }.padding(.all,20)
                
                MenuListView
                ButtonEmptyView
                
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
        }
    }
    
    var ButtonEmptyView: some View {
        Button {
            showSecondView.toggle()
        } label: {
            ZStack {
                VStack(spacing: 10) {
                    Image(systemName: "plus.circle.fill") .resizable()
                        .frame(width: 40,height: 40)
                        .foregroundStyle(.green)

                    Text("Crea Menu")
                        .font(.title2)
                        .foregroundStyle(.green)
                }
            }
            .frame(width: 350,height: 100)
            .background {
                RoundedRectangle(cornerRadius: 5.0)
                    .stroke(lineWidth: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.green)
            }
        }
        .navigationDestination(isPresented: $showSecondView) {
            MenuAddView()
        }
    }
    
    var MenuListView: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            HStack(alignment: .center) {
                Spacer()
                Text("Lunes")
                    .font(.title3)
                Spacer()
            }.background(Color.green)
             .padding(.all,20)
            HStack(alignment: .center) {
                Spacer()
                Text("Postre")
                    .font(.callout)
                    .bold()
                    .italic()
                    .foregroundStyle(.green)
                Spacer()
            }.padding(.vertical,20)
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Plato de comida")
                            .font(.body)
                            .bold()
                        Spacer()
                        Text("99.99 €")
                            .font(.body)
                            .italic()
                    }
                    Text("comentario co entario comentario coment, comentario co entario comentario coment")
                        .font(.caption)
                }
                .padding(.horizontal,30)
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Plato de comida")
                        .font(.body)
                        .bold()
                    Spacer()
                    Text("99.99 €")
                        .font(.body)
                        .italic()
                }
                Text("comentario co entario comentario coment, comentario co entario comentario coment")
                    .font(.caption)
            }
            .padding(.all,30)
                
                Color.black
                    .frame(height: 1)
                    .padding(.all,20)
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        }
}

struct MenuAddView: View {
    @State var viewModel: MenuAddModelView
    @State public var hiddenBackButton: Bool = false
    
    init() {
        let viewModel = MenuAddModelView()
        self._viewModel =  State(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavegationBarView(hiddenBackButton: $hiddenBackButton) {
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
                
                let firstCategoriId = viewModel.listPlaceModel.first{$0.typePlace == index.typePlace}?.id ?? 0
                
                let lastCategoriId = viewModel.listPlaceModel.last{$0.typePlace == index.typePlace}?.id ?? 0
                
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
                                        .font(.caption)
                                        .italic()
                                        .foregroundStyle(Color.black)
                                }
                                Text(index.comment)
                                    .font(.caption)
                                    .foregroundStyle(Color.black)
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

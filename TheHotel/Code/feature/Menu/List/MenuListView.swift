//
//  MenuListView.swift
//  TheHotel
//
//  Created by Jaime Tejeiro on 9/9/24.
//

import SwiftUI

struct MenuListView: View {
    @State var viewModel: MenuListViewModel
    @State var showSecondView: Bool = false
    @Binding var editButton: Bool
    
    init(_ viewModel:MenuListViewModel = MenuListViewModel(),
         editButton: Binding<Bool> ) {
        self._viewModel =  State(wrappedValue: viewModel)
        self._editButton = editButton
    }
    
    var body: some View {
            ZStack(alignment:.top) {
                ScrollView {
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
                        
                        VStack(spacing: 20) {
                            MenuListCamp(editButton: $editButton)
                                .environment(viewModel)
                            ButtonEmptyView
                            Spacer()
                        }
                        
                        
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
                    .onAppear{
                        Task {
                            viewModel.configViewModel()
                        }
                    }
                }
                
            }
    }
    
    
    
    var ButtonEmptyView: some View {
        NavigationStack{
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
        }
        .navigationDestination(isPresented: $showSecondView) {
            MenuAddView()
        }
    }

}
struct MenuListCamp: View {
    @Environment(MenuListViewModel.self) var viewModel
    @Binding var editButton: Bool
    
    fileprivate func headerCell(_ header: MenuModel) -> some View {
        return HStack(alignment: .center) {
            Spacer()
            Text(header.getDay())
                .font(.title3)
                .foregroundStyle(.black)
            Spacer()
            Text(header.getDayWeek())
                .font(.title3)
                .foregroundStyle(.black)
            Spacer()
            Spacer()
        }.background(Color.green)
         .padding(.horizontal,20)
    }
    
    fileprivate func headerBodyCell(_ cell: PlaceModel) -> some View {
        return  HStack(alignment: .center) {
            Spacer()
            Text(cell.typePlace.localizable)
                .font(.callout)
                .bold()
                .italic()
                .foregroundStyle(.green)
            Spacer()
        }.padding(.horizontal, 10)
    }
    
    fileprivate func bodyCell(_ cell: PlaceModel) -> some View {
        return VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(cell.title)
                    .font(.body)
                    .bold()
                    .foregroundStyle(Color.black)
                
                Spacer()
                Text(cell.priceCoin)
                    .font(.body)
                    .italic()
                    .foregroundStyle(Color.black)
            }
            if cell.comment != "" {
                Text(cell.comment)
                    .font(.caption)
                    .foregroundStyle(Color.black)
            }
        }
        .padding(.horizontal,20)
    }
    
    
    fileprivate func editButtonCell(_ cell: MenuModel) -> some View {
        return VStack(alignment: .leading, spacing: 5) {
            HStack {
                NavigationLink {
                        MenuAddView(cell)
                } label: {
                    Image(systemName: "pencil.circle")
                        .resizable()
                        .frame(width: 20,height: 20)
                        .foregroundStyle(.green)
                }
                Spacer()
                Button {
                    Task {
                        do {
                            await viewModel.deleteMenuModelList(id: cell.id)
                        }
                    }
                } label: {
                    Image(systemName: "trash.circle")
                        .resizable()
                        .frame(width: 20,height: 20)
                        .foregroundStyle(.green)
                }
            }
        }
        .padding(.horizontal,20)
    }
    var body: some View {
        VStack(spacing: 15) {
            if viewModel.processState == .display {
                ForEach(viewModel.listMenuModel){ header in
                    if editButton {
                        self.editButtonCell(header)
                    }
                    self.headerCell(header)
                    
                    ForEach(header.listPlace.sorted(by: {$0.typePlace.position<$1.typePlace.position})){ cell in
                        
                        let firstCategoriId = header.listPlace.first(where: {$0.typePlace == cell.typePlace})?.id ?? UUID()
                        
                        if firstCategoriId == cell.id {
                            self.headerBodyCell(cell)
                        }
                        
                        let lastCategoriId = header.listPlace.last(where: {$0.typePlace == cell.typePlace})?.id ?? UUID()
                        
                        self.bodyCell(cell)
                        
                        if lastCategoriId == cell.id {
                            Color.black
                                .frame(height: 1)
                                .padding(.horizontal,20)
                        }
                    }
                }
            }
        }
    }
}



#Preview {
    MenuListView(editButton: .constant(true))
}

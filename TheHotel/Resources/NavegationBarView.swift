//
//  NavegationBarView.swift
//  TheHotel
//
//  Created by Jaime Tejeiro on 9/9/24.
//

import SwiftUI

let navBarAppearence = UINavigationBarAppearance()
 
struct NavegationBarView<Content: View> : View {
   
    @Binding public var hiddenBackButton: Bool
    var content: () -> Content
    @Environment(\.dismiss) private var dismiss
    
    init(_ hiddenBackButton: Binding<Bool> = .constant(true) ,
        @ViewBuilder _ content: @escaping () -> Content) {
            navBarAppearence.configureWithOpaqueBackground()
        navBarAppearence.backgroundColor = .white
            navBarAppearence.shadowColor = .clear
            
        UINavigationBar.appearance().standardAppearance = navBarAppearence
        UINavigationBar.appearance().scrollEdgeAppearance = UINavigationBar.appearance().compactScrollEdgeAppearance
        self._hiddenBackButton = hiddenBackButton
        self.content = content
    }
    
    var body: some View {
        NavigationStack {
                content()
        }.toolbar {
            ToolbarItem(placement: .navigation) {
                if !hiddenBackButton {
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
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("", displayMode: .inline)
        
    }
    
}

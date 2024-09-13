//
//  FormPopupView.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 4/7/24.
//

import Foundation
import SwiftUI

struct FormPopupView<Content: View>: View  {
    let titleBox:String
    @Binding var isClose:Bool
    @ViewBuilder var content: () -> Content
    
    
    var body: some View {
        ZStack(alignment:.center ) {
            Color.green
                .ignoresSafeArea(.all)
                .opacity(0.5).onTapGesture {
                    isClose.toggle()
                }
            
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                    Spacer()
                    Text(titleBox)
                        .font(.system(size: 18))
                        .foregroundStyle(.white)
                        .padding()
                    Spacer()
                }
                .background(.green)
                ZStack {
                    content()
                }
                .padding(.vertical,5)
            }
            .frame(minWidth: 0,maxWidth: .infinity, alignment: .topLeading)
            .background(Color.white)
            .cornerRadius(6)
            .padding(.horizontal,10)
        }.background(BackgroundGrayView())
    }
}

struct FormPopupList:View {
    @Binding var isClose:Bool
    @Binding var index:Int
    let titleBox:String
    let list:[ListFormString]
    
    var body: some View {
        FormPopupView(titleBox: titleBox, isClose: $isClose) {
            ScrollView {
                LazyVStack {
                    ForEach(0..<list.count , id: \.self) { index in
                        HStack {
                            Text(list[index].name)
                                .font(.system(size: 15))
                                .foregroundStyle(.black)
                                .multilineTextAlignment(.leading)
                                .padding(.all, 10)
                                .frame(minWidth: 0,maxWidth: .infinity,alignment: .leading)
                        }
                        .frame(minWidth: 0,maxWidth: .infinity, minHeight: 0, maxHeight: 40,alignment: .leading)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation {
                                self.index = index
                                isClose.toggle()
                            }
                        }
                        .id(index)
                        .hoverEffect()
                        
                        Color.green
                            .frame(height:1)
                            .opacity(0.6)
                            .padding(.horizontal,10)
                    }
                }
            }
            .frame(height: getIdealHeight())
        }
    }
    
    
    func getIdealHeight() -> CGFloat {
       let height = ((40 * CGFloat(list.count + 1)) + 20)
        debugPrint("getIdealHeight")
        debugPrint(height)
        if height < 400 {
            return height
        }
        
        return 400
    }
            
}

enum FormDateTimeTypes {
    case BeforeNow
    case afterNow
    case all
}

struct FormPopupDate:View {
    @Binding var isClose:Bool
    @Binding var date:Date
    let titleBox:String
    var timetype:FormDateTimeTypes = .all
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: "es_ES")
        return formatter
    }()

    
    var body: some View {
        FormPopupView(titleBox: titleBox, isClose: $isClose) {
            VStack {
                switch timetype {
                   // listCalendarStyles : WheelDatePickerStyle GraphicalDatePickerStyle()
                case .BeforeNow:
                    DatePicker(titleBox, selection: $date,in: Date.now...,displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                                    .frame(maxHeight: 350)
                case .afterNow:
                    let currentDate = Date()
                    let eighteenYearsAgo = Calendar.current.date(byAdding: .year, value: -18, to: currentDate)!
                    DatePicker(titleBox, selection: $date,in: ...eighteenYearsAgo,displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                                    .frame(maxHeight: 400)
                case .all:
                    DatePicker(titleBox, selection: $date,displayedComponents: .date)
                                    .datePickerStyle(GraphicalDatePickerStyle())
                                    .frame(maxHeight: 400)
                }
               
                Button {
                    isClose.toggle()
                } label: {
                    Text("Selecciona el dia del menu")
                        .font(.system(size: 17,weight: .bold))
                        .foregroundStyle(.green)
                        .hoverEffect(/*@START_MENU_TOKEN@*/.automatic/*@END_MENU_TOKEN@*/)
                        .padding()
                }

            }
        }
    }
            
}



struct BackgroundGrayView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIVisualEffectView(effect: .none)
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

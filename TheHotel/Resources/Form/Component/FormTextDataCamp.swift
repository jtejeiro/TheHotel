//
//  FormTextDataCamp.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 7/7/24.
//

import SwiftUI

struct FormDataCamp {
   @EnvironmentObject var model: FormDataModel
    
}

extension FormDataCamp {
    
    static func formText(@Binding model:FormDataModel) -> some View {
        return FormTextView(
            inputText: $model.inputText,
            placeHolder: model.getPlaceholder(),
            keyboardType: self.getTypekeyboard(model: model),
            disabled: $model.isDisabled ,
            isError: $model.iSErrorBox,
            limiteChart: model.limitChart)
            .onChange(of: model.inputText) {oldValue, value in
                debugPrint(model.inputText)
            }
    }
    
    static func formSecureField(@Binding model:FormDataModel) -> some View {
        return FormSecureField(
            inputText: $model.inputText,
            placeHolder: model.getPlaceholder(),
            keyboardType: self.getTypekeyboard(model: model),
            disabled: $model.isDisabled ,
            isError: $model.iSErrorBox,
            limiteChart: model.limitChart)
            .onChange(of: model.inputText) {oldValue, value in
                debugPrint(model.inputText)
            }
    }
    
    static func getTypekeyboard(model:FormDataModel)-> UIKeyboardType {
        switch model.typeTextfield {
        case .Text:
            return .default
        case .number:
            return .numberPad
        case .email:
            return .emailAddress
        }
    }
}

struct FormTextDataCamp:View {
    @EnvironmentObject var model: FormDataModel
    
    var body: some View {
        FormTextView(inputText: $model.inputText,placeHolder: model.getPlaceholder(),keyboardType: getTypekeyboard(), disabled: $model.isDisabled , isError: $model.iSErrorBox,limiteChart: model.limitChart)
            .onChange(of: model.inputText) {oldValue, value in
                debugPrint(model.inputText)
            }
    }
    
    func getTypekeyboard()-> UIKeyboardType {
        switch model.typeTextfield {
        case .Text:
            return .default
        case .number:
            return .numberPad
        case .email:
            return .emailAddress
        }
    }
}

struct FormSecureFieldCamp:View {
    @EnvironmentObject var model: FormDataModel
    
    var body: some View {
        FormSecureField(inputText: $model.inputText,placeHolder: model.getPlaceholder(),keyboardType: getTypekeyboard(), disabled: $model.isDisabled , isError: $model.iSErrorBox,limiteChart: model.limitChart)
            .onChange(of: model.inputText) {oldValue, value in
                debugPrint(model.inputText)
            }
    }
    
    func getTypekeyboard()-> UIKeyboardType {
        switch model.typeTextfield {
        case .Text:
            return .default
        case .number:
            return .numberPad
        case .email:
            return .emailAddress
        }
    }
}


struct FormSpinnerCamp:View {
    @EnvironmentObject var model: FormDataModel
    @State var isPopup: Bool = false
    @State var index: Int = 999
    
    
    var body: some View {
        FormTextNoEditView(inputText: $model.inputText, placeHolder: model.getPlaceholder(),isDisabled: $model.isDisabled, isError: $model.iSErrorBox)
            .simultaneousGesture(TapGesture().onEnded({
                if !model.isDisabled {
                    if model.listFormString.count != 0 {
                        isPopup.toggle()
                    }
                }
             }))
                .fullScreenCover(isPresented: $isPopup) {
                FormPopupList(isClose: $isPopup, index: $index, titleBox: model.titleBox, list: model.listFormString)
            }.onChange(of: index) { old, value in
                model.inputText = model.listFormString[value].name
                debugPrint(model.inputText)
            }
    }
}


struct FormDateCamp:View {
    @EnvironmentObject var model: FormDataModel
    @State var isPopup: Bool = false
    @State var date: Date = Date.now
    var timetype:FormDateTimeTypes = .all
    
    var body: some View {
        FormTextNoEditView(inputText: $model.inputText, placeHolder: model.getPlaceholder(),isDisabled: $model.isDisabled, isError: $model.iSErrorBox)
            .simultaneousGesture(TapGesture().onEnded({
                if !model.isDisabled {
                    isPopup.toggle()
                }
             }))
                .fullScreenCover(isPresented: $isPopup) {
                    FormPopupDate(isClose: $isPopup, date: $date, titleBox: model.titleBox, timetype: timetype)
            }.onChange(of: date) { old, value in
                model.inputText = date.toString(format: "dd EEEE yyyy")
                model.inputDate = date
                debugPrint(model.inputText)
            }
    }
}


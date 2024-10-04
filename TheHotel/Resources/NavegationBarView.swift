//
//  NavegationBarView.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 12/6/24.
//

import SwiftUI


let navBarAppearence = UINavigationBarAppearance()


struct NavegationBarView<Content: View> : View {

    @Binding public var hiddenBackButton: Bool
    var content: () -> Content
    @Environment(\.dismiss) private var dismiss
    
    init( hiddenBackButton: Binding<Bool> ,
        @ViewBuilder _ content: @escaping () -> Content) {
        navBarAppearence.configureWithOpaqueBackground()
        navBarAppearence.backgroundColor = .white
        navBarAppearence.shadowColor = .clear
        
        UINavigationBar.appearance().standardAppearance = navBarAppearence
        UINavigationBar.appearance().scrollEdgeAppearance = UINavigationBar.appearance().standardAppearance
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
                        print("button pressed")
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
            
        } //.background(NavigationConfiguration())
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("", displayMode: .inline)
        
    }
    
}

struct NavigationConfiguration: UIViewControllerRepresentable {
    
init() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.shadowColor = .clear
        navBarAppearance.backgroundColor = .white
        UINavigationBar.appearance().standardAppearance = navBarAppearance
    }
    
func makeUIViewController(
        context: UIViewControllerRepresentableContext<NavigationConfiguration>
    ) -> UIViewController {
        UIViewController()
    }
    
func updateUIViewController(_ uiViewController: UIViewController,
                                context: UIViewControllerRepresentableContext<NavigationConfiguration>) {}
    
}

extension UINavigationController{
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
}

struct LoadingProgressView: View {
    @State private var isLoading = true
    
    var body: some View {
        ZStack(alignment:.center ) {
            Color.clear
                .ignoresSafeArea(.all)
                .opacity(0.1)

        ZStack(alignment: .center) {
            VStack {
                Spacer()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                    .scaleEffect(2.0, anchor: .center)
                    .foregroundStyle(.white)
                    .colorMultiply(.white)
                    .padding(.all,10)
                Spacer()
                Text("Cargando...")
                    .foregroundStyle(.white)
                    .colorMultiply(.white)
                    .font(.system(size: 20, weight: .bold))
                    .padding(.all,10)
                Spacer()
            }
            .frame(width: 150, height: 120, alignment: .center)
            // Optional: make it bigger
        }
        .padding(.all,10)
        .background(Color.black.opacity(0.8))
        .cornerRadius(10)
        .shadow(radius: 2)
            .onAppear {
                startAnimating()
            }
        }.background(BackgroundGrayView())
    }
    
    func startAnimating() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(Animation.linear(duration: 1.5).repeatForever()) {
                isLoading = true
            }
        }
    }
    
}


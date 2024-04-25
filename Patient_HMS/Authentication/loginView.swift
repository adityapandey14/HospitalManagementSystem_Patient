//
//  loginView.swift
//  Patient_HMS
//
//  Created by Aditya Pandey on 21/04/24.
//

import SwiftUI
import FirebaseAuth

struct loginView: View {
    
    @State private var email = ""
    @State private var password = ""

    @EnvironmentObject var viewModel : AuthViewModel
    
   
    var body: some View {
        NavigationView{
            VStack{
                VStack{
//                    VStack(alignment: .leading){
//                        Text("MEDNEX")
//                            .fontWeight(.bold)
//                            .font(.system(size: 70).weight(.bold))
//                            .fontDesign(.rounded)
//                            .foregroundColor(.midNightExpress)
//                    }
//                    .padding()
                    
                    //login and signup option
//                    HStack{
//                        VStack(alignment: .leading) {
//                            Text("Welcome back")
//                                .font(.system(size: 30).weight(.bold))
//                            Text("Enter your Credentials to log in")
//                        }
//                        Spacer()
////                        VStack{
////                            NavigationLink(destination: signUpView()){
////                                Text("Sign up")
////                                    .font(AppFont.mediumSemiBold)
////                                    .foregroundColor(.gray)
////                            }
////                            Rectangle()
////                                .frame(width: 100, height: 3)
////                                .foregroundStyle(Color.clear)
////                        }
//                    }
//                    .padding(.horizontal, 50)
//                    .offset(y: 130)
                    
                    //login details
                    VStack{
                        VStack(alignment: .leading){
                            VStack(alignment: .leading) {
                                Text("Welcome back")
                                    .font(.system(size: 30).weight(.light))
                                Text("Enter your Credentials to log in")
                                    .font(.system(size: 17).weight(.light))
                            }
                            .padding(10)
//                            Text("Email address")
//                                .font(AppFont.mediumReg)
//                                .padding(.leading, 10)
                            TextField("Email address", text: $email)
                                .autocapitalization(.none)
                                .textFieldStyle(.plain)
                                .cornerRadius(8)
                                .padding(10)
                                .underlineTextField()
                        }
                        .listRowBackground(Color.clear)
                        VStack(alignment: .leading){
//                            Text("Password")
//                                .font(AppFont.mediumReg)
//                                .padding(.leading, 10)
                            SecureField("Password", text: $password)
                                .cornerRadius(8)
                                .padding(10)
                                .underlineTextField()
                        }
                        .padding(.top)
                    }
                    .padding(.top, 20)
                    .listStyle(PlainListStyle())
                    
                    
                    VStack(alignment: .trailing){
                        Text("Forgot Password?")
                            .foregroundColor(.midNightExpress)
                            .padding(.leading,170)
                    }
                    
                    //button
                    Button {
                        Task {
                            try await viewModel.signIn(withEmail: email, password: password)
                            print("Button clicked")
                        }
                        
                    } label :{
                        
                        Text("Login")
                            .foregroundColor(.buttonForeground)
                            .frame(width: 325, height: 50)
                            .background(Color.midNightExpress)
                            .cornerRadius(10)
                    }
                    .frame(width: 325, height: 50)
                    .background(Color.midNightExpress)
                    .cornerRadius(10)
                    .disabled(!FormIsValid)
                    .opacity(FormIsValid ? 1.0 : 0.5)
                }
                
                HStack{
                    Text("Don’t have an account?")
                        .foregroundColor(.gray)
                        .padding(.top)
                    
                    NavigationLink(destination: signUpView()){
                        Text("Register")
                            .foregroundColor(.asparagus)
                            .padding(.top)
                    }
                }
                Spacer()
            }
            .padding()
            .background(Color.solitude)
            //          .environment(\.colorScheme, .dark)
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    loginView()
}

extension loginView: AuthenticationFormProtocol {
    var FormIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
    }
}
    
extension View {
    func underlineTextField() -> some View {
        self
            .padding(.vertical, 10)
            .overlay(Rectangle().frame(height: 2).padding(.top, 35))
            .foregroundColor(.gray)
            .padding(5)
    }
}

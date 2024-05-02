//
//  TodayMeds.swift
//  Patient_HMS
//
//  Created by admin on 02/05/24.
//

import SwiftUI
struct TodayMeds: View {
    
//    @State private var searchTerm = "Search"
    @State private var searchText = ""
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(hex: "e8f2fd"), Color(hex: "ffffff")]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Today's Medicines")
                        .bold()
//                        .offset(x: -50, y: -270)
                        .padding(.trailing, 90)
                        .font(.system(size: 28))
                    
                    HStack {
                        HStack {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .padding(.leading, 7)
                                TextField("Search doctor", text: $searchText)
                                    .cornerRadius(10)
                                    .padding(10)
                                    .padding(.leading)
                                    .background(Color.elavated)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .frame(maxWidth: .infinity)
                                //                                    .cornerRadius(8)
                                
                                Button(action: {
                                    searchText = ""
                                }) {
                                    Text("Clear")
                                }
                                .padding(.trailing, 9)
                            }
                            .frame(height: 50)
                            .background(Color.white)
                            .foregroundColor(Color.gray)
                            .padding(20)
                            .frame(width: 340)
                            //                            .cornerRadius(10)
                            //                        .offset(x: -1, y: -270)
                        }
                        
                        Button {
                            
                        } label : {
                            Image(systemName: "plus.circle")
                                .foregroundColor(Color.black)
                        }
//                        .offset(x: -15, y: -270)
//                        .padding(.trailing)
                    }
                    ZStack {
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 330, height: 60)
                            .cornerRadius(10)
//                            .offset(y: -220)
                        HStack {
                            HStack {
                                Image(systemName: "pill.fill")
                                Text("Zincovit CL")
                                //                                .offset(x: 40)
                            }
                            NavigationLink(destination: MedicineDetail()) {
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color.black)
                                //                                    .offset(x: 160)
                                    .padding(.leading, 150)
                            }
                            
                        }
//                        .offset(x: -80, y: -220)
                    }
                    ZStack {
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 330, height: 60)
                            .cornerRadius(10)
//                            .offset(y: -220)
                        HStack {
                            HStack {
                                Image(systemName: "pill.fill")
                                //                                .offset(x: -7)
                                Text("Dolo 650")
                                //                                .offset(x: 32)
                            }
                            NavigationLink(destination: MedicineDetail()) {
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color.black)
                                //                                    .offset(x: 168)
                                    .padding(.leading, 170)
                            }
                            
                        }
//                        .offset(x: -80, y: -220)
                    }
//                    .offset(y: 10)

                }
//                .offset(y: 80)
                .padding(.bottom, 350)
            }
        }
    }
}


#Preview {
    TodayMeds()
}

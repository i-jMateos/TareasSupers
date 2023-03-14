//
//  EjemploSwiftUIView.swift
//  TodoListJordi
//
//  Created by Jordi Mateos on 23/11/22.
//

import SwiftUI

struct EjemploSwiftUIView: View {
    
    var body: some View {
        
        VStack {
            Text("Hello, World!")
                .font(.title)
                .multilineTextAlignment(.center)
            //                .bold()
                .padding()
                .border(Color.primary, width: 5)
                .fontWeight(.black)
                .foregroundColor(.mint)
            Spacer()
            Text("Hola Jordi")
                .shadow(radius: 10)
            
            Image(systemName: "sun.max")
                .font(.title)
                .bold()
            
            ZStack {
                Rectangle()
                //                    .stroke(lineWidth: 5)
                    .fill(.red)
                
                Circle()
                    .frame(width: 120, height: 120)
                
            }
        }
        .frame(width: 300, height: 200)
        
        
    }
}


struct EjemploSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        EjemploSwiftUIView()
    }
}

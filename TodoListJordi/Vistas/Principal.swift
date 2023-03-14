//
//  Principal.swift
//  TodoListJordi
//
//  Created by Jordi Mateos on 12/12/22.
//

import SwiftUI

struct Principal: View {
    var body: some View {
        
        TabView {
            ListasView()
                .tabItem {
                    Label("Tiendas", systemImage: "cart.fill")
                }
            
            UrgentesView()
                .tabItem {
                    Label("Urgente", systemImage: "exclamationmark.triangle.fill")
                }
        }
        .tint(.black)

        // Comprobamos si es la primera ejecución, para crear las tiendas por defecto
        .onAppear {
            comprobarPrimeraEjecucion()
        }
    }
}

struct Principal_Previews: PreviewProvider {
    static var previews: some View {
        Principal()
    }
}

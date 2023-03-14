//
//  ItemUrgenteRow.swift
//  TodoListJordi
//
//  Created by Jordi Mateos on 12/12/22.
//

import SwiftUI

extension Image {
    
    func formatearIcono() -> some View {
        self
            .resizable()
            .scaledToFit()
            .frame(width: 50, height: 50)
    }
    
}

struct ItemUrgenteRow: View {
    
    @State var item: Item
    
    var tienda: Lista? {
        item.lista
    }
    
    var body: some View {
        
        NavigationLink(destination: {
            
            ItemDetallesView(item: item)
            
        }, label: {
            HStack {
                
                if let imagen = tienda?.uiImagen {
                    Image(uiImage: imagen)
                        .formatearIcono()
                    
                } else {
                    
                    Image(systemName: "cart.fill")
                        .formatearIcono()
                }
                
                
                
                VStack(alignment: .leading) {
                    
                    Text(item.titulo ?? "")
                    
                    Text(tienda?.nombre ?? "")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    
                }
                
                Spacer()
                if let fecha = item.fechaLimite {
                    Text(fecha, style: .date)
                }
            }
            // MARK: SwipeActions
            .swipeActions(edge: .leading) {
                
                Button {
                    withAnimation {
                        item.cambiarEstado()
                    }
                    
                } label: {
                    Label("Completado", systemImage: "checkmark.circle.fill")

                }
                .tint(.green)
                
                
            }
        })
    }
}



struct ItemUrgenteRow_Previews: PreviewProvider {
    static var previews: some View {
        ItemUrgenteRow(item: itemEjemplo)
    }
}

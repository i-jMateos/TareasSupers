//
//  ListaRowView.swift
//  TodoListJordi
//
//  Created by Jordi Mateos on 23/11/22.
//

import SwiftUI

struct ListaRowView: View {
    
    @ObservedObject var lista: Lista
    
    @FetchRequest(sortDescriptors: [])
    var itemsSinCompletar:FetchedResults<Item>
    
    init(lista: Lista) {
        
        self.lista = lista
        
        _itemsSinCompletar = FetchRequest<Item>(
            sortDescriptors: [], predicate: NSPredicate(format:"lista = %@ AND completado == NO" , lista)
        )
    }
    
    var body: some View {
        HStack {
            
            if let imagen =  lista.uiImagen {
                
                Image(uiImage: imagen)
                    .formatearIcono()
                
            } else {
                
                Image(systemName: "cart.fill")
                    .formatearIcono()
            }
//            Image("lista")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 30)
            
            VStack(alignment: .leading) {
                
                Text(lista.nombre ?? "-")
                    .bold()
                
                // Sólo mostramos la descripción si existe
                if let descripcion = lista.descripcion, !descripcion.isEmpty {
                    
                    Text(descripcion)
                        .font(.footnote)
                }
            }
            Spacer()
        }
        .badge(itemsSinCompletar.count)
    }
}

// MARK: - Preview
struct ListaRowView_Previews: PreviewProvider {
    
//    static func listaEjemplo() -> Lista {
//        let lista = Lista(context: PersistenceController.preview.container.viewContext)
//        lista.nombre = "Lista de la compra"
//        lista.descripcion = "Cosas a comprar"
//
//        return lista
//    }
    
    static var previews: some View {

        ListaRowView(lista: listaEjemplo)
            .previewLayout(.sizeThatFits)
//            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

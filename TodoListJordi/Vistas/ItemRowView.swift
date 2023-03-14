//
//  ItemRowView.swift
//  TodoListJordi
//
//  Created by Jordi Mateos on 24/11/22.
//

import SwiftUI

struct ItemRowView: View {
    
    // MARK: ViewContext
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject var item: Item
    
    @State var mostrarSheetDetalles = false
    
    // MARK: Body
    var body: some View {
        
//        Button {
//            withAnimation {
//                mostrarSheetDetalles.toggle()
//            }
//
//        } label: {
//
//            HStack {
//                Image(systemName: item.completado ? "checkmark.circle.fill" : "circle")
//                    .foregroundColor(item.completado ? .green : .red)
//
//                Text(item.titulo ?? "-")
//                    .bold(item.completado ? false : true)
//                    .strikethrough(item.completado ? true : false)
//
//                Spacer()
//
//                if let fechaCreacion = item.fechaCreacion {
//                    Text(fechaCreacion, style: .date)
//                        .font(.footnote)
//                }
//            }
//        }
//        .listRowBackground(item.completado ? Color("naranjaApp") : Color.white)
    
        NavigationLink(destination: {
            
            ItemDetallesView(item: item)
            
        }, label: {
            
            HStack {
                Image(systemName: item.completado ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(item.completado ? .green : .red)
                
                Text(item.titulo ?? "-")
                    .bold(item.completado ? false : true)
                    .strikethrough(item.completado ? true : false)
                
                Spacer()
                
                if let fechaCreacion = item.fechaCreacion {
                    Text(fechaCreacion, style: .date)
                        .font(.footnote)
                }
                
                if item.importancia == Importancia.urgente.rawValue {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.yellow)
                    
                }
            }
        })
        
        // MARK: SwipeActions
        .swipeActions(edge: .leading) {
            
            Button {
                withAnimation {
                    item.cambiarEstado()
//                    cambiarEstadoItem(item: item)
                }
                
            } label: {
//                Text("Completar")
                if item.completado {
                    Label("No completado", systemImage: "circle")
                } else {
                    Label("Completado", systemImage: "checkmark.circle.fill")
                }
            }
            .tint(item.completado ? .yellow : .green)
            
            
        }
        
        // MARK: Sheet añadir
        .fullScreenCover(isPresented: $mostrarSheetDetalles) {
//        .sheet(isPresented: $mostrarSheetDetalles) {
            
            ItemDetallesView(item: item)
                .presentationDetents([.medium, .large])
        }
    }
    
    
}

// MARK: Preview
//struct ItemRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemRowView(item:)
//    }
//}

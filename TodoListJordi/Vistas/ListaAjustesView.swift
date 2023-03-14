//
//  ListaAjustesView.swift
//  TodoListJordi
//
//  Created by Jordi Mateos on 5/12/22.
//

import SwiftUI
import PhotosUI

struct ListaLocal {
    
    var nombre: String = ""
    var descripcion: String = ""

    var imagen: UIImage? = nil
}

struct ListaAjustesView: View {
    
    // MARK: Dismiss
    @Environment(\.dismiss) var dismiss
    
    // MARK: ViewContext
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject var lista: Lista
    
    @State var listaLocal: ListaLocal = ListaLocal()
    
    @State private var selectedItem: PhotosPickerItem? = nil
    
    var body: some View {
        
        NavigationStack {
            Form {
                Section("General") {
                    
                    
                    TextField("Nombre", text: $listaLocal.nombre)
                    
                    TextField("Notas", text: $listaLocal.descripcion, axis: .vertical)
                }
                
                Section("Imagen") {
                    HStack {
                        Spacer()
                        PhotosPicker(
                            selection: $selectedItem,
                            matching: .images,
                            photoLibrary: .shared()) {
                                Label("Escoge la imagen", systemImage: "photo.on.rectangle.angled")
                            }
                            .onChange(of: selectedItem) { newItem in
                                Task {
                                    
                                    // Retrieve selected asset in the form of Data
                                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                        
                                        listaLocal.imagen = imagenDesdeData(data: data)
                                        
                                    }
                                }
                            }
                        Spacer()
                    }
                    
                    if let imagen = listaLocal.imagen {
                        Image(uiImage: imagen)
                            .resizable()
                            .scaledToFit()
                    }
                    
                }
                
                
            }
            .toolbar {
                
                // MARK: Botón cancelar
                ToolbarItem(placement: .navigationBarLeading) {
                    
                    Button("Cancelar") {
                        dismiss()
                    }
                    .foregroundColor(.red)
                }
                
                // MARK: Botón guardar
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Button("Guardar") {
                        withAnimation {
                            guardarCambios()
                        }
                        dismiss()
                    }
                    
                    
                    
                    .bold()
                }
            }
        }
        .onAppear {
            cargarValores()
        }
    }
    
    func cargarValores() {
        
        listaLocal.nombre = lista.nombre ?? ""
        listaLocal.descripcion = lista.descripcion ?? ""
        
        listaLocal.imagen = lista.uiImagen
    }
    
    func guardarCambios() {
        
        lista.nombre = listaLocal.nombre
        lista.descripcion = listaLocal.descripcion

        
        lista.uiImagen = listaLocal.imagen

        
        if viewContext.hasChanges {
            try? viewContext.save()
        }
        
    }
}

struct ListaAjustesView_Previews: PreviewProvider {
    static var previews: some View {
        ListaAjustesView(lista: listaEjemplo)
    }
}

//
//  ItemDetallesView.swift
//  TodoListJordi
//
//  Created by Jordi Mateos on 24/11/22.
//

import SwiftUI
import PhotosUI

// MARK: - Extensión Binding
extension Binding {
    
    // https://stackoverflow.com/questions/68543882/cannot-convert-value-of-type-bindingstring-to-expected-argument-type-bindi
    
    
    func toUnwrapped<T>(_ defaultValue: T) -> Binding<T> where Value == Optional<T>  {
        
        Binding<T>(get: { self.wrappedValue ?? defaultValue },
                   set: { self.wrappedValue = $0 })
    }
}

struct ItemLocal {
    var titulo: String = ""
    var notas: String = ""
    var fechaCreacion: Date = Date()
    var fechaLimite: Date = Date()
    var completado = false
    var activarFechaLimite = false
    
    var importancia: String? = nil
    
    var imagen: UIImage? = nil
}

enum Importancia: String {
    case urgente = "Urgente ⚠️"
    case importante = "Importante"
    case pocoImportante = "Poco importante"
    case nadaImportante = "Nada importante"
    
    static var todosLosValores: [Importancia] {
        return [.urgente, .importante, .pocoImportante, .nadaImportante]
    }
}

struct ItemDetallesView: View {
    
    // MARK: Dismiss
    @Environment(\.dismiss) var dismiss
    
    // MARK: ViewContext
    @Environment(\.managedObjectContext) private var viewContext
    
    // Core Data
    @ObservedObject var item: Item
    
    // Local para el formulario
    @State var itemLocal: ItemLocal = ItemLocal()
    
    @State private var selectedItem: PhotosPickerItem? = nil

   
    
    // MARK: - Body
    var body: some View {
        
        NavigationStack {
            Form {
                
                Section("General") {
                    // Título
//                    HStack {
//                        Text("Título")
//                            .fontWeight(.light)
//                        Spacer()
                        TextField("Título", text: $itemLocal.titulo)
//                            .multilineTextAlignment(.trailing)
//                    }
                    
                    // Completado
//                    HStack {
//                        Text("Completado")
//                            .fontWeight(.light)
//                        Spacer()
                        Toggle("Completado", isOn: $itemLocal.completado)
//                    }
                    
                    // Notas
//                    HStack {
//                        Text("Notas")
//                            .fontWeight(.light)
//                        Spacer()
                        TextField("Notas", text: $itemLocal.notas, axis: .vertical)
//                            .lineLimit(3)
//                            .multilineTextAlignment(.trailing)
//                    }
                    
                    
                }
                
                // Fechas
                Section ("Fechas") {
                    
                    Toggle(isOn: $itemLocal.activarFechaLimite) {
                        Label("Fecha límite", systemImage: "calendar")
                            .fontWeight(.light)
                    }
                    
                    if itemLocal.activarFechaLimite {
//                    HStack {
//                        Text("Fecha límite")
//                            .fontWeight(.light)
//                        Spacer()
                    
                        DatePicker("Fecha límite", selection: $itemLocal.fechaLimite, in: Date()... , displayedComponents: .date)
                        //                    }
                    }
                }
                
                // Imagen
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
                                        
                                        itemLocal.imagen = imagenDesdeData(data: data)
                                        
                                    }
                                }
                            }
                        Spacer()
                    }
                    
                    if let imagen = itemLocal.imagen {
                        Image(uiImage: imagen)
                            .resizable()
                            .scaledToFit()
                    }

                }
                
                Section("Otros ajustes") {
                    
                    Picker(selection: $itemLocal.importancia) {
                        
                        Text("-")
                            .tag(nil as String?)
                        
                        ForEach(Importancia.todosLosValores, id:\.self) { importancia in
                            Text(importancia.rawValue)
                                .tag(importancia.rawValue as String?)
                        }
//                        ForEach(Importancia.todo, id:\.self) {
//
//                        }
                        
//                        Text("⚠️⚠️⚠️ Importante")
//                            .tag("Importante" as String?)
//                        Text("⚠️Poco importante")
//                            .tag("Poco importante" as String?)
//                        Text("Nada importante")
//                            .tag("Nada importante" as String?)
                        
                    } label: {
                        Label("Importancia", systemImage: "exclamationmark.triangle")
                    }
//                    .pickerStyle(.segmented)

                }
               
            }
            
            .onAppear {
                cargarValores()
            }
            
            .navigationBarBackButtonHidden(true)
            
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
        
    }
    
    func cargarValores() {
        
        itemLocal.titulo = item.titulo ?? ""
        itemLocal.notas = item.notas ?? ""
        itemLocal.fechaLimite = item.fechaLimite ?? Date()
        itemLocal.fechaCreacion = item.fechaCreacion ?? Date()
        itemLocal.completado = item.completado
        itemLocal.activarFechaLimite = item.activarFechaLimite
        itemLocal.importancia = item.importancia
        
        itemLocal.imagen = item.uiImagen
    }
    
    func guardarCambios() {
        
        item.titulo = itemLocal.titulo
        item.notas = itemLocal.notas
        item.fechaLimite = itemLocal.fechaLimite
        item.fechaCreacion = itemLocal.fechaCreacion
        item.completado = itemLocal.completado
        item.activarFechaLimite = itemLocal.activarFechaLimite
        item.importancia = itemLocal.importancia
        
        item.uiImagen = itemLocal.imagen
        
        if !item.activarFechaLimite {
            item.fechaLimite = Date()
        }
        
        if viewContext.hasChanges {
            try? viewContext.save()
        }
        
    }
}

// MARK: - Preview
struct ItemDetallesView_Previews: PreviewProvider {
    
    static var previews: some View {
        ItemDetallesView(item: itemEjemplo)
    }
}

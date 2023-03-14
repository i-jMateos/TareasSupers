//
//  ListaDetalleView.swift
//  TodoListJordi
//
//  Created by Jordi Mateos on 23/11/22.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct ListaDetalleView: View {
    
    // MARK: ViewContext
    @Environment(\.managedObjectContext) private var viewContext
    
    // MARK: FetchRequest
    @FetchRequest(sortDescriptors: [SortDescriptor(\.completado), SortDescriptor(\.titulo)])
    var itemsOrdenados: FetchedResults<Item>
    
    @State var mostrarAlertAñadir = false
    @State var mostrarSheetAjustes = false

    @State var tituloNuevoItem = ""
    
    @State var editMode: EditMode = .inactive
    @State  var showPhotoPicker = false
    @State var imagen: Data? = nil
    
    @State private var selectedItem: PhotosPickerItem? = nil

    
    // MARK: Propiedades
    @ObservedObject var listaTareas: Lista
    @State var itemSeleccionado: Item?
    
    init(listaTareas: Lista) {
        
        self.listaTareas = listaTareas
        
        _itemsOrdenados = FetchRequest<Item>(
            sortDescriptors: [SortDescriptor(\.completado), SortDescriptor(\.titulo)],
            predicate: NSPredicate(format: "lista == %@", listaTareas)
        )
    }
    
    // MARK: - Body
    fileprivate func imagenDeItem(_ data: Data?) -> Image {
        guard let data = data else {return  Image(systemName: "photo") }
        
        return Image(uiImage: UIImage(data: data)!)
    }
    
    var body: some View {
        
        Group {
            
            // MARK: No hay elementos
            if itemsOrdenados.count == 0 {
                VStack {
                    Button {
                        mostrarAlertAñadir.toggle()
                        
                    } label: {
                        Label("AÑADE ALGÚN ITEM PARA COMENZAR", systemImage: "plus.circle")
                            .padding()
                            .bold()
                            .frame(width: 300)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color("naranjaApp"))

                    Spacer()
                }
                .padding()

                
            } else {
                
                // MARK: Lista de items
                List {
                    ForEach(itemsOrdenados) { item in
                        
                        ItemRowView(item: item)
                        
                        
                    }
                    .onDelete { indices in
                        
                        for indice in indices {
                            
                            eliminarItem(item: itemsOrdenados[indice])
                        }
                        
                    }
                    
                    
                    
                }
                
                
                
            }
        }
        .navigationTitle(listaTareas.nombre ?? "")
        .listStyle(.inset)
        // MARK: Toolbar
        .toolbar {
            
            // MARK: Botón de ajustes
            Button {
                mostrarSheetAjustes.toggle()
                
            } label: {
                Label("Ajustes", systemImage: "gearshape.fill")
            }
            .fullScreenCover(isPresented: $mostrarSheetAjustes) {
                
                ListaAjustesView(lista: listaTareas)
            }

            
            // MARK: Botón de editar
//            if itemsOrdenados.count > 0 {
                EditButton()
                .disabled(itemsOrdenados.count == 0)
//            }
            
            if !editMode.isEditing {
                
                // MARK: Botón de añadir
                Button {
                    mostrarAlertAñadir = true
                    //                        añadirLista(nombre: "Prueba")
                    
                } label: {
                    Image(systemName: "plus")
                }
                .sheet(isPresented: $mostrarAlertAñadir, content: {
                    VStack {
                        HStack {
                            Button("Cancelar", role: .destructive, action: {
                                mostrarAlertAñadir.toggle()
                            })
                            Spacer()
                            Text("Nuevo item")
                            Spacer()
                            Button("Guardar", action: {
                                
                                withAnimation {
                                    añadirItem(imageData: imagen, titulo: tituloNuevoItem, lista: listaTareas)
                                    tituloNuevoItem = ""
                                    mostrarAlertAñadir.toggle()
                                }
                            })
                        }
                        Spacer()
                       
                        PhotosPicker(
                            selection: $selectedItem,
                            matching: .images,
                            photoLibrary: .shared()) {
                                imagenDeItem(imagen)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 200, height: 200)
                            }
                            .onChange(of: selectedItem) { newItem in
                                Task {
                                    
                                    // Retrieve selected asset in the form of Data
                                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                        
                                        self.imagen = data
                                        
                                    }
                                }
                            }
                       
                        TextField("Título", text: $tituloNuevoItem)
                            .textFieldStyle(.roundedBorder)
                        Spacer()

                    }
                    .padding()
                    
                    
                })
                
                // MARK: Alerta de Añadir
                                
                
                
            }
        }
        .environment(\.editMode, $editMode)
        
        
    }
    
    func añadirItem(imageData: Data?, titulo: String, lista: Lista) {
        
        let nuevoItem = Item(context: viewContext)
        nuevoItem.imagenData = imageData
        nuevoItem.titulo = titulo
        nuevoItem.lista = lista
        nuevoItem.fechaCreacion = Date()
        nuevoItem.completado = false
        
        if viewContext.hasChanges {
            try? viewContext.save()
        }
    }
    
    func eliminarItem(item: Item) {
        
        viewContext.delete(item)
        
        if viewContext.hasChanges {
            try? viewContext.save()
        }
        
    }
    
    
}

// MARK: - Preview
struct ListaDetalleView_Previews: PreviewProvider {
    
//    static func listaEjemplo() -> Lista {
//        let lista = Lista(context: PersistenceController.preview.container.viewContext)
//        lista.nombre = "Lista de la compra"
//        lista.descripcion = "Cosas a comprar"
//
////        let item = Item(context: PersistenceController.preview.container.viewContext)
////        item.lista = lista
////        item.titulo = "Leche"
////        item.notas = "Semidesnatada"
////
//        return lista
//    }
    
    static var previews: some View {
        
        NavigationStack {
            ListaDetalleView(listaTareas: listaEjemplo)
        }
    }
}

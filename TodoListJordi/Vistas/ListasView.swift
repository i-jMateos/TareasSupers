//
//  ListasView.swift
//  TodoListJordi
//
//  Created by Jordi Mateos on 23/11/22.
//

import SwiftUI

struct ListasView: View {
    
    // MARK: ViewContext
    @Environment(\.managedObjectContext) private var viewContext
    
    // MARK: FectchRequest
    @FetchRequest(sortDescriptors: [SortDescriptor(\.nombre)])
    var listasOrdenadas:FetchedResults<Lista>
    @FetchRequest(sortDescriptors: [])
    var items:FetchedResults<Item>
    
    @State var mostrarAlertAñadir = false
    
    @State var nombreNuevaLista = ""
    
    @State var editMode: EditMode = .inactive
    
    @State var searchText = ""
    @State var superFiltrados = [Lista]()
    
    init () {
             UINavigationBar.appearance().backgroundColor = .clear
            UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
           // UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.red]
        
    }
    
    // MARK: - Body
    var body: some View {
        
        NavigationStack {
            List {
                Section {
                    VStack (alignment: .center,spacing: 0){
                        Text("Importantes")
                            .padding([.horizontal, .top])
                            .font(.title)
                            .bold()
                            .frame(maxWidth:.infinity ,alignment: .leading)
                        
                        let itemsImportantes = items.filter({$0.importancia == "Importante"})
                        if !itemsImportantes.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(itemsImportantes) { item in
                                        NavigationLink {
                                            ItemDetallesView(item: item)
                                        } label: {
                                            VStack(alignment: .leading) {
                                                if let image = item.uiImagen {
                                                    Image(uiImage: image)
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 200, height: 170)
                                                        .cornerRadius(8)
                                                } else {
                                                    ZStack {
                                                        Image(systemName: "takeoutbag.and.cup.and.straw")
                                                            .resizable()
                                                            .scaledToFill()
                                                            .padding(64)
                                                            
                                                    }
                                                    .background(Color("customWhite"))
                                                    .frame(width: 200, height: 170)
                                                    .cornerRadius(8)
                                                    
                                                }
                                                
                                                Text( item.titulo!.isEmpty || item.titulo == nil ? "No hay titulo" : item.titulo!)
                                                Text((item.fechaCreacion?.formatted())!)
                                                    .fontWeight(.light)
                                                    .font(.system(size: 12))
                                            }
                                        }

                                    }
                                }
                                .padding()
                            }
                            
                        } else {
                            VStack {
                                Text("Aún no hay items importantes")
                                Text("Aqui aparecearán los items que seleccione como importantes al agregar compras a su tienda")
                                    .fontWeight(.light)
                                    .font(.system(size: 13))
                            }
                            .padding()
                            .background(Color("customWhite"))
                            .cornerRadius(8)
                            .frame(width: UIScreen.main.bounds.width-60, height: 200)
                            
                        }
                        
                    }
                    
                    if superFiltrados.isEmpty {
                        ForEach(listasOrdenadas) { listaTareas in
                            //                ForEach (Array(listasOrdenadas.enumerated()), id: \.1.id) { indice, lista in
                            
                            NavigationLink {
                                // Destino
                                ListaDetalleView(listaTareas: listaTareas)
                                
                                // Etiqueta
                            } label: {
                                ListaRowView(lista: listaTareas)
                            }
                            //                    .listRowBackground(indice % 2 == 0 ? Color.gray : Color.white)
                            
                        }
                        .onDelete { indices in
                            
                            for indice in indices {
                                
                                eliminarLista(lista: listasOrdenadas[indice])
                            }
                            
                        }
                        .padding(.horizontal)
                    } else {
                        ForEach(superFiltrados) { listaTareas in
                            //                ForEach (Array(listasOrdenadas.enumerated()), id: \.1.id) { indice, lista in
                            
                            NavigationLink {
                                // Destino
                                ListaDetalleView(listaTareas: listaTareas)
                                
                                // Etiqueta
                            } label: {
                                ListaRowView(lista: listaTareas)
                            }
                            //                    .listRowBackground(indice % 2 == 0 ? Color.gray : Color.white)
                            
                        }
                        .onDelete { indices in
                            
                            for indice in indices {
                                
                                eliminarLista(lista: listasOrdenadas[indice])
                            }
                            
                        }
                        .padding(.horizontal)
                    }
                    //                .onMove { origen, destino in
                    //
                    //                }
                    
                } header: {
                    ZStack(alignment: .bottom) {
                        Image("headerImage")
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width, height: 200)
                            .scaledToFill()
                            .cornerRadius(10)
                            .clipped()
                        
                        Rectangle().fill(LinearGradient(colors: [.black.opacity(0.5), .clear], startPoint: .top, endPoint: .bottom))
                        
                        HStack {
                            Image(systemName: "magnifyingglass")
                            TextField("Buscar supermercado", text: $searchText)
                                .scrollDismissesKeyboard(.automatic)
                                .onChange(of: searchText) { newValue in
                                    superFiltrados  = listasOrdenadas.filter({$0.nombre!.contains(newValue)})
                                }
                            if !searchText.isEmpty {
                                Button("Cancelar") {
                                    searchText = ""
                                }
                            }
                            
                        }
                        .padding(16)
                        .background(.white)
                        .cornerRadius(8)
                        
                        
                        
                    }
                }
                .listRowSeparatorTint(.clear)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                
            }
            .offset(y: -30)
            .ignoresSafeArea()
            .listStyle(.plain)
            .navigationTitle("Tiendas")
            .toolbar {
               
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    
                    // MARK: Botón de editar
                    if listasOrdenadas.count > 0 {
                        
                            EditButton()
                                .tint(.white)
                                .background(.black.opacity(0.5))
                                .cornerRadius(4)
                                .padding(4)
                        }
                       
                    
                    
                    if !editMode.isEditing {
                        
                        // MARK: Botón de añadir
                            Button {
                                mostrarAlertAñadir = true
                                //                        añadirLista(nombre: "Prueba")
                                
                            } label: {
                                Image(systemName: "plus")
                            }
                            .tint(.white)
                            .background(.black.opacity(0.5))
                            .cornerRadius(4)
                            .padding(4)
                        
                        Spacer(minLength: 4)
                        
                        // MARK: Alerta de Añadir
                        .alert("Nuevo supermercado", isPresented: $mostrarAlertAñadir) {
                            
                            TextField("Nombre", text: $nombreNuevaLista)
                            
                            Button("Cancel", role: .cancel, action: {})
                            
                            Button("Ok", role: .destructive, action: {
                                
                                withAnimation {
                                    añadirLista(nombre: nombreNuevaLista)
                                    nombreNuevaLista = ""
                                }
                            })
                        }
                    }
                }
            }
            .environment(\.editMode, $editMode)
        }
        
        
    }
    
    func añadirLista(nombre: String) {
        
        let nuevaLista = Lista(context: viewContext)
        nuevaLista.nombre = nombre
        
        if viewContext.hasChanges {
            try? viewContext.save()
        }
    }
    
    func eliminarLista(lista: Lista) {
        
        viewContext.delete(lista)
        
        if viewContext.hasChanges {
            try? viewContext.save()
        }
        
    }
    
}

// MARK: - Preview
struct ListasView_Previews: PreviewProvider {
    static var previews: some View {
        ListasView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

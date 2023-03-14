//
//  FuncionesAuxiliares.swift
//  TodoListJordi
//
//  Created by Jordi Mateos on 24/11/22.
//

import Foundation
import CoreData

import UIKit

var listaEjemplo: Lista {
    
    let context = PersistenceController.preview.container.viewContext
    
    let listaEjemplo = Lista(context: context)
    listaEjemplo.nombre = "Mercadona"
    listaEjemplo.uiImagen = UIImage(named: "logoMercadona")
    
    
    let item = Item(context: context)
    item.lista = listaEjemplo
    item.titulo = "Leche"
    item.fechaCreacion = Date()
    
    let item2 = Item(context: context)
    item2.lista = listaEjemplo
    item2.titulo = "Queso"
    item2.fechaCreacion = Date()
    
//    for tipo in TipoCampo.allCases {
//
//        _ = coleccionEjemplo.crearCampoNuevo(nombre: tipo.rawValue, tipo: tipo)
//
//        //        let campoEjemplo = Campo(context: context)
//        //        campoEjemplo.nombre = tipo.rawValue
//        //        campoEjemplo.tipoCampo = tipo
//        //        campoEjemplo.coleccion = coleccionEjemplo
//        //        campoEjemplo.orden = Int16(coleccionEjemplo.camposOrdenados().count)
//    }
//    for i in 1...5 {
//        let elemento = Elemento(context: context)
//        elemento.nombre = "Elemento \(i)"
//        elemento.coleccion = coleccionEjemplo
//    }
    
    return listaEjemplo
}

var itemEjemplo: Item {
    
    let viewContext = PersistenceController.preview.container.viewContext
    

    let item = Item(context: viewContext)
    
    item.titulo = "Leche"
    item.notas = "Semidesnatada en brick"
    item.fechaCreacion = Date()
    item.fechaLimite = Date().addingTimeInterval(100000) //Calendar.current.date(byAdding: DateComponents().day, to: Date())
    item.lista = listaEjemplo
    
    return item
}

// MARK: - Imágenes

func imagenDesdeData(data:Data?) -> UIImage? {
    
    if let imagenData = data, let imagen = UIImage(data: imagenData) {
        
        return imagen
        
    } else {
        return nil
    }
}

func imagenAData(imagen:UIImage?) -> Data? {
    
    if let imagen, let imagenData = imagen.pngData() {
        
        return imagenData
        
    } else {
        return nil
    }
}

func comprobarPrimeraEjecucion() {

    let primeraEjecucion = UserDefaults.standard.bool(forKey: "primeraEjecucion") as Bool

    if !primeraEjecucion {
        
        crearTiendasPorDefecto()
        
        UserDefaults.standard.set(true, forKey: "primeraEjecucion")
    }
}

func crearTiendasPorDefecto() {
    
    let context = PersistenceController.shared.container.viewContext
    
    let mercadona = Lista(context: context)
    mercadona.nombre = "Mercadona"
    mercadona.uiImagen = UIImage(named: "logoMercadona")
    
    let dia = Lista(context: context)
    dia.nombre = "Dia"
    dia.uiImagen = UIImage(named: "logoDia.svg")
    
    let spar = Lista(context: context)
    spar.nombre = "Spar"
    spar.uiImagen = UIImage(named: "logoSpar")
    
    let esclat = Lista(context: context)
    esclat.nombre = "Esclat"
    esclat.uiImagen = UIImage(named: "logoEsclat")

    try? context.save()

}

// MARK: - Extensión Item 
extension Item {
    
    var uiImagen:UIImage? {
        get {
            guard let imagen = imagenDesdeData(data: self.imagenData) else { return nil }
            
            return imagen
            
        } set (nuevaImagen) {
            imagenData = imagenAData(imagen: nuevaImagen)
        }
    }
}


// MARK: - Extensión Lista
extension Lista {
    
    var uiImagen:UIImage? {
        get {
            guard let imagen = imagenDesdeData(data: self.imagenData) else { return nil }
            
            return imagen
            
        } set (nuevaImagen) {
            imagenData = imagenAData(imagen: nuevaImagen)
        }
    }
    
    var numItemsSinCompletar: Int {
        
        guard let viewContext = self.managedObjectContext else { return 0 }
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format:"lista = %@ AND completado == NO" , self)
        
        do {
            
            let itemsSinCompletar = try viewContext.fetch(request)
            
            return itemsSinCompletar.count
            
        } catch {
            return 0
        }
        
    }
}

// MARK: - Extensión Item
extension Item {
    
    // MARK: Cambiar estado item
    func cambiarEstado() {
        
        guard let viewContext = self.managedObjectContext else { return }
        
        self.completado.toggle()
        
        if viewContext.hasChanges {
            try? viewContext.save()
        }
    }
}

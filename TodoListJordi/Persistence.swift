//
//  Persistence.swift
//  TodoListJordi
//
//  Created by Jordi Mateos on 23/11/22.
//

import CoreData
import UIKit

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
//        for i in 1...2 {
//            let nuevaLista = Lista(context: viewContext)
//            nuevaLista.nombre = "Merca \(i)"
//            nuevaLista.descripcion = "Desjhgdshjgd shgd shj g"
//        }
        
        let mercadona = Lista(context: viewContext)
        mercadona.nombre = "Mercadona"
        mercadona.uiImagen = UIImage(named: "logoMercadona")
        
        let dia = Lista(context: viewContext)
        dia.nombre = "Dia"
        dia.uiImagen = UIImage(named: "logoDia")
        
        let spar = Lista(context: viewContext)
        spar.nombre = "Spar"
        spar.uiImagen = UIImage(named: "logoSpar")
        
        let esclat = Lista(context: viewContext)
        esclat.nombre = "Esclat"
        esclat.uiImagen = UIImage(named: "logoEsclat")
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "TodoListJordi")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}

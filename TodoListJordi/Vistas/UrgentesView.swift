//
//  UrgentesView.swift
//  TodoListJordi
//
//  Created by Jordi Mateos on 12/12/22.
//

import SwiftUI

struct UrgentesView: View {
    
    // MARK: ViewContext
    @Environment(\.managedObjectContext) private var viewContext
    
    // MARK: FetchRequest
    @FetchRequest(sortDescriptors: [SortDescriptor(\.fechaLimite), SortDescriptor(\.titulo)], predicate: NSPredicate(format: "importancia == 'Urgente ⚠️' AND completado == NO"))
    var itemsOrdenados: FetchedResults<Item>
    

    var body: some View {
        
        NavigationStack {
            
            List {
                ForEach(itemsOrdenados) { item in
                    ItemUrgenteRow(item: item)
                }
            }
            .listStyle(.inset)
            .navigationTitle("Urgente")
            
        }
    }
    

}



struct UrgentesView_Previews: PreviewProvider {
    static var previews: some View {
        UrgentesView()
    }
}

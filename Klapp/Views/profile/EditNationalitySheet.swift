//
//  EditNationalitySheet.swift
//  Klapp
//
//  Created by Alessio Millauro on 21/08/25.
//

import SwiftUI

struct EditNationalitySheet: View {
    
    @Binding var currentNationality: String
    var onSave: () -> Void
    var onCancel: () -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("update_nationality")) {
                    TextField("Nazionalità", text: $currentNationality)
                        .textInputAutocapitalization(.words)
                }
            }
            .navigationTitle("update_nationality")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annulla", action: onCancel)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Salva", action: onSave)
                        .bold()
                }
            }
        }
    }
}

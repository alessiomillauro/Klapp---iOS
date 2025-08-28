//
//  LoginView.swift
//  Klapp
//
//  Created by Alessio Millauro on 21/08/25.
//

import SwiftUICore
import SwiftUI

struct LoginView: View {
    @StateObject private var vm = LoginViewModel()
    @FocusState private var focusedField: Field?
    @State private var showPassword: Bool = false
    
    enum Field { case email, password }
    
    let onLoginSuccess: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer(minLength: 20)
            
            VStack(spacing: 8) {
                Image("LiyickyLogoWhite")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140, height: 140)
                Text("Accedi")
                    .font(.largeTitle.bold())
            }
            .padding(.top, 24)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Email").font(.caption).foregroundColor(.secondary)
                TextField("name@domain.com", text: $vm.email)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
                    .focused($focusedField, equals: .email)
                    .submitLabel(.next)
                    .onSubmit { focusedField = .password }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Password").font(.caption).foregroundColor(.secondary)
                HStack {
                    Group {
                        if showPassword {
                            TextField("••••••••", text: $vm.password)
                                .textContentType(.password)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                        } else {
                            SecureField("••••••••", text: $vm.password)
                                .textContentType(.password)
                        }
                    }
                    .focused($focusedField, equals: .password)
                    .submitLabel(.go)
                    .onSubmit { Task { await vm.signIn(email: vm.email, password: vm.password) } }
                    
                    Button {
                        withAnimation { showPassword.toggle() }
                    } label: {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
            }
            
            HStack {
                Toggle(isOn: $vm.rememberMe) {
                    Text("Ricordami")
                }
                .toggleStyle(SwitchToggleStyle(tint: .blue))
                
                Spacer()
                
                Button("Password dimenticata?") {
                    Task { await vm.resetPassword() }
                }
                .font(.footnote)
            }
            
            // Error / info
            if let msg = vm.errorMessage {
                Text(msg)
                    .font(.footnote)
                    .foregroundColor(msg.hasPrefix("✉️") ? .green : .red)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            // Pulsanti azione
            VStack(spacing: 12) {
                Button {
                    Task { await vm.signIn(email: vm.email, password: vm.password) }
                } label: {
                    HStack {
                        if vm.isLoading { ProgressView() }
                        Text("Accedi")
                            .bold()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(vm.canSubmit ? Color.blue : Color.gray.opacity(0.4))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .disabled(!vm.canSubmit)
                
                Button {
                    Task { await vm.signUp() }
                } label: {
                    Text("Crea un account")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray5))
                        .foregroundColor(.primary)
                        .cornerRadius(12)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .background(Color(.systemBackground))
        .onChange(of: vm.didLogin) { logged in
            if loggedIn(logged) { onLoginSuccess() }
        }
    }
    
    private func loggedIn(_ flag: Bool) -> Bool {
        if flag { return true }
        return false
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView { }
            .preferredColorScheme(.light)
        LoginView { }
            .preferredColorScheme(.dark)
    }
}

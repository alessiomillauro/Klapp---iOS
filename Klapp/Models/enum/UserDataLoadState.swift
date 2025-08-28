//
//  UserDataLoadState.swift
//  Klapp
//
//  Created by Alessio Millauro on 21/08/25.
//

enum UserDataLoadState {
    case idle
    case loading
    case loaded(UserData?)
    case error(String)
}

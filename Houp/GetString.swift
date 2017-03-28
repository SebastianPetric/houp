//
//  GetString.swift
//  Houp
//
//  Created by Sebastian on 28.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import Foundation

enum GetString: String {
    case username = "Benutzername"
    case name = "Name"
    case prename = "Vorname"
    case email = "Email"
    case password = "Passwort"
    case birthday = "Geburtstag"
    case male = "Männlich"
    case female = "Weiblich"
    case repeatPassword = "Passwort wiederholen"
    case registrieren = "Registrieren"
    case login = "Login"
    case enterUsername = "Benutzername eingeben"
    case enterPassword = "Passwort eingeben"
    case appName = "Houp"
    
    //Icons
    
    case appLogoIcon = "logo_houp"
    case defaultProfileImage = "profile_default"
    case logoutIcon = "logout_icon"
    case createIcon = "create_icon"
    case moreIcon = "more_icon"
    case privateGroupBarIcon = "private_group_tab_bar"
    case publicGroupBarIcon = "public_group_tab_bar"
    case activityBarIcon = "activity_tab_bar"
    
    
    //Buttons
    case continueButton = "Weiter"
    case finishRegistrationButton = "Los gehts!"
    
    //Tabbar
    case tabBarPrivateGroup = "Private"
    case navBarPrivateGroup = "Deine Gruppen"
    case tabBarPublicGroup = "Öffentlich"
    case navBarPublicGroup = "Öffentliche Gruppe"
    case tabBarActivity = "Yin"
    case navBarActivity = "Yang"
    case tabBarSettings = "Mehr"
    case navBarSettings = "Einstellungen"
    
    
    //Error 
    
    case errorTitle = "Upps"
    case errorOKButton = "OK"
    case errorNoButton = "Nein"
    case errorFillAllFields = "Bitte alle Felder ausfüllen!"
    case errorFalseUsernamePassword = "Benutzername oder Passwort stimmt nicht! Bitte versuche es nochmal!"
    case errorUsernameAlreadyInUse = "Suche dir bitte einen anderen Nutzernamen. Dieser wird bereits verwendet."
    case errorWantProfileImage = "Willst du kein Profilbild machen?"
    case errorDifferentPasswords = "Passwörter stimmen nicht überein!"
    case errorEmailAlreadyExists = "Email Adresse wird bereits verwendet."
}

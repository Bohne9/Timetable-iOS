//
//  Language.swift
//  Timetable
//
//  Created by Jonah Schueller on 02.04.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import Foundation


enum LanguageType: String {
    
    case English = "English"
    case German = "German"
    
}

class LanguageElement: CustomStringConvertible, Equatable {
    static func ==(_ a: LanguageElement, _ b: LanguageElement) -> Bool{
        return a.description == b.description
    }
    static func ==(_ a: String, _ b: LanguageElement) -> Bool{
        return a == b.description
    }
    static func ==(_ a: LanguageElement, _ b: String) -> Bool{
        return a.description == b
    }
    var description: String
    var translations = [LanguageType:String]()
    
    init(_ description: String, translations: [LanguageType:String] = [LanguageType:String]()) {
        self.description = description.lowercased()
        self.translations = translations
    }
    
    func addTranslation(language: LanguageType, translation: String){
        translations[language] = translation
    }
    
    func setTranslation(translations: [LanguageType:String]){
        self.translations = translations
    }
    
    
    /**
     - parameters:
        - language: Translation language
     
       Returns the Translation for the given language
    */
    func getTranslation(language: LanguageType) -> String?{
        return translations[language]
    }
    
    
}

class Language {
    
    static func translate(_ descr: String) -> String {
        return shared.getTranslation(descr)
    }
    
    static var shared = Language()
    var language = LanguageType.English
    
    var translations = [LanguageElement]()
    
    init() {
//
//        if let lang = UserDefaults.standard.string(forKey: "language") {
//            self.language = LanguageType(rawValue: lang)!
//        }else {
//
//            UserDefaults.standard.set(language.rawValue, forKey: "language")
//        }
//
        language = preferedLanguage()
        
        loadTranslations()
    }
    
    
    func preferedLanguage() -> LanguageType {
        let lang = Locale.preferredLanguages[0].components(separatedBy: "-")[0]
        print("Prefered Language: \(lang)")
        
        if lang == "de" {
            return .German
        }
        return .English
    }
    
    
    func getTranslation(_ description: String) -> String {
        for element in translations {
            if element == description.lowercased() {
                return element.getTranslation(language: language)!
            }
        }
        print("Warning! Language description \(description) not found.")
        return "nil"
    }
    
    func loadTranslations(){
        // Syntax: <classname>_<element>
        // Example: LessonEditView_Delete
        
        translations.append(contentsOf: [
            // Day Translations
            LanguageElement("Day_Monday", translations: [.English : "Monday", .German : "Montag"]),
            LanguageElement("Day_Tuesday", translations: [.English : "Tuesday", .German : "Dienstag"]),
            LanguageElement("Day_Wednesday", translations: [.English : "Wednesday", .German : "Mittwoch"]),
            LanguageElement("Day_Thursday", translations: [.English : "Thursday", .German : "Donnerstag"]),
            LanguageElement("Day_Friday", translations: [.English : "Friday", .German : "Freitag"]),
            LanguageElement("Day_Saturday", translations: [.English : "Saturday", .German : "Samstag"]),
            LanguageElement("Day_Sunday", translations: [.English : "Sunday", .German : "Sonntag"]),
            
            // Lesson Control
            LanguageElement("Today", translations: [.English : "Today", .German : "Heute"]),
            LanguageElement("This week", translations: [.English : "This week", .German : "Diese Woche"]),
            LanguageElement("MoreThanAWeek", translations: [.English : "More than a week ago", .German : "Älter als eine Woche"]),
            
            LanguageElement("LessonControl_AddLesson", translations: [.English : "Add Lesson", .German : "Neuer Eintrag"]),
            
            // Add Lesson View
            LanguageElement("AddLesson_Lesson", translations: [.English : "Name", .German : "Name"]),
            LanguageElement("AddLesson_Teacher", translations: [.English : "Teacher Name", .German : "Lehrer Name"]),
            LanguageElement("AddLesson_Room", translations: [.English : "Room", .German : "Raum"]),
            LanguageElement("AddLesson_Start", translations: [.English : "Begin", .German : "Begin"]),
            LanguageElement("AddLesson_End", translations: [.English : "End", .German : "Ende"]),
            
            LanguageElement("ZeroWord", translations: [.English : "No", .German : "Keine"]),
            
            // Chat
            LanguageElement("Chat_NextLesson", translations: [.English : "Next lesson at", .German : "Nächste Stunde am"]),
            
            
            LanguageElement("Lesson", translations: [.English : "Course", .German : "Kurs"]),
            LanguageElement("Lessons", translations: [.English : "Courses", .German : "Kurse"]),
            
            LanguageElement("Task", translations: [.English : "Task", .German : "Aufgabe"]),
            LanguageElement("Tasks", translations: [.English : "Tasks", .German : "Aufgaben"]),
            
            LanguageElement("Chat", translations: [.English : "Chat", .German : "Chat"]),
            LanguageElement("Chats", translations: [.English : "Chats", .German : "Chats"]),
            
            LanguageElement("News", translations: [.English : "News", .German : "Neuigkeiten"]),
            
            LanguageElement("Material", translations: [.English : "Material", .German : "Materiale"]),
            LanguageElement("Materials", translations: [.English : "Materials", .German : "Materialien"]),
            
            
            // General terms
            LanguageElement("Add", translations: [.English : "Add", .German : "Hinzufügen"]),
            LanguageElement("Profile", translations: [.English : "Profile", .German : "Profil"]),
            LanguageElement("Cancel", translations: [.English : "Cancel", .German : "Abbrechen"]),
            LanguageElement("Yes", translations: [.English : "Yes", .German : "Ja"]),
            LanguageElement("Edit", translations: [.English : "Edit", .German : "Bearbeiten"]),
            LanguageElement("Save", translations: [.English : "Save", .German : "Fertig"]),
            LanguageElement("Delete", translations: [.English : "Delete", .German : "Löschen"]),
            LanguageElement("DeleteLesson", translations: [.English : "Delete Lesson", .German : "Eintrag entfernen"]),
            LanguageElement("Time", translations: [.English : "Time", .German : "Uhrzeit"]),
            LanguageElement("Done", translations: [.English : "Done", .German : "Fertig"]),
            // Questions
            LanguageElement("Confirm Delete", translations: [.English : "Are you shure you want to delete the lesson?", .German : "Bist du dir sicher, dass du den Eintrag löschen möchtest?"]),
            
            
            LanguageElement("UpdateAll", translations: [.English : "Update all lessons name?", .German : "Name für alle Eintrage ändern?"]),
            LanguageElement("ForAll", translations: [.English : "For all", .German : "Für alle"]),
            LanguageElement("ForThis", translations: [.English : "Only for this", .German : "Nur für diesen"]),
            
            
            LanguageElement("WhichLessonAdd", translations: [.English : "Which course do you want to add?", .German : "Welchen Kurs möchtest du hinzufügen?"]),
        ])
        
        
        
        
    }
    
    
    
}


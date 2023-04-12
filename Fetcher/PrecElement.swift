import SwiftUI
import SWXMLHash

class PrecJSON: Codable, Identifiable{
    var id: UUID?
    var precSerialNumber: String = ""
    var caseTitle: String = ""
    var caseNumber: String = ""
    var judgementDay: String = ""
    var judgement: String = ""
    var courtName: String = ""
    var courtSort: String = ""
    var caseSortName: String = ""
    var caseSortCord: String = ""
    var judgementSort: String = ""
    var holding: String = ""
    var summary: String = ""
    var refArticle: String = ""
    var refPrec: String = ""
    var contents: String = ""
    var starRank : Int = 0
    var date = Date()
    var update: String = ""
    var memo: String = ""
}

class PrecJSONCollection: Codable, Identifiable{
    var id: UUID?
    var name: String = ""
    var date = Date()
    var collection = [PrecJSON]()
    var undeletable = false
}

class PrecJSONList: Codable, Identifiable{
    var id: UUID?
    var userID: String = ""
    var precList = [PrecJSON]()
    var date = Date()
}

class PrecDetail: ObservableObject, Identifiable{
    @Published var id: UUID?
    @Published var precSerialNumber: String?
    @Published var caseTitle: String?
    @Published var caseNumber: String?
    @Published var judgementDay: String?
    @Published var judgement: String?
    @Published var courtName: String?
    @Published var courtSort: String?
    @Published var caseSortName: String?
    @Published var caseSortCord: String?
    @Published var judgementSort: String?
    @Published var holding: String?
    @Published var summary: String?
    @Published var refArticle: String?
    @Published var refPrec: String?
    @Published var contents: String?
    @Published var starRank : Int
    @Published var date: Date?
    @Published var update: String?
    @Published var memo: String?    
    
    init(){
        self.id = UUID()
        self.precSerialNumber = ""
        self.caseTitle = ""
        self.caseNumber = ""
        self.judgementDay = ""
        self.judgement = ""
        self.courtName = ""
        self.courtSort = ""
        self.caseSortName = ""
        self.caseSortCord = ""
        self.judgementSort = ""
        self.holding = ""
        self.summary = ""
        self.refArticle = ""
        self.refPrec = ""
        self.contents = ""
        self.starRank = 0
        self.date = Date()
        self.update = ""
        self.memo = ""
        
    }
}

class Prec: ObservableObject, Identifiable {
    @Published var id: UUID?
    @Published var precSerialNumber: String?
    @Published var caseTitle: String?
    @Published var caseNumber: String?
    @Published var judgementDay: String?
    @Published var court: String?
    @Published var caseSort: String?
    @Published var judgement: String?
    @Published var detailLink: String?
    @Published var starRank : Int
    @Published var date: Date?
    @Published var update: String?
    @Published var memo: String?
    
    init(){
        self.id = UUID()
        self.precSerialNumber = ""
        self.caseTitle = ""
        self.caseNumber = ""
        self.judgementDay = ""
        self.court = ""
        self.caseSort = ""
        self.judgement = ""
        self.detailLink = ""
        
        self.starRank = 0
        self.date = Date()
        self.update = ""
        self.memo = ""
    }//:init
}//:class

class PrecCollection: ObservableObject, Identifiable{
    @Published var id = UUID()
    @Published var name = String()
    @Published var collection = [Prec]()
}

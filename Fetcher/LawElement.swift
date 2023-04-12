import SwiftUI
import SWXMLHash

class fontStyle: ObservableObject{
    @Published var font = ""
    @Published var fontSize = 17
}

class JSON: Codable, Identifiable{
    var lawKey:String = "" //<법령 법령키="0107192021051818146">
    //<기본정보>
    var lawID: String = "" //법령ID
    
    var promulgationDate: String = "" //<공포일자>20210518</공포일자>
    var promulgationNum: String = "" //<공포번호>18146</공포번호>
    
    var language: String = "" //<언어>한글</언어>
    
    var lawSort: String = "" //<법종구분 법종구분코드="A0002">법률</법종구분>
    var lawSortCord: String = "" //<법종구분 법종구분코드="A0002">법률</법종구분>
    
    var lawName: String = "" //<법령명_한글>
    var lawNameChangeOrNot: String = "" //<제명변경여부>N</제명변경여부>
    
    
    var lawEffectiveDate: String = "" //<시행일자>20210518</시행일자>
    var revision: String = "" //<제개정구분>일부개정</제개정구분>
    
    var promulgatedOrNot: String = "" //<공포법령여부>Y</공포법령여부>
    
    //<조문>
    var articleKey: String = "" //조문단위 조문키
    var articleNum: String = "" //조문번호
    var articleBranchNum: String = "" //조문가지번호
    var articleOrNot: String = "" //조문여부
    
    var articleTitle: String = "" //<조문제목>정의</조문제목>
    var articleEnforcementDate: String = "" //<조문시행일자>20210518</조문시행일자>
    
    var articleMoveBefore: String = "" //<조문이동이전></조문이동이전>
    var articleMoveAfter: String = "" //<조문이동이후></조문이동이후>
    var articleChangeOrNot: String = "" //<조문변경여부>N</조문변경여부>
    
    var articleContent: String = "" //<조문내용>제2조(정의) 이 법에서 사용하는 용어의 정의는 다음과 같다
    
    var paraNum: String = "" //<항번호>①</항번호>
    var paraReviSort: String = "" //<항제개정유형>개정</항제개정유형>
    var paraReviString: String = "" //<항제개정일자문자열>2016.1.6, 2021.9.24</항제개정일자문자열>
    var paraContent: String = "" //<항내용>
    
    var subParaNum: String = "" //호    號    Subparagraph
    var subParaContent: String = "" //호    號    Subparagraph
    
    var itemNum: String = "" //목    目    Item
    var itemContent: String = "" //목    目    Item
    
    var part: String = "" //편    編    Part
    var chapter: String = "" //장    章    Chapter
    var section: String = "" //절    節    Section
    var subSection: String = "" //관    款    SubSection
    
    var generalProvisions: String = "" //총칙    總 則    General Provisions
    var commonProvisions: String = "" //통칙    通 則    Common Provisions
    
    var id: UUID?
    var index: Int = 0
    var name: String = ""
    var title: String = ""
    var article: String = ""
    
    //metaData
    var starRank: Int = 0
    var saveDate = Date()
    var memo: String = ""
}

class JSONCollection: Codable, Identifiable{
    var id: UUID?
    var name: String = ""
    var date = Date()
    var collection = [JSON]()
    var undeletable = false
}

class JSONLawList: Codable, Identifiable{
    var id: UUID?
    var userID: String = ""
    var lawList = [JSONCollection]()
    var date = Date()
}

class Article: ObservableObject, Identifiable {
    @Published var lawKey: String? //<법령 법령키="0107192021051818146">
    //<기본정보>
    @Published var lawID: String? //법령ID
    
    @Published var promulgationDate: String? //<공포일자>20210518</공포일자>
    @Published var promulgationNum: String? //<공포번호>18146</공포번호>
    
    @Published var language: String? //<언어>한글</언어>
    
    @Published var lawSort: String? //<법종구분 법종구분코드="A0002">법률</법종구분>
    @Published var lawSortCord: String? //<법종구분 법종구분코드="A0002">법률</법종구분>
    
    @Published var lawName: String? //<법령명_한글>
    @Published var lawNameChangeOrNot: String? //<제명변경여부>N</제명변경여부>
    
    
    @Published var lawEffectiveDate: String? //<시행일자>20210518</시행일자>
    
    @Published var revision: String? //<제개정구분>일부개정</제개정구분>
    
    @Published var promulgatedOrNot: String? //<공포법령여부>Y</공포법령여부>
    
    //<조문>
    @Published var articleKey: String? //조문단위 조문키
    @Published var articleNum: String? //조문번호
    @Published var articleBranchNum: String? //조문가지번호
    @Published var articleOrNot: String? //조문여부
    
    @Published var articleTitle: String? //<조문제목>정의</조문제목>
    @Published var articleEnforcementDate: String? //<조문시행일자>20210518</조문시행일자>
    
    @Published var articleMoveBefore: String? //<조문이동이전></조문이동이전>
    @Published var articleMoveAfter: String? //<조문이동이후></조문이동이후>
    @Published var articleChangeOrNot: String? //<조문변경여부>N</조문변경여부>
    
    @Published var articleContent: String? //<조문내용>제2조(정의) 이 법에서 사용하는 용어의 정의는 다음과 같다
    
    @Published var paraNum: String? //<항번호>①</항번호>
    @Published var paraReviSort: String? //<항제개정유형>개정</항제개정유형>
    @Published var paraReviString: String? //<항제개정일자문자열>2016.1.6, 2021.9.24</항제개정일자문자열>
    @Published var paraContent: String? //<항내용>
    
    @Published var subParaNum: String? //호    號    Subparagraph
    @Published var subParaContent: String? //호    號    Subparagraph
    
    @Published var itemNum: String? //목    目    Item
    @Published var itemContent: String? //목    目    Item
    
    @Published var part: String? //편    編    Part
    @Published var chapter: String? //장    章    Chapter
    @Published var section: String? //절    節    Section
    @Published var subSection: String? //관    款    SubSection
    
    @Published var generalProvisions: String? //총칙    總 則    General Provisions
    @Published var commonProvisions: String? //통칙    通 則    Common Provisions
    
    @Published var id: UUID?
    @Published var name: String?
    @Published var title: String?
    @Published var article: String?
    
    //metaData
    @Published var starRank: Int
    @Published var saveDate: Date
    @Published var memo: String?
//    @Published var saveDate: Date
//    @Published var update: String?
//    @Published var memo: String?
    
    init(){
        self.lawKey = "" //<법령 법령키="0107192021051818146">
        //<기본정보>
        self.lawID = "" //법령ID
        
        self.promulgationDate = "" //<공포일자>20210518</공포일자>
        self.promulgationNum = "" //<공포번호>18146</공포번호>
        
        self.language = "" //<언어>한글</언어>
        
        self.lawSort = "" //<법종구분 법종구분코드="A0002">법률</법종구분>
        self.lawSortCord = "" //<법종구분 법종구분코드="A0002">법률</법종구분>
        
        self.lawName = "" //<법령명_한글>
        self.lawNameChangeOrNot = "" //<제명변경여부>N</제명변경여부>
        
        self.lawEffectiveDate = "" //<시행일자>20210518</시행일자>
        
        self.revision = "" //<제개정구분>일부개정</제개정구분>
        
        self.promulgatedOrNot = "" //<공포법령여부>Y</공포법령여부>
        
        //<조문>
        self.articleKey = "" //조문단위 조문키
        self.articleNum = "" //조문번호
        self.articleBranchNum = "" //조문가지번호
        self.articleOrNot = "" //조문여부
        
        self.articleTitle = "" //<조문제목>정의</조문제목>
        self.articleEnforcementDate = "" //<조문시행일자>20210518</조문시행일자>
        
        self.articleMoveBefore = "" //<조문이동이전></조문이동이전>
        self.articleMoveAfter = "" //<조문이동이후></조문이동이후>
        self.articleChangeOrNot = "" //<조문변경여부>N</조문변경여부>
        
        self.articleContent = "" //<조문내용>제2조(정의) 이 법에서 사용하는 용어의 정의는 다음과 같다
        
        self.articleChangeOrNot = "" //<조문변경여부>N</조문변경여부>
        
        self.paraNum = "" //<항번호>①</항번호>
        self.paraReviSort = "" //<항제개정유형>개정</항제개정유형>
        self.paraReviString = "" //<항제개정일자문자열>2016.1.6, 2021.9.24</항제개정일자문자열>
        self.paraContent = "" //<항내용>
        
        self.subParaNum = "" //호    號    Subparagraph
        self.subParaContent = "" //호    號    Subparagraph
        
        self.itemNum = "" //목    目    Item
        self.itemContent = "" //목    目    Item
        
        self.part = "" //편    編    Part
        self.chapter = "" //장    章    Chapter
        self.section = "" //절    節    Section
        self.subSection = "" //관    款    SubSection
        self.generalProvisions = "" //총칙    總 則    General Provisions
        self.commonProvisions = "" //통칙    通 則    Common Provisions
        
        self.id = UUID()
        self.name = ""
        self.title = ""
        self.article = ""
        
        //metaData
        self.starRank = 0
        self.saveDate = Date()
        self.memo = ""
    }//:init
}//:class

class ArticleCollection: ObservableObject, Identifiable{
    @Published var id = UUID()
    @Published var name = String()
    @Published var collection = [Article]()
}

class MetaData: ObservableObject, Identifiable{
    @Published var id = UUID()
    @Published var name = String()
    @Published var collection = [Article]()
    
//    부칙공포일자    int    부칙공포일자
//    부칙공포번호    int    부칙공포번호
//    부칙내용    String    부칙내용
//    별표번호    int    별표번호
//    별표가지번호    int    별표가지번호
//    별표구분    String    별표구분
//    별표제목    String    별표제목
//    별표시행일자    int    별표시행일자
//    별표서식파일링크    String    별표서식파일링크
//    별표HWP파일명    String    별표 HWP 파일명
//    별표서식PDF파일링크    String    별표서식PDF파일링크
//    별표PDF파일명    String    별표 PDF 파일명
//    별표이미지파일명    String    별표 이미지 파일명
//    별표내용    String    별표내용
//    개정문내용    String    개정문내용
//    제개정이유내용    String    제개정이유내용
}

class ListItem: ObservableObject, Identifiable{
    @Published var id = UUID()
    @Published var Favorite : Bool
    @Published var JoHangHoString = String()
    
    init(Favorite: Bool, JoHangHoString: String) {
        self.Favorite = Favorite
        self.JoHangHoString = JoHangHoString
    }//:init
    
}//:class

class LawListItem: ObservableObject, Identifiable{
    @Published var id = UUID()
    @Published var Favorite : Bool
    @Published var ListText = String()
    
    init(Favorite: Bool, ListText: String) {
        self.Favorite = Favorite
        self.ListText = ListText
    }//:init
    
}//:class

struct JoMoon : Hashable, Identifiable, Codable {
    var id = UUID()
    var JoKey = String()
    var JoNumber = String()
    var JoMoonOrNot = String() 
    var JoBody = String()
    var HangNumber: [String?]
    var HangBody: [String?]
    var HoBody: [String?]
    var Favorite : Bool
    var JoHangHoString = String()
    
    static let defaultData = JoMoon(
        JoKey: "",
        JoNumber: "",
        JoMoonOrNot: "", 
        JoBody: "",
        HangNumber: [""],
        HangBody: [""],
        HoBody: [""],
        Favorite: false,
        JoHangHoString: ""
        )
}

struct JoMoonCollection: Hashable, Codable{
    //var id = UUID()
    var collection: [JoMoon]
}



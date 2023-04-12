import SwiftUI
import SWXMLHash
import Alamofire

//@MainActor
class LawDataCollectionFetcher: ObservableObject {
    @Published var lawsArray_LawCol = JoMoonCollection(collection: [JoMoon.defaultData])
    @Published var searchResultText = [LawListItem(Favorite: false, ListText: "")]
    @Published var lawArticles = [Article.init()]
    @Published var duplicateYN = false
    @Published var totalPagesCount = 0
    @Published var totalSearchCount = 0
    
    let urlLawString = "https://www.law.go.kr/DRF/lawService.do?OC=tagnshukma&target=law&type=XML"
    
    let urlLawSearchString =  "https://www.law.go.kr/DRF/lawSearch.do?OC=tagnshukma&target=law&type=XML&display=10"
    
    let urlPrecSearchString =
    "http://www.law.go.kr/DRF/lawSearch.do?OC=tagnshukma&target=prec&type=XML&display=3"
    
    enum FetchError: Error {
        case badRequest
        case badJSON
    }
    
    func saveJSONSearchHistory(data:[String]?) {
        let jsonEncoder = JSONEncoder()
        do {
            let encodedData = try jsonEncoder.encode(data)
            print(String(data: encodedData, encoding: .utf8)!)
            guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
            
            let fileURL = documentDirectoryUrl.appendingPathComponent("SearchHistory.json")
            do {
                try encodedData.write(to: fileURL)
                print("SearchHistory.json Saved by func.saveJSONSearchHistory")
            }
            catch let error as NSError {
                print(error)
            }
        } catch {
            print(error)
        }
    }
    
    func loadJSONSearchHistory() -> [String]? {
        let jsonDecoder = JSONDecoder()
        do {
            guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil}
            
            let fileURL = documentDirectoryUrl.appendingPathComponent("SearchHistory.json")
            
            let jsonData = try Data(contentsOf: fileURL, options: .mappedIfSafe)
            let decodedJson = try jsonDecoder.decode([String].self, from: jsonData)
            
            print("SearchHistory.json Loaded by func.loadJSONSearchHistory")
            
            return decodedJson
        }
        catch {
            print(error)
            return nil
        }
    }
    
    func saveJSONLawList(data:JSONLawList?) {
        let jsonEncoder = JSONEncoder()
        do {
            let encodedData = try jsonEncoder.encode(data)
            print(String(data: encodedData, encoding: .utf8)!)
            
            guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
            
            let fileURL = documentDirectoryUrl.appendingPathComponent("lawList.json")
            
            //guard let fileURL = Bundle.main.url(forResource: "lawList", withExtension: "json") else{return}
            
            do {
                try encodedData.write(to: fileURL)
                print("lawList.json Saved by func.saveJsonLawList")
            }
            catch let error as NSError {
                print(error)
            }
        } catch {
            print(error)
        }
    }
    
    func saveJSONCollection(lawName: String, data:JSONCollection) {
        let jsonEncoder = JSONEncoder()
        do {
            let encodedData = try jsonEncoder.encode(data)
            print(String(data: encodedData, encoding: .utf8)!)
            guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
            
            let fileURL = documentDirectoryUrl.appendingPathComponent("\(lawName)_JSONCollection.json")
            
            do {
                try encodedData.write(to: fileURL)
                print("\(lawName)_JSONCollection.json Saved by func.saveJsonCollectionData")
            }
            catch let error as NSError {
                print(error)
            }
        } catch {
            print(error)
        }
    }
    
    func saveJSON(lawName: String, data:[JSON]) {
        let jsonEncoder = JSONEncoder()
        do {
            let encodedData = try jsonEncoder.encode(data)
            print(String(data: encodedData, encoding: .utf8)!)
            guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
            
            let fileURL = documentDirectoryUrl.appendingPathComponent("\(lawName)_JSON.json")
            
            do {
                try encodedData.write(to: fileURL)
                print("\(lawName)_JSON.json Saved by func.saveJsonData")
            }
            catch let error as NSError {
                print(error)
            }
        } catch {
            print(error)
        }
    }
    
    func loadJSONLawList() -> JSONLawList? {
        let jsonDecoder = JSONDecoder()
        do {
            guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil}
            
            let fileURL = documentDirectoryUrl.appendingPathComponent("lawList.json")
            
            //guard let fileURL = Bundle.main.url(forResource: "lawList", withExtension: "json") else {return nil}
            
            let jsonData = try Data(contentsOf: fileURL, options: .mappedIfSafe)
            
            let decodedJsonLawList = try jsonDecoder.decode(JSONLawList.self, from: jsonData)
            
            print("lawList.json Loaded by func.loadJsonLawList")
            
            return decodedJsonLawList
        }
        catch {
            print(error)
            return nil
        }
    }
    
    func loadJSONCollection(lawName: String) -> JSONCollection? {
        let jsonDecoder = JSONDecoder()
        do {
            guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil}
            
            let fileURL = documentDirectoryUrl.appendingPathComponent("\(lawName)_JSONCollection.json")
            
            let jsonData = try Data(contentsOf: fileURL, options: .mappedIfSafe)
            let decodedJson = try jsonDecoder.decode(JSONCollection.self, from: jsonData)
            
            print("\(lawName)_JSONCollection.json Loaded by func.loadJSONCollection")
            
            return decodedJson
        }
        catch {
            print(error)
            return nil
        }
    }
    
    func loadJSON(lawName: String) -> [JSON]?{
        let jsonDecoder = JSONDecoder()
        do {
            guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil}
            
            let fileURL = documentDirectoryUrl.appendingPathComponent("\(lawName)_JSON.json")
            
            let jsonData = try Data(contentsOf: fileURL, options: .mappedIfSafe)
            
            let decodedJson = try jsonDecoder.decode([JSON].self, from: jsonData)
            
            print("\(lawName)_JSON.json Loaded by func.loadJSON")
            
            return decodedJson
        }
        catch {
            print(error)
            return nil
        }
    }
    
    func StringTrimming_Line(target: String?, line: String) -> String? {
        var trimmed_Line = target
        //var trimmed_Line2 : String?
        if line == "Y" || line == "y" {
            trimmed_Line = trimmed_Line?.replacingOccurrences(of: "\n", with: "", options: NSString.CompareOptions.literal, range: nil)
            trimmed_Line = trimmed_Line?.replacingOccurrences(of: " ①", with: "①", options: NSString.CompareOptions.literal, range: nil)
        }
        return trimmed_Line
    }
    
    func StringTrimming_Tab(target: String?, tab: String) -> String? {
        var trimmed_Tab = target
        if tab == "Y" || tab == "y" {
            trimmed_Tab = trimmed_Tab?.replacingOccurrences(of: "\t", with: " ", options: NSString.CompareOptions.literal, range: nil)
        }
        return trimmed_Tab
    }
    
    func StringTrimming_DoubleSpace(target: String?, DoubleSpace: String) -> String? {
        var trimmed_DS = target
        if DoubleSpace == "Y" || DoubleSpace == "y" {
            trimmed_DS = trimmed_DS?.replacingOccurrences(of: "  ", with: "", options: NSString.CompareOptions.literal, range: nil)
        }
        return trimmed_DS
    }
    
    func StringTrimming(target: String?, line: String, tab: String, doublespace: String) -> String? {
        let trimmed1 = StringTrimming_Line(target: target, line: line)
        let trimmed2 = StringTrimming_Tab(target: trimmed1, tab: tab)
        let trimmed3 = StringTrimming_DoubleSpace(target: trimmed2, DoubleSpace: doublespace)
        return trimmed3
    }
    
    //@available(iOS 15.0, *)
    
    func fetchSmall(keyword: String, completion: @escaping (Bool) -> Void) async
    throws{
        print("fetchSmall start")
        let parameters: Parameters = ["LM": keyword]
        AF.request(
            urlLawString,
            method: .get,
            parameters: parameters,
            encoding: URLEncoding.queryString)
        .validate()
        .responseString { response in
            switch response.result {
            case .success:
                let xml = XMLHash.config { config in
                    //config.shouldProcessLazily = true
                }.parse(response.value!)
                
                //print("xml : \(xml)")
                
                var indexnum = 0
                
                var partIndex = 1
                var partString = ""
                
                var chapterIndex = 1
                var chapterString = ""
                
                var sectionIndex = 1
                var sectionString = ""
                
                var subSecIndex = 1
                var subSecString = ""
                //XMLdata stored in Law struct 

                self.lawArticles.removeAll()
                
                for elem in xml["법령"]["조문"]["조문단위"].all {
                    
                    self.lawArticles.append(Article())
                    //print(elem)
                    self.lawArticles[indexnum].articleKey?.append(elem.element?.attribute(by: "조문키")?.text ?? "")
                    //print(self.lawArticles[indexnum].articleKey!)
                    
                    self.lawArticles[indexnum].articleNum?.append(elem["조문번호"].element?.text ?? "")
                    //print(self.lawArticles[indexnum].articleNum!)
                    
                    self.lawArticles[indexnum].articleBranchNum?.append(elem["조문가지번호"].element?.text ?? "")
                    
                    self.lawArticles[indexnum].articleOrNot?.append(elem["조문여부"].element?.text ?? "")
                    //print(self.lawArticles[indexnum].articleOrNot!)
                    
                    self.lawArticles[indexnum].articleTitle?.append(elem["조문제목"].element?.text ?? "")
                    
                    self.lawArticles[indexnum].articleEnforcementDate?.append(elem["조문시행일자"].element?.text ?? "")
                    //print(self.lawArticles[indexnum].articleEnforcementDate!)
                    
                    self.lawArticles[indexnum].articleMoveBefore?.append(elem["조문이동이전"].element?.text ?? "")
                    
                    self.lawArticles[indexnum].articleMoveAfter?.append(elem["조문이동이후"].element?.text ?? "")
                    
                    self.lawArticles[indexnum].articleContent?.append(elem["조문내용"].element?.text ?? "")
                    
                    let tempPart = "제"+"\(partIndex)"+"편"
                    let tempChapter = "제"+"\(chapterIndex)"+"장"
                    let tempSection = "제"+"\(sectionIndex)"+"절"
                    let tempSubSec = "제"+"\(subSecIndex)"+"관"
                    
                    if (elem["조문여부"].element!.text == "전문"){
                        if let JunMoon = elem["조문내용"].element?.text{
                            if JunMoon.contains(tempPart){
                                partString = self.StringTrimming(target: JunMoon, line: "Y", tab: "Y", doublespace: "Y") ?? ""
                                partIndex += 1
                                chapterString = ""
                                chapterIndex = 1
                                sectionString = ""
                                sectionIndex = 1
                                subSecString = ""
                                subSecIndex = 1
                            }
                            
                            if JunMoon.contains(tempChapter){
                                chapterString = self.StringTrimming(target: JunMoon, line: "Y", tab: "Y", doublespace: "Y") ?? ""
                                chapterIndex += 1
                                sectionString = ""
                                sectionIndex = 1
                                subSecString = ""
                                subSecIndex = 1
                            }
                            
                            if JunMoon.contains(tempSection){
                                sectionString = self.StringTrimming(target: JunMoon, line: "Y", tab: "Y", doublespace: "Y") ?? ""
                                sectionIndex += 1
                                subSecString = ""
                                subSecIndex = 1
                            }
                            
                            if JunMoon.contains(tempSubSec){
                                subSecString = self.StringTrimming(target: JunMoon, line: "Y", tab: "Y", doublespace: "Y") ?? ""
                                subSecIndex += 1
                            }
                            
                            if let trimmed_JoBodyString = self.StringTrimming(target: JunMoon, line: "N", tab: "Y", doublespace: "Y"){
                                self.lawArticles[indexnum].article?.append(trimmed_JoBodyString)
                            }
                        }//if let
                    }//if
                    
                    self.lawArticles[indexnum].part?.append(partString)
                    self.lawArticles[indexnum].chapter?.append(chapterString)
                    self.lawArticles[indexnum].section?.append(sectionString)
                    self.lawArticles[indexnum].subSection?.append(subSecString)
                    
                    print(self.lawArticles[indexnum].articleKey!)
                    
                    //print(self.lawArticles[indexnum].part)
                    //print(self.lawArticles[indexnum].chapter!)
                    //print(self.lawArticles[indexnum].section!)
                    //print(self.lawArticles[indexnum].subSection!)
                    
                    if elem["조문여부"].element!.text == "조문" {
                        
                        let JoNumber = elem["조문번호"].element?.text ?? ""
                        
                        let JoTitle0 = elem["조문제목"].element?.text ?? ""
                        
                        let JoBranch = elem["조문가지번호"].element?.text ?? ""
                        
                        let JoTitle1 = JoTitle0.replacingOccurrences(of: "(", with: "", options: NSString.CompareOptions.literal, range: nil)
                        
                        let JoTitle2 = JoTitle1.replacingOccurrences(of: ")", with: "", options: NSString.CompareOptions.literal, range: nil)
                        
                        let JoTitleComplete = "제" + JoNumber + "조" + "(" + JoTitle2 + ")"
                        
                        let JoTitleComplete2 = "제" + JoNumber + "조의" + JoBranch + "(" + JoTitle2 + ")"
                        
                        let trimmedJoBody_title = elem["조문내용"].element!.text.replacingOccurrences(of: JoTitleComplete, with: "", options: NSString.CompareOptions.literal, range: nil)
                        
                        let trimmedJoBody_title_withBranch = trimmedJoBody_title.replacingOccurrences(of: JoTitleComplete2, with: "", options: NSString.CompareOptions.literal, range: nil)
                        
                        let trimmedJoBody_line = self.StringTrimming(target: trimmedJoBody_title_withBranch, line: "Y", tab: "Y", doublespace: "Y")
                        
                        if JoBranch == ""{
                            self.lawArticles[indexnum].title?.append("제" + JoNumber + "조" + " (" + JoTitle2 + ")")
                        } else if JoBranch != ""{
                            self.lawArticles[indexnum].title?.append("제" + JoNumber + "조의" + JoBranch + " (" + JoTitle2 + ")")
                        }
                        
                        if JoTitle2 == "" {self.lawArticles[indexnum].title? = ""}
                        
                        if let JoBody = trimmedJoBody_line {
                            if JoBody != "" {
                                self.lawArticles[indexnum].article?.append(JoBody + "\n\n")
                            }
                        }
                        
                        for i in 0..<(elem["항"].children.count){
                            
                            let trimmedHangBody_line = self.StringTrimming(target: elem["항"][i]["항내용"].element?.text, line: "Y", tab: "Y", doublespace: "Y")
                            self.lawArticles[indexnum].paraNum?.append(elem["항"][i]["항번호"].element?.text ?? "")
                            self.lawArticles[indexnum].paraReviSort?.append(elem["항"][i]["항제개정유형"].element?.text ?? "")
                            self.lawArticles[indexnum].paraReviString?.append(elem["항"][i]["항제개정일자문자열"].element?.text ?? "")
                            self.lawArticles[indexnum].paraContent?.append(elem["항"][i]["항내용"].element?.text ?? "")
                                
                            if let HangBody = trimmedHangBody_line {
                                if HangBody != "" {
                                    self.lawArticles[indexnum].article?.append(HangBody+"\n\n")
                                }
                                
                            }
                            
                            for j in 0..<(elem["항"][i]["호"].children.count){
                                
                                self.lawArticles[indexnum].subParaNum?.append(elem["항"][i]["호"][j]["호번호"].element?.text ?? "")
                                
                                self.lawArticles[indexnum].subParaContent?.append(elem["항"][i]["호"][j]["호내용"].element?.text ?? "")
                                
                                if let trimmedHoBody_line = self.StringTrimming(target: elem["항"][i]["호"][j]["호내용"].element?.text, line: "Y", tab: "Y", doublespace: "Y") {
                                    if trimmedHoBody_line != "" {
                                        self.lawArticles[indexnum].article?.append("  " + trimmedHoBody_line + "\n\n")
                                    }
                                }
                                
                                for k in 0..<(elem["항"][i]["호"][j]["목"].children.count){
                                    
                                    self.lawArticles[indexnum].itemNum?.append(elem["항"][i]["호"][j]["목"][k]["목번호"].element?.text ?? "")
                                    
                                    self.lawArticles[indexnum].itemContent?.append(elem["항"][i]["호"][j]["목"][k]["목내용"].element?.text ?? "")
                                    
                                    let trimmedMokBody_line = self.StringTrimming(target: elem["항"][i]["호"][j]["목"][k]["목내용"].element?.text, line: "N", tab: "Y", doublespace: "Y")
                                            
                                    if let MokBody = trimmedMokBody_line {
                                        self.lawArticles[indexnum].article?.append("    " + MokBody + "\n\n")
                                        
                                    }
                                }//:for_k
                            }//:for_j
                        }//:for_i
                        
                    }
                    
                    self.lawArticles[indexnum].lawKey?.append(xml["법령"].element?.attribute(by: "법령키")?.text ?? "")
                    //print(self.lawArticles[num].lawKey)
                    
                    self.lawArticles[indexnum].promulgationDate?.append(xml["법령"]["기본정보"]["공포일자"].element?.text ?? "")
                    //print(self.lawArticles[num].promulgationDate!)
                    
                    self.lawArticles[indexnum].promulgationNum?.append(xml["법령"]["기본정보"]["공포번호"].element?.text ?? "")
                    //print(self.lawArticles[num].promulgationNum!)
                    
                    self.lawArticles[indexnum].language?.append(xml["법령"]["기본정보"]["언어"].element?.text ?? "")
                    //print(self.lawArticles[num].language!)
                    
                    self.lawArticles[indexnum].lawSort?.append(xml["법령"]["기본정보"]["법종구분"].element?.text ?? "")
                    //print(self.lawArticles[num].lawSort!)
                    
                    self.lawArticles[indexnum].lawSortCord?.append(xml["법령"]["기본정보"]["법종구분"].element?.attribute(by: "법종구분코드")?.text ?? "")
                    //print(self.lawArticles[num].lawSortCord!)
                    
                    self.lawArticles[indexnum].lawName?.append(xml["법령"]["기본정보"]["법령명_한글"].element?.text ?? "")
                    //print(self.lawArticles[num].lawName!)
                    
                    self.lawArticles[indexnum].lawNameChangeOrNot?.append(xml["법령"]["기본정보"]["제명변경여부"].element?.text ?? "")
                    //print(self.lawArticles[num].lawNameChangeOrNot!)
                    
                    self.lawArticles[indexnum].lawEffectiveDate?.append(xml["법령"]["기본정보"]["시행일자"].element?.text ?? "")
                    //print(self.lawArticles[num].lawEffectiveDate!)
                    
                    self.lawArticles[indexnum].revision?.append(xml["법령"]["기본정보"]["제개정구분"].element?.text ?? "")
                    //print(self.lawArticles[num].revision!)
                    
                    self.lawArticles[indexnum].promulgatedOrNot?.append(xml["법령"]["기본정보"]["공포법령여부"].element?.text ?? "")
                    //print(self.lawArticles[num].promulgatedOrNot!)
                    
                    self.lawArticles[indexnum].name = xml["법령"]["기본정보"]["법령명_한글"].element?.text ?? ""
                    
                    self.lawArticles[indexnum].starRank = 0
                    //print("starRank \(self.lawArticles[indexnum].starRank)")
                    
                    indexnum += 1
                    
                }//:for
                
//                for num in 0..<self.lawArticles.count {
//                    self.lawArticles[num].lawKey?.append(xml["법령"].element?.attribute(by: "법령키")?.text ?? "")
//                    //print(self.lawArticles[num].lawKey)
//                    
//                    self.lawArticles[num].promulgationDate?.append(xml["법령"]["기본정보"]["공포일자"].element?.text ?? "")
//                    //print(self.lawArticles[num].promulgationDate!)
//                    
//                    self.lawArticles[num].promulgationNum?.append(xml["법령"]["기본정보"]["공포번호"].element?.text ?? "")
//                    //print(self.lawArticles[num].promulgationNum!)
//                    
//                    self.lawArticles[num].language?.append(xml["법령"]["기본정보"]["언어"].element?.text ?? "")
//                    //print(self.lawArticles[num].language!)
//                    
//                    self.lawArticles[num].lawSort?.append(xml["법령"]["기본정보"]["법종구분"].element?.text ?? "")
//                    //print(self.lawArticles[num].lawSort!)
//                    
//                    self.lawArticles[num].lawSortCord?.append(xml["법령"]["기본정보"]["법종구분"].element?.attribute(by: "법종구분코드")?.text ?? "")
//                    //print(self.lawArticles[num].lawSortCord!)
//                    
//                    self.lawArticles[num].lawName?.append(xml["법령"]["기본정보"]["법령명_한글"].element?.text ?? "")
//                    //print(self.lawArticles[num].lawName!)
//                    
//                    self.lawArticles[num].lawNameChangeOrNot?.append(xml["법령"]["기본정보"]["제명변경여부"].element?.text ?? "")
//                    //print(self.lawArticles[num].lawNameChangeOrNot!)
//                    
//                    self.lawArticles[num].lawEffectiveDate?.append(xml["법령"]["기본정보"]["시행일자"].element?.text ?? "")
//                    //print(self.lawArticles[num].lawEffectiveDate!)
//                    
//                    self.lawArticles[num].revision?.append(xml["법령"]["기본정보"]["제개정구분"].element?.text ?? "")
//                    //print(self.lawArticles[num].revision!)
//                    
//                    self.lawArticles[num].promulgatedOrNot?.append(xml["법령"]["기본정보"]["공포법령여부"].element?.text ?? "")
//                    //print(self.lawArticles[num].promulgatedOrNot!)
//                    
//                    self.lawArticles[num].name = xml["법령"]["기본정보"]["법령명_한글"].element?.text ?? ""
//                }
                
                DispatchQueue.main.async {
                    completion(true)
                }
                
                print("fetchSmall done")

                return
                
                //return self.articles.collection
                
            case .failure(let err) :
                print(err.localizedDescription)
                
                return
            }//:switch
        }//response
    }
    
    func fetchLawListData(keyword: String, pages: String, completion: @escaping (Bool) -> Void) async
    throws {
        print("fetchLawListData start")
        let parameters: Parameters = [
            "query": keyword,
            "page": pages
        ]
        
        AF.request(urlLawSearchString,
                   method: .get,
                   parameters: parameters,
                   encoding: URLEncoding.queryString)
        .validate()
        .responseString { response in
            switch response.result {
            case.success:
                
                    let rawData = response.value
                    let xml = XMLHash.config { config in
                        //config.shouldProcessLazily = true
                    }.parse(rawData!)
                    
                    var idx = 0
                    
                let totalCnt = xml["LawSearch"]["totalCnt"].element!.text
                
                self.totalSearchCount = Int(totalCnt)!
                
                if let floatCnt = Float(totalCnt){
                    let ceilCnt = ceilf(floatCnt/10)
                    let intCnt = Int(ceilCnt)
                    self.totalPagesCount = intCnt
                }
                
                self.searchResultText.removeAll()
                for elem in xml["LawSearch"]["law"].all{

                        self.searchResultText.append(LawListItem(Favorite: false, ListText: ""))
                        
                        self.searchResultText[idx].ListText.append(elem["법령명한글"].element?.text ?? "")
                        idx += 1
                    }//:for
                DispatchQueue.main.async {
                    completion(true)
                }
                    print("fetchLawListData done")
                
                return
            case .failure(let err) :
                print(err.localizedDescription)
            }//:switch
        }
    }//:throws
    
    func fetchLawData(keyword: String) async
    throws {
        let parameters: Parameters = [
            "LM": keyword
        ]
        
        AF.request(urlLawString,
                   method: .get,
                   parameters: parameters,
                   encoding: URLEncoding.queryString)
        .validate()
        .responseString { response in
            switch response.result {
            case .success: // 성공
                let rawData = response.value
                let xml = XMLHash.config { config in
                    //config.shouldProcessLazily = true
                }.parse(rawData!)
                //print(xml)
                        
                var indexnum = 0
                //XMLdata stored in Law struct 
                        
                self.lawsArray_LawCol.collection.removeAll()
                
                for elem in xml["법령"]["조문"]["조문단위"].all {
                            
                    self.lawsArray_LawCol.collection.append(JoMoon.defaultData)
                            
                    self.lawsArray_LawCol.collection[indexnum].JoMoonOrNot.append(elem["조문여부"].element!.text)
                            
                    self.lawsArray_LawCol.collection[indexnum].JoNumber.append(elem["조문번호"].element!.text)
                            
                    self.lawsArray_LawCol.collection[indexnum].JoKey.append(elem.element?.attribute(by: "조문키")?.text ?? "")
                            
                    if self.lawsArray_LawCol.collection[indexnum].JoMoonOrNot == "조문" {
                                
                        let trimmedJoBody_line = self.StringTrimming(target: elem["조문내용"].element!.text, line: "N", tab: "Y", doublespace: "Y")
                                
                        self.lawsArray_LawCol.collection[indexnum].JoBody.append(trimmedJoBody_line!)
                                
                        self.lawsArray_LawCol.collection[indexnum].JoHangHoString.append(trimmedJoBody_line!)
                                
                        if (elem["항"].element?.text != "") {
                                    
                            for i in 0..<(elem["항"].children.count){
                                        
                                let trimmedHangBody_line = self.StringTrimming(target: elem["항"][i]["항내용"].element?.text, line: "N", tab: "Y", doublespace: "Y")
                                self.lawsArray_LawCol.collection[indexnum].HangBody.append(trimmedHangBody_line ?? "")
                                        
                                self.lawsArray_LawCol.collection[indexnum].JoHangHoString.append(trimmedHangBody_line ?? "")
                                        
                                if (elem["항"][i]["호"].element?.text != "") {
                                            
                                    for j in 0..<(elem["항"][i]["호"].children.count){
                                                
                                        let trimmedHoBody_line = self.StringTrimming(target: elem["항"][i]["호"][j]["호내용"].element?.text, line: "N", tab: "Y", doublespace: "Y")
                                                
                                        self.lawsArray_LawCol.collection[indexnum].HangBody.append(trimmedHoBody_line ?? "")
                                                
                                        self.lawsArray_LawCol.collection[indexnum].JoHangHoString.append(trimmedHoBody_line ?? "")
                                            
                                        for k in 0..<(elem["항"][i]["호"][j]["목"].children.count){
                                            
                                            let trimmedHoBody_line = self.StringTrimming(target: elem["항"][i]["호"][j]["목"][k]["목내용"].element?.text, line: "n", tab: "y", doublespace: "y")
                                            
                                            self.lawsArray_LawCol.collection[indexnum].HangBody.append(trimmedHoBody_line ?? "")
                                            
                                            self.lawsArray_LawCol.collection[indexnum].JoHangHoString.append("\n")
                                            
                                            self.lawsArray_LawCol.collection[indexnum].JoHangHoString.append(trimmedHoBody_line ?? "")
                                        }//:for_k
                                    }//:for_j
                                }//:if
                            }//:for_i
                        }//:if
                    } else if (self.lawsArray_LawCol.collection[indexnum].JoMoonOrNot == "전문"){
                                
                        let trimmed_JoHangHoString = self.StringTrimming(target: elem["조문내용"].element?.text, line: "n", tab: "y", doublespace: "y") 
                                
                        self.lawsArray_LawCol.collection[indexnum].JoBody.append(trimmed_JoHangHoString ?? "")
                                
                        self.lawsArray_LawCol.collection[indexnum].JoHangHoString.append(trimmed_JoHangHoString ?? "")
                                
                    }//:if,elseif
                            
                    indexnum += 1
                            
                }//:for
                        
                print("fetchLawData Done")
                return
                
            case .failure(let err) :
                    
                print(err.localizedDescription)
                
            }//:switch
        }//:responseString
    }
}

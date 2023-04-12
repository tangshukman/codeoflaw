import SwiftUI
import SWXMLHash
import Alamofire

//@MainActor
class PrecDataCollectionFetcher: ObservableObject {
    
    @Published var precSearchResult = [Prec.init()]
    @Published var precDetailResult = PrecDetail.init()
    @Published var duplicateYN = false
    @Published var totalPagesCount = 0
    @Published var totalSearchCount = 0
    
    let urlPrecSearchXML = "https://www.law.go.kr/DRF/lawSearch.do?OC=tagnshukma&target=prec&type=XML&mobileYn=N&display=10"
    
    let urlPrecDetailXML = "https://www.law.go.kr/DRF/lawService.do?OC=tagnshukma&target=prec&type=XML"
    
    enum FetchError: Error {
        case badRequest
        case badJSON
    }
    
    func saveJSONPrecHistory(data:[PrecJSON]?) {
        let jsonEncoder = JSONEncoder()
        do {
            let encodedData = try jsonEncoder.encode(data)
//            print(String(data: encodedData, encoding: .utf8)!)
            guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
            
            let fileURL = documentDirectoryUrl.appendingPathComponent("PrecHistory.json")
            do {
                try encodedData.write(to: fileURL)
                print("PrecHistory.json Saved by func.saveJSONPrecHistory")
            }
            catch let error as NSError {
                print(error)
            }
        } catch {
            print(error)
        }
    }
    
    func loadJSONPrecHistory() -> [PrecJSON]? {
        let jsonDecoder = JSONDecoder()
        do {
            guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil}
            
            let fileURL = documentDirectoryUrl.appendingPathComponent("PrecHistory.json")
            
            let jsonData = try Data(contentsOf: fileURL, options: .mappedIfSafe)
            let decodedJson = try jsonDecoder.decode([PrecJSON].self, from: jsonData)
            
            print("PrecHistory.json Loaded by func.loadJSONPrecHistory")
            
            return decodedJson
        }
        catch {
            print(error)
            return nil
        }
    }
    
    func savePrecJSONList(data:PrecJSONList?) {
        let jsonEncoder = JSONEncoder()
        do {
            let encodedData = try jsonEncoder.encode(data)
//            print(String(data: encodedData, encoding: .utf8)!)
            guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
            
            let fileURL = documentDirectoryUrl.appendingPathComponent("precJSONList.json")
            do {
                try encodedData.write(to: fileURL)
                print("precJSONList.json Saved by func.savePrecJSONList")
            }
            catch let error as NSError {
                print(error)
            }
        } catch {
            print(error)
        }
    }
    
    func loadPrecJSONList() -> PrecJSONList? {
        let jsonDecoder = JSONDecoder()
        do {
            guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil}
            
            let fileURL = documentDirectoryUrl.appendingPathComponent("precJSONList.json")
            
            let jsonData = try Data(contentsOf: fileURL, options: .mappedIfSafe)
            let decodedPrecJSONList = try jsonDecoder.decode(PrecJSONList.self, from: jsonData)
            
            print("precJSONList.json Loaded by func.loadPrecJSONList")
            
            return decodedPrecJSONList
        }
        catch {
            print(error)
            return nil
        }
    }
    
    func StringTrimming_numbers(target: String?) -> String? {
        var trimmed = target
        let gana: [String] = ["가","나","다","라","마","바","사","아","자","차","카","타","파","하"]
        
        trimmed = trimmed?.replacingOccurrences(of: "【검    사】", with: "【검 사】", options: NSString.CompareOptions.literal, range: nil)
        trimmed = trimmed?.replacingOccurrences(of: "【이    유】", with: "【이 유】", options: NSString.CompareOptions.literal, range: nil)
        trimmed = trimmed?.replacingOccurrences(of: "【주    문】", with: "【주 문】", options: NSString.CompareOptions.literal, range: nil)
        
        for i in 1...20 {
            trimmed = trimmed?.replacingOccurrences(of: " [\(i)]", with: "\n\n[\(i)]", options: NSString.CompareOptions.literal, range: nil)
            trimmed = trimmed?.replacingOccurrences(of: "  \(i).", with: "\n\n\(i).", options: NSString.CompareOptions.literal, range: nil)
            trimmed = trimmed?.replacingOccurrences(of: "  \(i).", with: "\n\n\(i).", options: NSString.CompareOptions.literal, range: nil)
            trimmed = trimmed?.replacingOccurrences(of: " (\(i))", with: "\n\n  (\(i))", options: NSString.CompareOptions.literal, range: nil)
            trimmed = trimmed?.replacingOccurrences(of: " \(i))", with: "\n\n  \(i))", options: NSString.CompareOptions.literal, range: nil)
        }
        
        for j in 0..<gana.count{
            trimmed = trimmed?.replacingOccurrences(of: "  \(gana[j]).", with: "\n\n \(gana[j]).", options: NSString.CompareOptions.literal, range: nil)
            trimmed = trimmed?.replacingOccurrences(of: "  (\(gana[j]))", with: "\n\n (\(gana[j]))", options: NSString.CompareOptions.literal, range: nil)
            trimmed = trimmed?.replacingOccurrences(of: "  \(gana[j]))", with: "\n\n \(gana[j]))", options: NSString.CompareOptions.literal, range: nil)
        }
        
        trimmed = trimmed?.replacingOccurrences(of: "  ", with: "\n ", options: NSString.CompareOptions.literal, range: nil)
        trimmed = trimmed?.replacingOccurrences(of: "[대법관", with: "\n\n[대법관", options: NSString.CompareOptions.literal, range: nil)
        trimmed = trimmed?.replacingOccurrences(of: "의견]", with: "의견]\n\n", options: NSString.CompareOptions.literal, range: nil)
        
        return trimmed
    }
    
    func StringTrimming(target: String?) -> String? {
        var trimmed = StringTrimming_numbers(target: target)
        trimmed = trimmed?.replacingOccurrences(of: "【", with: "\n\n【", options: NSString.CompareOptions.literal, range: nil)
        //trimmed = trimmed?.replacingOccurrences(of: "대법관 ", with: "\n\n대법관 ", options: NSString.CompareOptions.literal, range: nil)
        return trimmed
    }
    
    //@available(iOS 15.0, *)
    
    func fetchPrecListData(keyword: String, pages: String, completion: @escaping (Bool) -> Void) async
    throws {
        print("fetchPrecListData start")
        let parameters: Parameters = [
            "query": keyword,
            "page" : pages
        ]
        
        AF.request(urlPrecSearchXML,
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
                
                //print(xml)
                
                var idx = 0
                
                let totalCnt = xml["PrecSearch"]["totalCnt"].element!.text
                self.totalSearchCount = Int(totalCnt)!
                if let floatCnt = Float(totalCnt){
                    let ceilCnt = ceilf(floatCnt/10)
                    let intCnt = Int(ceilCnt)
                    self.totalPagesCount = intCnt
                }
                print("page : \(self.totalPagesCount)")
                self.precSearchResult.removeAll()
                
                for elem in xml["PrecSearch"]["prec"].all{
                    self.precSearchResult.append(Prec())
                    if let caseTitle = elem["사건명"].element?.text{
                        self.precSearchResult[idx].caseTitle?.append(caseTitle)
                        
                    }
                    if let caseNumber = elem["사건번호"].element?.text{
                        self.precSearchResult[idx].caseNumber?.append(caseNumber)
//                        print("case number : \(self.precSearchResult[idx].caseNumber)")
                    }
                    if let precSerialNumber = elem["판례일련번호"].element?.text{
                        self.precSearchResult[idx].precSerialNumber?.append(precSerialNumber)
//                        print("serial number : \(self.precSearchResult[idx].precSerialNumber)")
                    }
                    if let detailLink = elem["판례상세링크"].element?.text{
                        self.precSearchResult[idx].detailLink?.append(detailLink)
//                        print("detail Link : \(self.precSearchResult[idx].detailLink)")
                    }
                    idx += 1
                }//:for
                
                DispatchQueue.main.async {
                    completion(true)
                }
                print("fetchPrecListData done")
                return
                
            case .failure(let err) :
                print(err.localizedDescription)
            }//:switch
        }
    }//:throws
    
    func fetchPrecDetail(SerialNumber: String, completion: @escaping (Bool) -> Void) async
    throws {
        print("fetchPrecDetail start")
        let parameters: Parameters = [
            "ID": SerialNumber
        ]
        
        AF.request(urlPrecDetailXML,
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
                
                //print(xml)
                
                var idx = 0
                
                //self.precDetailResult..removeAll()
                
                for elem in xml["PrecService"].all{
                    self.precDetailResult.precSerialNumber? = elem["판례정보일련번호"].element!.text
                    self.precDetailResult.caseTitle? = elem["사건명"].element!.text
                    self.precDetailResult.caseNumber? = self.StringTrimming(target: elem["사건번호"].element!.text)!
                    self.precDetailResult.judgementDay? = elem["선고일자"].element!.text
                    self.precDetailResult.judgement? = elem["선고"].element!.text
                    self.precDetailResult.courtName? = elem["법원명"].element!.text
                    self.precDetailResult.courtSort? = elem["법원종류코드"].element!.text
                    self.precDetailResult.caseSortName? = elem["사건종류명"].element!.text
                    self.precDetailResult.caseSortCord? = elem["사건종류코드"].element!.text
                    self.precDetailResult.judgementSort? = elem["판결유형"].element!.text
                    
                    if let holding = self.StringTrimming(target: elem["판시사항"].element!.text){
                        self.precDetailResult.holding? = holding
                    }
                    if let summary = self.StringTrimming(target: elem["판결요지"].element!.text){
                        self.precDetailResult.summary? = summary
                    }
                    if let refarti = self.StringTrimming(target: elem["참조조문"].element!.text){
                        self.precDetailResult.refArticle? = "\n" + refarti
                    }
                    if let refprec = self.StringTrimming(target: elem["참조판례"].element!.text){
                        var refprec2 = refprec.replacingOccurrences(of: """
<a href="#AJAX" onclick="javascript:showCase(
""", with: "", options: NSString.CompareOptions.literal, range: nil)
                        refprec2 = refprec2.replacingOccurrences(of: """
);" >
""", with: "", options: NSString.CompareOptions.literal, range: nil)
                        refprec2 = refprec2.replacingOccurrences(of: "<br/>", with: "", options: NSString.CompareOptions.literal, range: nil)
                        refprec2 = refprec2.replacingOccurrences(of: "</a>", with: "", options: NSString.CompareOptions.literal, range: nil)
                        refprec2 = refprec2.replacingOccurrences(of: "대법원", with: "\n대법원", options: NSString.CompareOptions.literal, range: nil)
                        self.precDetailResult.refPrec? = refprec2
                    }
                    
                    if let contents = self.StringTrimming(target: elem["판례내용"].element?.text){
                        self.precDetailResult.contents? = contents
                    }
                    
                    //print("summary : \(self.precDetailResult[idx].summary)")
                    idx += 1
                }//:for
                
                DispatchQueue.main.async {
                    completion(true)
                }
                print("fetchPrecDetail done")
                return
                
            case .failure(let err) :
                print(err.localizedDescription)
            }//:switch
        }
    }//:throws
}



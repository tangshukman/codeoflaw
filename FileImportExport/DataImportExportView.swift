import SwiftUI
import UniformTypeIdentifiers

struct DataImportExportView: View {
    @EnvironmentObject var viewFont: fontStyle
    @EnvironmentObject var fetcher: LawDataCollectionFetcher
    @EnvironmentObject var precFetcher: PrecDataCollectionFetcher
    
    @AppStorage("titleColor") var titleColor: Color = Color.primary
    @AppStorage("bodyColor") var bodyColor: Color = Color.primary
    @AppStorage("titleSize", store: .standard) var titleSize = 17 
    @AppStorage("bodySize", store: .standard) var bodySize = 17
    @AppStorage("lineSpace", store: . standard) var lineSpace = 10
    @AppStorage("font") var font: String = UserDefaults.standard.string(forKey: "font") ?? ""
    //@State
    @State private var document: MessageDocument = MessageDocument(message: "Hello, World!")
    @State private var isImporting: Bool = false
    @State private var isPrecImporting: Bool = false
    @State private var isExporting: Bool = false
    @State private var isPrecExporting: Bool = false
    
    @State var loadedJSONLawList = JSONLawList()
    @State var precJSONList = PrecJSONList()
    
    @State var fileName = "default"
    
    @State var isShow = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                isImporting.toggle()
            }, label: {
                Text("법령 / 판례 백업 데이터 불러오기")
            })
            .buttonStyle(.borderedProminent)
            .padding()
            
//            Button(action: {
//                isPrecImporting.toggle()
//            }, label: {
//                Text("판례 백업 데이터 불러오기")
//            })
//            .buttonStyle(.borderedProminent)
//            .padding()    
                
            Button(action: {
                isExporting.toggle()
                let jsonEncoder = JSONEncoder()
                do {
                    let encodedData = try jsonEncoder.encode(loadedJSONLawList)
                    
                    document.message = String(data: encodedData, encoding: .utf8)!
                    fileName = "Law_BackupData" 
                } catch {
                    print(error)
                }
            }, label: {
                Text("법령 데이터 백업")
            })
            .buttonStyle(.borderedProminent)
            .padding()
            
            Button(action: {
                isExporting.toggle()
                let jsonEncoder = JSONEncoder()
                do {
                    let encodedData = try jsonEncoder.encode(precJSONList)
                    
                    document.message = String(data: encodedData, encoding: .utf8)!
                    fileName = "Prec_BackupData"
                } catch {
                    print(error)
                }
            }, label: {
                Text("판례 데이터 백업")
            })
            .buttonStyle(.borderedProminent)
            .padding()
                
//                Button(action: {
//                    isExporting.toggle()
//                }, label: {
//                    Text("(.txt) 데이터 내보내기")
//                })
//                .buttonStyle(.borderedProminent)
//                .padding()
                //Spacer()
            
        }
        .padding()
        .fileImporter(
            isPresented: $isImporting,
            allowedContentTypes: [UTType.plainText],
            allowsMultipleSelection: false
        ) { result in
            do {
                guard let selectedFile: URL = try result.get().first else { return }
                guard selectedFile.startAccessingSecurityScopedResource() else { return }
                
                let jsonDecoder = JSONDecoder()
                
                let jsonData = try Data(contentsOf: selectedFile, options: .mappedIfSafe)
                
                let theFileName = (selectedFile.absoluteString as NSString).lastPathComponent
                print(theFileName)
                
                if theFileName.contains("Law"){
                    let decodedJsonLawList = try jsonDecoder.decode(JSONLawList.self, from: jsonData)
                    fetcher.saveJSONLawList(data: decodedJsonLawList)
                }
                
                if theFileName.contains("Prec"){
                    let decodedPrecJSONList = try jsonDecoder.decode(PrecJSONList.self, from: jsonData)
                    precFetcher.savePrecJSONList(data: decodedPrecJSONList)
                }
                
                selectedFile.stopAccessingSecurityScopedResource()
            } catch {
                Swift.print(error.localizedDescription)
            }
        }//fileImporter
        
        .fileExporter(
            isPresented: $isExporting,
            document: document,
            contentType: UTType.json,
            defaultFilename: fileName
        ) { result in
            if case .success = result {
                Swift.print("Success!")
            } else {
                Swift.print("Something went wrong…")
            }
        }//fileExporter
        
        .navigationBarTitle("설정", displayMode: .inline)
        
        .task{
            guard let tempLoadedJSONLawList = fetcher.loadJSONLawList() else{return}
            loadedJSONLawList = tempLoadedJSONLawList
            guard let tempPrecJSONList = precFetcher.loadPrecJSONList() else{return}
            precJSONList = tempPrecJSONList
        }
    }//:bodyview
}

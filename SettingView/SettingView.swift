import SwiftUI
import UniformTypeIdentifiers

struct SettingView: View {
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
    @State private var isExporting: Bool = false
    
    @State var loadedJSONLawList = JSONLawList()
    
    @State var isShow = false
    
    var body: some View {
        NavigationView{
            VStack(alignment: .leading) {
                NavigationLink(destination: FontSettingView()) {
                    HStack{
                        Image(systemName: "chevron.right.square.fill")
                        Text("글씨 크기, 줄 간격 설정")
                        Text("")
                        Image(systemName: "textformat.size.ko")
                            .font(.title2)
                    }
                }
                .padding(.vertical)
                //Spacer()
                NavigationLink(destination: DataImportExportView() ){
                    HStack{
                        Image(systemName: "chevron.right.square.fill")
                        Text("데이터 백업")
                        //Text(" ")
                        Image(systemName: "externaldrive.fill.badge.timemachine")
                        
                        Text("/  불러오기")
                        Image(systemName: "square.and.arrow.down")
                    }
                }
                .padding(.vertical)
                //Spacer()
                NavigationLink(destination: DataDeleteView() ){
                    HStack{
                        Image(systemName: "chevron.right.square.fill")
                        Text("앱 데이터 삭제")
                        Text(" ")
                        Image(systemName: "trash")
                            .font(.title3)
                    }
                }
                .navigationBarTitle("설정", displayMode: .inline)
                .padding(.vertical)
                Spacer()
            }
            //.padding()
        }
        
        
        //:VStack
        .task{
            guard let tempLoadedJSONLawList = fetcher.loadJSONLawList() else{return}
            loadedJSONLawList = tempLoadedJSONLawList
        }
    }//:bodyview
}

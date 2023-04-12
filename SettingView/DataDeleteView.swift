import SwiftUI

struct DataDeleteView: View {
    @Environment(\.colorScheme) var scheme
    
    @EnvironmentObject var fetcher: LawDataCollectionFetcher
    @EnvironmentObject var precFetcher: PrecDataCollectionFetcher
    
    @State var loadedJSON = [JSON.init()]
    @State var loadedJSONCollection = JSONCollection()
    @State var loadedJSONLawList = JSONLawList()
    
    @State var loadedPrecJSON = PrecJSON.init()
    @State var loadedPrecJSONList = PrecJSONList()
    
    @State var searchHistory = [String]()
    @State var precSearchHistory = [PrecJSON]()
    
    @State private var showingAlert = false
    
    func removeRows(at offsets: IndexSet) {
        Task{
            loadedJSONLawList.lawList.remove(atOffsets: offsets)
            fetcher.saveJSONLawList(data: loadedJSONLawList)
            loadedJSONLawList = fetcher.loadJSONLawList() ?? JSONLawList()
        }
    }
    
    @State private var actionTitle = ""
    
    var body: some View {
//        NavigationView{
        ZStack{
        Theme.myBackgroundColor(forScheme: scheme)
        .edgesIgnoringSafeArea(.all)
            VStack(alignment: .center){
                //Group{
                    List(){
                        Section("법령"){
                            ForEach(loadedJSONLawList.lawList, id:\.name){collection in
                                HStack{
                                    Text(collection.name)
                                    Spacer()
                                    Button(action: {
                                        self.showingAlert.toggle()
                                    }){
                                        Image(systemName: "trash")
                                        //                                    Text("삭제")
                                            .padding(.horizontal)
                                    }
                                    .foregroundColor(.white)
                                    .background(.red)
                                    .cornerRadius(5)
                                    .alert(isPresented: $showingAlert) {
                                        let firstButton = Alert.Button.default(Text("취소")) {
                                            print("primary button pressed")
                                        }
                                        let secondButton = Alert.Button.cancel(Text("즉 시 제 거")) {
                                            guard let index = loadedJSONLawList.lawList.firstIndex(where: {$0.name == collection.name}) else{return}
                                            loadedJSONLawList.lawList.remove(at: index)
                                            fetcher.saveJSONLawList(data: loadedJSONLawList)
                                            guard let loadedJSONLawListTemp = fetcher.loadJSONLawList() else{return}
                                            loadedJSONLawList =  loadedJSONLawListTemp
                                            print("secondary button pressed")
                                        }
                                        return Alert(title: Text("해당 법령 데이터를 삭제 하시겠습니까?"),
                                                     message: Text("⚠️주의! : 해당 법령 관련 데이터가 모두 삭제됩니다. (조문 내용, 즐겨찾기, 메모 등)"),
                                                     primaryButton: firstButton, secondaryButton: secondButton)
                                    }
                                }
                                //Divider()
                            }//ForEach
                        }//Section
                        Section("판례"){
                            ForEach(loadedPrecJSONList.precList, id:\.caseTitle){prec in
                                HStack(){
                                    VStack(alignment: .leading){
                                        Text(prec.caseNumber)
                                            .font(.subheadline)
                                        Spacer()
                                        Text(prec.caseTitle)
                                            .font(.caption)
                                    }
                                    Spacer()
                                    Button(action: {
                                        self.showingAlert.toggle()
                                    }){
                                        Image(systemName: "trash")
                                            .padding(.horizontal)
                                    }
                                    .foregroundColor(.white)
                                    .background(.red)
                                    .cornerRadius(5)
                                    .alert(isPresented: $showingAlert) {
                                        let firstButton = Alert.Button.default(Text("취소")) {
                                            print("primary button pressed")
                                        }
                                        let secondButton = Alert.Button.cancel(Text("즉 시 제 거")) {
                                            guard let index = loadedPrecJSONList.precList.firstIndex(where: {$0.caseTitle == prec.caseTitle}) else{return}
                                            loadedPrecJSONList.precList.remove(at: index)
                                            precFetcher.savePrecJSONList(data: loadedPrecJSONList)
                                            guard let loadedPrecJSONListTemp = precFetcher.loadPrecJSONList() else{return}
                                            loadedPrecJSONList =  loadedPrecJSONListTemp
                                            print("secondary button pressed")
                                        }
                                        return Alert(title: Text("해당 판례 데이터를 삭제 하시겠습니까?"),
                                                     message: Text("⚠️주의! : 해당 판례 관련 데이터가 모두 삭제됩니다. (판례 내용, 즐겨찾기, 메모 등)"),
                                                     primaryButton: firstButton, secondaryButton: secondButton)
                                    }
                                }
                                //Divider()
                            }//Foreach
                        }//Section
                        Section("법령 검색 기록"){
                            ForEach(searchHistory.indices, id:\.self){index in
                                HStack(){
                                    VStack(alignment: .leading){
                                        Text(searchHistory[index])
                                    }
                                    Spacer()
                                    Button(action: {
                                        self.showingAlert.toggle()
                                    }){
                                        Image(systemName: "trash")
                                            .padding(.horizontal)
                                    }
                                    .foregroundColor(.white)
                                    .background(.red)
                                    .cornerRadius(5)
                                    .alert(isPresented: $showingAlert) {
                                        let firstButton = Alert.Button.default(Text("취소")) {
                                            print("primary button pressed")
                                        }
                                        let secondButton = Alert.Button.cancel(Text("즉 시 제 거")) {
                                            searchHistory.remove(at: index)
                                            fetcher.saveJSONSearchHistory(data: searchHistory)
                                            guard let temphistory = fetcher.loadJSONSearchHistory() else{return}
                                            searchHistory = temphistory
                                            print("secondary button pressed")
                                        }
                                        return Alert(title: Text("법령 검색 기록을 삭제 하시겠습니까?"),
                                                     message: Text(""),
                                                     primaryButton: firstButton, secondaryButton: secondButton)
                                    }
                                }
                                //Divider()
                            }//Foreach
                        }//Section
                        Section("판례 검색 기록"){
                            ForEach(precSearchHistory, id:\.caseTitle){item in
                                HStack(){
                                    VStack(alignment: .leading){
                                        Text(item.caseTitle)
                                    }
                                    Spacer()
                                    Button(action: {
                                        self.showingAlert.toggle()
                                    }){
                                        Image(systemName: "trash")
                                            .padding(.horizontal)
                                    }
                                    .foregroundColor(.white)
                                    .background(.red)
                                    .cornerRadius(5)
                                    .alert(isPresented: $showingAlert) {
                                        let firstButton = Alert.Button.default(Text("취소")) {
                                            print("primary button pressed")
                                        }
                                        let secondButton = Alert.Button.cancel(Text("즉 시 제 거")) {
                                            let index = precSearchHistory.firstIndex(where: {$0.caseTitle == item.caseTitle})
                                            precSearchHistory.remove(at: index!)
                                            precFetcher.saveJSONPrecHistory(data: precSearchHistory)
                                            guard let history = precFetcher.loadJSONPrecHistory() else{return}
                                            precSearchHistory = history
                                            print("secondary button pressed")
                                        }
                                        return Alert(title: Text("판례 검색 기록을 삭제 하시겠습니까?"),
                                                     message: Text(""),
                                                     primaryButton: firstButton, secondaryButton: secondButton)
                                    }
                                }
                                //Divider()
                            }//Foreach
                        }//Section
                        
                        Button(action: {
                            self.showingAlert.toggle()
                        }){
                            HStack{
                                Spacer()
                                Text("검색기록 일괄 삭제")
                                Spacer()
                            }
                        }
                        //.foregroundColor(.white)
                        //.background(.red)
                        .cornerRadius(5)
                        .alert(isPresented: $showingAlert) {
                            let firstButton = Alert.Button.default(Text("취소")) {
                                print("primary button pressed")
                            }
                            let secondButton = Alert.Button.cancel(Text("삭제")) {
                                searchHistory.removeAll()
                                precSearchHistory.removeAll()
                                fetcher.saveJSONSearchHistory(data: searchHistory)
                                precFetcher.saveJSONPrecHistory(data: precSearchHistory)
                                print("secondary button pressed")
                            }
                            return Alert(title: Text("전체 검색기록을 삭제하시겠습니까?"),
                                         message: Text(""),
                                         primaryButton: firstButton, secondaryButton: secondButton)
                        }
                    }//List
                    //}//Group
                //.frame(minHeight: 150, maxHeight: 160, alignment: .leading)
//                    .font(.subheadline)
            }//VStack
        //.padding(.horizontal)
            
        }//:ZStack
            
            .task {
                guard let tempLoadedJSONLawList = fetcher.loadJSONLawList() else{return}
                loadedJSONLawList = tempLoadedJSONLawList
                guard let tempLoadedPrecJSONList = precFetcher.loadPrecJSONList() else{return}
                loadedPrecJSONList = tempLoadedPrecJSONList
                guard let history = fetcher.loadJSONSearchHistory() else{return}
                searchHistory = history
                guard let history = precFetcher.loadJSONPrecHistory() else{return}
                precSearchHistory = history
            }//:.task
            .navigationBarTitle("앱 데이터 삭제", displayMode: .inline)
            
        //}//:NavigationView
    }//:bodyview
}//:Memecreatorview


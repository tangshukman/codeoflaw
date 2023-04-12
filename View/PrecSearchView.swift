import SwiftUI

struct PrecSearchView: View {
    @Environment(\.colorScheme) var scheme
    @EnvironmentObject var precFetcher: PrecDataCollectionFetcher
    @State var searchText: String = ""
    @State var sectionTitle: String = ""
    @State var precJSONArray = PrecJSON()
    @State var precJSONList = PrecJSONList()
    
    @State var searchHistory = [PrecJSON]()
    
    @State private var shouldAnimate: Bool = false
    
    @State var duplicateCheck: Bool = false
    
    @State var pages = "1"
    @State var intPages = 1
    
    //@State var refresh: Bool = false
    
    func removeRows(at offsets: IndexSet) {
        Task{
            searchHistory.remove(atOffsets: offsets)
            precFetcher.saveJSONPrecHistory(data: searchHistory)
            guard let history = precFetcher.loadJSONPrecHistory() else{return}
            searchHistory = history
        }
    }
    
    func precListSearch() async {
        self.shouldAnimate = true
        try? await precFetcher.fetchPrecListData(keyword: searchText, pages: pages, completion: { isSuccess in
            if isSuccess {
                self.shouldAnimate = false
            }
        })
    }
    
    var searchResultListView: some View {
        VStack{
            HStack(){
                Text("판례 검색 결과")
                    .font(.subheadline)
                    .fontWeight(.ultraLight)
                    .padding(.horizontal)
                Spacer()
                
                Text("총 \(precFetcher.totalSearchCount)개")
                    .font(.subheadline)
                    .fontWeight(.ultraLight)
                    .padding(.horizontal)
            }
            
            ScrollView(){//1
                ForEach(precFetcher.precSearchResult) { item in
                    Divider()
                    HStack{
                        if shouldAnimate {
                            ActivityIndicator(shouldAnimate:
                                                self.$shouldAnimate)
                        }
                        
                        Spacer()
                        Button(action: {
                            if !(item.caseTitle == "" && searchText == ""){
                                self.shouldAnimate = true
                                Task{
                                    try? await precFetcher.fetchPrecDetail(SerialNumber: item.precSerialNumber!, completion: { isSuccess in
                                        if isSuccess {
                                            self.shouldAnimate = false
                                        }
                                    })
                                }//Task
                                
                                let repeatedList = searchHistory.filter{$0.caseTitle == item.caseTitle}.count
                                
                                let temp = PrecJSON()
                                temp.caseTitle.append(item.caseTitle!)
                                temp.precSerialNumber.append(item.precSerialNumber!)
                                searchHistory.insert(temp, at: 0)
                                
                                if repeatedList != 0 {
                                    if let dupListIndex = searchHistory.lastIndex(where: {$0.caseTitle == item.caseTitle}) {
                                        searchHistory.remove(at: dupListIndex)
                                    }
                                }
                                
                                precFetcher.saveJSONPrecHistory(data: searchHistory)
                                
                                let repeatedPrecList = precJSONList.precList.filter{$0.caseTitle == item.caseTitle}.count
                                precFetcher.duplicateYN = repeatedPrecList == 0 ? false : true
                                sectionTitle = item.caseTitle!
                            }//if
                        }) {
                            let repeatedList = searchHistory.filter{$0.caseTitle == item.caseTitle}.count
                            if !(item.caseTitle == "" && searchText == ""){
                                if repeatedList == 0 {
                                    Image(systemName: "book.closed")
                                    VStack(alignment: .leading){
                                        Text(item.caseNumber ?? "")
                                            .font(.subheadline)
                                        Text(item.caseTitle ?? "")
                                            .font(.caption)
                                    }
                                    .foregroundColor(.primary)
                                    Spacer()
                                }else{
                                    Image(systemName: "book.fill")
                                    VStack(alignment: .leading){
                                        Text(item.caseNumber ?? "")
                                            .font(.subheadline)
                                        Text(item.caseTitle ?? "")
                                            .font(.caption)
                                    }
                                    Spacer()
                                }
                            }
                        }//:Button
                        Spacer()
                    }//:HStack1
                    Spacer()
                }//:ForEach
            }//:ScrollView
            .frame(maxHeight: 180)
            .padding(.horizontal)
        
            if precFetcher.totalPagesCount > 1 {
                HStack{
                    if intPages > 1 {
                        Button(action:{
                            if let pageNumber = Int(pages){
                                intPages = pageNumber - 1
                                if intPages <= 1 {intPages = 1}
                                pages = String(intPages)
                            }
                            Task{
                                await precListSearch()
                            }
                        }){
                            //Text("Previous")
                            Image(systemName: "arrow.left")
                        }
                        //.frame(maxHeight:110)
                        .buttonStyle(.bordered)
                        //                            .background(.blue)
                        .cornerRadius(5)
                    }
                    Spacer()
                    Text("\(pages) p / \(precFetcher.totalPagesCount) p")
                    Spacer()
                    if precFetcher.totalPagesCount > intPages {
                        Button(action:{
                            if let pageNumber = Int(pages){
                                intPages = pageNumber + 1
                                if intPages >= precFetcher.totalPagesCount {intPages = precFetcher.totalPagesCount}
                                pages = String(intPages)
                            }
                            Task{
                                await precListSearch()
                            }
                        }){
                            Image(systemName: "arrow.right")
                        }
                        .buttonStyle(.bordered)
                        .cornerRadius(5)
                    } 
                }
                .frame(width:250)
                .padding(.horizontal)
            }//if
        }
    }
    
    var precPreview: some View{
        VStack{
            Group{
                HStack(){
                    Text("판례 미리보기")
                        .font(.subheadline)
                        .fontWeight(.ultraLight)
                        .padding(.horizontal)
                    Spacer()
                }
                if precFetcher.precDetailResult.caseTitle != "" {
                    HStack{
                        if shouldAnimate {
                            ActivityIndicator(shouldAnimate: self.$shouldAnimate)
                        }//:if
                        Spacer()
                        
                        if !precFetcher.duplicateYN {
                            Button(action: {
                                if let tempPrecJSONList = precFetcher.loadPrecJSONList(){
                                    precJSONList = tempPrecJSONList
                                    
                                }
                                precJSONArray.precSerialNumber = precFetcher.precDetailResult.precSerialNumber ?? ""
                                precJSONArray.caseTitle = precFetcher.precDetailResult.caseTitle ?? ""
                                precJSONArray.caseNumber = precFetcher.precDetailResult.caseNumber ?? ""
                                precJSONArray.judgementDay = precFetcher.precDetailResult.judgementDay ?? ""
                                precJSONArray.judgement = precFetcher.precDetailResult.judgement ?? ""
                                precJSONArray.courtName = precFetcher.precDetailResult.courtName ?? ""
                                precJSONArray.courtSort = precFetcher.precDetailResult.courtSort ?? ""
                                precJSONArray.caseSortName = precFetcher.precDetailResult.caseSortName ?? ""
                                precJSONArray.caseSortCord = precFetcher.precDetailResult.caseSortCord ?? ""
                                precJSONArray.judgementSort = precFetcher.precDetailResult.judgementSort ?? ""
                                precJSONArray.holding = precFetcher.precDetailResult.holding ?? ""
                                precJSONArray.summary = precFetcher.precDetailResult.summary ?? ""
                                precJSONArray.refArticle = precFetcher.precDetailResult.refArticle ?? ""
                                precJSONArray.refPrec = precFetcher.precDetailResult.refPrec ?? ""
                                precJSONArray.contents = precFetcher.precDetailResult.contents ?? ""
                                
                                let repeatedItems = precJSONList.precList.filter{$0.caseTitle == precFetcher.precDetailResult.caseTitle}.count
                                
                                if repeatedItems == 0{
                                    precJSONList.precList.insert(precJSONArray, at: 0)
                                    precFetcher.savePrecJSONList(data: precJSONList)
                                    precFetcher.duplicateYN = true
                                    
                                }else{
                                    precFetcher.duplicateYN = false
                                    
                                }
                            }){
                                Text("기기에 판례 다운로드")
                                Image(systemName: "platter.filled.bottom.and.arrow.down.iphone")
                                
                            }//Button
                            .buttonStyle(.borderedProminent)
                            .cornerRadius(5)
                            
                        }else {
                            Text("저장된 판례")
                            Image(systemName: "checkmark.circle.fill")
                            
                        }
                    }//Hstack
                    .padding(.horizontal)
                }//if
            }
            Group{
                ScrollView{//:ScrollView
                    if precFetcher.precDetailResult.caseTitle != "" {
                        VStack(alignment:.leading){
                            Text("📎 사건명 : \(precFetcher.precDetailResult.caseTitle ?? "")")
                            Divider()
                            Text("📂 사건번호 : \(precFetcher.precDetailResult.caseNumber ?? "")")
                            Divider()
                            Text("📂 판시사항 : \(precFetcher.precDetailResult.holding ?? "")")
                            Divider()
                        }
                        VStack(alignment:.leading){
                            Text("📂 판결요지 : \(precFetcher.precDetailResult.summary ?? "")")
                            Divider()
                            Text("📂 참조조문 : \(precFetcher.precDetailResult.refArticle ?? "")")
                            Divider()
                            Text("📂 참조판례 : \(precFetcher.precDetailResult.refPrec ?? "")")
                            Divider()
                            Text("📂 판례내용 : \(precFetcher.precDetailResult.contents ?? "")")
                        }
                    }
                }
            }
            //ScrollView
            .padding(.horizontal)
        }
    }
    
    var body: some View {
        //viewUpdate
        let _ = Self._printChanges()
        VStack{//1
            HStack{//1
                TextField("검색어를 입력하세요", text: $searchText)
                    .onSubmit {
                        Task{
                            await precListSearch()
                        }//:Task
                    }//:onSubmit
                    .onChange(of: searchText) {
                        print($0)
                    }//:onChange
                    .padding()
                Button{
                    Task{
                        await precListSearch()
                    }//:Task
                }label: {
                    Image(systemName: "magnifyingglass")
                    Text("판례 검색")
                }//:Button,label
                .buttonStyle(.borderedProminent)
                .background(.gray)
                .cornerRadius(5)
            }//:HStack1
            .padding(.horizontal)
            
            //Task{
            Divider()
            searchResultListView
            Divider()
            
            HStack(){
                Text("판례 검색 기록")
                    .font(.subheadline)
                    .fontWeight(.ultraLight)
                    .padding(.horizontal)
                Spacer()
            }
            ScrollView(.horizontal){
                HStack{
                    ForEach(searchHistory, id:\.caseTitle){ historyList in
                        Text(historyList.caseTitle)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.secondary, lineWidth: 2)
                            )
                            .cornerRadius(5)
                            .onTapGesture {
                                self.shouldAnimate = true
                                Task{
                                    try? await precFetcher.fetchPrecDetail(SerialNumber: historyList.precSerialNumber, completion: { isSuccess in
                                        if isSuccess {
                                            self.shouldAnimate = false
                                        }
                                    })
                                    
                                    let repeatedItems = precJSONList.precList.filter{$0.caseTitle == historyList.caseTitle}.count
                                    
                                    precFetcher.duplicateYN = repeatedItems == 0 ? false : true                                   
                                    
                                }//Task
                                sectionTitle = historyList.caseTitle
                            }//onTapGesture
                    }//onDelete
                }.padding(.horizontal)
            }
            Divider()
            precPreview
        }
        .background((scheme == .dark) ? .black : .white)
        .task{
            guard let history = precFetcher.loadJSONPrecHistory() else{return}
            searchHistory = history
            guard let tempPrecJSONList = precFetcher.loadPrecJSONList() else{return}
            precJSONList = tempPrecJSONList
        }//.navigationBarHidden(true)
    }//:bodyview
}//:struct

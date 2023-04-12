import SwiftUI

struct ArticleSearchView: View {
    @Environment(\.colorScheme) var scheme
    @EnvironmentObject var fetcher: LawDataCollectionFetcher
    @State var searchText: String = ""
    @State var sectionTitle: String = ""
    @State var jsonCollection = JSONCollection()
    @State var jsonArray = [JSON]()
    @State var jsonLawList = JSONLawList()
    @State var searchHistory = [String]()
    
    @State var pages = "1"
    @State var intPages = 1
    @State private var shouldAnimate = false
    
    func removeRows(at offsets: IndexSet) {
        Task{
            searchHistory.remove(atOffsets: offsets)
            fetcher.saveJSONSearchHistory(data: searchHistory)
            guard let history = fetcher.loadJSONSearchHistory() else{return}
            searchHistory = history
        }
    }
    
    func searchLawList() async {
        self.shouldAnimate = true
        try? await fetcher.fetchLawListData(keyword: searchText, pages: pages, completion: { isSuccess in
            if isSuccess {
                self.shouldAnimate = false
            }
        })
    }
    
    var searchResultListView: some View {
        VStack{
            HStack{
                Text("법령 검색 결과")
                    .font(.subheadline)
                    .fontWeight(.ultraLight)
                    .padding(.horizontal)
                Spacer()
                Text("총 \(fetcher.totalSearchCount)개")
                    .font(.subheadline)
                    .fontWeight(.ultraLight)
                    .padding(.horizontal)
            }
            ScrollView{//1
                ForEach(fetcher.searchResultText) { item in
                    Divider()
                    HStack{
                        if shouldAnimate {
                            ActivityIndicator(shouldAnimate:
                                                self.$shouldAnimate)
                        }
                        Button(action: {
                            if !(item.ListText == "" && searchText == ""){
                                self.shouldAnimate = true
                                Task{
                                    try await fetcher.fetchSmall(keyword: item.ListText, completion: { isSuccess in
                                        if isSuccess{
                                            self.shouldAnimate = false
                                        }//if
                                    })//try await
                                }//Task
                                
                                //check repeated items
                                let repeatedList = searchHistory.filter{$0 == item.ListText}.count
                                
                                searchHistory.insert(item.ListText, at: 0)
                                
                                if repeatedList != 0 {
                                    if let dupListIndex = searchHistory.lastIndex(where: {$0 == item.ListText}) {
                                        searchHistory.remove(at: dupListIndex)
                                    }
                                }
                                
                                fetcher.saveJSONSearchHistory(data: searchHistory)
                                
                                let repeatedItems = jsonLawList.lawList.filter{$0.name == item.ListText}.count
                                
                                fetcher.duplicateYN = repeatedItems == 0 ? false : true
                                sectionTitle = item.ListText
                            }
                        }) {
                            if !(item.ListText == "" && searchText == ""){
                                let repeatedList = searchHistory.filter{$0 == item.ListText}.count
                                if repeatedList == 0 {
                                    Image(systemName: "book.closed")
                                    Text(item.ListText)
                                        .font(.subheadline)
                                        .foregroundColor(.primary)
                                }else{
                                    Image(systemName: "book.fill")
                                    Text(item.ListText)
                                        .font(.subheadline)
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
            
            if fetcher.totalPagesCount > 1 {
                HStack{
                    if intPages > 1 {
                        Button(action:{
                            if let pageNumber = Int(pages){
                                intPages = pageNumber - 1
                                if intPages <= 1 {intPages = 1}
                                pages = String(intPages)
                            }
                            Task{
                                await searchLawList()
                            }
                        }){
                            Image(systemName: "arrow.left")
                        }
                        .buttonStyle(.bordered)
                        .cornerRadius(5)
                        
                    }
                    Spacer()
                    Text("\(pages) p / \(fetcher.totalPagesCount) p")
                    Spacer()
                    if fetcher.totalPagesCount > intPages {
                        Button(action:{
                            if let pageNumber = Int(pages){
                                intPages = pageNumber + 1
                                if intPages >= fetcher.totalPagesCount {intPages = fetcher.totalPagesCount}
                                pages = String(intPages)
                            }
                            Task{
                                await searchLawList()
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
    }//SearchListView
    
    var articlePreview: some View {
        VStack{
            HStack(){
                Text("법령 미리보기")
                    .font(.subheadline)
                    .fontWeight(.ultraLight)
                    .padding(.horizontal)
                Spacer()
                Text("\(fetcher.lawArticles[0].name ?? "")")
                    .font(.caption)
                    .fontWeight(.ultraLight)
                    .padding(.horizontal)
            }//HStack
            Spacer()
            if fetcher.lawArticles[0].article != "" {
                HStack{
                    Spacer()
                    if !fetcher.duplicateYN{
                        
                        Button(action: {
                            jsonArray.removeAll()
                            jsonLawList = fetcher.loadJSONLawList() ?? JSONLawList()
                            
                            //print(jsonArray)
                            for i in 0..<fetcher.lawArticles.count {
                                jsonArray.append(JSON())
                                let name = fetcher.lawArticles[i].name ?? ""
                                let title = fetcher.lawArticles[i].title ?? ""
                                let article = fetcher.lawArticles[i].article ?? ""
                                let articleKey = fetcher.lawArticles[i].articleKey ?? ""
                                jsonArray[i].name = name
                                jsonArray[i].title = title
                                jsonArray[i].article = article
                                jsonArray[i].articleKey = articleKey
                                
                            }//for
                            
                            jsonCollection.name = jsonArray[0].name
                            jsonCollection.collection = jsonArray
                            
                            //check repeated list
                            let repeatedItems = jsonLawList.lawList.filter{$0.name == fetcher.lawArticles[0].name}.count
                            
                            if repeatedItems == 0{
                                jsonLawList.lawList.insert(jsonCollection, at: 0)
                                fetcher.saveJSONLawList(data: jsonLawList)
                                fetcher.duplicateYN = true
                            }else{
                                fetcher.duplicateYN = false
                            }
                        }){
                            Text("기기에 법령 다운로드")
                            Image(systemName: "arrow.down.doc.fill")
                        }//Button
                        .buttonStyle(.borderedProminent)
                        //.background(.blue)
                        .cornerRadius(5)
                    }//if
                    else{
                        Text("저장된 법령")
                        Image(systemName: "checkmark.circle.fill")
                    }
                }//Hstack
                .padding(.horizontal)
            }//if
            ScrollView{//:ScrollView
                //Section(""){
                ForEach(fetcher.lawArticles, id:\.article){ articles in
                    HStack{
                        if shouldAnimate {
                            ActivityIndicator(shouldAnimate: self.$shouldAnimate)
                        }//:if
                        VStack{
                            Divider()
                            HStack{
                                if articles.title != "" {
                                    Text(articles.title!)
                                        .padding(.horizontal)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 5)
                                                .stroke(.secondary, lineWidth: 1)
                                        )
                                } 
                                Spacer()
                            }
                            Spacer()
                            Text(articles.article ?? "")
                        }
                    }//:HStack
                }//:Foreach
                //}//Section
            }//ScrollView
            .padding(.horizontal)
        }//VStack
//        .background((scheme == .dark) ? .black : .white)
    }
    
    var body: some View {
        //viewUpdate
        let _ = Self._printChanges()
        
        VStack{//1
            HStack{//1
                TextField("검색어를 입력하세요", text: $searchText)
                    .onSubmit {
                        Task{
                            await searchLawList()
                        }//:Task
                    }//:onSubmit
                    .onChange(of: searchText) {
                        print($0)
                    }//:onChange
                    .padding()
                Button{
                    Task{
                        await searchLawList()
                    }//:Task
                }label: {
                    Image(systemName: "magnifyingglass")
                    Text("법령 검색")
                }//:Button,label
                .buttonStyle(.borderedProminent)
                .cornerRadius(5)
            }//:HStack1
            .padding(.horizontal)
            
            Divider()
            searchResultListView
            Divider()
            
            HStack(){
                Text("법령 검색 기록")
                    .font(.subheadline)
                    .fontWeight(.ultraLight)
                    .padding(.horizontal)
                Spacer()
            }
            ScrollView(.horizontal){
                HStack{
                    ForEach(searchHistory, id:\.self){ historyList in
                        Text(historyList)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.secondary, lineWidth: 2)
                            )
                            .cornerRadius(5)
                            .onTapGesture {
                                self.shouldAnimate = true
                                Task{
                                    try await fetcher.fetchSmall(keyword: historyList, completion: { isSuccess in
                                        if isSuccess{
                                            self.shouldAnimate = false
                                        }
                                    })
                                }//Task
                                
                                let repeatedItems = jsonLawList.lawList.filter{$0.name == historyList}.count
                                
                                fetcher.duplicateYN = repeatedItems == 0 ? false : true
                                sectionTitle = historyList 
                            }//onTapGesture
                    }//.onDelete(perform: removeRows)
                }.padding(.horizontal)
            }//ScrollView
            
            Divider()
            articlePreview
            
        }//VStack
        .background((scheme == .dark) ? .black : .white)
        .task{
            guard let history = fetcher.loadJSONSearchHistory() else{return}
            searchHistory = history
            guard let jsonList = fetcher.loadJSONLawList() else{return}
            jsonLawList =  jsonList
        }
        //.navigationBarHidden(true)
    }//:bodyview
}//:struct

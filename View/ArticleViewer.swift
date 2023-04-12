import SwiftUI

struct ArticleViewer: View {
    @Environment(\.colorScheme) var scheme
    @EnvironmentObject var viewFont: fontStyle
    @EnvironmentObject var fetcher: LawDataCollectionFetcher
    
    @State private var searchText = String()
    @State var rating = 0
    
    @AppStorage("titleColor") var titleColor: Color = Color.secondary
    @AppStorage("bodyColor") var bodyColor: Color = Color.primary
    @AppStorage("titleSize", store: .standard) var titleSize = 17 
    @AppStorage("bodySize", store: .standard) var bodySize = 17
    @AppStorage("lineSpace", store: . standard) var lineSpace = 5
    @AppStorage("font") var font: String = UserDefaults.standard.string(forKey: "font") ?? ""
    
    @State var loadedJSON = [JSON.init()]
    @State var loadedJSONCollection = JSONCollection()
    @State var loadedJSONLawList = JSONLawList()
    @State var lawListIndex = Int()
    
    @State var showingPopup = false
    
    @State var addressMemo = ""
    @State var addressName = ""
    @State var addressTitle = ""
    @State var addressArticle = ""
    
    @State var memoIsEdit = false
    @FocusState private var isFocused: Bool
    @State var memoText = String()
    @State var memoOnly = false
    @State var bookmarkOnly = false
    
    @State var lastArticleKey = String()
    @State var scrollIdx = [Int]()
    @State var scrollIdxString = [String]()
    
    func scrollIdxCal() {
        //scrollIdxString.append(lastArticleKey)
        let stringKey = lastArticleKey.prefix(4)
        if let intKey = Int(stringKey){
            if intKey > 10{
                scrollIdx = [1, intKey*1/9, intKey*2/9, intKey*3/9, intKey*4/9, intKey*5/9, intKey*6/9, intKey*7/9, intKey*8/9, intKey]
            }else{
                scrollIdx = [1, intKey/2, intKey]
            }
            //scrollIdxString = scrollIdx.map({reAssemble(idx: $0)})
            print(scrollIdxString)
        }
    }
    
    func reAssemble(idx:Int) -> String{
        var assembled = String()
        if idx < 10{
            assembled = "000" + String(idx) + "001"
        }else if 10 < idx && idx < 100 {
            assembled = "00" + String(idx) + "001"
        }else if 100 < idx && idx < 1000 {
            assembled = "0" + String(idx) + "001"
        }else{
            assembled = String(idx) + "001"
        }
        return assembled
    }
    //@State var showingAlert = false
    //@State private var pressed = false
    
    let alphabet = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    
    var searchResults: [JSON] {
        if searchText.isEmpty {
            return loadedJSON
        } else {
            return loadedJSON.filter { $0.title.contains(searchText) || $0.article.contains(searchText)}
        }
    }
    
    func removeRows(at offsets: IndexSet) {
        Task{
            loadedJSONLawList.lawList.remove(atOffsets: offsets)
            fetcher.saveJSONLawList(data: loadedJSONLawList)
            loadedJSONLawList = fetcher.loadJSONLawList() ?? JSONLawList()
        }
    }
    
    @State private var actionTitle = "" 
    
    var memo: some View{
        Form{
            VStack {
                TextEditor(text: $memoText)
                    .focused($isFocused)
                    .padding(.horizontal)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(0)
                    .frame(maxWidth: .infinity, minHeight:200, maxHeight: 250)
                    .border(Color.gray, width: 2)
                    .foregroundColor(.primary)
                    .background(scheme == .dark ? Color.black : Color.white)
                    .textSelection(.enabled)
                    .cornerRadius(5)
            
            HStack{
                Button(action: {
                    withAnimation{
                        memoText = ""
                    }
                }){
                    Text("Clear")
                        
                }
                .font(.caption)
                .foregroundColor(.primary)
                .buttonStyle(.bordered)
                .background(.red)
                .cornerRadius(5)
                
                Button(action: {
                    withAnimation{
                        memoText = memoText + addressArticle
                    }
                }){
                    Text("조문 복사")
                        
                }
                .font(.caption)
                .foregroundColor(.primary)
                .buttonStyle(.bordered)
                .background(.gray)
                .cornerRadius(5)
                
                Button(action: {
                    withAnimation{
                        if let i = loadedJSONLawList.lawList.firstIndex(where: {$0.name == addressName}){
                            lawListIndex = i
                            if let j = loadedJSONLawList.lawList[i].collection.firstIndex(where: {$0.title == addressTitle}){
                                loadedJSONLawList.lawList[i].collection[j].memo = memoText
                                if memoText != ""{
                                    loadedJSONLawList.lawList[i].collection[j].starRank = 1
                                }
                                fetcher.saveJSONLawList(data: loadedJSONLawList)
                            }
                        }
                        fetcher.saveJSONLawList(data: loadedJSONLawList)
                        //loadedJSONLawList = fetcher.loadJSONLawList() ?? JSONLawList()
                        memoIsEdit = false
                    }
                }){
                    Image(systemName: "arrow.down.doc")
                    Text("저장")
                }
                .font(.caption)
                .foregroundColor(.primary)
                .buttonStyle(.bordered)
                .background(.cyan)
                .cornerRadius(5)
                
                Button(action: {
                    withAnimation{
                        memoIsEdit = false
                    }
                }){
                    Text("취소")
                }
                .font(.caption)
                .foregroundColor(.primary)
                .buttonStyle(.bordered)
                .background(.gray)
                .cornerRadius(5)
            }
            Spacer()
        }//VStack
            .frame(maxWidth: .infinity, maxHeight: 250)
            .foregroundColor(.gray)
            
        }//Form
        .frame(maxWidth: .infinity, maxHeight: 300)
    }
    
    var body: some View {

        NavigationView{
            ZStack{
                Theme.myBackgroundColor(forScheme: scheme)
                    .edgesIgnoringSafeArea(.all)
                
                if memoIsEdit{
                    memo
                    .zIndex(1)
                }
                
                VStack{
                    ScrollViewReader{ scrollView in
                        ZStack{
                            ScrollView {
                                ForEach(bookmarkOnly ? searchResults.filter{$0.starRank > 0} : searchResults, id:\.article) { articles in
                                    HStack{
                                        VStack{
                                            if articles.article != ""{
                                                HStack{
                                                    HStack{
                                                        Button(action:{
                                                            withAnimation{
                                                                if articles.starRank == 0 {
                                                                    articles.starRank = 1
                                                                    
                                                                } else if articles.starRank >= 1 {
                                                                    articles.starRank = 0
                                                                    
                                                                }
                                                                loadedJSONCollection.collection = loadedJSON
                                                                loadedJSONLawList.lawList[lawListIndex] = loadedJSONCollection
                                                                fetcher.saveJSONLawList(data: loadedJSONLawList)
                                                                guard let tempLawList = fetcher.loadJSONLawList() else{return}
                                                                loadedJSONLawList = tempLawList
                                                                loadedJSONCollection = loadedJSONLawList.lawList[lawListIndex]
                                                                loadedJSON = loadedJSONCollection.collection
                                                                
                                                            }
                                                        }){
                                                            if articles.starRank == 0{
                                                                Image(systemName: "bookmark")
                                                                    .frame(width:10, height:20)
                                                                
                                                            } else if articles.starRank >= 1{
                                                                Image(systemName: "bookmark.fill")
                                                                    .frame(width:10, height:20)
                                                                
                                                            }//if
                                                        }//Button
                                                        .buttonStyle(.plain)
                                                        .padding(.horizontal)
                                                        
                                                        Button(action:{
                                                            withAnimation {
                                                                memoIsEdit.toggle()
                                                                addressName = articles.name
                                                                addressTitle = articles.title
                                                                addressArticle = articles.article
                                                                addressMemo = articles.memo
                                                                memoText = articles.memo
                                                                isFocused = true
                                                            }
                                                        }
                                                        ){
                                                            Image(systemName: "note.text")
                                                                .frame(width:10, height:20)
                                                        }
                                                        .buttonStyle(.plain)
                                                        Text(" ")
                                                        //.padding(.horizontal)
                                                    }//VStack
                                                    //.padding(.horizontal)
                                                    
                                                    
                                                    if articles.title != "" {
                                                        StyledText(verbatim: (articles.title))
                                                            .style(.highlight(), ranges:{[$0.range(of: searchText)]})
                                                            .style(.bold())
                                                            .contextMenu(ContextMenu(menuItems: {
                                                                Button("Copy", action: {
                                                                    UIPasteboard.general.string = articles.title
                                                                })
                                                            }))
                                                            .foregroundColor(titleColor)
                                                            .font(.custom(font, size: CGFloat(titleSize)))
                                                            .lineSpacing(CGFloat(lineSpace))
                                                            .multilineTextAlignment(.leading)
                                                            .padding(.horizontal)
                                                            .overlay(
                                                                RoundedRectangle(cornerRadius: 5)
                                                                    .stroke(.secondary, lineWidth: 1)
                                                            )
                                                        //.id(articles.)
                                                        
                                                    } else if articles.title == "" {
                                                        Text(articles.article)
                                                            .contextMenu(ContextMenu(menuItems: {
                                                                Button("Copy", action: {
                                                                    UIPasteboard.general.string = articles.title
                                                                })
                                                            }))
                                                            .foregroundColor(titleColor)
                                                            .font(.custom(font, size: CGFloat(titleSize)))
                                                            .lineSpacing(CGFloat(lineSpace))
                                                            .multilineTextAlignment(.leading)
                                                    }
                                                    
                                                    //Spacer()
                                                    //StarRankView(rank: $rating, starOneOnOff: false)
                                                    Text(" ")
                                                    Spacer()
                                                }//HStack
                                                Spacer()
                                                VStack(alignment:.leading){
                                                    if articles.title != "" {
                                                        //SelectableText(articles.article)
                                                        //TextEditor(text: articles.article)
                                                        StyledText(verbatim: articles.article)
                                                            .style(.highlight(), ranges:{[$0.range(of: searchText)]})
                                                            .style(.bold())
                                                            .contextMenu(ContextMenu(menuItems: {
                                                                Button("Copy", action: {
                                                                    UIPasteboard.general.string = articles.title +  articles.article
                                                                })
                                                            }))
                                                            .foregroundColor(bodyColor)
                                                            .font(.custom(font, size: CGFloat(bodySize)))
                                                            .lineSpacing(CGFloat(lineSpace))
                                                            .multilineTextAlignment(.leading)
                                                            .frame(
                                                                maxWidth: .infinity,
                                                                maxHeight: .infinity,
                                                                alignment: .bottomLeading)
                                                        if articles.memo != "" {
                                                            HStack{
                                                                Image(systemName: "arrow.turn.down.right")
                                                                Text(articles.memo)
                                                                    .foregroundColor(bodyColor)
                                                                    .font(.custom(font, size: CGFloat(bodySize-2)))
                                                                    .lineSpacing(CGFloat(lineSpace))
                                                                    .multilineTextAlignment(.leading)
                                                                    .textSelection(.enabled)
                                                                    .padding(.horizontal)
                                                                    .overlay(
                                                                        RoundedRectangle(cornerRadius: 5)
                                                                            .stroke(.secondary, lineWidth: 1)
                                                                    )
                                                                //.border
                                                                Spacer()
                                                            }
                                                        }
                                                    }//:if
                                                }//:VStack
                                                //Text("ef")
                                                .textSelection(.enabled)
                                                
                                                
                                                //Spacer()
                                                //.padding(.vertical)
                                            }//:if
                                        }//:VStack
                                        Text("    ")
                                    }//HStack
                                    .id(articles.articleKey)
                                    //Text(articles.articleKey)
                                    //print(articles.articleKey)
                                    Divider()
                                }//:ForEach
                                .font(.custom(viewFont.font, size: 17))
                            }//ScrollView
                            //.padding(.horizontal)
                            VStack {
                                ForEach(scrollIdx, id: \.self) { letter in
                                    HStack {
                                        Spacer()
                                        Button(action: {
                                            
                                            //need to figure out if there is a name in this section before I allow scrollto or it will crash
//                                            if contacts.first(where: { $0.lastName.prefix(1) == letter }) != nil {
//                                                withAnimation {
//                                                    scrollView.scrollTo(letter)
//                                                }
//                                            }0001000
                                            withAnimation{
                                                let scrollString = reAssemble(idx: letter)
                                                print("letter = \(letter)")
                                                scrollView.scrollTo(scrollString)
                                            }
                                        }, label: {
                                            VStack{
                                                Text("\(letter)")
                                                    .font(.system(size: 12))
                                                    .foregroundColor(.gray)
                                                if letter != scrollIdx.last{
                                                    Text("*")
                                                }
                                            }
                                            
                                            
                                        })
                                    }
                                }
                            }
                        }//ZStack
                    }//ScrollViewReader
                    
                    HStack{
                        Toggle("즐겨찾기만 따로 보기", isOn: $bookmarkOnly)
                            .font(.caption2)
                            .toggleStyle(.button)
                            .padding(.horizontal)
                    }
                    
                    Divider()
                    ScrollView{
                        ForEach(loadedJSONLawList.lawList, id:\.name){collection in
                            HStack{
                                if let name = loadedJSON[0].name {
                                    if collection.name == name {
                                        Image(systemName: "book")
                                            .foregroundColor(Color.accentColor)
                                            .font(.caption)
                                    } else{
                                        Image(systemName: "book.closed")
                                    }
                                }
                                Spacer()
                                Text(collection.name)
                                    .deleteDisabled(collection.undeletable)
                                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                        Button(role: .destructive){
                                            guard let index = loadedJSONLawList.lawList.firstIndex(where: {$0.name == collection.name}) else{return}
                                            loadedJSONLawList.lawList.remove(at: index)
                                            fetcher.saveJSONLawList(data: loadedJSONLawList)
                                            guard let loadedJSONLawListTemp = fetcher.loadJSONLawList() else{return}
                                            loadedJSONLawList =  loadedJSONLawListTemp
                                            actionTitle = "Move the trash"
                                        } label: { Label("Trash", systemImage: "trash.circle")
                                        }//button
                                    }
                                    .onTapGesture {
                                        guard let tempLoadedJSONLawList = fetcher.loadJSONLawList() else{return}
                                        loadedJSONLawList = tempLoadedJSONLawList
                                        
                                        if let lawIndex = loadedJSONLawList.lawList.firstIndex(where: {$0.name == collection.name}){
                                            loadedJSONCollection = loadedJSONLawList.lawList[lawIndex]
                                            lawListIndex = lawIndex
                                        }
                                        
                                        loadedJSON = loadedJSONCollection.collection
                                        
                                        lastArticleKey = loadedJSON.last?.articleKey ?? ""
                                        
                                        scrollIdxCal()
                                    }
                            }
                            Divider()
                        }
                        .onDelete(perform: removeRows)
                    
                    }//ScrollView
                    .opacity(self.memoIsEdit ? 0.3 : 1)
                    .frame(maxHeight: 160, alignment: .leading)
                    .font(.subheadline)
                }//VStack
                .padding(.horizontal)
                
            }//:VStack
            
            .task {
                guard let tempLoadedJSONLawList = fetcher.loadJSONLawList() else{return}
                loadedJSONLawList = tempLoadedJSONLawList
            }//:.task
            .navigationBarTitle(loadedJSONCollection.name)
            
        }//:NavigationView
        .searchable(text: $searchText, placement:.navigationBarDrawer(displayMode: SearchFieldPlacement.NavigationBarDrawerDisplayMode.always)) {
            ForEach(searchResults, id:\.title) { result in
                Text(result.title).searchCompletion(result.title)
                Text(result.article).searchCompletion(result.article)
            }//:ForEach
        }//:searchable
        .onSubmit(of: .search) { // 1
            print("submit")        
        }
    }//:bodyview
}//:Memecreatorview


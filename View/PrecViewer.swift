import SwiftUI

struct PrecViewer: View {
    @Environment(\.colorScheme) var scheme
    @EnvironmentObject var viewFont: fontStyle
    @EnvironmentObject var precFetcher: PrecDataCollectionFetcher
    
    @State private var searchText = String()
    @State var rating = 0
    
    @AppStorage("titleColor") var titleColor: Color = Color.primary
    @AppStorage("bodyColor") var bodyColor: Color = Color.primary
    @AppStorage("titleSize", store: .standard) var titleSize = 17 
    @AppStorage("bodySize", store: .standard) var bodySize = 17
    @AppStorage("lineSpace", store: . standard) var lineSpace = 10
    @AppStorage("font") var font: String = UserDefaults.standard.string(forKey: "font") ?? ""
    @State var loadedPrecJSON = PrecJSON.init()
    @State var loadedPrecJSONList = PrecJSONList()
    
    @State var lawListIndex = Int()
    @State var precListIndex = Int()
    
    @State private var showHolding = true
    @State private var showSummary = true
    @State private var showRefArti = true
    @State private var showRefPrec = true
    @State private var showContents = false
    
    @State private var actionTitle = "" 
    
    var body: some View {
        ZStack{
            Theme.myBackgroundColor(forScheme: scheme)
                .edgesIgnoringSafeArea(.all)
            NavigationView{
                VStack{
                    ScrollView(){
                        VStack(alignment:.leading){
                            if loadedPrecJSON.caseTitle != ""{
                                Divider()
                                HStack{
                                    Image(systemName: "paperclip")
                                    StyledText(verbatim: (loadedPrecJSON.caseTitle))
                                        .style(.highlight(), ranges:{[$0.range(of: searchText)]})
                                        .style(.bold())
                                        .foregroundColor(titleColor)
                                        .font(.custom(font, size: CGFloat(titleSize)))
                                    Spacer()
                                    //StarRankView(rank: $rating, starOneOnOff: false)
//                                    Button(action:{
//                                        if loadedPrecJSON.starRank == 0 {
//                                            loadedPrecJSON.starRank = 1
//                                            
//                                        } else if loadedPrecJSON.starRank >= 1 {
//                                            loadedPrecJSON.starRank = 0
//                                        }
//                                        loadedPrecJSONList.precList[precListIndex] = loadedPrecJSON
//                                        precFetcher.savePrecJSONList(data: loadedPrecJSONList)
//                                        
//                                        guard let tempPrecList = precFetcher.loadPrecJSONList() else{return}
//                                        loadedPrecJSONList = tempPrecList
//                                        loadedPrecJSON = loadedPrecJSONList.precList[precListIndex]
//                                    }){
//                                        if loadedPrecJSON.starRank == 0{
//                                            Image(systemName: "bookmark")
//                                        } else if loadedPrecJSON.starRank >= 1{
//                                            Image(systemName: "bookmark.fill")
//                                        }//if
//                                    }//Button
//                                    .buttonStyle(.borderedProminent)
//                                    //.background(.gray)
//                                    .cornerRadius(5)
                                }//HStack
                                
                            }//:VStack
                            
                        }//Vstack
                        .lineSpacing(CGFloat(lineSpace))
                        .multilineTextAlignment(.leading)
                        
                        VStack(alignment:.leading){
                            Group{
                                Divider()
                                HStack{
                                    Image(systemName: "folder")
                                    Text("사건번호 :")
                                    StyledText(verbatim: loadedPrecJSON.caseNumber)
                                        .style(.highlight(), ranges:{[$0.range(of: searchText)]})
                                        .style(.bold())
                                        .contextMenu(ContextMenu(menuItems: {
                                            Button("Copy", action: {
                                                UIPasteboard.general.string = loadedPrecJSON.caseNumber
                                            })
                                        }))
                                        .padding(.horizontal)
                                    
                                }
                                
                                
                                Divider()
                                HStack{
                                    Image(systemName: "folder")
                                    Text("판시사항 :")
                                    Spacer()
                                    Button(action: {
                                        withAnimation{
                                            self.showHolding.toggle()
                                        }
                                    }){
                                        Image(systemName: "chevron.forward.circle.fill")
                                            .rotationEffect(.degrees(showHolding ? 90 : 0))
                                    }
                                }
                                if showHolding {
                                    //Text(loadedPrecJSON.holding)
                                    StyledText(verbatim: loadedPrecJSON.holding)
                                        .style(.highlight(), ranges:{[$0.range(of: searchText)]})
                                        .style(.bold())
                                        .contextMenu(ContextMenu(menuItems: {
                                            Button("Copy", action: {
                                                UIPasteboard.general.string = loadedPrecJSON.holding
                                            })
                                        }))
                                }
                                
                                Divider()
                                
                                HStack{
                                    Image(systemName: "folder")
                                    Text("판결요지 :")
                                    Spacer()
                                    Button(action: {
                                        withAnimation{
                                            self.showSummary.toggle()
                                        }
                                    }){
                                        Image(systemName: "chevron.forward.circle.fill")
                                            .rotationEffect(.degrees(showSummary ? 90 : 0))
                                    }
                                }
                                if showSummary {
                                    //Text(loadedPrecJSON.summary)
                                    StyledText(verbatim: loadedPrecJSON.summary)
                                        .style(.highlight(), ranges:{[$0.range(of: searchText)]})
                                        .style(.bold())
                                        .contextMenu(ContextMenu(menuItems: {
                                            Button("Copy", action: {
                                                UIPasteboard.general.string = loadedPrecJSON.summary
                                            })
                                        }))
                                }
                                
                                Divider()
                                
                            }
                            
                            Group{
                                HStack{
                                    Image(systemName: "folder")
                                    Text("참조조문 :")
                                    Spacer()
                                    Button(action: {
                                        withAnimation{
                                            self.showRefArti.toggle()
                                        }
                                    }){
                                        Image(systemName: "chevron.forward.circle.fill")
                                            .rotationEffect(.degrees(showRefArti ? 90 : 0))
                                    }
                                }
                                if showRefArti {
                                    //Text(loadedPrecJSON.summary)
                                    StyledText(verbatim: loadedPrecJSON.refArticle)
                                        .style(.highlight(), ranges:{[$0.range(of: searchText)]})
                                        .style(.bold())
                                        .contextMenu(ContextMenu(menuItems: {
                                            Button("Copy", action: {
                                                UIPasteboard.general.string = loadedPrecJSON.refArticle
                                            })
                                        }))
                                    
                                }
                                
                                Divider()
                                HStack{
                                    Image(systemName: "folder")
                                    Text("참조판례 :")
                                    Spacer()
                                    Button(action: {
                                        withAnimation{
                                            self.showRefPrec.toggle()
                                        }
                                    }){
                                        Image(systemName: "chevron.forward.circle.fill")
                                            .rotationEffect(.degrees(showRefPrec ? 90 : 0))
                                    }
                                }
                                if showRefPrec {
                                    //Text(loadedPrecJSON.summary)
                                    StyledText(verbatim: loadedPrecJSON.refPrec)
                                        .style(.highlight(), ranges:{[$0.range(of: searchText)]})
                                        .style(.bold())
                                        .contextMenu(ContextMenu(menuItems: {
                                            Button("Copy", action: {
                                                UIPasteboard.general.string = loadedPrecJSON.refPrec
                                            })
                                        }))
                                }
                                
                                Divider()
                                
                                HStack{
                                    Image(systemName: "folder")
                                    Text("판례내용")
                                    Spacer()
                                    Button(action: {
                                        withAnimation{
                                            self.showContents.toggle()
                                        }
                                    }){
                                        HStack{
                                            Text(showContents ? "" : "더보기")
                                            Image(systemName: "chevron.forward.circle.fill")
                                                .rotationEffect(.degrees(showContents ? 90 : 0))
                                        }
                                    }
                                }
                                if showContents {
                                    //                                Text(loadedPrecJSON.contents)
                                    StyledText(verbatim: loadedPrecJSON.contents)
                                        .style(.highlight(), ranges:{[$0.range(of: searchText)]})
                                        .style(.bold())
                                        .contextMenu(ContextMenu(menuItems: {
                                            Button("Copy", action: {
                                                UIPasteboard.general.string = loadedPrecJSON.contents
                                            })
                                        }))
                                }
                            }
                        }
                        .foregroundColor(bodyColor)
                        .font(.custom(font, size: CGFloat(bodySize)))
                        .lineSpacing(CGFloat(lineSpace))
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .bottomLeading)
                        .textSelection(.enabled)
                        .font(.custom(viewFont.font, size: 17))
                        
                    }//ScrollView
                    .textSelection(.enabled)
                    
                    Divider()
                    VStack{
                        //List{
                            //Section("저장된 판례 리스트"){
                        ScrollView{
                            ForEach(loadedPrecJSONList.precList, id:\.caseTitle){prec in
                                HStack{
                                    if let number = loadedPrecJSON.caseNumber {
                                        if prec.caseNumber == number{
                                            Image(systemName: "book")
                                                .foregroundColor(Color.accentColor)
                                        } else{
                                            Image(systemName: "book.closed")
                                        }
                                    } 
//                                    Divider()
                                    //Spacer()
                                    Text(prec.caseNumber)
                                        .font(.subheadline)
                                    Spacer()
                                    Divider()
                                    Text(prec.caseTitle)
                                        .font(.subheadline)
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    Button(role: .destructive){
                                        
                                        guard let index = loadedPrecJSONList.precList.firstIndex(where: {$0.caseTitle == prec.caseTitle}) else{return}
                                        loadedPrecJSONList.precList.remove(at: index)
                                        precFetcher.savePrecJSONList(data: loadedPrecJSONList)
                                        guard let loadedPrecJSONListTemp = precFetcher.loadPrecJSONList() else{return}
                                        loadedPrecJSONList =  loadedPrecJSONListTemp
                                        
                                    } label: { Label("Trash", systemImage: "trash.circle")
                                    }//button
                                }
                                .onTapGesture {
                                    guard let tempLoadedPrecJSONList = precFetcher.loadPrecJSONList() else{return}
                                    loadedPrecJSONList = tempLoadedPrecJSONList
                                    for i in 0..<loadedPrecJSONList.precList.count{
                                        if loadedPrecJSONList.precList[i].caseTitle == prec.caseTitle {
                                            loadedPrecJSON = loadedPrecJSONList.precList[i]
                                            precListIndex = i
                                        }
                                    }
                                }
                                Divider()
                            }
                        }
                    }//List
                    .frame(minHeight: 150, maxHeight: 160, alignment: .leading)
                    .background(scheme == .dark ? Color.black : Color.white)
                    
                }//:VStack
                .padding(.horizontal)
                .background(scheme == .dark ? Color.black : Color.white)
                
                .task {
                    guard let tempLoadedPrecJSONList = precFetcher.loadPrecJSONList() else{return}
                    loadedPrecJSONList = tempLoadedPrecJSONList
                }//:.task
                
                .navigationBarTitle(loadedPrecJSON.caseNumber + " " + loadedPrecJSON.caseTitle)
            }//:NavigationView
            .searchable(text: $searchText, placement:.navigationBarDrawer(displayMode: SearchFieldPlacement.NavigationBarDrawerDisplayMode.always))
            
        }//ZStack
        
    }//:bodyview
    
}//:Memecreatorview

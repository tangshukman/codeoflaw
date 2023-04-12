//import SwiftUI
//
//struct FavoriteView: View {
//    @EnvironmentObject var viewFont: fontStyle
//    @EnvironmentObject var fetcher: LawDataCollectionFetcher
//    
//    @State var loadedJSONEach = JSON()
//    @State var loadedJSON = [JSON]()
//    @State var loadedJSONCollection = JSONCollection()
//    @State var loadedJSONLawList = JSONLawList()
//    @State var lawListIndex = Int()
//    
//    @State var addressMemo = ""
//    @State var addressName = ""
//    @State var addressTitle = ""
//    @State var addressArticle = ""
//    
//    @State var sorters = ["날짜별","법령별"]
//    @State private var selectedSort = 0
//
//    @AppStorage("titleColor") var titleColor: Color = Color.gray
//    @AppStorage("bodyColor") var bodyColor: Color = Color.white
//    @AppStorage("titleSize") var titleSize : Int = UserDefaults.standard.integer(forKey: "titleSize")
//    @AppStorage("bodySize") var bodySize : Int = UserDefaults.standard.integer(forKey: "bodySize")
//    @AppStorage("font") var font: String = UserDefaults.standard.string(forKey: "font") ?? ""
//    @AppStorage("lineSpace") var lineSpace: Int = UserDefaults.standard.integer(forKey: "lineSpace")
//    
//    @State private var editMode = EditMode.inactive
//    @State var memoIsEdit = false
//    @State var showingPopup = false
//    
//    @State var memoText = String()
//    @State var placeholder: String = "텍스트가 비어있네요"
//    
//    @State var showTerms: Bool = false
//    
//    @State var deck: Deck = Deck()
//    
//    enum Field: Hashable {
//        case memoText
//    }
//    
//    @FocusState private var focusField: Bool
//    
//    func removeRows(at offsets: IndexSet) {
//        Task{
//            loadedJSONLawList.lawList.remove(atOffsets: offsets)
//            fetcher.saveJSONLawList(data: loadedJSONLawList)
//            loadedJSONLawList = fetcher.loadJSONLawList() ?? JSONLawList()
//        }
//    }
//    
//    var memo: some View{
//        
//        VStack {
//            TextEditor(text: $memoText)
//                .padding()
//            .multilineTextAlignment(.leading)
//            .opacity(self.memoText.isEmpty ? 0.25 : 1)
//            .lineSpacing(10.0)
//            .frame(minWidth: 400, maxWidth: .infinity, minHeight: 400, maxHeight: 400)
//            .border(Color.gray, width: 8)
//            .background(Color(uiColor: .secondarySystemBackground))
//            .textSelection(.enabled)
//            
//            HStack{
//                Button(action: {
//                    if let i = loadedJSONLawList.lawList.firstIndex(where: {$0.name == addressName}){
//                        lawListIndex = i
//                        if let j = loadedJSONLawList.lawList[i].collection.firstIndex(where: {$0.title == addressTitle}){
//                            loadedJSONLawList.lawList[i].collection[j].memo = memoText
//                            fetcher.saveJSONLawList(data: loadedJSONLawList)
//                        }
//                    }
//                    fetcher.saveJSONLawList(data: loadedJSONLawList)
//                    loadedJSONLawList = fetcher.loadJSONLawList() ?? JSONLawList()
//                    memoIsEdit = false
//                }){
//                    Text("Save")
//                    Image(systemName: "arrow.down.doc")
//                }
//                .buttonStyle(.bordered)
//                .background(.blue)
//                .cornerRadius(15)
//            }
//        Spacer()
//        
//        }//VStack
//    }
//    
//    var body: some View {
//        //Text("date // name")
//        NavigationView{
//            ZStack{
//                if memoIsEdit{
//                    memo.zIndex(1)
//                }
//                VStack{
//                    //                    Button(action:{
//                    //                        //self.deck.cardPlus()
//                    //                    }){
//                    //                        Image(systemName:"note")
//                    //                    }
//                    List{
//                        ForEach(loadedJSONLawList.lawList, id:\.name){ item in 
//                            NavigationLink(destination: SortedView(lawName: item.name)){
//                                Text(item.name)
//                            }
//                            .navigationViewStyle(StackNavigationViewStyle())
//                            .navigationBarTitle("Favorite View", displayMode: .inline)
//                        }//.onDelete(perform: removeRows)
//                    }//List
//                    List{
//                        Section("전체 즐겨찾기 목록"){
//                            ForEach(loadedJSONLawList.lawList, id:\.name){ item in
//                                let rankedItem = item.collection.filter({$0.starRank>0})
//                                //Section(){
//                                ForEach(rankedItem, id:\.article){ rankedOne in
//                                    VStack{
//                                        Divider()
//                                        HStack{
//                                            Text(rankedOne.title)
//                                                .foregroundColor(titleColor)
//                                                .font(.custom(font, size: CGFloat(titleSize)))
//                                                .lineSpacing(CGFloat(lineSpace))
//                                                .multilineTextAlignment(.leading)
//                                            Divider()
//                                                .frame(height: 20)
//                                            Spacer()
//                                            Divider()
//                                                .frame(height: 20)
//                                            Text(rankedOne.name)
//                                                .fontWeight(.ultraLight)
//                                            
//                                        }
//                                        Divider()
//                                        
//                                        Text(rankedOne.article)
//                                            .foregroundColor(bodyColor)
//                                            .font(.custom(font, size: CGFloat(bodySize)))
//                                            .lineSpacing(CGFloat(lineSpace))
//                                            .multilineTextAlignment(.leading)
//                                        //.textSelection(.enabled)
//                                        
//                                        Divider()
//                                        HStack{
//                                            if rankedOne.memo != "" {
//                                                Image(systemName: "arrow.turn.down.right")
//                                                Text(rankedOne.memo)
//                                                    .foregroundColor(bodyColor)
//                                                    .font(.custom(font, size: CGFloat(bodySize)))
//                                                    .lineSpacing(CGFloat(lineSpace))
//                                                    .multilineTextAlignment(.leading)
//                                                    .textSelection(.enabled)
//                                                Spacer()
//                                            }
//                                            
//                                            HStack{
//                                                Spacer()
//                                                
//                                                Button(action:{
//                                                    memoIsEdit.toggle()
//                                                    addressName = rankedOne.name
//                                                    addressTitle = rankedOne.title
//                                                    addressArticle = rankedOne.article
//                                                    addressMemo = rankedOne.memo
//                                                    memoText = rankedOne.memo
//                                                    focusField = memoIsEdit
//                                                }, label: {
//                                                    //Image(systemName:"plus.circle.fill")
//                                                    Image(systemName:"note.text")
//                                                    Text("memo")
//                                                })
//                                                .buttonStyle(.bordered)
//                                                .background(.gray)
//                                                .cornerRadius(15)
//                                            }
//                                        }
//                                        Divider()
//                                    }//VStack
//                                }//ForEach
//                            }//ForEach
//                        }//Section
//                    }//List1
//                    
//                }//VStack
//                
//                //.navigationBarItems(leading: EditButton())
//                //.environment(\.editMode, $editMode)
//                
//            }//ZStack
//        }//Naviview
//    
//        .task{
//            if let tempLoadedJSONLawList = fetcher.loadJSONLawList(){
//                loadedJSONLawList = tempLoadedJSONLawList
//            }
//            
//        }//task
//        
//    }//bodyview
//    
//}//struct
//

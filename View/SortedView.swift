//import SwiftUI
//
//struct SortedView: View{
//    
//    @EnvironmentObject var viewFont: fontStyle
//    @EnvironmentObject var fetcher: LawDataCollectionFetcher
//    
//    //@Binding var firstNaviLinkActive: Bool
//
//    @State var loadedJSON = [JSON]()
//    @State var loadedJSONCollection = JSONCollection()
//    @State var loadedJSONLawList = JSONLawList()
//    @State var lawListIndex = Int()
//    
//    @AppStorage("titleColor") var titleColor: Color = Color.gray
//    @AppStorage("bodyColor") var bodyColor: Color = Color.white
//    @AppStorage("titleSize") var titleSize : Int = UserDefaults.standard.integer(forKey: "titleSize")
//    @AppStorage("bodySize") var bodySize : Int = UserDefaults.standard.integer(forKey: "bodySize")
//    @AppStorage("font") var font: String = UserDefaults.standard.string(forKey: "font") ?? ""
//    @AppStorage("lineSpace") var lineSpace: Int = UserDefaults.standard.integer(forKey: "lineSpace")
//    
//    @State private var sortType: Int = 0
//    @State private var sortAscending: Int = 0
//    
//    var lawName: String 
//    
//    var body: some View {
//        
//        let rankedJSON = loadedJSON.filter{$0.starRank > 0}
//        
//        let sortedJSONNameUp = rankedJSON.sorted{$0.title < $1.title}
//        let sortedJSONNameDown = rankedJSON.sorted{$0.title > $1.title}
//        let sortedJSONDateUp = rankedJSON.sorted{$0.date < $1.date}
//        let sortedJSONDateDown = rankedJSON.sorted{$0.date > $1.date}
//        
//        List(){
////            Button(action: { firstNaviLinkActive = false}, label: {
////                Text("처음 View(Test1View) 로")
////            })
//            HStack{
//                Picker("정렬 기준", selection: $sortType){
//                    Text("조문번호").tag(0)
//                    Text("추가된 날짜").tag(1)
//                }
//                if sortType == 0 {
//                    Picker("오름차순 내림차순", selection: $sortAscending){
//                        Text("오름차순").tag(0)
//                        Text("내림차순").tag(1)
//                    }
//                } else if sortType == 1{
//                    Picker("New Old", selection: $sortAscending){
//                        Text("최신").tag(0)
//                        Text("과거").tag(1)
//                    }
//                }
//            }//:HStack
//                .pickerStyle(SegmentedPickerStyle())
//            
//            Section(lawName){
//                if sortType == 0 {
//                    if sortAscending == 0 {
//                        ForEach(sortedJSONNameUp, id:\.article){sortedItem in
//                            VStack{
//                                HStack{
//                                    Text(sortedItem.title)
//                                        .foregroundColor(titleColor)
//                                        .font(.custom(font, size: CGFloat(titleSize)))
//                                        .lineSpacing(CGFloat(lineSpace))
//                                    //.frame(width: 310, alignment: .leading)
//                                        .multilineTextAlignment(.leading)
//                                    Spacer()
//                                }
//                                Spacer()
//                                Text(sortedItem.article)
//                                    .foregroundColor(bodyColor)
//                                    .font(.custom(font, size: CGFloat(bodySize)))
//                                    .lineSpacing(CGFloat(lineSpace))
//                                //.frame(width: 310, alignment: .leading)
//                                    .multilineTextAlignment(.leading)
//                            }
//                        }
//                    }else if sortAscending == 1{
//                        ForEach(sortedJSONNameDown, id:\.article){sortedItem in
//                            VStack{
//                                HStack{
//                                    Text(sortedItem.title)
//                                        .foregroundColor(titleColor)
//                                        .font(.custom(font, size: CGFloat(titleSize)))
//                                        .lineSpacing(CGFloat(lineSpace))
//                                    //.frame(width: 310, alignment: .leading)
//                                        .multilineTextAlignment(.leading)
//                                    Spacer()
//                                }
//                                Spacer()
//                                Text(sortedItem.article)
//                                    .foregroundColor(bodyColor)
//                                    .font(.custom(font, size: CGFloat(bodySize)))
//                                    .lineSpacing(CGFloat(lineSpace))
//                                //.frame(width: 310, alignment: .leading)
//                                    .multilineTextAlignment(.leading)
//                            }
//                        }
//                    }
//                } else if sortType == 1 {
//                    if sortAscending == 0 {
//                        ForEach(sortedJSONDateDown, id:\.article){sortedItem in
//                            VStack{
//                                HStack{
//                                    Text(sortedItem.title)
//                                        .foregroundColor(titleColor)
//                                        .font(.custom(font, size: CGFloat(titleSize)))
//                                        .lineSpacing(CGFloat(lineSpace))
//                                    //.frame(width: 310, alignment: .leading)
//                                        .multilineTextAlignment(.leading)
//                                    Spacer()
//                                }
//                                Spacer()
//                                Text(sortedItem.article)
//                                    .foregroundColor(bodyColor)
//                                    .font(.custom(font, size: CGFloat(bodySize)))
//                                    .lineSpacing(CGFloat(lineSpace))
//                                //.frame(width: 310, alignment: .leading)
//                                    .multilineTextAlignment(.leading)
//                            }
//                        }
//                    }else if sortAscending == 1{
//                        ForEach(sortedJSONDateUp, id:\.article){sortedItem in
//                            VStack{
//                                HStack{
//                                    Text(sortedItem.title)
//                                        .foregroundColor(titleColor)
//                                        .font(.custom(font, size: CGFloat(titleSize)))
//                                        .lineSpacing(CGFloat(lineSpace))
//                                    //.frame(width: 310, alignment: .leading)
//                                        .multilineTextAlignment(.leading)
//                                    Spacer()
//                                }
//                                Spacer()
//                                Text(sortedItem.article)
//                                    .foregroundColor(bodyColor)
//                                    .font(.custom(font, size: CGFloat(bodySize)))
//                                    .lineSpacing(CGFloat(lineSpace))
//                                //.frame(width: 310, alignment: .leading)
//                                    .multilineTextAlignment(.leading)
//                            }
//                        }
//                    }
//                }                
//            }
//        }
//        .navigationViewStyle(StackNavigationViewStyle())
//        //.navigationBarHidden(true)
//            .task{
//                guard let tempLoadedJSONLawList = fetcher.loadJSONLawList() else{return}
//                loadedJSONLawList = tempLoadedJSONLawList
//                for i in 0..<loadedJSONLawList.lawList.count{
//                    if loadedJSONLawList.lawList[i].name == lawName {
//                        loadedJSONCollection = loadedJSONLawList.lawList[i]
//                        lawListIndex = i
//                    }
//                }
//                loadedJSON = loadedJSONCollection.collection
//                print("FavoriteView loaded")
//                print("lawListIndex = \(lawListIndex)")
//            }//task
//    }
//}

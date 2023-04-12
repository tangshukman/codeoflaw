import SwiftUI

struct Viewer: View {
//    @Environment(\.colorScheme) var scheme
    @StateObject private var fetcher = LawDataCollectionFetcher()
    @StateObject private var precFetcher = PrecDataCollectionFetcher()
    
    @State private var viewSelect: Int = 0
    @State var showingPopup = false
    
    var body: some View {
//        VStack{
//            Picker("법령 판례", selection: $viewSelect){
//                Text("법령 보기").tag(0)
//                //.textSelection(.enabled)
//                Text("판례 보기").tag(1)
//            }
//            .pickerStyle(.segmented)
//            if viewSelect == 0 {
//                ArticleViewer()
//                    .environmentObject(fetcher)
//                    .environmentObject(precFetcher)
//            }else{
//                PrecViewer()
//                    .environmentObject(fetcher)
//                    .environmentObject(precFetcher)
//            }
//        }
//        ZStack{
//            Theme.myBackgroundColor(forScheme: scheme)
//                .edgesIgnoringSafeArea(.all)
            NavigationView{
                TabView{
                    ArticleViewer()
                        .environmentObject(fetcher)
                        .environmentObject(precFetcher)
                        .tabItem{
                            HStack{
                                Image(systemName: "1.square.fill")
                                Text("법령 보기")
                            }
                        }
                    
                    PrecViewer()
                        .environmentObject(fetcher)
                        .environmentObject(precFetcher)
                        .tabItem{
                            Image(systemName: "2.square.fill")
                            Text("판례 보기")
                        }
                }//.tabViewStyle(PageTabViewStyle())
            }
//        }
        
        
    }
}

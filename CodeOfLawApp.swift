import SwiftUI
//import FirebaseCore
//
//class AppDelegate: NSObject, UIApplicationDelegate {
//  func application(_ application: UIApplication,
//                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//
//    return true
//  }
//}

@main
struct CodeOfLawApp: App {
    
    //    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var viewFont = fontStyle()
    @StateObject private var fetcher = LawDataCollectionFetcher()
    @StateObject private var precFetcher = PrecDataCollectionFetcher()
    //@StateObject private var artiFetcher = ArticleFetcher()
    
    
    @State private var navigateTo = ""
    @State private var isActive = false
    
    @State var showingPopup = false
    
    @State var firstNaviLinkActive: Bool = false
    
    var body: some Scene {
        
        WindowGroup {
            //NavigationView{
            TabView{
                SearchView()
                    .environmentObject(fetcher)
                    .environmentObject(precFetcher)
                    .tabItem {
                        Label("검색", systemImage: "magnifyingglass")
                    }
                ArticleViewer()
                    .environmentObject(fetcher)
                    .environmentObject(viewFont)
                    .tabItem{
                        HStack{
                            //Image(systemName: "")
                            Image(systemName: "doc.append")
                            Text("법령 보기")
                        }
                    }
                PrecViewer()
                    .environmentObject(precFetcher)
                    .environmentObject(viewFont)
                    .tabItem{
                        Image(systemName: "doc.richtext")
                        //Image(systemName: "2.square.fill")
                        Text("판례 보기")
                    }
                FlipCardView()
                    .environmentObject(fetcher)
                    .tabItem {
                        Label("암기카드", systemImage: "menucard")
                        
                    }
                SettingView()
                    .environmentObject(viewFont)
                    .environmentObject(fetcher)
                    .environmentObject(precFetcher)
                    .tabItem {
                        Label("설정", systemImage: "gear")
                    }
//                WebContentView()
//                    .tabItem {
//                        Label("Blog", systemImage:  "globe.americas")
//                    }
            }//:TabView
            //.tabViewStyle(PageTabViewStyle())
            .navigationViewStyle(StackNavigationViewStyle())
            
        }//WindonwsGroup
    }
}

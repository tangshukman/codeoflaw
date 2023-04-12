import SwiftUI

struct SearchView: View {
    @State private var viewSelect: Int = 0
    
    var body: some View {
        VStack{
            Picker("법령 판례", selection: $viewSelect){
                Text("법령 검색").tag(0)
                Text("판례 검색").tag(1)
            }
            .pickerStyle(.segmented)
            if viewSelect == 0 {
                ArticleSearchView()
            }else{
                PrecSearchView()
            }
        }
    }
}


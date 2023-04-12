import SwiftUI
import WebKit

struct WebContentView: View {
    let webView = WebView(request: URLRequest(url: URL(string: "https://m.cafe.naver.com/codeoflaw")!))
    
    var body: some View {
        VStack {
            webView
            
            HStack {
                Spacer()
                Button(action: {
                    self.webView.goBack()
                }){
                    VStack{
                        Image(systemName: "arrow.left.circle")
                            .font(.title)
                            .foregroundColor(.gray)
                            .frame(minWidth: 40, maxWidth: 50)
                        Text("뒤로")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .frame(minWidth: 40, maxWidth: 50)
                    }
                }
                Spacer()
//                .padding()
                Button(action: {
                    self.webView.goHome()
                }){
                    VStack{
                        Image(systemName: "house")
                            .font(.title)
                            .foregroundColor(.gray)
                            .frame(minWidth: 40, maxWidth: 50)
                        Text("Home")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .frame(minWidth: 40, maxWidth: 50)
                    }
                    
                }
                Spacer()
//                .padding()
                Button(action: {
                    self.webView.refresh()
                }){
                    VStack{
                        Image(systemName: "arrow.clockwise.circle.fill")
                            .font(.title)
                            .foregroundColor(.gray)
                            .frame(minWidth: 40, maxWidth: 50)
                        Text("새로고침")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .frame(minWidth: 40, maxWidth: 50)
                    }
                }
                Spacer()
                //.padding()
                Button(action: {
                    self.webView.goForward()
                }){
                    VStack{
                        Image(systemName: "arrow.right.circle")
                            .font(.title)
                            .foregroundColor(.gray)
                            .frame(minWidth: 40, maxWidth: 50)
                        Text("앞으로")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .frame(minWidth: 40, maxWidth: 50)
                    }
                }
                Spacer()
            }
        }
    }
}

struct WebView: UIViewRepresentable {
    let request: URLRequest
    private var webView: WKWebView?
    
    init(request: URLRequest) {
        self.webView = WKWebView()
        self.request = request
    }
    
    func makeUIView(context: Context) -> WKWebView {
        return webView!
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(request)
    }
    
    func goBack(){
        webView?.goBack()
    }
    
    func goForward(){
        webView?.goForward()
    }
    
    func refresh() {
        webView?.reload()
    }
    
    func goHome() {
        webView?.load(request)
    }
}

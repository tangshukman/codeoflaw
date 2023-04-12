import SwiftUI

struct FontSettingView: View {
    @EnvironmentObject var viewFont: fontStyle
    @EnvironmentObject var fetcher: LawDataCollectionFetcher
    @EnvironmentObject var precFetcher: PrecDataCollectionFetcher
    
    @AppStorage("titleColor") var titleColor: Color = Color.primary
    @AppStorage("bodyColor") var bodyColor: Color = Color.primary
    @AppStorage("titleSize", store: .standard) var titleSize = 17 
    @AppStorage("bodySize", store: .standard) var bodySize = 17
    @AppStorage("lineSpace", store: . standard) var lineSpace = 10
    @AppStorage("font") var font: String = UserDefaults.standard.string(forKey: "font") ?? ""
    //@State
    @State private var document: MessageDocument = MessageDocument(message: "Hello, World!")
    @State private var isImporting: Bool = false
    @State private var isExporting: Bool = false
    
    @State var loadedJSONLawList = JSONLawList()
    
    @State var isShow = false
    
    var body: some View {
        //NavigationView{
            VStack{
                List{
                    Section("뷰어 설정"){
                        HStack{
                            Spacer()
                            Button(action: {
                                titleColor = Color.gray
                                bodyColor = Color.black
                                titleSize = 17
                                bodySize = 17
                                lineSpace = 5
                                font = ""
                            }){
                                Text("기본값으로 돌아가기").frame(alignment: .trailing)
                            }
                        }
                        
                        Stepper("제목 크기 : \(titleSize)", value: $titleSize, in: 5...30)
                        Stepper("본문 크기 : \(bodySize)", value: $bodySize, in: 5...30)
                        Stepper("줄 간격 : \(lineSpace)", value: $lineSpace, in: 0...15)
                        
                        ColorPicker("제목 색깔", selection: $titleColor)
                        ColorPicker("본문 색깔", selection: $bodyColor)
                        
                        ZStack{
                            FontPickerView(font: $font, isShow: $isShow)
                            HStack{
                                Text("Font Style").font(.custom(font, size: 17))
                                
                                Spacer()
                                
                                Button(action: {
                                    isShow.toggle()
                                    viewFont.font = font
                                    UserDefaults.standard.set(self.titleSize, forKey: "titleSize")
                                }, label: {
                                    Text(font != ""
                                         ? "\(font)" : "기본 서체")
                                })//:Button
                            }//:HStack
                        }//:ZStack
                    }
                        //}//:List
                    Section("미리보기"){
                        VStack{
                            Text(
"""
대한민국헌법 
[시행 1988.2.25.] [헌법 제10호, 1987.10.29., 전부개정]
전문
유구한 역사와 전통에 빛나는 우리 대한국민은 3ㆍ1운동으로 건립된 대한민국임시정부의 법통과 불의에 항거한 4ㆍ19민주이념을 계승하고,
\t\t\t\t...중략...
""")
                            .foregroundColor(bodyColor)
                            .font(.custom(font, size: CGFloat(bodySize)))
                            Text("제1장 총강\n제1조 ")
                                .foregroundColor(titleColor)
                                .font(.custom(font, size: CGFloat(titleSize)))
                            Text("① 대한민국은 민주공화국이다.\n② 대한민국의 주권은 국민에게 있고, 모든 권력은 국민으로부터 나온다.")
                                .foregroundColor(bodyColor)
                                .font(.custom(font, size: CGFloat(bodySize)))
                        }//:VStack
                        .lineSpacing(CGFloat(lineSpace))
                    }//Section
                //Divider()
                }
            }
        //}//NavigationView
        .navigationBarTitle("글씨 크기, 줄 간격 설정", displayMode: .inline)
        //.navigationViewStyle(.stack)
        //.navigationViewStyle(.stack)
        .task{
            
        }
    }//:bodyview
}

extension Color: RawRepresentable {
    
    public init?(rawValue: Int) {
        let red =   Double((rawValue & 0xFF0000) >> 16) / 0xFF
        let green = Double((rawValue & 0x00FF00) >> 8) / 0xFF
        let blue =  Double(rawValue & 0x0000FF) / 0xFF
        self = Color(red: red, green: green, blue: blue)
    }
    public var rawValue: Int {
        let red = Int(coreImageColor.red * 255 + 0.5)
        let green = Int(coreImageColor.green * 255 + 0.5)
        let blue = Int(coreImageColor.blue * 255 + 0.5)
        return (red << 16) | (green << 8) | blue
    }
    private var coreImageColor: CIColor {
        return CIColor(color: UIColor(self))
    }
}

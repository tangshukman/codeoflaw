import SwiftUI

struct Card: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let title: String
    let article: String
    let memo: String
    let date: String = ""
    let color: Color
}

struct Deck {
    @EnvironmentObject var fetcher: LawDataCollectionFetcher
    var topCardOffset: CGSize = .zero
    var activeCard: Card? = nil
    
    var cards = [Card]()   
    
    var count: Int {
        return cards.count
    }
    
    func position(of card: Card) -> Int {
        return cards.firstIndex(of: card) ?? 0
    }
    
    func scale(of card: Card) -> CGFloat {
        let deckPosition = position(of: card)
        let scale = CGFloat(deckPosition) * 0.02
        return CGFloat(1 - scale)
    }
    
    func deckOffset(of card: Card) -> CGFloat {
        let deckPosition = position(of: card)
        let offset = deckPosition * -10
        return CGFloat(offset)
    }
    
    func zIndex(of card: Card) -> Double {
        return Double(count - position(of: card))
    }
    
    func rotation(for card: Card, offset: CGSize = .zero) -> Angle {
        return .degrees(Double(offset.width) / 20.0)
    }
    
    mutating func moveToBack(_ state: Card) {
        let topCard = cards.remove(at: position(of: state))
        cards.append(topCard)
    }
    
    mutating func moveToFront(_ state: Card) {
        let topCard = cards.remove(at: position(of: state))
        cards.insert(topCard, at: 0)
    }
}

struct FlipEffect: GeometryEffect {
    
    var animatableData: Double {
        get { angle }
        set { angle = newValue }
    }
    
    @Binding var flipped: Bool
    var angle: Double
    let axis: (x: CGFloat, y: CGFloat)
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        
        DispatchQueue.main.async {
            self.flipped = self.angle >= 90 && self.angle < 270
        }
        
        let tweakedAngle = flipped ? -180 + angle : angle
        let a = CGFloat(Angle(degrees: tweakedAngle).radians)
        
        var transform3d = CATransform3DIdentity;
        transform3d.m34 = -1/max(size.width, size.height)
        
        transform3d = CATransform3DRotate(transform3d, a, axis.x, axis.y, 0)
        transform3d = CATransform3DTranslate(transform3d, -size.width/2.0, -size.height/2.0, 0)
        
        let affineTransform = ProjectionTransform(CGAffineTransform(translationX: size.width/2.0, y: size.height / 2.0))
        
        return ProjectionTransform(transform3d).concatenating(affineTransform)
    }
}

struct FrontCardView: View {
    let card: Card
    @Binding var animate3d: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                Text(card.name)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .bold()
                Spacer()
                Text("메모")
            }
            
            Divider()
            //Spacer()
            VStack(alignment: .leading){
                Text(card.title)
//                    .bold()
                ScrollView{
                    Text(card.memo)
//                        .bold()
                    Spacer()
                }
                .frame(height:250)
            }
            .font(.system(size: 15))
            .foregroundColor(.primary)
            .multilineTextAlignment(.leading)
            .padding(.horizontal)
            
            Spacer()
            
            HStack{
                Spacer()
                Button(action: {
                    withAnimation(Animation.linear(duration: 0.2)) {
                        animate3d.toggle()
                    }
                }){
                    Text("Flip")
                }
                .buttonStyle(.borderedProminent)
                Spacer()
            }
        }
        
        .padding()
        .frame(width: 300, height: 400)
        .background(
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(card.color)
        ).shadow(radius: 1)
    }
}

struct BackCardView: View {
    let card: Card
    @Binding var animate3d: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                Text(card.name)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .bold()
                Spacer()
                Text("조문")
            }
            
            Divider()
            VStack(alignment: .leading){
                Text(card.title)
//                    .bold()
                ScrollView{
                    Text(card.article)
//                        .bold()
                }
                .frame(height:250)
            }
            .font(.system(size: 15))
            //.foregroundColor(.blue)
            //.multilineTextAlignment(.leading)
            .padding(.horizontal)
            
            Spacer()
            HStack{
                Spacer()
                Button(action: {
                    withAnimation{
                        animate3d.toggle()
                    }
                }){
                    Text("Flip")
                }
                .buttonStyle(.borderedProminent)
                Spacer()
            }
            //                Spacer()
        }
        .padding()
        .frame(width: 300, height: 400)
        .background(
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(card.color)
        )
        .shadow(radius: 1)
    }
}

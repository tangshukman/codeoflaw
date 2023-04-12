import SwiftUI

struct FlipCardView: View {
    @Environment(\.colorScheme) var scheme
    @EnvironmentObject var fetcher: LawDataCollectionFetcher
    @State private var flipped = false
    @State private var animate3d = false
    
    @State var deck: Deck = Deck()
    //let card: Card
    
    var body: some View {
        
        VStack {
            Spacer()
            
            ZStack() {
                if deck.cards.isEmpty{
                    Text("NO MEMO")
                }
                ForEach(deck.cards) { card in
                    //ZStack{
                        FrontCardView(card: card, animate3d: $animate3d)
                            .opacity(flipped ? 0.0 : 1.0)
                            .zIndex(self.deck.zIndex(of: card))
                            .offset(x: self.offset(for: card).width, y: self.offset(for: card).height)
                            .offset(y: self.deck.deckOffset(of: card))
                            .scaleEffect(x: self.deck.scale(of: card), y: self.deck.scale(of: card))
                            .rotationEffect(self.rotation(for: card))
                            .gesture(
                                DragGesture()
                                    .onChanged({ (drag) in
                                        
                                        if self.deck.activeCard == nil {
                                            self.deck.activeCard = card
                                        }
                                        if card != self.deck.activeCard {return}        
                                        
                                        withAnimation(.spring()) {
                                            self.deck.topCardOffset = drag.translation
                                            if
                                                drag.translation.width < -200 ||
                                                    drag.translation.width > 200 ||
                                                    drag.translation.height < -250 ||
                                                    drag.translation.height > 250 {
                                                
                                                self.deck.moveToBack(card)
                                            } else {
                                                self.deck.moveToFront(card)
                                            }
                                        }
                                    })
                                    .onEnded({ (drag) in
                                        withAnimation(.spring()) {
                                            self.deck.activeCard = nil
                                            self.deck.topCardOffset = .zero
                                        }
                                    })
                            )
                        BackCardView(card: card, animate3d: $animate3d).opacity(flipped ? 1.0 : 0.0)
//                    }//zstack
                    .zIndex(self.deck.zIndex(of: card))
                    
                    .offset(x: self.offset(for: card).width, y: self.offset(for: card).height)
                    .offset(y: self.deck.deckOffset(of: card))
                    .scaleEffect(x: self.deck.scale(of: card), y: self.deck.scale(of: card))
                    .rotationEffect(self.rotation(for: card))
                    .gesture(
                        DragGesture()
                            .onChanged({ (drag) in
                                
                                if self.deck.activeCard == nil {
                                    self.deck.activeCard = card
                                }
                                if card != self.deck.activeCard {return}        
                                
                                withAnimation(.spring()) {
                                    self.deck.topCardOffset = drag.translation
                                    if
                                        drag.translation.width < -200 ||
                                            drag.translation.width > 200 ||
                                            drag.translation.height < -250 ||
                                            drag.translation.height > 250 {
                                        
                                        self.deck.moveToBack(card)
                                    } else {
                                        self.deck.moveToFront(card)
                                    }
                                }
                            })
                            .onEnded({ (drag) in
                                withAnimation(.spring()) {
                                    self.deck.activeCard = nil
                                    self.deck.topCardOffset = .zero
                                }
                            })
                    )
                    
                }
                
            }//ZStack
            .modifier(FlipEffect(flipped: $flipped, angle: animate3d ? 180 : 0, axis: (x: 1, y: 0)))
//            .onTapGesture {
//                withAnimation(Animation.linear(duration: 0.2)) {
//                    self.animate3d.toggle()
//                }
//            }
            Spacer()
        }
        
        .task{
//            if let tempLoadedJSONLawList = fetcher.loadJSONLawList(){
//                loadedJSONLawList = tempLoadedJSONLawList
//            }
            self.deck.cards.removeAll()
            cardPlus()
        }//task
        
    }//body
    
    func offset(for card: Card) -> CGSize {
        if card != self.deck.activeCard {return .zero}
        
        return deck.topCardOffset
    }
    
    func rotation(for card: Card) -> Angle {
        guard let activeCard = self.deck.activeCard
        else {return .degrees(0)}
        
        if card != activeCard {return .degrees(0)}
        
        return deck.rotation(for: activeCard, offset: deck.topCardOffset)
    }
    
    func cardPlus(){
        if let tempLoadedJSONLawList = fetcher.loadJSONLawList(){
            //loadedJSONLawList = tempLoadedJSONLawList
            for i in 0..<tempLoadedJSONLawList.lawList.count {
                for j in 0..<tempLoadedJSONLawList.lawList[i].collection.count {
                    if tempLoadedJSONLawList.lawList[i].collection[j].memo != "" {
                        deck.cards.append(
                            Card(name: tempLoadedJSONLawList.lawList[i].collection[j].name, title: tempLoadedJSONLawList.lawList[i].collection[j].title, article: tempLoadedJSONLawList.lawList[i].collection[j].article, memo: tempLoadedJSONLawList.lawList[i].collection[j].memo, color: (scheme == .dark) ? .black : .white))
                    }
                }
            }
        }
    }
}
//    .background((scheme == .dark) ? .black : .white)

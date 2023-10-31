//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by sam hastings on 27/10/2023.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    var viewModel: EmojiMemoryGame
    
    static let emojiThemes = ["halloween": ["🎃","💀", "🧙‍♀️", "👹","👿","👺","⚰️","🕸️","🦇","🔮","🕯️","🖤"],
                       "animals": ["🐶","🐱","🐭","🐹","🐰","🦊","🐻","🐼","🐻‍❄️","🐨","🐯","🦁"],
                       "plants": ["🌵","🎄","🌳","🌴","🪵","🌱","🍁","🎍","🍃","🍄","🍀","🌿"]]
    
    var body: some View {
        VStack {
            Text("Memorize").font(.title)
            ScrollView {
                cards
            }
            themeButtons
        }
        .padding()
    }
    
    @State private var emojis: [String] = emojiThemes[Theme.halloween.rawValue]!

    
    func generateEmojis(forTheme theme: Theme, maxPairs: Int = 4) -> [String] {
        let maxLength = min(max(maxPairs, 4), 6)
        let selectedEmojis = EmojiMemoryGameView.emojiThemes[theme.rawValue]!.shuffled().prefix(maxLength)
        return (selectedEmojis + selectedEmojis).shuffled()
    }
    
    var themeButtons: some View {
        HStack{
            themeButton(for: .halloween, withSymbol: "moon.fill")
            Spacer()
            themeButton(for: .plants, withSymbol: "leaf.fill")
            Spacer()
            themeButton(for: .animals, withSymbol: "pawprint.fill")
        }
        .padding()
        .font(.largeTitle)
    }
    
    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))]) {
            ForEach(0..<emojis.count, id: \.self) {index in
                CardView(content: emojis[index])
                    .aspectRatio(2/3, contentMode: .fit)
            }
        }
        .foregroundColor(.red)
    }
    
    func themeButton(for theme: Theme, withSymbol symbol: String) -> some View {
        Button(action: {
            emojis = generateEmojis(forTheme: theme, maxPairs: 6)
        }, label: {
            VStack{
                Image(systemName: symbol)
                Text(theme.rawValue).font(.footnote)
            }
        })
        .foregroundColor(.red)
    }
    
}

struct CardView: View {
    @State var isFaceUp = true
    let content: String
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
            Group {
                base.foregroundColor(.white)
                base.strokeBorder(lineWidth: 2)
                Text(content).font(.largeTitle)
            }
            .opacity(isFaceUp ? 1 : 0)
            base.opacity(isFaceUp ? 0 : 1)
        }
        .onTapGesture {
            isFaceUp.toggle()
        }
    }
}

enum Theme: String {
    case halloween, animals, plants
}




#Preview {
    EmojiMemoryGameView()
}

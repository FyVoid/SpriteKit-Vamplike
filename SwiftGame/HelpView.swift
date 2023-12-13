import SwiftUI

struct HelpView: View {
    struct Page {
        var imageName: String
        var description: String
    }
    
    var pages: [Page]
    @State private var currentPage = 0
    
    var body: some View {
        TabView(selection: $currentPage) {
            ForEach(0..<pages.count, id: \.self) { index in
                ZStack {
                    Color.gray
                        .edgesIgnoringSafeArea(.all)
                    
                    ZStack {
                        Image(pages[index].imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 1000)
                        
                        Text(pages[index].description)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.orange)
                            .padding()
                    }
                }
                .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        let pages: [HelpView.Page] = [
            HelpView.Page(imageName: "photo", description: "Page 1 Description"),
            HelpView.Page(imageName: "book", description: "Page 2 Description"),
            HelpView.Page(imageName: "star", description: "Page 3 Description"),
        ]
        
        HelpView(pages: pages)
    }
}

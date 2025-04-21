import SwiftUI

struct CommentView: View {
    let comment: Comment
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(comment.author)
                    .font(.headline)
                    .padding(.leading)
                Spacer()
            }
            
            Text(comment.content)
                .padding(.leading)
        }
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 2)
    }
}


#Preview {
    CommentView(comment: Comment(content: "Comment here ... and here ... and here ...", author: "johndoe"))
}

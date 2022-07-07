//
//  SwiftUIView.swift
//  NoteApp
//
//  Created by Тимофей Лукашевич on 30.06.22.
//

import SwiftUI

struct SwiftUIView: View {
    var body: some View {
        Group {
            if Bool.random() {
                Rectangle()
            } else {
                ProgressView()
                    .foregroundColor(.orange)
            }
        }
        .onAppear {
            print("dffff")
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}

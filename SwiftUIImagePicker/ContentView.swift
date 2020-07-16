//
//  ContentView.swift
//  SwiftUIImagePicker
//
//  Created by Henry Havens on 7/16/20.
//  Copyright © 2020 Henry Havens. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var showActionSheet = false
    @State var showImagePicker = false
    
    @State var sourceType:UIImagePickerController.SourceType = .camera
    
    @State var image:UIImage?
    
    var body: some View {
        VStack {
            if image != nil {
                Image(uiImage: image!)
                .resizable()
                .scaledToFit()
                    .frame(width: 300, height: 300)
            } else {
                Image(systemName: "person.circle")
                .resizable()
                .scaledToFit()
                    .frame(width: 300, height: 300)
            }
            
            Button(action: {
                self.showActionSheet.toggle()
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
                    .shadow(radius: 3)
                    .opacity(0.7)
                    .padding()
            }.actionSheet(isPresented: $showActionSheet){
                ActionSheet(title: Text("Add a picture to your post"),
                            message: nil, buttons: [.default(Text("Camera"),
                                action: {
                                self.showImagePicker = true
                                self.sourceType = .camera
                            }),
                                .default(Text("Photo Library"),
                                    action: {
                                    self.showImagePicker = true
                                    self.sourceType = .photoLibrary
                            }),
                                .cancel()
                ])
            }.sheet(isPresented: $showImagePicker) {
                imagePicker(image: self.$image, showImagePicker: self.$showImagePicker, sourceType: self.sourceType)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

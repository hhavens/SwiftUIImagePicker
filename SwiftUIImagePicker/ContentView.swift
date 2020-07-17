//
//  ContentView.swift
//  SwiftUIImagePicker
//
//  Created by Henry Havens on 7/16/20.
//  Copyright © 2020 Henry Havens. All rights reserved.
//

import SwiftUI
import FirebaseStorage

struct ContentView: View {
    
    @State var showActionSheet = false
    @State var showImagePicker = false
    
    @State var sourceType:UIImagePickerController.SourceType = .camera
    
    @State var upload_image:UIImage?
    @State var download_image:UIImage?
    
    var body: some View {
        VStack {
            HStack {
            if upload_image != nil {
                Image(uiImage: upload_image!)
                .resizable()
                .scaledToFit()
                    .frame(width: 120, height: 120)
            } else {
                Image(systemName: "person.circle")
                .resizable()
                .scaledToFit()
                    .frame(width: 120, height: 120)
            }
                Spacer()
            if download_image != nil {
                    Image(uiImage: download_image!)
                    .resizable()
                    .scaledToFit()
                        .frame(width: 120, height: 120)
                } else {
                    Image(systemName: "person.circle")
                    .resizable()
                    .scaledToFit()
                        .frame(width: 120, height: 120)
                }
            }.padding()
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
                imagePicker(image: self.$upload_image, showImagePicker: self.$showImagePicker, sourceType: self.sourceType)
            }
            Button(action: {
                if let thisImage = self.upload_image {
                    uploadImage(image: thisImage)
                } else {
                    print("Couldn't upload image - No image present")
                }
            }) {
                Text("Upload Image")
            }
            
            Button(action: {
                Storage.storage().reference().child("temp").getData(maxSize: 3 * 1024 * 1024) {
                    (imageData, err) in
                    if let err = err {
                        print("An error has occurred - \(err.localizedDescription)")
                    } else {
                        if let imageData = imageData {
                            self.download_image = UIImage(data: imageData)
                        } else {
                            print("Couldn't unwrap image data image")
                        }
                    }
                }
            }) {
                Text("Download Image")
            }
        }
    }
}

func uploadImage(image:UIImage){
    if let imageData = image.jpegData(compressionQuality: 1){
        let storage = Storage.storage()
        storage.reference().child("temp").putData(imageData, metadata: nil){
            (_, err) in
            if let err = err {
                print("An error has occurred - \(err.localizedDescription)")
            } else {
                print("Image uploaded successfully")
            }
        }
    } else {
        print("Couldn't unwrap image to data")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//  PhotoViewer.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 8/17/24.
//  Copyright © 2024 Javad Mammadbayli. All rights reserved.
//

import IQKeyboardManager
import JMessageInput
import LazyPager
import SwiftUI

extension UIImage: Identifiable {}

@objc protocol PhotoViewerDelegate {
    func photoViewerDidConfirm(text: String?, items: [UIImage])
    func photoViewerDidCancel()
    func photoViewerDidDeletePhotoAtIndex(index: Int)
    func photoViewerControllerDidAskForMorePhotos()
}

class PhotoViewerViewModel: ObservableObject {
    @Published var images: [UIImage]
    @Published var index: Int = 0
    @Published var isPresented = true
    @Published var hasTextInput = true
    @Published var hasPlusbutton = true
    weak var delegate: PhotoViewerDelegate?

    var showReel: Bool {
        images.count > 1
    }

    init(images: [UIImage] = PhotoViewerViewModel.testData,
         delegate: PhotoViewerDelegate? = nil) {
        self.images = images
        self.delegate = delegate
    }

    func removeImage(at index: Int) {
        images.remove(at: index)

        if self.index > 0 {
            self.index -= 1
        }

        delegate?.photoViewerDidDeletePhotoAtIndex(index: index)
    }

    func dismiss() {
        isPresented.toggle()
    }
}
extension PhotoViewerViewModel: JMessageInputDelegate {
    func plusButtonPressed(input: JMessageInput) {
        delegate?.photoViewerControllerDidAskForMorePhotos()
    }

    func sendButtonPressed(input: JMessageInput) {
        let text = (input.text?.isEmpty ?? false) ? nil : input.text
        delegate?.photoViewerDidConfirm(text: text, items: images)
        dismiss()
    }
    
    func inputWillChangeFrame(input: JMessageInput, frame: CGRect) {

    }

    func inputDidChangeFrame(input: JMessageInput, frame: CGRect) {

    }
}

private extension PhotoViewerViewModel {
    static var testData: [UIImage] {
        let data1 = NSData(contentsOf: URL(string: "https://images.pexels.com/photos/884788/pexels-photo-884788.jpeg?auto=compress&cs=tinysrgb&w=800")!)!
        let image1 = UIImage(data: data1 as Data)!

        let data2 = NSData(contentsOf: URL(string: "https://images.pexels.com/photos/1266810/pexels-photo-1266810.jpeg?auto=compress&cs=tinysrgb&w=800")!)!
        let image2 = UIImage(data: data2 as Data)!

        let data3 = NSData(contentsOf: URL(string: "https://images.pexels.com/photos/673857/pexels-photo-673857.jpeg?auto=compress&cs=tinysrgb&w=800")!)!
        let image3 = UIImage(data: data3 as Data)!

        let data4 = NSData(contentsOf: URL(string: "https://images.pexels.com/photos/1169084/pexels-photo-1169084.jpeg?auto=compress&cs=tinysrgb&w=800")!)!
        let image4 = UIImage(data: data4 as Data)!

        return [image1, image2, image3, image4]
    }
}

struct PhotoViewer: View {
    @ObservedObject var viewModel: PhotoViewerViewModel

    init(viewModel: PhotoViewerViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        zStack
        .onAppear {
            IQKeyboardManager.shared().isEnabled = false
        }
        .onDisappear {
            IQKeyboardManager.shared().isEnabled = true
        }
    }

    @ViewBuilder
    private var zStack: some View {
        ZStack(alignment: .bottom) {
            pager

            VStack {
                HStack {
                    Spacer()
                    Button {
                        viewModel.delegate?.photoViewerDidCancel()
                    } label: {
                        Image(systemName: "xmark")
                            .tint(.nfsGreen)
                            .scaleEffect(CGSize(width: 1.3, height: 1.3))
                    }
                }
                .padding(20)

                Spacer()

                VStack {
                    if viewModel.showReel {
                        smallImages
                    }

                    messageInput()
                        .frame(idealHeight: 50, maxHeight: 150)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.top, 10)
                .background(
                    LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.15)]),
                                   startPoint: .top,
                                   endPoint: .bottom)
                )
            }
        }
    }

    private var pager: some View {
        LazyPager(data: viewModel.images, page: $viewModel.index) { element in
            Image(uiImage: element)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        .zoomable(min: 1, max: 5)
        .onTap {
            self.endTextEditing()
        }
        .onDismiss{
            viewModel.dismiss()
        }
        .frame(maxHeight: .infinity)
        .ignoresSafeArea()
        .background(.black)
    }

    private var smallImages: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { scroll in
                HStack(spacing: 10) {
                    ForEach(Array(viewModel.images.enumerated()), id: \.offset) { index, element in
                        smallImageView(uiImage: element, for: index)
                            .id(index)
                    }

                    Spacer()
                }
                .padding(.leading, 40)
                .onReceive(viewModel.$index.debounce(for: .seconds(0.05), scheduler: DispatchQueue.main)) { index in
                    withAnimation {
                        scroll.scrollTo(index, anchor: .center)
                    }
                }
            }
        }
    }

    private func smallImageView(uiImage image: UIImage, for index: Int) -> some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 60, height: 60)
            .cornerRadius(5) // Inner corner radius
            .padding(2) // Width of the border
            .background(viewModel.index == index ? .white : .clear) // Color of the border
            .cornerRadius(5) // Outer corner radius
            .onTapGesture {
                withAnimation(.easeInOut) {
                    viewModel.index = index
                }
            }
            .overlay {
                if viewModel.index == index {
                    Button(action: {
                        withAnimation(.easeInOut) {
                            viewModel.removeImage(at: index)
                        }
                    }, label: {
                        Image(systemName: "trash")
                            .resizable()
                            .aspectRatio(contentMode: .fit)                        .frame(width: 30)
                    })
                    .tint(.white)
                    .shadow(color:.black, radius: 10)
                }
            }
    }

    private func messageInput() -> some View {
        let input = JMessageInput()
        input.translatesAutoresizingMaskIntoConstraints = true
        input.layer.borderWidth = 0
        input.tintColor = .nfsGreen()
        input.state = .dirty
        input.textView.inputAccessoryView = UIView()
        input.plusButton.isHidden = !viewModel.hasPlusbutton
        input.textView.isHidden = !viewModel.hasTextInput
        input.delegate = viewModel
        input.maxTextHeight = 40

        return JMessageInputWrapper(input: input)
    }
}

struct JMessageInputWrapper: UIViewRepresentable {
    let input: JMessageInput

    func makeUIView(context: Context) -> JMessageInput {
        return input
    }

    func updateUIView(_ input: JMessageInput, context: Context) {
        
    }
}

@objc class PhotoViewerContainer: NSObject {
    @objc var hasPlusButton: Bool {
        get {
            viewModel.hasPlusbutton
        }
        set(val) {
            viewModel.hasPlusbutton = val
        }
    }
    @objc var hasTextInput: Bool {
        get {
            viewModel.hasTextInput
        }
        set(val) {
            viewModel.hasTextInput = val
        }
    }
    @objc weak var delegate: PhotoViewerDelegate? {
        get {
            viewModel.delegate
        }
        set(val) {
            viewModel.delegate = val
        }
    }
    @objc var items: [UIImage] {
        get {
            viewModel.images
        }
        set(val) {
            viewModel.images = val
        }
    }

    @objc var viewController: UIViewController!
    private let viewModel = PhotoViewerViewModel()

    @objc func create() {
        viewController = HostingViewController(rootView: PhotoViewer(viewModel: viewModel))
    }
}

#Preview {
    return PhotoViewer(viewModel: PhotoViewerViewModel())
}

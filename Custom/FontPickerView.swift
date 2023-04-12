import SwiftUI

struct FontPickerView: UIViewControllerRepresentable {
    //@Published var font: String
    @Binding var font : String
    @Binding var isShow : Bool
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, font: font)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<FontPickerView>) -> UIViewController {
        return UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<FontPickerView>) {
        if isShow{
            let configuration = UIFontPickerViewController.Configuration()
            configuration.includeFaces = true
            configuration.displayUsingSystemFont = true
            configuration.filteredTraits = [.classModernSerifs]
            
            let picker = UIFontPickerViewController()
            picker.delegate = context.coordinator
            picker.title = "select Font"
            
            uiViewController.present(picker, animated: true, completion: {isShow.toggle()
            })
        }
    }
}

class Coordinator : NSObject, UIFontPickerViewControllerDelegate {
    var fontView : FontPickerView
    var font : String
    
    init(_ control : FontPickerView, font: String){
        self.fontView = control
        self.font = font
    }
    func fontPickerViewControllerDidPickFont(_ viewController: UIFontPickerViewController) {
        guard let discriptor = viewController.selectedFontDescriptor else{
            return
        }
        let selectedFont = UIFont(descriptor: discriptor, size: 30)
        fontView.font = selectedFont.fontName
    }
}

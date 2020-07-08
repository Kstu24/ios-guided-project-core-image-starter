import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins
import Photos

class PhotoFilterViewController: UIViewController {

    //MARK: - Outlets
	@IBOutlet weak var brightnessSlider: UISlider!
	@IBOutlet weak var contrastSlider: UISlider!
	@IBOutlet weak var saturationSlider: UISlider!
	@IBOutlet weak var imageView: UIImageView!
    
    //MARK: - Properties
    var origionalImage: UIImage? {
        didSet {
            updateImage()
        }
    }
    
    private let context = CIContext()
    private let filter = CIFilter.colorControls()
	
	override func viewDidLoad() {
		super.viewDidLoad()
        let filter = CIFilter.gaussianBlur()
        print(filter.attributes)
        origionalImage = imageView.image
	}
    
    //MARK: - Methods
    private func image(byFiltering image: UIImage) -> UIImage {
        let inputImage = CIImage(image: image)
        filter.inputImage = inputImage
        filter.saturation = saturationSlider.value
        filter.contrast = contrastSlider.value
        filter.brightness = brightnessSlider.value
        
        guard let outputImage = filter.outputImage else { return image }
        guard let renderCGImage = context.createCGImage(outputImage, from: outputImage.extent) else { return image }
        
        return UIImage(cgImage: renderCGImage)
    }
    
    private func updateImage() {
        if let origionalImage = origionalImage {
            imageView.image = image(byFiltering: origionalImage)
        } else {
            imageView.image = nil
        }
    }
    
    private func presentImagePickerController() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("Could not access photo library.")
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
	// MARK: Actions
	
	@IBAction func choosePhotoButtonPressed(_ sender: Any) {
		presentImagePickerController()
	}
	
	@IBAction func savePhotoButtonPressed(_ sender: UIButton) {
		// TODO: Save to photo library
	}
	

	// MARK: Slider events
	
	@IBAction func brightnessChanged(_ sender: UISlider) {
        updateImage()
	}
	
	@IBAction func contrastChanged(_ sender: Any) {
        updateImage()
	}
	
	@IBAction func saturationChanged(_ sender: Any) {
        updateImage()
	}
}

extension PhotoFilterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            origionalImage = image
        } else if let image = info[.originalImage] as? UIImage {
            origionalImage = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}


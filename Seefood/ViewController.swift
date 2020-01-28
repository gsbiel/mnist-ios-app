//
//  ViewController.swift
//  Seefood
//
//  Created by user161182 on 1/28/20.
//  Copyright © 2020 user161182. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        imagePicker.delegate = self
        // Define que o nosso imagePicker esta destinado a pegar uma imagem da camera.
        imagePicker.sourceType = .camera
        // Se voce quisesse que o imagePicker abrisse a galeria de fotos do usuario, bastaria usar o atributo abaixo
        //imagePicker.souceType = .photoLibrary
        // Nao permite ao usuario editar a foto escolhida
        imagePicker.allowsEditing = false
    }
    
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        // Abre o imagePicker no app, que, no caso, e a camera do usuario.
        present(imagePicker, animated: true, completion: nil)
    }

}

// O protocolo UIImagePickerControllerDelegate precisa do UINavigationControllerDelegate
// Ambos permitem o acesso a camera, bem como a captura de uma imagem tirada da camera
extension ViewController : UIImagePickerControllerDelegate {
    
    // Assim que o usuario tira uma foto com o imagePicker e decide usa-la, esse metodo e chamado.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // info e um dicionario, dentro dele esta a imagem que o usuario escolheu.
        if let imagePicked = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            //Agora vamos inserir a imagem no ImageView do nosso StoryBoard
            imageView.image = imagePicked
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
}

extension ViewController: UINavigationControllerDelegate {
    
}


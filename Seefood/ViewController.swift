//
//  ViewController.swift
//  Seefood
//
//  Created by user161182 on 1/28/20.
//  Copyright © 2020 user161182. All rights reserved.
//

import UIKit

//Framework para lidar com modelos de Machine Learning
import CoreML
//Framework para processar imagens
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
    
    func detect(image : CIImage){
        
        // O metodo abaixo carrega um modelo que esta representado por classe (no formato .ml) e o transforma em um tipo CoreML.
        guard let model = try? VNCoreMLModel(for: MNISTClassifier().model) else {
            fatalError("Loading CoreMLModel failed.")
        }
        
        // Aqui estamos configurando uma requisicao que vai ser feita em um modelo. Assim que for feita, programamos o que vai acontecer no closure abaixo.
        let request = VNCoreMLRequest(model: model) { (request, error) in
            
            // Os resultados da requisicao estao dentro de um array. Os dados do array estao Upcasted para o tipo Any.
            // Vamos fazer um DownCasting do array para o tipo [VNClassificationObservation]
            guard let results = request.results as? [VNClassificationObservation] else{
                fatalError("Model failed to process image")
            }
            
            // Aqui ja podemos acessar os resultados das observacoes feitas sobre a imagem
            // results e um array de observacoes, cada observacao tem uma taxa de confiabilidade em ordem decrescente.
            // A que nos interessa geralmente e a primeira!
            print(results)
            if let firstResult = results.first {
                self.navigationItem.title =  "Voce escreveu o numero: \(firstResult.identifier)"
            }
        }
        //Aqui criamos o gerenciados da requisicao, que vai pegar a imagem e entregar a request.
        let handler = VNImageRequestHandler(ciImage: image)
        
        do{// Aqui realizamos a request
            try handler.perform([request])
        }catch{
            print("Error handling request. \(error)")
        }
    }
}

// O protocolo UIImagePickerControllerDelegate precisa do UINavigationControllerDelegate
// Ambos permitem o acesso a camera, bem como a captura de uma imagem tirada da camera
extension ViewController : UIImagePickerControllerDelegate {
    
    // Assim que o usuario tira uma foto com o imagePicker e decide usa-la, esse metodo e chamado.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // info e um dicionario cujos valores estao UpCasted para o tipo "any", dentro dele esta a imagem que o usuario escolheu.
        if let imagePicked = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            //Agora vamos inserir a imagem no ImageView do nosso StoryBoard
            imageView.image = imagePicked
            
            //CIImage e um metodo que converte imagens do tipo UIImage em CoreImage.
            //CoreImage e o formato de imagem que a framework Vision usa para processar imagens, aplicar filtros etc...
            guard let ciImage = CIImage(image: imagePicked) else {
                fatalError("Cannot convert image to Core Image datatype")
            }
            
            detect(image : ciImage)
            
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
}

extension ViewController: UINavigationControllerDelegate {
    
}


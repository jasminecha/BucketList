//
//  CaptureViewController.swift
//  GraduateList
//
//  Created by Jasmine Cha on 10/25/15.
//  Copyright © 2015 Jasmine Cha. All rights reserved.
//  Tutorial from - https://github.com/DriveCurrent/photo-picker

import UIKit
import AVFoundation

class CaptureViewController: UIViewController {

    // MARK: Properties
//    @IBOutlet weak var blankView: UIView!
    @IBOutlet weak var cameraView: UIImageView!
    @IBOutlet weak var blankView: UIView!
    
    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?

    
    // MARK: Actions
    @IBAction func cancel(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func done(segue:UIStoryboardSegue) {
        // currently does the same thing as cancel hehe
    }

    
    @IBAction func didPressTakePhoto(sender: UIButton) {
        if let videoConnection = stillImageOutput!.connectionWithMediaType(AVMediaTypeVideo){
            stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {(sampleBuffer, error) in
                if(sampleBuffer != nil){
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let dataProvider = CGDataProviderCreateWithCFData(imageData)
                    let cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, CGColorRenderingIntent.RenderingIntentDefault)
                    
                    let image = UIImage(CGImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.Right)
                    self.cameraView.image = image
                }
                
            })
        }
    }
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        captureSession = AVCaptureSession()
        captureSession!.sessionPreset = AVCaptureSessionPresetPhoto
        
        let backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        let input = try! AVCaptureDeviceInput(device: backCamera)
        captureSession?.addInput(input)
        stillImageOutput = AVCaptureStillImageOutput()
        stillImageOutput!.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        
        
        if captureSession!.canAddOutput(stillImageOutput){
            captureSession!.addOutput(stillImageOutput)
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            blankView.layer.addSublayer(previewLayer!)
            previewLayer!.frame = blankView.bounds
            
            captureSession!.startRunning()
        }
    }
    
    override func viewDidAppear(animated: Bool){
        super.viewDidAppear(animated)
        previewLayer!.frame = blankView.bounds
    }
    
}

//
//  CameraCaptureViewController.swift
//  Medchat
//
//  Created by Srihari Mohan on 10/20/16.
//  Copyright © 2016 Srihari Mohan. All rights reserved.
//

import UIKit
import AVFoundation

class CameraCaptureViewController: UIViewController {

    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var didTakePhoto = Bool()
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var tempImageView: UIImageView!
    @IBOutlet weak var talk: UIButton!
    
    override func viewDidLayoutSubviews() {
        previewLayer?.frame = CGRectMake(0, CGRectGetMinY(cameraView.bounds), UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = AVCaptureSessionPreset1920x1080
        let backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        var input: AVCaptureDeviceInput
        do {
            try input = AVCaptureDeviceInput(device: backCamera)
        } catch { return; }
        
        guard let captureSession = captureSession else {
            return;
        }
        
        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
            stillImageOutput = AVCaptureStillImageOutput()
            stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
            if captureSession.canAddOutput(stillImageOutput) {
                captureSession.addOutput(stillImageOutput)
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
                previewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.Portrait
                guard let previewLayer = previewLayer else {
                    return;
                }
                cameraView.layer.addSublayer(previewLayer)
                captureSession.startRunning()
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func didPressTakePhoto() {
        if let videoConnection = stillImageOutput?.connectionWithMediaType(AVMediaTypeVideo) {
            videoConnection.videoOrientation = AVCaptureVideoOrientation.Portrait
            stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConnection) {
                (sampleBuffer, error) in
                
                if sampleBuffer != nil {
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let dataProvider = CGDataProviderCreateWithCFData(imageData)
                    let cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, CGColorRenderingIntent.RenderingIntentDefault)
                    if let cgImageRef = cgImageRef {
                        let image = UIImage(CGImage: cgImageRef, scale: 1.0, orientation: UIImageOrientation.Right)
                        self.tempImageView.image = image
                        self.tempImageView.hidden = false
                    }
                }
            }
        }
    }
    
    func didPressTakeAnother() {
        if didTakePhoto {
            captureSession?.startRunning()
            tempImageView.hidden = true
            didTakePhoto = false
        } else {
            captureSession?.startRunning()
            didTakePhoto = true
            didPressTakePhoto()
            captureSession?.stopRunning()
        }
    }
}

//
//  VINScanViewController.swift
//  AnylineExamples
//


import Foundation
import UIKit

import Anyline

class VINScanViewController: UIViewController, ALOCRScanPluginDelegate {
    
    // The Anyline plugins used to scan
    var vinScanViewPlugin : ALOCRScanViewPlugin!;
    var vinScanPlugin : ALOCRScanPlugin!;
    var scanView : ALScanView!;
    
    let kVINScanLicenseKey = "eyAiZGVidWdSZXBvcnRpbmciOiAib2ZmIiwgImlvc0lkZW50aWZpZXIiOiBbICJjb20uYW55bGluZS5Td2lmdFRlc3RBcHAiIF0sICJsaWNlbnNlS2V5VmVyc2lvbiI6IDIsICJtYWpvclZlcnNpb24iOiAiNCIsICJtYXhEYXlzTm90UmVwb3J0ZWQiOiAwLCAicGluZ1JlcG9ydGluZyI6IGZhbHNlLCAicGxhdGZvcm0iOiBbICJpT1MiIF0sICJzY29wZSI6IFsgIkFMTCIgXSwgInNob3dQb3BVcEFmdGVyRXhwaXJ5IjogZmFsc2UsICJzaG93V2F0ZXJtYXJrIjogdHJ1ZSwgInRvbGVyYW5jZURheXMiOiA2MCwgInZhbGlkIjogIjIwMjItMTItMzEiIH0KeVFPcEJuQ0RIVm9LaFk1YkowMGpsOWdyb1RSVnFrME9PbDJ4N3M5NWllcHRTOC95aU1HK0JvditMeGI5NWdzbwpiNld1YVI4RHFXSXpvL3B5TW1iMUVXMTE3QmVBVm9Hek5GRHFybHE3UjBSU0dpT1Z3VzJGYTEzQkJWU0lZVXRNCnhoOXZ6ZGN5ZFluckpuRUFWYVhSTjFDdDdwQmU3bkJnNnFhalJmWG1FMGJMbUtKTDhPVlV3amNsd2h4TGtacGYKSUV5RTJkOVNVWllZOEZjaThXWmd3Szl4SzROU1BIQ3RzTFp2Q0d1N1gvOUdzekVuUlk1bDdReFNMTE1hUEd3SQp1VTdoUFlsWEJZMXY5RGNORk41SktwT3cxWW5ITTY3azRTWEtmL3d0MlZvaUtEZzFoOEh6NUtCbVZsVWpvSHllCng1c203YjJtQmROTEdrc3J6N3VQVFE9PQo=";
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // Set the background color to black to have a nicer transition
        self.view.backgroundColor = UIColor.black
        
        self.title = "VIN";
    
        //Load Anyline Files (script)
        guard let aleFilePath: String = Bundle.main.path(forResource: "vin", ofType: "ale") else {
            assertionFailure("Script file not found")
            return
        }
        //Load Anyline Files (model)
        guard let modelFilePath: String = Bundle.main.path(forResource: "vin", ofType: "any") else {
            assertionFailure("Model File file not found")
            return
        }
    
        // Initializing the energy module. Its a UIView subclass. We set its frame to fill the whole screen
        do {
            let ocrConfig = ALOCRConfig.init()
            ocrConfig.scanMode = ALOCRScanMode.ALAuto
            //Set custom script filePath
            ocrConfig.customCmdFilePath = aleFilePath
            //Set custom model filePath
            try ocrConfig.setLanguages([modelFilePath], error: ())
            
            //Create ScanPlugin with ALOCRConfig
            self.vinScanPlugin = try ALOCRScanPlugin.init(pluginID: "VIN", licenseKey: kVINScanLicenseKey, delegate: self, ocrConfig: ocrConfig)
            
            //Load UI config json file
            guard let uiConfigFilePath: String = Bundle.main.path(forResource: "vin_capture_config", ofType: "json") else {
                assertionFailure("UI Config file not found")
                return
            }
            
            //Parse
            guard let uiConfig = ALScanViewPluginConfig.init(jsonFilePath: uiConfigFilePath) else {
                assertionFailure("UI Config file not parsable")
                return
            }
            
            self.vinScanViewPlugin = ALOCRScanViewPlugin.init(scanPlugin: self.vinScanPlugin, scanViewPluginConfig: uiConfig)
            self.scanView = ALScanView.init(frame: self.view.bounds, scanViewPlugin: self.vinScanViewPlugin);
        } catch {
            //Handle error here
            print("Setup error: \(error.localizedDescription).")
        }
      
        //Add Anyline to view hierachy
        self.view.addSubview(self.scanView);
        //Start Camera with Anyline
        self.scanView.startCamera();
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        
        //Stop Anyline
        do {
            try self.vinScanViewPlugin.stop();
        } catch {
            print("Stop error: \(error.localizedDescription).")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        //Start Anyline
        do {
            try self.vinScanViewPlugin.start();
        } catch {
            print("Start error: \(error.localizedDescription).")
        }
    }
    
    func anylineOCRScanPlugin(_ anylineOCRScanPlugin: ALOCRScanPlugin, didFind result: ALOCRResult) {
        print("VIN Result: \(result).")
    }
}

import Foundation
import UIKit

import Anyline

class DocumentScanViewController: UIViewController, ALDocumentScanPluginDelegate, ALInfoDelegate, ALDocumentInfoDelegate, ALScanViewPluginDelegate {
    
    let licenseKey = "eyAiZGVidWdSZXBvcnRpbmciOiAib2ZmIiwgImlvc0lkZW50aWZpZXIiOiBbICJjb20uYW55bGluZS5Td2lmdFRlc3RBcHAiIF0sICJsaWNlbnNlS2V5VmVyc2lvbiI6IDIsICJtYWpvclZlcnNpb24iOiAiNCIsICJtYXhEYXlzTm90UmVwb3J0ZWQiOiAwLCAicGluZ1JlcG9ydGluZyI6IGZhbHNlLCAicGxhdGZvcm0iOiBbICJpT1MiIF0sICJzY29wZSI6IFsgIkFMTCIgXSwgInNob3dQb3BVcEFmdGVyRXhwaXJ5IjogZmFsc2UsICJzaG93V2F0ZXJtYXJrIjogdHJ1ZSwgInRvbGVyYW5jZURheXMiOiA2MCwgInZhbGlkIjogIjIwMjItMTItMzEiIH0KeVFPcEJuQ0RIVm9LaFk1YkowMGpsOWdyb1RSVnFrME9PbDJ4N3M5NWllcHRTOC95aU1HK0JvditMeGI5NWdzbwpiNld1YVI4RHFXSXpvL3B5TW1iMUVXMTE3QmVBVm9Hek5GRHFybHE3UjBSU0dpT1Z3VzJGYTEzQkJWU0lZVXRNCnhoOXZ6ZGN5ZFluckpuRUFWYVhSTjFDdDdwQmU3bkJnNnFhalJmWG1FMGJMbUtKTDhPVlV3amNsd2h4TGtacGYKSUV5RTJkOVNVWllZOEZjaThXWmd3Szl4SzROU1BIQ3RzTFp2Q0d1N1gvOUdzekVuUlk1bDdReFNMTE1hUEd3SQp1VTdoUFlsWEJZMXY5RGNORk41SktwT3cxWW5ITTY3azRTWEtmL3d0MlZvaUtEZzFoOEh6NUtCbVZsVWpvSHllCng1c203YjJtQmROTEdrc3J6N3VQVFE9PQo="
    
    // Add the Anyline OCR Plugins
    var documentScanViewPlugin:ALDocumentScanViewPlugin!
    var documentScanPlugin:ALDocumentScanPlugin!
    var scanView:ALScanView!
    
    var showingLabel: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        title = "Scan Document"
        
        do {
            // Initialise the Scan Plugin
            documentScanPlugin = try ALDocumentScanPlugin.init(pluginID: "DOCUMENT", licenseKey: licenseKey, delegate: self)
            
            // Initialise the Scan View Plugin
            documentScanViewPlugin = ALDocumentScanViewPlugin.init(scanPlugin: documentScanPlugin)
            
            // Initialise the Scan View
            scanView = ALScanView.init(
                frame: view.bounds,
                scanViewPlugin: documentScanViewPlugin,
                cameraConfig: ALCameraConfig.defaultDocument()!,
                flashButtonConfig: ALFlashButtonConfig.defaultFlash())
        } catch let error {
            print("Initialization error: \(error.localizedDescription)")
        }
        
        documentScanPlugin.postProcessingEnabled = true
//        documentScanViewPlugin.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the view and start the camera
        view.addSubview(scanView)
        view.sendSubviewToBack(scanView)
        scanView.startCamera()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        do {
            try self.documentScanViewPlugin.start()
        } catch let error {
            print("Start error: \(error.localizedDescription)")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        do {
            try self.documentScanViewPlugin.stop();
        } catch {
            print("Stop error: \(error.localizedDescription)")
        }
    }
    
    // This is the main delegate method Anyline uses to display its results
    func anylineDocumentScanPlugin(_ anylineDocumentScanPlugin: ALDocumentScanPlugin, hasResult transformedImage: UIImage, fullImage fullFrame: UIImage, documentCorners corners: ALSquare) {
        let viewController = UIViewController()
        viewController.view.frame = self.view.bounds;
        let imageView = UIImageView(frame: viewController.view.bounds)
        imageView.center = CGPoint(x: imageView.center.x, y: imageView.center.y + 30)
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.image = transformedImage
        viewController.view.addSubview(imageView)
        
        if ((self.navigationController) != nil) {
            self.navigationController?.pushViewController(viewController, animated: true)
        } else {
            self.present(viewController, animated: true) {};
        }
    }    
}

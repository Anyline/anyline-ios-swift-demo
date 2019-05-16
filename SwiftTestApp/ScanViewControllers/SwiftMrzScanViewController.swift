import Foundation
import UIKit

import Anyline

class SwiftMrzScanViewController: UIViewController ,ALIDPluginDelegate {

    // The Anyline plugins used to scan
    var mrzScanViewPlugin : ALIDScanViewPlugin!;
    var mrzScanPlugin : ALIDScanPlugin!;
    var scanView : ALScanView!;

    let kIDScanLicenseKey = "eyAiZGVidWdSZXBvcnRpbmciOiAib2ZmIiwgImlvc0lkZW50aWZpZXIiOiBbICJjb20uYW55bGluZS5Td2lmdFRlc3RBcHAiIF0sICJsaWNlbnNlS2V5VmVyc2lvbiI6IDIsICJtYWpvclZlcnNpb24iOiAiNCIsICJtYXhEYXlzTm90UmVwb3J0ZWQiOiAwLCAicGluZ1JlcG9ydGluZyI6IGZhbHNlLCAicGxhdGZvcm0iOiBbICJpT1MiIF0sICJzY29wZSI6IFsgIkFMTCIgXSwgInNob3dQb3BVcEFmdGVyRXhwaXJ5IjogZmFsc2UsICJzaG93V2F0ZXJtYXJrIjogdHJ1ZSwgInRvbGVyYW5jZURheXMiOiA2MCwgInZhbGlkIjogIjIwMjItMTItMzEiIH0KeVFPcEJuQ0RIVm9LaFk1YkowMGpsOWdyb1RSVnFrME9PbDJ4N3M5NWllcHRTOC95aU1HK0JvditMeGI5NWdzbwpiNld1YVI4RHFXSXpvL3B5TW1iMUVXMTE3QmVBVm9Hek5GRHFybHE3UjBSU0dpT1Z3VzJGYTEzQkJWU0lZVXRNCnhoOXZ6ZGN5ZFluckpuRUFWYVhSTjFDdDdwQmU3bkJnNnFhalJmWG1FMGJMbUtKTDhPVlV3amNsd2h4TGtacGYKSUV5RTJkOVNVWllZOEZjaThXWmd3Szl4SzROU1BIQ3RzTFp2Q0d1N1gvOUdzekVuUlk1bDdReFNMTE1hUEd3SQp1VTdoUFlsWEJZMXY5RGNORk41SktwT3cxWW5ITTY3azRTWEtmL3d0MlZvaUtEZzFoOEh6NUtCbVZsVWpvSHllCng1c203YjJtQmROTEdrc3J6N3VQVFE9PQo="

    override func viewDidLoad() {
        super.viewDidLoad();

        // Set the background color to black to have a nicer transition
        self.view.backgroundColor = UIColor.black

        self.title = "Passport Scanning";


        // Initializing the energy module. Its a UIView subclass. We set its frame to fill the whole screen
        do {
            self.mrzScanPlugin = try ALIDScanPlugin.init(pluginID: "MRZ_PLUGIN", licenseKey: kIDScanLicenseKey, delegate: self, idConfig: ALMRZConfig.init())

            self.mrzScanViewPlugin = ALIDScanViewPlugin.init(scanPlugin: self.mrzScanPlugin)
            self.scanView = ALScanView.init(frame: self.view.bounds, scanViewPlugin: self.mrzScanViewPlugin);
        } catch let error {
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
            try self.mrzScanViewPlugin.stop();
        } catch {
            //Handle error here
            print("Stop error: \(error.localizedDescription).")
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);

        //Start Anyline
        do {
            try self.mrzScanViewPlugin.start();
        } catch let error {
            //Handle error here
            print("Start error: \(error.localizedDescription).")
        }
    }


    func anylineIDScanPlugin(_ anylineIDScanPlugin: ALIDScanPlugin, didFind scanResult: ALIDResult<AnyObject>) {
        let mrzResult = scanResult.result as! ALMRZIdentification

        //Handle MRZ result here:
        // ...
        // ...
        print("MRZ resul: givenNames:\(mrzResult.givenNames) \n surNames:\(mrzResult.surNames) \n documentNumber:\(mrzResult.documentNumber)")
    }
}

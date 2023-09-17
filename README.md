<p align="center">
<img src="Assets/ATFaceDetectCamera.png" " alt="ATFaceDetectCamera Logo" />

## About
ATFaceDetectCamera have some custom views for face detection using:
  - AVFoundation for accessing Camera
  - Vision for Face detection

## Usage
All of cameraView is UIView's subview so you are flexible in building new custom UI
- For normal camera view
```swift
 let cameraView: ATCameraViewInterface = ATFaceDetectCameraHandler.shared.createNormalCamera()
```

- For TrueDepth camera view
```swift
 let cameraView: ATCameraViewInterface = ATFaceDetectCameraHandler.shared.ATTrueDepthCameraView()
```

## Delegate
Set delegate to get face image data 
```swift      
do {
  try cameraView.setDelegate(self)
} catch let err as NSError {
    print(err)
}       
```
- Normal Camera Delegation:
```swift      
extension ViewController: ATTrueDepthCameraDelegate {
    func cameraViewOutput(sender: ATCameraViewInterface, result: ATNormalResult) {
        
    }
    
    func cameraViewOutput(sender: ATCameraViewInterface, invalidFace: VNFaceObservation, invalidType: ATFaceState) {
        
    } 
}   
```
- TrueDepth Camera Delegation:
```swift      
extension ViewController: ATTrueDepthCameraDelegate {
    func cameraViewOutput(sender: ATCameraViewInterface, result: ATTrueDepthResult) {
        
    }
    
    func cameraViewOutput(sender: ATCameraViewInterface, invalidFace: VNFaceObservation, depthData: AVDepthData, invalidType: ATFaceState) {
        
    } 
}   
```

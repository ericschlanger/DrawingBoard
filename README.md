DrawingBoard
============

Final Project for HCI Class. Collaborative drawing board iPhone application.

Features
---
1. Onscreen drawing
2. Numerous brush sizes & color
3. Connect to other iOS devices via Bluetooth/WiFi
4. Pan around canvas
5. Undo functionality
6. Save & Share Drawing to Photo Library, Facebook, Twitter, iMessage, Mail, AirDrop
7. Stable & Memory Efficient

Models
---
1. FancyPoint - Wrapper class for drawn point (contains point, color, opacity, strokeID)

Views
---
1. CanvasScrollView - Custom UIScrollView that supports UIGestureRecognizers in its content
2. RNGridMenu - Grid-style popup used for intro help menu
3. DMRNotificationView - Unintrusive popup used for notifying upon connect/disconnect
4. NKOColorPickerView - Traditional photoshop-esque color picker

Controllers
---
1. MPCHandler - Controls multipeer connectivity framework
2. SplashViewController - View controller for splash animations
3. CanvasViewController - View controller for drawing (main screen)
4. OptionViewController - View controller for options popover
5. WYPopoverController - Allows popovers on iPhone & iPad
6. UIAlertView+Blocks - Category that adds block support to UIAlertView

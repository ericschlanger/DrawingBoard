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
FancyPoint - Wrapper class for drawn point (contains point, color, opacity, strokeID)

Views
---
CanvasScrollView - Custom UIScrollView that supports UIGestureRecognizers in its content
RNGridMenu - Grid-style popup used for intro help menu
DMRNotificationView - Unintrusive popup used for notifying upon connect/disconnect
NKOColorPickerView - Traditional photoshop-esque color picker

Controllers
---
MPCHandler - Controls multipeer connectivity framework
SplashViewController - View controller for splash animations
CanvasViewController - View controller for drawing (main screen)
OptionViewController - View controller for options popover
WYPopoverController - Allows popovers on iPhone & iPad
UIAlertView+Blocks - Category that adds block support to UIAlertView

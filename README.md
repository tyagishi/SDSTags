# SDSTags

library for Tags incl. views.

## Protocol
- TagProtocol
  protocol for tag element
- Taggable
   protocol for the element which can have (multiple) tags

## View
- EditableTag
   combined TagField/TagView
   with click, toggle TagField/TagView

- TagField / SwiftUI (only for macOS, based on NSTokenField)
   View for editing Taggable-element tags.
   
- TagView / SwiftUI
   View for showing Tags
   

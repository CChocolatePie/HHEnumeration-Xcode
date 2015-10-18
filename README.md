<p align="center" >
<img src="bugEnding.png" title="bugEnding Organization logo" float=left>
</p>
<p>
Try our best to be lazy but easier to code!
</p>

### What is it?
This plugin is used to autocompletion prefix of enum members for Objective-C


### What effects does it make?
#### before
![before](https://raw.githubusercontent.com/bugEnding/HHEnumeration-xcode/master/before.gif)
#### after
![after](https://raw.githubusercontent.com/bugEnding/HHEnumeration-xcode/master/after.gif)

### How to use?
- Download HHEnumeration and build the target.
- It will be installed this folder  by default:          
`~/Library/Application Support/Developer/Shared/Xcode/Plug-ins`
- Xcode version 6.1+

### What? it doesn't work?
- Be sure the plugin can be installed in this folder
   (`~/Library/Application Support/Developer/Shared/Xcode/Plug-ins`)
- Command + Q quit Xcode,when open again you may have this dialogue
   please click `load bundle`

   ![dialogue](https://raw.githubusercontent.com/bugEnding/HHEnumeration-xcode/master/img/loadbundle.jpeg)
- Follow me,open plug-ins folder

   ![showpackage](https://raw.githubusercontent.com/bugEnding/HHEnumeration-xcode/master/img/showpackage.png)
   ![replace1](https://raw.githubusercontent.com/bugEnding/HHEnumeration-xcode/master/img/replace1.png)
   ![replace2](https://raw.githubusercontent.com/bugEnding/HHEnumeration-xcode/master/img/replace2.png)
- What? you don't have any other plugin?

   open `terminal` run this `defaults read /Applications/Xcode.app/Contents/Info DVTPlugInCompatibilityUUID`
   to get your current Xcode's UUID, and add this UUID to plugin  Info.plist->DVTPlugInCompatibilityUUIDs 
   ![addUUID](https://raw.githubusercontent.com/bugEnding/HHEnumeration-xcode/master/img/addUUID.png)
    


### License
The MIT License (MIT)

Copyright (c) 2015 

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
<p align="center" >
<img src="img/bugEnding.png" title="bugEnding Organization logo" float=left>
</p>
<p>
Try our best to be lazy but easier to code!
</p>

-
### What is it?
This plugin is used to autocompletion prefix of enum members for Objective-C

-
### What effects does it make?
#### before
![before](https://raw.githubusercontent.com/bugEnding/HHEnumeration-xcode/master/img/before.gif)
#### after
![after](https://raw.githubusercontent.com/bugEnding/HHEnumeration-xcode/master/img/after.gif)

-
### How to use?
- Use [Alcatraz](https://github.com/supermarin/Alcatraz) to install.Or download HHEnumeration and build the target.
- It will be installed this folder  by default:          
`~/Library/Application Support/Developer/Shared/Xcode/Plug-ins`
- Xcode version 6.1+
- Tips:HHEnumeration depends on IDEIndex,Xcode will auto update the IDEIndex when you open a project,
so it will take some seconds. And if you found it doesn't work please use `Command + S` IDEIndex will be updated too.

-
### What? it doesn't work?
- Be sure the plugin can be installed in this folder
   (`~/Library/Application Support/Developer/Shared/Xcode/Plug-ins`)
- Command + Q quit Xcode,when open again you may have this dialogue
   please click `load bundle`
<br/> ![dialogue](https://raw.githubusercontent.com/bugEnding/HHEnumeration-xcode/master/img/loadbundle.jpeg)
- Follow me,open plug-ins folder
<br/> ![showpackage](https://raw.githubusercontent.com/bugEnding/HHEnumeration-xcode/master/img/showpackage.png)
 ![replace1](https://raw.githubusercontent.com/bugEnding/HHEnumeration-xcode/master/img/replace1.png)
 ![replace2](https://raw.githubusercontent.com/bugEnding/HHEnumeration-xcode/master/img/replace2.png)
- What? you don't have any other plugin?
  open `terminal` run this `defaults read /Applications/Xcode.app/Contents/Info DVTPlugInCompatibilityUUID`
  to get your current Xcode's UUID, and add this UUID to plugin  Info.plist->DVTPlugInCompatibilityUUIDs 
<br/> ![addUUID](https://raw.githubusercontent.com/bugEnding/HHEnumeration-xcode/master/img/addUUID.png)
    

-
### The MIT License (MIT) [More](https://raw.githubusercontent.com/bugEnding/HHEnumeration-xcode/master/LICENSE)

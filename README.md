<p align="center" >
<img src="img/bugEnding.png" title="bugEnding Organization logo" float=left>
</p>

-
### What is it?
This plugin is used to autocompletion enum members for Objective-C

-
###Important
Please delete old version plugin<br/>
`~/Library/Application Support/Developer/Shared/Xcode/Plug-ins`<br/>
use `rm -r ~/Library/Application\ Support/Developer/Shared/Xcode/Plug-ins/HHEnumeration.xcplugin` in `terminal`
New version will be installed here<br/>
`~/Library/Developer/Xcode/Plug-ins`

-
### What effects does it make?
![after](https://raw.githubusercontent.com/bugEnding/HHEnumeration-xcode/master/img/after-new.gif)

-
### How to use?
- Use [Alcatraz](https://github.com/supermarin/Alcatraz) to install.Or download HHEnumeration and build the target.
- It will be installed this folder  by default:     
`~/Library/Developer/Xcode/Plug-ins`
- Xcode version 6.1+
- Tips:<br/>
HHEnumeration depends on IDEIndex,Xcode will auto update the IDEIndex when you open a project,
so it will take some seconds. And if you found it doesn't work please use `Command + S` IDEIndex will be updated too.<br/>
- support enum that define  `typedef NS_ENUM( , )` and `typedef NS_OPTIONS( , )`

-
### What? it doesn't work?
- Be sure the plugin can be installed in this folder
   (`~/Library/Developer/Xcode/Plug-ins`)
- Command + Q quit Xcode,when open again you may have this dialogue
   please click `load bundle`
- open `terminal` run this `defaults read /Applications/Xcode.app/Contents/Info DVTPlugInCompatibilityUUID`
  to get your current Xcode's UUID, and add this UUID to plugin project  Info.plist->DVTPlugInCompatibilityUUIDs 
    <br/> rebuild it.
<br/> ![addUUID](https://raw.githubusercontent.com/bugEnding/HHEnumeration-xcode/master/img/addUUID.png)
    

-
### The MIT License [More](https://raw.githubusercontent.com/bugEnding/HHEnumeration-xcode/master/LICENSE)

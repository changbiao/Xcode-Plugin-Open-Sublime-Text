Xcode Open In Sublime Text
==============================

![Open In Sublime Text](https://raw.githubusercontent.com/ryanmeisters/Xcode-Plugin-Open-Sublime-Text/master/Misc/OpenInSublimeText.gif)

Open In Sublime Text is a simple xcode plugin to quickly open a source file in Sublime Text from Xcode. Of course, you can just drag the file from the Xcode navigator onto the Sublime Text icon in your dock, but that's a lot of work. This plugin adds a `Open In Sublime Text` menu item to Xcode's Editor menu, which can be easily mapped to a convenient keyboard shortcut. 

![Open In Sublime Text Editor Menu](https://raw.githubusercontent.com/ryanmeisters/Xcode-Plugin-Open-Sublime-Text/master/Misc/OpenInSublimeTextMenu.png)


#Installation
1. Install the plugin. This can be done in 2 ways:

    1. Install [Alcatraz](http://alcatraz.io) and search for `OpenInSublimeText`, or
    2. Clone this repository, open `OpenInSublimeText.xcodeproj`, build, and restart xcode
2. Assign a keyboard shortcut to `Open In Sublime Text` for Xcode in the OSX Keyboard System Preferences. 

-----
Tested in Xcode 5.1.1 + with Sublime Text 3

###Known Limitations
- This plugin assumes the existence of `/Applications/Sublime Text.app` (the default for Sublime Text 3), and there is not currently a way to override that assumption.


###### And my Xcode6.3(6D570) UUID is 9F75337B-21B4-4ADC-B558-F9CADF7073A7;
###### Xcode IDEKit.h has changed；So I edit OSTUtil.h:
```
IDEWorkspaceWindowController* OSTLastActiveWindowController(){
// TODO: Must update IDEKit.h for Xcode5
static IDEWorkspaceWindowController* workspace = nil;
if ([[IDEWorkspaceWindow class] respondsToSelector:@selector(lastActiveWorkspaceWindow)])
{   //for Xcode6.3
workspace = [IDEWorkspaceWindow performSelector:@selector(lastActiveWorkspaceWindow)];
}
else if([[IDEWorkspaceWindow class] respondsToSelector:@selector(lastActiveWorkspaceWindowController)])
{
workspace = [IDEWorkspaceWindow performSelector:@selector(lastActiveWorkspaceWindowController)];
}
NSLog(@"插件获取工作区控制器: %@", workspace);
return workspace;
}
```
*Thanks for the plugin, so helpful!*


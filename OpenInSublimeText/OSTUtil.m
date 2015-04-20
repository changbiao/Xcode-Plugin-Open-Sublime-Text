//
//  OSTUtil.m
//  OpenInSublimeText
//
//  Created by Ryan Meisters on 9/17/14.
//  Copyright (c) 2014 Ryan M. All rights reserved.
//
//  Borrowed from XVim Xcode Plugin :)

#import "OSTUtil.h"
#import "DVTFoundation.h"
#import "DVTKit.h"
#import "IDEKit.h"

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

IDEWorkspaceTabController* OSTLastActiveWorkspaceTabController(){
    return [OSTLastActiveWindowController() activeWorkspaceTabController];
}

IDEEditorArea* OSTLastActiveEditorArea(){
    return [OSTLastActiveWindowController() editorArea];
}

DVTSourceTextView* OSTLastActiveSourceView(){
    return [[[[OSTLastActiveEditorArea() lastActiveEditorContext] editor] mainScrollView] documentView];
}

@implementation OSTUtil

@end

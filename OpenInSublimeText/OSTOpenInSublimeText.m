//
//  OSTOpenInSublimeText.m
//  OSTOpenInSublimeText
//
//  Created by Ryan Meisters on 9/16/14.
//    Copyright (c) 2014 Ryan M. All rights reserved.
//

#import "OSTOpenInSublimeText.h"

#import "OSTUtil.h"
#import "IDEKit.h"

#import "NSTextStorage+VimOperation.h"

typedef struct OSTCursorLocation {
    NSUInteger line;
    NSUInteger column;
}CursorLocation;

static OSTOpenInSublimeText *sharedPlugin;

static NSString * const kOSTMenuItemTitle = @"在Sublime Text中打开";

@interface OSTOpenInSublimeText()

@property (nonatomic, strong) NSBundle *bundle;

@property (nonatomic, strong) NSTimer *menuConfigTimer;

@property (nonatomic) dispatch_queue_t queue;

@end

@implementation OSTOpenInSublimeText

+ (void)pluginDidLoad:(NSBundle *)plugin {
    
    static dispatch_once_t onceToken;
    
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[self alloc] initWithBundle:plugin];
        });
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithBundle:(NSBundle *)plugin {
    if (self = [super init]) {
        // reference to plugin's bundle, for resource acccess
        self.bundle = plugin;
        NSLog(@"初始化插件包:%@", plugin);
        [self registerForNotifications];
    }
    return self;
}

#pragma mark - Notifications

- (void) registerForNotifications {
    NSLog(@"注册监听通知信息");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidBecomeKey:) name:NSWindowDidBecomeKeyNotification object:nil];
}

- (void) windowDidBecomeKey:(NSNotification *)notification {
    NSLog(@"接收到通知:%@", notification);
    [self setupMenuIfNeeded];
}

#pragma mark - OST Menu Item Setup

- (void) setupMenuIfNeeded {
    
    NSMenu *editorMenu = [[[NSApp mainMenu] itemWithTitle:@"Editor"] submenu];
    NSLog(@"安装设置插件，当前菜单：%@", editorMenu);
    // Add the menu item if it isn't there already
    if (![editorMenu itemWithTitle:kOSTMenuItemTitle]) {
        [self addOSTMenuItemToMenu:editorMenu];
    }
}

- (void) addOSTMenuItemToMenu:(NSMenu *)menu {
    
    [menu addItem:[NSMenuItem separatorItem]];
    NSMenuItem *ostMenuItem = [[NSMenuItem alloc] initWithTitle:kOSTMenuItemTitle action:@selector(menuItemClicked) keyEquivalent:@"s"];
    [ostMenuItem setTarget:self];
    [menu addItem:ostMenuItem];
}

- (void) menuItemClicked {
    [self openCurrentFileWithSublimeTextAtLocation:[self currentCursorLocation]];
}


#pragma mark - Open In Sublime Text

- (void) openCurrentFileWithSublimeTextAtLocation:(CursorLocation)location {
    
    self.queue = dispatch_queue_create("io.rhm.OpenInSublimeText", NULL);
    
    NSString *path = [NSString stringWithFormat:@"%@:%lu:%lu", [self currentFilePath],location.line, location.column];
    
    dispatch_async(self.queue, ^{
        
        NSLog(@"OST: Openning %@ in Sublime Text", path);
        
        NSTask *task = [[NSTask alloc] init];
        
        task.launchPath = @"/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl";
        
        task.arguments = @[path, @"--wait"];
        
        task.terminationHandler = ^(NSTask *aTask){
            // dispatch_async(dispatch_get_main_queue(), ^{
           
            // });
        };

        [task launch];
        [task waitUntilExit];
    });
}

#pragma mark - Utility

- (NSString *) currentFilePath {
    
    IDEEditorArea *area = OSTLastActiveEditorArea();
    
    IDEEditorContext *context = area.lastActiveEditorContext;

    IDEEditor *editor = context.editor;
    
    IDEEditorDocument *doc = editor.document;

    NSURL *url = doc.fileURL;
    
    return url.path;
}

- (CursorLocation) currentCursorLocation {
    
    CursorLocation location;
    
    id docView = OSTLastActiveSourceView();
    NSLog(@"OST: Document view class -- %@", [docView class]);
    
    if ([docView isKindOfClass:[DVTSourceTextView class]]) {
        
        DVTSourceTextView *view = (DVTSourceTextView *)docView;
        
        NSInteger cursorIndex = [[[view selectedRanges] objectAtIndex:0] rangeValue].location;
        
        location.line = [view _currentLineNumber];

        location.column = [view.textStorage xvim_columnOfIndex:cursorIndex];
    }
    
    return location;
}


@end

//
//  TKOAppDelegate.m
//  TKOSidebarDemo
//
//  Created by Todd Olsen on 4/7/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOAppDelegate.h"
#import "TKOSidebarView.h"

@interface TKOAppDelegate ()
@property (nonatomic) TKOSidebarView * sidebarView;

@property (weak) IBOutlet NSBox *studentsView;
@property (weak) IBOutlet NSBox *assignementsView;
@property (weak) IBOutlet NSBox *problemsView;
@property (weak) IBOutlet NSBox *listsView;
@property (weak) IBOutlet NSBox *formatsView;
@property (weak) IBOutlet NSBox *tagsView;
@property (weak) IBOutlet NSBox *trashView;

@end

@implementation TKOAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.sidebarView = [[TKOSidebarView alloc] initWithFrame:[self.window.contentView bounds]];

    [self.sidebarView addSidebarViewItem:[[TKOSidebarViewItem alloc] initWithTitle:@"Students" icon:[NSImage imageNamed:@"TKOStudentsTemplate"] view:self.studentsView gravity:NSStackViewGravityTop]];
    [self.sidebarView addSidebarViewItem:[[TKOSidebarViewItem alloc] initWithTitle:@"Assignments" icon:[NSImage imageNamed:@"TKOAssignmentsTemplate"] view:self.assignementsView gravity:NSStackViewGravityTop]];
    [self.sidebarView addSidebarViewItem:[[TKOSidebarViewItem alloc] initWithTitle:@"Problems" icon:[NSImage imageNamed:@"TKOProblemsTemplate"] view:self.problemsView gravity:NSStackViewGravityTop]];
    [self.sidebarView addSidebarViewItem:[[TKOSidebarViewItem alloc] initWithTitle:@"Lists" icon:[NSImage imageNamed:@"TKOListsTemplate"] view:self.listsView gravity:NSStackViewGravityTop]];
    [self.sidebarView addSidebarViewItem:[[TKOSidebarViewItem alloc] initWithTitle:@"Formats" icon:[NSImage imageNamed:@"TKOFormatsTemplate"] view:self.formatsView gravity:NSStackViewGravityTop]];
    [self.sidebarView addSidebarViewItem:[[TKOSidebarViewItem alloc] initWithTitle:@"Tags" icon:[NSImage imageNamed:@"TKOTagsTemplate"] view:self.tagsView gravity:NSStackViewGravityTop]];
    [self.sidebarView addSidebarViewItem:[[TKOSidebarViewItem alloc] initWithTitle:@"Trash" icon:[NSImage imageNamed:@"TKOTrashTemplate"] view:self.trashView gravity:NSStackViewGravityBottom]];

    [self.sidebarView selectFirstTabViewItem:nil];
    [self.sidebarView setDelegate:self];
    [self.window setContentView:self.sidebarView];
}

- (void)sidebarViewWillChangeSelection:(NSNotification *)notification
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)sidebarViewDidChangeSelection:(NSNotification *)notification
{
    NSLog(@"%s", __PRETTY_FUNCTION__);    
}


@end

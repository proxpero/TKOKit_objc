//
//  TKOFontInspectorViewController.m
//  TKOFontInspectorViewDemo
//
//  Created by Todd Olsen on 2/8/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOFontInspectorViewController.h"
#import "TKOTextView.h"
#import "TKOTextStorage.h"
#import "TKOColorPickerView.h"

@interface TKOFontInspectorViewController () <NSTextViewDelegate>

@property (strong, nonatomic) NSString * selectedFontFamilyName;
@property (strong, nonatomic) NSString * selectedFontFaceName;
@property (nonatomic) CGFloat selectedFontSize;

@property (weak) IBOutlet NSPopUpButton *fontFamilyPopUpButton;
@property (weak) IBOutlet NSPopUpButton *fontFacePopUpButton;
@property (weak) IBOutlet NSTextField *fontSizeTextField;
@property (weak) IBOutlet NSSegmentedControl *fontTraitsSegmentedControl;
@property (weak) IBOutlet TKOColorPickerView *foregroundTextColorPicker;

- (IBAction)selectFontFamilyAction:(id)sender;
- (IBAction)selectFontFaceAction:(id)sender;
- (IBAction)modifyFontSizeAction:(id)sender;
- (IBAction)modifyFontTraitsAction:(id)sender;
- (IBAction)modifyForegroundTextColorAction:(id)sender;

@end

@implementation TKOFontInspectorViewController

- (id)init
{
    self = [super initWithNibName:@"TKOFontInspectorViewController"
                           bundle:nil];
    if (!self)
        return nil;
    
    return self;
}

- (void)awakeFromNib
{
    [self setupFontFamilies];
}

- (void)setDelegate:(id<TKOFontInspectorDelegate>)delegate
{
    if (_delegate == delegate)
        return;
    
    NSNotificationCenter * defaultCenter = [NSNotificationCenter defaultCenter];
    
    if (_delegate && [_delegate respondsToSelector:@selector(fontInspectorDidModifyFontFamily:)])
        [defaultCenter removeObserver:_delegate
                                 name:TKOFontInspectorDidModifyFontFamilyNotification
                               object:self];
    _delegate = delegate;
    if (_delegate && [_delegate respondsToSelector:@selector(fontInspectorDidModifyFontFamily:)])
        [defaultCenter addObserver:_delegate
                          selector:@selector(fontInspectorDidModifyFontFamily:)
                              name:TKOFontInspectorDidModifyFontFamilyNotification
                            object:self];
}

- (void)textViewDidChangeFont:(NSNotification *)notification
{
    NSFontManager * fontManager = [NSFontManager sharedFontManager];
    BOOL isMultiple = [fontManager isMultiple];
    if (isMultiple) {
        
    }
    NSFont * font = [fontManager selectedFont];
    NSFontDescriptor * fd = [font fontDescriptor];
    
    [self setSelectedFontFamilyName:[fd objectForKey:NSFontFamilyAttribute]];
    [self setSelectedFontFaceName:[fd objectForKey:NSFontFaceAttribute]];
    [self setSelectedFontSize:[font pointSize]];
    [self.fontTraitsSegmentedControl setSelected:[fontManager fontNamed:[fd objectForKey:NSFontNameAttribute]
                                                              hasTraits:NSBoldFontMask]
                                      forSegment:0];
    [self.fontTraitsSegmentedControl setSelected:[fontManager fontNamed:[fd objectForKey:NSFontNameAttribute]
                                                              hasTraits:NSItalicFontMask]
                                      forSegment:1];    
}

# pragma mark - Popup Buttons

- (void)setupFontFamilies
{
    static NSMenu * fontFamilyMenu = nil;
    if (!fontFamilyMenu) {
        
        fontFamilyMenu = [[NSMenu alloc] init];
        NSMenuItem * mi;
        
        NSMutableSet * names = [NSMutableSet new];
        for (NSFontDescriptor * fd in [[NSFontCollection fontCollectionWithName:NSFontCollectionUser] matchingDescriptors]) {
            [names addObject:[fd objectForKey:NSFontFamilyAttribute]];
        }
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"description"
                                                               ascending:YES
                                                                selector:@selector(localizedCaseInsensitiveCompare:)];
        NSArray * sortedNames = [names sortedArrayUsingDescriptors:@[sort]];
        
        for (NSString * name in sortedNames) {
            mi = [[NSMenuItem alloc] init];
            [mi setTitle:name];
            [mi setTarget:self];
            [mi setAction:@selector(selectFontFamilyAction:)];
            [fontFamilyMenu addItem:mi];
        }
        [self.fontFamilyPopUpButton setMenu:fontFamilyMenu];
    }
}

- (void)setupFontFaces
{
    NSMenu * menu = self.fontFacePopUpButton.menu;
    [menu removeAllItems];
    NSMenuItem * mi;
    
    NSString * familyName = self.fontFamilyPopUpButton.selectedItem.title;
    
    for (NSArray * member in [[NSFontManager sharedFontManager] availableMembersOfFontFamily:familyName]) {
        mi = [[NSMenuItem alloc] init];
        [mi setTitle:member[1]];
        [mi setRepresentedObject:member[0]];
        [mi setTag:[member[2] integerValue]];
        [menu addItem:mi];
    }
}

- (void)selectFontFamilyAction:(id)sender
{
    NSString * proposedNewFamilyName = self.fontFamilyPopUpButton.selectedItem.title;
    if ([proposedNewFamilyName isEqualToString:_selectedFontFamilyName])
        return;
    
    _selectedFontFamilyName = proposedNewFamilyName.copy;
    
    if ([self.delegate respondsToSelector:@selector(fontInspectorDidModifyFontFamily:)])
        [self.delegate fontInspectorDidModifyFontFamily:_selectedFontFamilyName];
    
    [self setupFontFaces];
}

- (void)setSelectedFontFamilyName:(NSString *)selectedFontFamilyName
{
    if ([_selectedFontFamilyName isEqualToString:selectedFontFamilyName])
        return;
    _selectedFontFamilyName = selectedFontFamilyName.copy;
    [self.fontFamilyPopUpButton selectItemWithTitle:_selectedFontFamilyName];
    [self setupFontFaces];
}

- (IBAction)selectFontFaceAction:(id)sender
{
    NSString * postscriptName = [[sender selectedItem] representedObject];
    NSString * proposedNewFaceName = self.fontFacePopUpButton.selectedItem.title;
    if ([proposedNewFaceName isEqualToString:_selectedFontFaceName])
        return;
    
    _selectedFontFaceName = proposedNewFaceName.copy;
    
    if ([self.delegate respondsToSelector:@selector(fontInspectorDidModifyFontFace:)])
        [self.delegate fontInspectorDidModifyFontFace:postscriptName];
}

- (void)setSelectedFontFaceName:(NSString *)selectedFontFaceName
{
    if ([_selectedFontFaceName isEqualToString:selectedFontFaceName])
        return;
    
    _selectedFontFaceName = selectedFontFaceName.copy;
    [self.fontFacePopUpButton selectItemWithTitle:_selectedFontFaceName];
}

- (IBAction)modifyFontSizeAction:(id)sender
{
    _selectedFontSize = self.fontSizeTextField.floatValue;
    if (_selectedFontSize < 0.0)
        _selectedFontSize = 6.0; // Minimum Font Size (Magic)
    
    if ([self.delegate respondsToSelector:@selector(fontInspectorDidModifyFontSize:)])
        [self.delegate fontInspectorDidModifyFontSize:_selectedFontSize];
}

- (void)setSelectedFontSize:(CGFloat)selectedFontSize
{
    _selectedFontSize = selectedFontSize;
    if (_selectedFontSize < 0.0)
        _selectedFontSize = 6.0; // Minimum Font Size (Magic)
    
    self.fontSizeTextField.stringValue = [NSString stringWithFormat:@"%g pt", _selectedFontSize];
}

enum {
    TKOBoldSegment = 0,
    TKOObliquitySegment = 1,
    TKOUnderlineSegment = 2,
};

- (IBAction)modifyFontTraitsAction:(id)sender
{
    switch ([sender selectedSegment]) { // Most recently selected segment index
        case TKOBoldSegment:
            
            if ([self.delegate respondsToSelector:@selector(fontInspectorDidModifyBoldness:)])
                [self.delegate fontInspectorDidModifyBoldness:[self.fontTraitsSegmentedControl isSelectedForSegment:TKOBoldSegment]];
            
            break;
        case TKOObliquitySegment:

            if ([self.delegate respondsToSelector:@selector(fontInspectorDidModifyObliquity:)])
                [self.delegate fontInspectorDidModifyObliquity:[self.fontTraitsSegmentedControl isSelectedForSegment:TKOObliquitySegment]];
            
            break;
            
        case TKOUnderlineSegment:
            
            if ([self.delegate respondsToSelector:@selector(fontInspectorDidModifyUnderlining:)])
                [self.delegate fontInspectorDidModifyUnderlining:[self.fontTraitsSegmentedControl isSelectedForSegment:TKOUnderlineSegment]];
            
            break;
        default:
            
            
            
            break;
    }
    
}

- (IBAction)modifyForegroundTextColorAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(fontInspectorDidModifyTextColor:)])
        [self.delegate fontInspectorDidModifyTextColor:self.foregroundTextColorPicker.selectedColor];
}

@end

NSString * TKOFontInspectorDidModifyFontFamilyNotification = @"TKOFontInspectorDidModifyFontFamilyNotification";

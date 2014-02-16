//
//  TKOFontInspectorViewController.m
//  TKOFontInspectorViewDemo
//
//  Created by Todd Olsen on 2/8/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOFontInspectorViewController.h"
#import "TKOTextSystem.h"
#import "TKOColorPickerView.h"

enum {
    TKOBoldSegment = 0,
    TKOObliquitySegment = 1,
    TKOUnderlineSegment = 2,
};

@interface TKOFontInspectorViewController () // <NSTextViewDelegate>

@property (unsafe_unretained, nonatomic) TKOTextView * textView;

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

- (void)textViewDidChangeFont:(NSNotification *)notification
{
    [self setTextView:[notification object]];
    
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
                                      forSegment:TKOBoldSegment];
    [self.fontTraitsSegmentedControl setSelected:[fontManager fontNamed:[fd objectForKey:NSFontNameAttribute]
                                                              hasTraits:NSItalicFontMask]
                                      forSegment:TKOObliquitySegment];
    
    if (self.textView.selectedRange.location < self.textView.string.length) {
        BOOL isUnderlined = ([self.textView.textStorage attribute:NSUnderlineStyleAttributeName
                                                          atIndex:self.textView.selectedRange.location
                                                   effectiveRange:NULL] > 0);
        [self.fontTraitsSegmentedControl setSelected:isUnderlined
                                          forSegment:TKOUnderlineSegment];
    }
}

# pragma mark - Popup Buttons

- (void)setupFontFamilies
{
    NSMenu * fontFamilyMenu = nil;
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

- (void)modifyAttribute:(NSString *)name
                  value:(id)value
{
    if (!self.textView)
        return;
    if (!value)
        return;
    
    for (NSValue * r in self.textView.selectedRanges) {
        NSRange range = [r rangeValue];
//        NSMutableAttributedString * attstr = self.textView.textStorage;
        [self.textView.textStorage addAttribute:name
                                          value:value
                                          range:range];
    }
}

- (void)selectFontFamilyAction:(id)sender
{
    NSString * proposedNewFamilyName = self.fontFamilyPopUpButton.selectedItem.title;
    if ([proposedNewFamilyName isEqualToString:_selectedFontFamilyName])
        return;
    
    _selectedFontFamilyName = proposedNewFamilyName.copy;
    
    NSFontManager * fontManager = [NSFontManager sharedFontManager];
    [self modifyAttribute:NSFontAttributeName
                    value:[fontManager convertFont:[fontManager selectedFont]
                                          toFamily:_selectedFontFamilyName]];
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
    
    NSFontManager * fontManager = [NSFontManager sharedFontManager];
    
    [self modifyAttribute:NSFontAttributeName
                    value:[fontManager convertFont:[fontManager selectedFont]
                                            toFace:postscriptName]];
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
    
    NSFontManager * fontManager = [NSFontManager sharedFontManager];    
    [self modifyAttribute:NSFontAttributeName
                    value:[fontManager convertFont:[fontManager selectedFont]
                                            toSize:_selectedFontSize]];
}

- (void)setSelectedFontSize:(CGFloat)selectedFontSize
{
    _selectedFontSize = selectedFontSize;
    if (_selectedFontSize < 0.0)
        _selectedFontSize = 6.0; // Minimum Font Size (Magic)
    
    self.fontSizeTextField.stringValue = [NSString stringWithFormat:@"%g pt", _selectedFontSize];
}

- (IBAction)modifyFontTraitsAction:(id)sender
{
    NSFontManager * fontManager = [NSFontManager sharedFontManager];
    NSString * attributeName;
    id value;
    
    NSInteger selectedSegment = [sender selectedSegment];
    
    if (selectedSegment == TKOBoldSegment) {
    
        attributeName = NSFontAttributeName;
        BOOL isBold = [self.fontTraitsSegmentedControl isSelectedForSegment:TKOBoldSegment];
        value = [fontManager convertFont:[fontManager selectedFont]
                             toHaveTrait:isBold ? NSBoldFontMask : NSUnboldFontMask];
        
    } else if (selectedSegment == TKOObliquitySegment) {
        
        attributeName = NSFontAttributeName;
        BOOL isOblique = [self.fontTraitsSegmentedControl isSelectedForSegment:TKOObliquitySegment];
        value = [fontManager convertFont:[fontManager selectedFont]
                             toHaveTrait:isOblique ? NSItalicFontMask : NSUnitalicFontMask];
        
    } else if (selectedSegment == TKOUnderlineSegment) {
        
        attributeName = NSUnderlineStyleAttributeName;
        BOOL isUnderlined = [self.fontTraitsSegmentedControl isSelectedForSegment:TKOUnderlineSegment];
        value = isUnderlined ? @(NSUnderlinePatternSolid|NSUnderlineStyleSingle) : @0;
        
    }

    [self modifyAttribute:attributeName
                    value:value];
}

- (IBAction)modifyForegroundTextColorAction:(id)sender
{
    [self modifyAttribute:NSForegroundColorAttributeName
                    value:self.foregroundTextColorPicker.selectedColor];
}

@end

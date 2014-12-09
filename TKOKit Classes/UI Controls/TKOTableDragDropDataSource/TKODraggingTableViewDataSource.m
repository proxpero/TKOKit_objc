//
//  TKODraggingTableViewDataSource.m
//  TKODragDropTableView
//
//  Created by Todd Olsen on 6/24/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKODraggingTableViewDataSource.h"

@interface TKODraggingTableViewDataSource ()

@property (nonatomic) id movingItem;
@property (nonatomic) NSUInteger movingRow;

@end

@implementation TKODraggingTableViewDataSource

# pragma mark - Table View Data Source

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    if (self.filteredItems) return [self.filteredItems count];
    return [self.items count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if (self.filteredItems) return self.filteredItems[row];
    return self.items[row];
}

# pragma mark - Dragging

- (id <NSPasteboardWriting>)tableView:(NSTableView *)tableView pasteboardWriterForRow:(NSInteger)row
{
    return (id <NSPasteboardWriting>)self.items[row];
}

- (void)tableView:(NSTableView *)tableView draggingSession:(NSDraggingSession *)session willBeginAtPoint:(NSPoint)screenPoint forRowIndexes:(NSIndexSet *)rowIndexes
{
    _movingItem = self.items[rowIndexes.firstIndex];
    _movingRow = rowIndexes.firstIndex;
}

- (void)tableView:(NSTableView *)tableView draggingSession:(NSDraggingSession *)session endedAtPoint:(NSPoint)screenPoint operation:(NSDragOperation)operation
{
    _movingItem = nil;
}

- (NSDragOperation)tableView:(NSTableView *)tableView
                validateDrop:(id<NSDraggingInfo>)info
                 proposedRow:(NSInteger)row
       proposedDropOperation:(NSTableViewDropOperation)dropOperation
{
    if (self.filteredItems) return NSDragOperationNone; // No dragdrop while filtering
    
    if (dropOperation == NSTableViewDropAbove)
        return NSDragOperationMove;
    
    return NSDragOperationNone;
}

- (BOOL)tableView:(NSTableView *)tableView
       acceptDrop:(id<NSDraggingInfo>)info
              row:(NSInteger)row
    dropOperation:(NSTableViewDropOperation)dropOperation
{
    if (dropOperation != NSTableViewDropAbove) return NO;
    
    NSUInteger movingRow = [self.items indexOfObject:self.movingItem];
    
    if (movingRow == row) return NO;
    NSRange dirtyRange = movingRow < row ? NSMakeRange(movingRow, row - movingRow - 1) : NSMakeRange(row, movingRow - row);
    NSRange movedRange = NSMakeRange(movingRow, 1);
    NSRange range = NSUnionRange(dirtyRange, movedRange);
    
    [self.items removeObjectAtIndex:movingRow];
    
    NSInteger insertionRow = movingRow < row ? row - 1 : row;
    [self.items insertObject:self.movingItem atIndex:insertionRow];
    
    [tableView beginUpdates];
    [tableView moveRowAtIndex:movingRow
                      toIndex:insertionRow];
    
    NSInteger limit = movingRow < row ? range.length + range.location + 1 : range.length + range.location;
    
    for (NSInteger i = range.location; i < limit; i++) {
        id <TKOIndexReassignable> child = [self.items objectAtIndex:i];
        [child reassignToIndex:i];
        [tableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:i]
                             columnIndexes:[NSIndexSet indexSetWithIndex:0]];
    }
    
    [tableView endUpdates];
    
    return YES;
}

@end

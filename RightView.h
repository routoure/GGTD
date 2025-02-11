/* All rights reserved */

#import <AppKit/AppKit.h>
#import "Document.h"

@interface RightView : NSView {   
    Document *document;
    NSMutableArray *labels; // An array with a NSDictionnary with @"position and @"text" keys
    NSInteger draggingIndex; //index of the label being dragged
    float dragOffset; 
    NSTextField *editingField; 
    NSInteger editingIndex; //index of the label being dragged
}


- (void)endEditing;
- (void)startEditingLabelAtIndex:(NSInteger)index ;
- (void) initializeLabels;
- (void) addCategory;
- (NSMutableArray *) getLabels;
- (void) setLabels: (NSMutableArray *)newLabels;
 -(void) setDocument:(Document *) unDocument;
@end

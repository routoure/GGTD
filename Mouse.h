#import <AppKit/AppKit.h>
#import "Document.h"

@interface MyTableView : NSTableView {
   Document *document; //pointeur vers le Document 
 }
  -(void) setDocument:(Document *) unDocument;
  -(void) mouseDown:(NSEvent *)event ;
@end
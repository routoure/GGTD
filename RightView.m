/* All rights reserved */

#import <AppKit/AppKit.h>
#import "RightView.h"

@implementation RightView
- (id) init {
    self = [super init];
    return self;
}

- (void) drawRect: (NSRect) frame {
    
    
    //int i;
    
    //NSBezierPath* BP = [NSBezierPath bezierPathWithRect: [self bounds]];
    //[[NSColor blackColor] set]; 
    //NSPoint tick = NSMakePoint(20, 0);
    //for (i=0;i<20;i++) {
    //   NSPoint origin = NSMakePoint(0, 40*i);
    //   BP = [NSBezierPath bezierPath];
    //  [BP setLineWidth: 3];
    //  [BP moveToPoint: origin];
    //  [BP relativeLineToPoint: tick];
    //  [BP stroke];
    //}
 
}


-(void) mouseDown:(id)sender{
  
  NSLog(@"Click dans la view");
}

@end

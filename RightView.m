/* All rights reserved */

#import <AppKit/AppKit.h>
#import "RightView.h"

@implementation RightView

- (instancetype) initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        labels = [[NSMutableArray alloc] init];
        editingIndex = -1;
        draggingIndex=-1;
        [self initializeLabels];
    }
    return self;
}



- (void) initializeLabels {
    CGFloat viewHeight = [self bounds].size.height;
    CGFloat step = viewHeight / 6;
    int i;
    for (i = 0; i < 5; i++) {
        NSMutableDictionary *label = [[NSMutableDictionary alloc] init];
        [label setObject:[NSString stringWithFormat:@"Texte %d", i+1] forKey:@"text"];
        // TBD Shuld be place at the middle of the view ; t depends of he size of the text
        [label setObject:[NSNumber numberWithFloat:(i + 1.0) * step] forKey:@"position"];
        [labels addObject:label];
    }

    [self setNeedsDisplay:YES];
}




- (void)drawRect:(NSRect)dirtyRect {
    [[NSColor grayColor] setFill];
    NSRectFill(dirtyRect);

    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSFont systemFontOfSize:10], NSFontAttributeName,
        [NSColor blackColor], NSForegroundColorAttributeName, nil];
    NSInteger i;
    for ( i = 0; i < [labels count]; i++) {
        NSString *text;
        if (i != editingIndex) {
          text = [[labels objectAtIndex:i] objectForKey:@"text"]; 
          NSLog(@"%@",text);
        
          float position = [[ [labels objectAtIndex:i] objectForKey:@"position"] floatValue];

          // Sauvegarde le contexte graphique
          [[NSGraphicsContext currentContext] saveGraphicsState];

          // Crée et applique une transformation de rotation
          NSAffineTransform *transform = [NSAffineTransform transform];
          [transform translateXBy:10 yBy:position];
          [transform rotateByDegrees:90]; // Rotation de 90° pour un texte vertical
          [transform concat];

          // Dessine le texte (avec un point de départ à (0,0) après transformation)
          [text drawAtPoint:NSMakePoint(0, 0) withAttributes:attributes];

          // Restaure le contexte graphique
          [[NSGraphicsContext currentContext] restoreGraphicsState];
        }
    }
}



- (NSInteger)indexForPoint:(NSPoint)point {
    NSInteger i;
    for ( i = 0; i < [labels count]; i++) {
        float pos = [[[labels objectAtIndex:i] objectForKey:@"position"] floatValue];
        NSLog(@"Pos : %f ",pos);
        
        float textSize=80;
        //NSRect rect = NSMakeRect(pos.x, pos, textSize.width, textSize.height);
        
        //if (NSPointInRect(point, rect)) {
       if ((pos>point.y)&&(pos<point.y+textSize/2))  return i;
        
    }
    return -1;
}

- (void)mouseDown:(NSEvent *)event {
    NSLog(@"MouseDown");
    
    NSPoint clickLocation = [self convertPoint:[event locationInWindow] fromView:nil];
    NSInteger index = [self indexForPoint:clickLocation];
    
    if (index != -1) {
        // This is a category title 
        if ([event clickCount] == 2) {
            [self startEditingLabelAtIndex:index];
        } else {
            draggingIndex = index;
            
            float pos = [[[labels objectAtIndex:index] objectForKey:@"position"] floatValue];
            dragOffset = clickLocation.y - pos;
        }
    } else {
        draggingIndex = -1;
    }
}

- (void)mouseDragged:(NSEvent *)event {
    if (draggingIndex != -1) {
       
        NSPoint newLocation = [self convertPoint:[event locationInWindow] fromView:nil];
        
        float pos=newLocation.y - dragOffset;
        
        NSMutableDictionary *label=[labels objectAtIndex:draggingIndex];
        // WE have to encapsulte NSPoint in *NSValue
        [label setObject:[NSNumber numberWithFloat:pos] forKey:@"position"];
        [labels replaceObjectatIndex:draggingIndex withObject:label];
        [self setNeedsDisplay:YES];
    }
}

- (void)mouseUp:(NSEvent *)event {
    draggingIndex = -1;
}



- (void)startEditingLabelAtIndex:(NSInteger)index {
    if (editingField != nil) {
        [self endEditing];
    }

    editingIndex = index;
    NSString *currentText = [[labels objectAtIndex:index] objectForKey:@"text"];
    float  position = [[[labels objectAtIndex:index] objectForKey:@"position"] floatValue];
    
    // We need to know the size of the text
    
    NSFont *font = [NSFont systemFontOfSize:10]; 

     NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
    font, NSFontAttributeName,
    nil];

     // Obtenir la taille du texte
     NSSize textSize = [currentText sizeWithAttributes:attributes];


    editingField = [[NSTextField alloc] initWithFrame:NSMakeRect(10, position+textSize.width/2+5, textSize.width+10, textSize.height+10 )];
    [editingField setStringValue:currentText];
    [editingField setFont:[NSFont systemFontOfSize:10]];
    [editingField setAlignment:NSTextAlignmentLeft];
    [editingField setBackgroundColor:[NSColor whiteColor]];
    [editingField setBordered:YES];
    [editingField setFocusRingType:NSFocusRingTypeNone];

    [editingField setTarget:self];
    [editingField setAction:@selector(endEditing)];
    NSWindow *window = [[NSApplication sharedApplication] mainWindow];
    NSView *contentView = [window contentView];

    [contentView addSubview:editingField];
    [[self window] makeFirstResponder:editingField];
}




- (void)endEditing {
    if (editingField != nil) {
        [[labels objectAtIndex:editingIndex] setObject:[editingField stringValue] forKey:@"text"];
        [editingField removeFromSuperview];
        editingField = nil;
        editingIndex = -1;
        [self setNeedsDisplay:YES];
    }
}

@end

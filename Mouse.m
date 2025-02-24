/* 
   Copyright (C) 2025 Jean-Marc Routoure <jmroutoure@mailbox.org>

   This file is part of Ggtd application

   Ggtd is free software; you can redistribute it and/or
   modify it under the terms of the GNU General Public
   License as published by the Free Software Foundation; either
   version 3 of the License, or (at your option) any later version.
 
   This application is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Library General Public License for more details.
 
   You should have received a copy of the GNU General Public
   License along with this library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111 USA.
*/
#import <AppKit/AppKit.h>
#import "Mouse.h"
#import "Document.h"

@implementation MyTableView

- (void)mouseDown:(NSEvent *)event {
    NSPoint point = [self convertPoint:[event locationInWindow] fromView:nil];
    //NSLog(@"MouseDown");
    //NSLog(@"Point cliqué x%f",point.x);
    //NSLog(@"Point cliqué y%f",point.y);
    
    NSInteger row = [self rowAtPoint:point];
    NSInteger colonne= [self columnAtPoint:point];
    //NSLog(@"Click sur colonne:%d ligne:%d boutton %d",colonne,row,[event buttonNumber]);
    
   //}
    BOOL clickOnLine=NO;
    if  ( abs(   (int)point.y-1 -row*40 )<6)  clickOnLine=YES;
    
    unsigned int flags;
    flags = [event modifierFlags];
    BOOL ctrl=NO;
    if (flags & NSControlKeyMask)  { ctrl=YES; }
      //NSLog(@"CTRL enfoncee");
      //[document gestionClickAtRow:row atColumn:colonne withCTRL:ctrl withEvent:event]}
    
    [document gestionClickAtRow:row atColumn:colonne withCTRL:ctrl withClickOnLine: clickOnLine  withEvent:event];
    
    [super mouseDown:event]; // Appeler la méthode parente pour conserver le comportement par défaut
    // A commenter si on veut gérer le mouseDragged
}

- (void)controlTextDidEndEditing:(NSNotification *)notification {
  NSLog(@"ENTER OU ESC");
}

-(void) setDocument:(Document *) unDocument{
  //[document retain];
  //[document alloc];
  // document=nil avant d'arriver ici 
  //On fait pointer document vers 
  document=unDocument;
  //[document release];
}


// Méthode appelée lors d'un clic droit
- (void)rightMouseDown:(NSEvent *)event {
  //NSLog(@"Début d'un right mouse down");
  //NSPoint point = [self convertPoint:[event locationInWindow] fromView:nil];
  //  NSLog(@"MouseUP");
  //  NSLog(@"Point cliqué x%f",point.x);
  //  NSLog(@"Point cliqué y%f",point.y);
    
  //  NSInteger row = [self rowAtPoint:point];
  //  NSInteger colonne= [self columnAtPoint:point];
  //[self selectRow:row byExtendingSelection:YES];  
  //[self editColumn:colonne  row:row withEvent:event select:NO] ; 
  
  }
//- (unsigned int) draggingSouceOperationMaskForLocal:(BOOL) flag {
//  return NSDragOperationCopy;
//}

- (void) mouseDragged:(NSEvent *) event {
  
  NSLog(@"Début d'un drag");
  
}

@end

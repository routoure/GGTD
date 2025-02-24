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

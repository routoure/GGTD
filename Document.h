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
#import <AppKit/NSDocument.h>
#import "Model.h"
@interface Document : NSDocument
{
  id tableView;
  id rightView;
  NSMutableDictionary *records;
  NSMutableArray *doneTasks;
  NSMutableArray *clickedLines;
  NSInteger clickedColumn; 
}
- (void) gestionClickAtRow: (NSInteger) row 
         atColumn: (NSInteger) column
         withCTRL:(BOOL) ctrl
         withClickOnLine: (BOOL) clickOnLine
         withEvent:(NSEvent *) event;
         
-(void) cut:(id)sender;
-(void) copy:(id)sender;
-(BOOL) paste:(id)sender;   
-(void) done:(id)sender;
      
- (JMRTache *) getTacheAtColumn: (NSInteger)  aColumn  atRow: (NSInteger)aRow ;

@end

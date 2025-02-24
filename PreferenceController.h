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

#ifndef PreferenceController_H_INCLUDE
#define PreferenceController_H_INCLUDE

#import <AppKit/AppKit.h>


extern NSString * const JMRDefaultFontSizeKey;
extern NSString * const JMRminimuFontSizeKey;
extern NSString * const JMRColumnWidthKey;
extern NSString * const JMRDefaultFileNameKey;
extern NSString * const JMRDirectoryNameKey;

@interface PreferenceController : NSWindowController
{
  
  IBOutlet id defaultFileName;
  IBOutlet id defaultFontSize;
  IBOutlet id minimunFontSize;
  IBOutlet id directoryName;
  IBOutlet id defaultFontSizeStepper;
  IBOutlet id minimunFontSizeStepper;
  IBOutlet id columnWidthSlider;
  IBOutlet id columnWidth;
  IBOutlet id directoryChoice;
 
}

- (IBAction) ChangeMinimumFontSize: (id)sender;
- (IBAction) changeColumneWidth: (id)sender;
- (IBAction) changeDefautFontSize: (id)sender;
- (IBAction) changeSelectedDirectory: (id)sender;
- (IBAction) chooseDirectoryBehavior: (id)sender;
- (IBAction) showPreferencePanel: (id)sender;
- (IBAction) closePreferencePanel: (id) sender;


- (int)getMinimunFontSize;
- (int)getDefaultFontSize;
- (int)getColumnWidth;
- (NSString *) getDefaultFileName;

- (void) tableViewRefresh;

@end

#endif // PreferenceController_H_INCLUDE

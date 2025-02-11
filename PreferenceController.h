/* All rights reserved */

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
  IBOutlet id columnWithSlider;
 
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

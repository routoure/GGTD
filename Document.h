/* All Rights reserved */

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

/* All Rights reserved */

#import <AppKit/AppKit.h>
#import <AppKit/NSDocument.h>
#import "Model.h"
@interface Document : NSDocument
{
  id tableView;
  NSMutableDictionary *records;
  NSMutableArray *doneTasks;
  NSMutableArray *clickedLines; //An array of 20 BOOL indicating which lines has to be increased in width 
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

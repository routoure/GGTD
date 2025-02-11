/* All rights reserved */

#import "PreferenceController.h"

NSString * const JMRDefaultFontSizeKey = @"DefaultFontSize";
NSString * const JMRMinimuFontSizeKey = @"MinimuFontSize";
NSString * const JMRDefaultFileNameKey = @"DefaultFileName";
NSString * const JMRDirectoryNameKey = @"DirectoryName";
NSString * const JMRColumnWidthKey = @"ColumnWidth";


@implementation PreferenceController

- (IBAction) ChangeMinimumFontSize: (id)sender
{

  int resultat=[sender intValue];
    NSLog(@"ChangeMinimumFontSize %d",resultat);
  if (resultat>[defaultFontSize intValue]) {
    resultat=[defaultFontSize intValue];
    [sender setIntValue:resultat];
  }

  [minimunFontSize setIntValue:resultat];
}

- (IBAction) changeDefautFontSize: (id)sender
{
  NSLog(@"ChangeMinimumFontSize");
  int resultat=[sender intValue];
  [defaultFontSize setIntValue:resultat];
  NSUserDefaults  *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setInteger:[defaultFontSize intValue] forKey: JMRDefaultFontSizeKey ];
  [self tableViewRefresh];
}

- (IBAction) changeColumneWidth: (id)sender
{
  int resultat=[sender intValue];
  NSLog(@" %d",resultat);
  NSUserDefaults  *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setInteger:[columnWithSlider intValue] forKey: JMRColumnWidthKey ];
  [self tableViewRefresh];
}



- (IBAction) changeSelectedDirectory: (id)sender
{
}

- (IBAction) chooseDirectoryBehavior: (id)sender
{
}

- (int)getMinimunFontSize {
   int tmp;
   NSUserDefaults  *defaults = [NSUserDefaults standardUserDefaults];
   tmp=[defaults integerForKey: JMRMinimuFontSizeKey];
   if (tmp==0) tmp=8;
   return tmp;
}

- (int)getDefaultFontSize {
   int tmp;
   NSUserDefaults  *defaults = [NSUserDefaults standardUserDefaults];
   tmp=[defaults integerForKey: JMRDefaultFontSizeKey];
   if (tmp==0) tmp=12;
   return tmp;
}

-(int)getColumnWidth {
   int tmp;
   NSUserDefaults  *defaults = [NSUserDefaults standardUserDefaults];
   tmp=[defaults integerForKey: JMRColumnWidthKey];
   if (tmp==0) tmp=125;
   return tmp;
}

- (NSString *) getDefaultFileName{
   NSString *tmp;
   NSUserDefaults  *defaults = [NSUserDefaults standardUserDefaults];
   tmp=[defaults objectForKey: JMRDefaultFileNameKey];
   if (tmp==nil) tmp=[ NSString stringWithFormat:@"Tasks"];
   return tmp;  
}




- (IBAction) showPreferencePanel: (id)sender{
   NSLog(@"minfont %d defautfont %d name:%@",[self  getMinimunFontSize],[self getDefaultFontSize], [self getDefaultFileName]);
   // Il faut aller chercher les valeur 
   [defaultFontSize setIntValue: [self  getDefaultFontSize]];
   [defaultFontSizeStepper setIntValue:[self  getDefaultFontSize]];
   [minimunFontSize setIntValue:[self  getMinimunFontSize]];
   [minimunFontSizeStepper setIntValue:[self  getMinimunFontSize]];
   [columnWithSlider setIntValue:[self  getColumnWidth]];
   [defaultFileName setStringValue:[self getDefaultFileName]];
   
   
  [self showWindow:self];
}

- (IBAction) closePreferencePanel: (id) sender {
  NSLog(@"Close");
  // Il faut enregistrer les valeurs par défauts à la fermeture du panel
   NSUserDefaults  *defaults = [NSUserDefaults standardUserDefaults];
   
   [defaults setInteger:[minimunFontSize intValue] forKey: JMRMinimuFontSizeKey ];
   
   [defaults setObject:[defaultFileName stringValue] forKey: JMRDefaultFileNameKey ];
  
  [[self window] performClose:self];
}

- (void) tableViewRefresh {
  //NSWindow *mainWindow = [[NSApplication sharedApplication] mainWindow];
  //NSTableView *tableView1 = [mainWindow.contentView viewWithTag:100]; // Assurez-vous que le NSTableView a un tag
  //NSLog(@"tableview1 trouvé %@",tableView1);
  //[tableView1 reloadData];
  
  NSDocument *currentDocument = [[NSDocumentController sharedDocumentController] currentDocument];
  NSWindow *documentWindow = [currentDocument windowForSheet];
  NSTableView *tableView2 = [documentWindow.contentView viewWithTag:100];
  NSLog(@"tableview2 trouvé %@",tableView2);
  [tableView2 setNeedsDisplay:YES];


}
  

@end

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
  [columnWidth setIntValue:resultat];
  
  NSUserDefaults  *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setInteger:resultat forKey: JMRColumnWidthKey ];
  NSLog(@"%d",resultat);
  [self tableViewRefresh];
}



- (IBAction) changeSelectedDirectory: (id)sender
{
  NSOpenPanel *panel = [NSOpenPanel openPanel];

 [panel setCanChooseFiles:NO];        // Désactive la sélection de fichiers
 [panel setCanChooseDirectories:YES]; // Active la sélection de répertoires
 [panel setAllowsMultipleSelection:NO]; // Permet de ne sélectionner qu’un seul dossier

  if ([panel runModal] == NSModalResponseOK) {
        NSURL *selectedURL = [[panel URLs] firstObject]; // Récupère le répertoire sélectionné
        //NSLog(@"Répertoire sélectionné : %@", [selectedURL path]);
        
        [directoryName setStringValue: [selectedURL path] ];
        [directoryName sizeToFit];
        
        
        NSString *tmp=[NSString stringWithFormat:@"%s", [selectedURL path] ];
        NSUserDefaults  *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:tmp forKey: JMRDirectoryNameKey ];
        }
}


- (IBAction) chooseDirectoryBehavior: (id)sender
{ 
  
  NSLog(@"Click dans cette zone");
  NSInteger selectedRow = [sender selectedRow];
  //NSLog(@"Bouton sélectionné : %@", [[sender cellAtRow:selectedRow column:0] title]);
  NSUserDefaults  *defaults = [NSUserDefaults standardUserDefaults];
  switch (selectedRow) {
    case 0: 
      
        [defaults setObject:[NSString stringWithFormat:@"%s/Desktop/", NSHomeDirectory()]  forKey: JMRDirectoryNameKey ];
      break;
    case 1:
        [defaults setObject:NSHomeDirectory() forKey: JMRDirectoryNameKey ];
      break;   
  }
  

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
   NSLog(@"Préference lue %d");
   if (tmp==0) tmp=125;
   return tmp;
}

- (NSString *) getDefaultFileName{
   NSString *tmp;
   NSUserDefaults  *defaults = [NSUserDefaults standardUserDefaults];
   tmp=[defaults objectForKey: JMRDefaultFileNameKey];
   if (tmp==nil) 
     tmp=[ NSString stringWithFormat:@"Tasks"];       
   return tmp;  
}


- (NSString *) getDefaultDirectory{
   NSString *tmp;
   NSUserDefaults  *defaults = [NSUserDefaults standardUserDefaults];
   tmp=[defaults objectForKey: JMRDirectoryNameKey];
   if (tmp==nil) 
     tmp = [NSString stringWithFormat:@"%s/Desktop/", NSHomeDirectory() ] ;      
   return tmp;  
}



- (IBAction) showPreferencePanel: (id)sender{
   NSLog(@"minfont %d defautfont %d name:%@",[self  getMinimunFontSize],[self getDefaultFontSize], [self getDefaultFileName]);
   // Il faut aller chercher les valeur 
   [defaultFontSize setIntValue: [self  getDefaultFontSize]];
   [defaultFontSizeStepper setIntValue:[self  getDefaultFontSize]];

   [minimunFontSize setIntValue:[self  getMinimunFontSize]];
   [minimunFontSizeStepper setIntValue:[self  getMinimunFontSize]];

   [columnWidthSlider setIntValue:[self  getColumnWidth]];
   [columnWidth setIntValue:[self  getColumnWidth]];


   
   [defaultFileName setStringValue:[self getDefaultFileName]];
   [directoryName setStringValue:@""];
   [directoryChoice selectCellAtRow: -1 column:0];
   
   //Mise à jour du panneau en fonction de la valeur de Diectory
   NSString *directoryNameTmp=[self getDefaultDirectory];
   if ([directoryNameTmp isEqual: [NSString stringWithFormat:@"%s/Desktop/", NSHomeDirectory() ] ]   ) [directoryChoice selectCellAtRow: 0 column:0];
  else  if ([directoryNameTmp isEqual: [NSString stringWithFormat:@"%s", NSHomeDirectory() ] ] ) [directoryChoice selectCellAtRow: 1 column:0];
   else [directoryName setStringValue:directoryNameTmp];
    
   
   
  [self showWindow:self];
}

- (IBAction) closePreferencePanel: (id) sender {
  NSLog(@"Close");
  // Il faut enregistrer les valeurs par défauts à la fermeture du panel
   NSUserDefaults  *defaults = [NSUserDefaults standardUserDefaults];
   
   //[defaults setInteger:[minimunFontSize intValue] forKey: JMRMinimuFontSizeKey ];
   
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
  //NSLog(@"tableview2 trouvé %@",tableView2);
  [tableView2 setNeedsDisplay:YES];


}
  

@end

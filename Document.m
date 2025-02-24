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

#import "Document.h"
#import "Model.h"
#import "RightView.h"
#import "PreferenceController.h"
@implementation Document

- (NSString *) windowNibName
{
  return @"Document.gorm";
}

- (int) numberOfRowsInTableView: (NSTableView*) view {
 return 20;
}

// ---------------------------------------------------------------------------------
// Fonction delegate d'un tableview pour gérer l'allure des colonnes


- (void)tableView:(NSTableView *)thisTableView 
  willDisplayCell:(id)cell 
   forTableColumn:(NSTableColumn *)tableColumn 
              row:(NSInteger)row {
    //NSLog(@"Will displayCell");
    if ([cell isKindOfClass:[NSTextFieldCell class]]) {
        NSTextFieldCell *textCell = (NSTextFieldCell *)cell;
        
        NSUserDefaults  *defaults = [NSUserDefaults standardUserDefaults];
        [textCell setFont:[NSFont systemFontOfSize:[defaults integerForKey: JMRDefaultFontSizeKey]]];    
        
        
        // On ne redimensionne que les colonnes pairs
        NSInteger column= [[thisTableView tableColumns] indexOfObject:tableColumn];
        
        if ((column%2==1)&&(row==1)) {
          int width=[defaults integerForKey: JMRColumnWidthKey];
          if (width==0) width=125;
          [tableColumn setWidth:width];
           // On ajoute la taille de la fenêtre 
          NSRect tableFrame = [tableView frame];
  
     
         // Récupérer la fenêtre
         NSWindow *window = [[[self windowControllers] firstObject] window];
         NSRect windowFrame = [window frame];

         
         // Définir la nouvelle taille de la fenêtre
         windowFrame.size.width = tableFrame.size.width + 50; // Ajouter une marge si nécessaire
    
         // Appliquer la nouvelle taille
         [window setFrame:windowFrame display:YES animate:NO];
        }
        
        // mise à la ligne de la cellule  
        [textCell setWraps:YES];
        [textCell setLineBreakMode:NSLineBreakByWordWrapping];
        // Supprimer les bordures et le style par défa 
     
        
        // Dessin d'une ligne épaisse en bas d'une row
        if ([[clickedLines objectAtIndex:row] isEqual: @"G"]  ) {
          
          [[NSColor blackColor] setStroke];
          NSBezierPath *path = [NSBezierPath bezierPath];
   
          NSRect rowRect = [thisTableView rectOfRow:row];
          NSPoint origin=NSMakePoint(rowRect.origin.x,rowRect.origin.y);
          NSPoint offset=NSMakePoint(rowRect.size.width+10,0);
          [path setLineWidth:2];
          [path moveToPoint:origin];
          [path relativeLineToPoint:offset];
          [path stroke];
        }
        NSInteger rowSelected=[tableView selectedRow];
        if ((row==rowSelected)&&(column==clickedColumn)&&(column%2==1)) {
           NSColor *rowColor=[NSColor lightGrayColor];
           [textCell setDrawsBackground:YES]; 
           [textCell setBackgroundColor:rowColor];
           }
        else [textCell setDrawsBackground:NO];  
    }
}

// ---------------------------------------------------------------------------------

- (void) windowControllerDidLoadNib: (NSWindowController*) controller
{
    NSTableColumn *column;
    NSArray *columns = [tableView tableColumns];
    NSUserDefaults  *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger width;
    // First time the APP is lanched : 
    if ([defaults integerForKey: JMRColumnWidthKey]==0) width=125;
      else width=[defaults integerForKey: JMRColumnWidthKey];
    NSLog(@"%d",width);    
    
    column = [columns objectAtIndex: 0];
    
        
    [column setWidth: 25];
    [column setEditable: NO];
    [column setResizable: NO];
    [column setIdentifier: @"colonne0"];
    [[column headerCell] setStringValue: @""];
  
    column = [columns objectAtIndex: 1];
    [column setWidth: width];
    [column setEditable: YES];
    [column setResizable: YES];
    [column setIdentifier: @"colonne1"];
    [[column headerCell] setStringValue: @"Now"];
  
    column = [columns objectAtIndex: 2];
    [column setWidth: 25];
    [column setEditable: NO];
    [column setResizable: NO];
    [column setIdentifier: @"colonne2"];
    [[column headerCell] setStringValue: @""];
    
    column = [columns objectAtIndex: 3];
    [column setWidth: width];
    [column setEditable: YES];
    [column setResizable: YES];
    [column setIdentifier: @"colonne3"];
    [[column headerCell] setStringValue: @"After"];

    column = [columns objectAtIndex: 4];
    [column setWidth: 25];
    [column setEditable: NO];
    [column setResizable: NO];
    [column setIdentifier: @"colonne4"];
    [[column headerCell] setStringValue: @""];

    column = [[NSTableColumn alloc] initWithIdentifier: @"colonne5"];
    
    [column setWidth: width];
    [column setEditable: YES];
    [column setResizable: YES];
    
    [[column headerCell] setStringValue: @"In mind"];
  
    [tableView addTableColumn: column];
    [column release];

    [tableView setAutoresizesAllColumnsToFit: YES];
    
    [tableView setDocument: self];
    [rightView setDocument: self];
    
    // ajout d'un sous-menu Tasks
     NSMenu *myMenu1 = [[NSMenu alloc] initWithTitle:@"Tasks"];
     NSMenuItem *newItem11 = [[NSMenuItem alloc] initWithTitle:@"Delete"
                        action:@selector(delete:)
                        keyEquivalent:nil];
     NSMenuItem *newItem12 = [[NSMenuItem alloc] initWithTitle:@"Done"
                        action:@selector(done:)
                        keyEquivalent:@"d"];
     NSMenuItem *newItem13 = [[NSMenuItem alloc] initWithTitle:@"Show done tasks"
                        action:@selector(showDone:)
                        keyEquivalent:nil];
     NSMenuItem *newItem14 = [[NSMenuItem alloc] initWithTitle:@"Add new category"
                        action:@selector(addCategory:)
                        keyEquivalent:nil];
     // Ajouter l'élément au menu
    [myMenu1 addItem:newItem11];
    [myMenu1 addItem:newItem12];
    [myMenu1 addItem:newItem13];
    [myMenu1 addItem:newItem14];
    // Ajouter ce menu à la barre de menus principale
    [NSApp.mainMenu addItemWithTitle:@"Tasks" action:NULL keyEquivalent:nil];
    [NSApp.mainMenu setSubmenu:myMenu1 forItem:[NSApp.mainMenu itemWithTitle:@"Tasks"]];

    // ajout d'un sous-menu
     NSMenu *myMenu2 = [[NSMenu alloc] initWithTitle:@"Table"];
     NSMenuItem *newItem21 = [[NSMenuItem alloc] initWithTitle:@"Add cell"
                        action:@selector(addCell:)
                        keyEquivalent:nil];
     NSMenuItem *newItem22 = [[NSMenuItem alloc] initWithTitle:@"Remove cell"
                        action:@selector(removeCell:)
                        keyEquivalent:nil];
     NSMenuItem *newItem23 = [[NSMenuItem alloc] initWithTitle:@"Add row"
                        action:@selector(addRow:)
                        keyEquivalent:nil];
     NSMenuItem *newItem24 = [[NSMenuItem alloc] initWithTitle:@"Remove row"
                        action:@selector(removeRow:)
                        keyEquivalent:nil];
  
     
     // Ajouter l'élément au menu
    [myMenu2 addItem:newItem21];
    [myMenu2 addItem:newItem22];
    [myMenu2 addItem:newItem23];
    [myMenu2 addItem:newItem24];
    // Ajouter ce menu à la barre de menus principale
    [NSApp.mainMenu addItemWithTitle:@"Table" action:NULL keyEquivalent:nil];
    [NSApp.mainMenu setSubmenu:myMenu2 forItem:[NSApp.mainMenu itemWithTitle:@"Table"]];    
        
     
     // On récupère le nom du fichier 
     NSString *documentName= [self fileName];
    
     //NSLog(@"Lecture des données enregistré dans le fichier %@",documentName);
     [self readFromFile:documentName ofType:@""];
     
     // On ajoute la taille de la fenêtre 
     
     
     NSRect tableFrame = [tableView frame];
    NSLog(@"taille %f",tableFrame.size.width);
     // Il faut ajuster la taille de la scrollview à celle de la tableview
     //NSScrollView *scrollView=(NSScrollView *) [tableView superview];
     //[scrollView setAutoresizingMask: (NSViewWidthSizable | NSViewHeightSizable)];

     
     // Récupérer la fenêtre
     NSWindow *window = [[[self windowControllers] firstObject] window];
     NSRect windowFrame = [window frame];

         
    // Définir la nouvelle taille de la fenêtre
    windowFrame.size.width = tableFrame.size.width + 50; // Ajouter une marge si nécessaire
    
    // Appliquer la nouvelle taille
    [window setFrame:windowFrame display:YES animate:NO];

}

// ---------------------------------------------------------------------------------
- (void)      tableView: (NSTableView*) view
         setObjectValue: (id) object
         forTableColumn: (NSTableColumn*) column
                    row: (int) row
{   
 
  if ((object!=nil)&& !([object isEqual: @""])) {
    NSString *key=[NSString stringWithFormat : @"%@-%d", [column identifier],row ];
    JMRTache *nouvelleTache;
    nouvelleTache =[JMRTache alloc];
    [nouvelleTache JMRInitWithNom: [NSString stringWithFormat : @"%@",object]
                   withKey:key
                   withDuree:1
                   withEtat: 0 ];  
    [ records setObject:  nouvelleTache forKey:key];
    [nouvelleTache release]; 
    
    [tableView reloadData];
    [self updateChangeCount:NSChangeDone];   
  }
}


// ---------------------------------------------------------------------------------
// Methode delegate pour renvoyer la chaine à afficher colonne column et ligne row

- (id)              tableView: (NSTableView*) view
    objectValueForTableColumn: (NSTableColumn*) column
                          row: (int) row
{
  
 JMRTache *aTask;
 NSString *nomColonne=[column identifier];
 NSUInteger indexColonne=[[ nomColonne substringFromIndex:  [nomColonne length]-1] intValue]; 
 NSMutableString *resultat=[[NSMutableString alloc] init] ; 
 aTask = [ self  getTacheAtColumn:indexColonne atRow:row];
 
 if (aTask!=nil) {
    // Une entrée existe
    if ([aTask JMRGetNom] != nil) [resultat setString: [aTask JMRGetNom]];
 }
 else {
   //si le numéro de la colonne est pair et il faut aller chercher la durée
  
   // si colonne paire 
   if (indexColonne%2==0) {
     // Il faut aller chercher la valeur de la duree dans la colonne suivante
     aTask =[ self  getTacheAtColumn:indexColonne+1 atRow:row];
     if (aTask!=nil) {
       //NSLog(@" valeur de la durée dans cette case : %d ", [[cellule JMRGetDuree] intValue]);
       NSInteger dureeCalc=[aTask JMRGetDuree] ;
       NSInteger etatCalc=[aTask JMRGetEtat] ;
       switch (dureeCalc+10*etatCalc) {
         // Etat Normal
         case 0 : [resultat setString:@"."]; break;
         case 1 : [resultat setString:@"o"]; break;
         case 2 : [resultat setString:@"O"]; break; 
         // Etat Alerte  
         case 10 : [resultat setString:@"!."]; break;
         case 11 : [resultat setString:@"!o"]; break;
         case 12 : [resultat setString:@"!O"]; break;
         // Etat  commence
         case 20 : [resultat setString:@">."]; break;
         case 21 : [resultat setString:@">o"]; break;
         case 22 : [resultat setString:@">O"]; break;
         // Etat programme  
         case 30 : [resultat setString:@".<"]; break;
         case 31 : [resultat setString:@"o<"]; break;
         case 32 : [resultat setString:@"O<"]; break;   
         default : [resultat setString:@"o"]; break;                                
         } 
     }
     else [resultat setString:@""];
   }    
 }
 
 
   return  [resultat copy]; // On retourne une NSString.
     
 }



 
// ---------------------------------------------------------------------------------


- (void) gestionClickAtRow: (NSInteger) row 
         atColumn: (NSInteger) column 
         withCTRL:(BOOL) ctrl 
         withClickOnLine: (BOOL) clickOnLine
         withEvent:(NSEvent *) event {
   
   
   if (clickOnLine) {
     // On a clique sur une ligne 
     if  ([[clickedLines objectAtIndex:row] isEqual: @"N"]) [clickedLines replaceObjectAtIndex:row withObject: @"G" ];
       else [clickedLines replaceObjectAtIndex:row withObject: @"N" ];
     [self updateChangeCount:NSChangeDone];
     }
   else {
     JMRTache *aTask=[self getTacheAtColumn :column+1 atRow:row];  
     if ((column%2==0)&&(aTask!=nil)) {
        if (ctrl) [aTask JMRIncreaseEtat]; 
        else   [aTask JMRIncreaseDuree];
        [self updateChangeCount:NSChangeDone];     
        }
     clickedColumn=column;
     }    
}

// ---------------------------------------------------------------------------------


- (JMRTache *) getTacheAtColumn: (NSInteger)  aColumn  atRow: (NSInteger)aRow {
   
   NSString *key=[NSString  stringWithFormat : @"colonne%d-%d", aColumn, aRow ];
   JMRTache *aTask;
   aTask =[records valueForKey:key];
   return aTask;
  
}
// ---------------------------------------------------------------------------------Lectue Ecriture de document 
// ---------------------------------------------------------------------------------/// 


// ---------------------------------------------------------------------------------

- (BOOL) readFromFile: (NSString*)fileName ofType: (NSString*)type {
   NSLog(@"ReadFromFile");
   NSData *fileData = [NSData dataWithContentsOfFile:fileName];
   //[fileData retain];
    if (!fileData) {
        return NO;
    }
   else {
     NSError *error = nil; 
    [self readFromData:fileData ofType:type error:&error]; 
    return YES; 
  }
}

// ---------------------------------------------------------------------------------

- (NSData *) dataOfType:(NSString *) aType
            error:(NSError **)outError 
  {
    [tableView deselectAll:nil];
    
    NSArray *objectsToSave =[NSArray arrayWithObjects:records, doneTasks, clickedLines,[rightView getLabels],nil ];
    NSLog(@"%@",objectsToSave);
    
    // En GNUstep, utiliser NSKeyedArchiver sans requiringSecureCoding
    //NSError *archiveError = nil;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:objectsToSave];

   
    return data;
    }

// ---------------------------------------------------------------------------------
- (BOOL)  readFromData:(NSData *) data
          ofType:(NSString *) typeName
          error:(NSError **) outError
  {
  
  
  NSArray  *results = [NSKeyedUnarchiver unarchiveObjectWithData:data];
  [results retain];
  
  //NSLog(@"%@",results);
  
  [records release];
  
  records=[results objectAtIndex: 0];     

 
  
  [doneTasks release];
  doneTasks = [results objectAtIndex: 1];
  
  
  
  [clickedLines release ];
  clickedLines = [results objectAtIndex: 2];  
 
  if ([results count]==4) {
    NSMutableArray *newLabels= [[NSMutableArray alloc] init ];
    
    newLabels = [results objectAtIndex: 3];
    [rightView setLabels:newLabels];
  }
    
  
 
  return YES;        
  }

// ---------------------------------------------------------------------------------

- (id) init{
    self = [super init];
    records = [[NSMutableDictionary alloc] init];
    doneTasks= [[NSMutableArray alloc] init];
    clickedLines=[[NSMutableArray alloc] init];
    // Defalt name of the documen.
   
    //NSUserDefaults  *defaults = [NSUserDefaults standardUserDefaults];
    //NSString *fileName=[defaults objectForKey: JMRDefaultFileNameKey];
    //if ((fileName==nil)||( [fileName isEqual:@""]) ) fileName=[NSString  stringWithFormat:@"tasks"]; 
    NSString *fileName=[NSString  stringWithFormat:@"tasks"]; 
       
    // NSString *directory=[defaults objectForKey: JMRDirectoryNameKey];
    //if ((directory==nil)||( [directory isEqual:@""]))  directory=[NSString stringWithFormat:@"%@/Desktop/", NSHomeDirectory()  ]; 
    
    NSString *directory=[NSString stringWithFormat:@"%@/Desktop/", NSHomeDirectory()  ]; 
      
    [self setFileName:[NSString stringWithFormat:@"%@/%@.gtd", directory,fileName]];
    [self setFileType:@"gtd"];
    int i;
    for (i=0;i<=20;i++) 
      if ((i%5)==0) [clickedLines insertObject:@"G" atIndex:i];
      else   [clickedLines insertObject:@"N" atIndex:i];
    return self;
}


// ---------------------------------------------------------------------------------

- (void) dealloc
{
    //[records release];
    [records dealloc];
    [doneTasks dealloc];
    [clickedLines dealloc ];
    [super dealloc];
}

// --------------------------- copier coller -----------------
  
-(void) cut:(id)sender{
  
  NSInteger clickedRow=[tableView selectedRow];
 
  [self copy:sender];
  
  if (clickedColumn%2==1){
   JMRTache *cellule = [ self getTacheAtColumn:clickedColumn atRow:clickedRow ]; 
   if (cellule !=nil) {
     NSString *key=[NSString stringWithFormat : @"colonne%d-%d", clickedColumn, clickedRow];
     [records removeObjectForKey:key];
     [self updateChangeCount:NSChangeDone]; 
     [tableView reloadData];
     }
   }    
}  

// --------------------------------------------------------------
-(void) copy:(id)sender{
  
  NSInteger clickedRow=[tableView selectedRow];
  
  if (clickedColumn%2==1) {
    NSPasteboard *pb=[NSPasteboard generalPasteboard];
    [pb declareTypes:[NSArray arrayWithObject:NSStringPboardType]
      owner:self];
    JMRTache *aTask=[ self getTacheAtColumn:clickedColumn atRow:clickedRow ]; 
    if ((aTask !=nil)&&([aTask JMRGetNom]!=nil)) {
      NSString *encode=[NSString stringWithFormat:@"%@-%d-%d",[aTask JMRGetNom],    [aTask JMRGetDuree], [aTask JMRGetEtat] ];
      [pb setString:encode forType:NSStringPboardType]; 
      } 
  }
}    


// --------------------------------------------------------------
  
-(BOOL) paste:(id)sender{
   NSInteger clickedRow=[tableView selectedRow];
   NSPasteboard *pb=[NSPasteboard generalPasteboard];
   NSArray *types =[pb types];
   NSString *value = [pb stringForType:NSStringPboardType];
   NSArray *components=[value componentsSeparatedByString:@"-"];
   NSInteger dureeTmp, etatTmp;
   NSLog(@"paste a la colonne:%d et de la ligne:%d ",clickedColumn, clickedRow);
   
   if ([types containsObject:NSStringPboardType] && (clickedColumn%2==1) && ([components count]==3)  ) {
     // data avalaible in the pasteboard and correct column clicked
     
     // Initialisation des nombres avec des valeurs par défaut   
     dureeTmp = 1;  // Valeur par défaut
     etatTmp = 0 ;   // Valeur par défaut


     JMRTache *cellule=[ self getTacheAtColumn:clickedColumn atRow:clickedRow ];
      
     if (cellule !=nil){
        //the selected cell already contains data

        [cellule JMRSetNom:[components objectAtIndex:0] ];
        
        dureeTmp = [[components objectAtIndex:1] integerValue];
        etatTmp = [[components objectAtIndex:2] integerValue ];
        [cellule JMRSetDuree: dureeTmp ];        
        [cellule JMRSetEtat: etatTmp];
        
        }  
     else 
       {
       NSLog(@"Paste in a new cell");  
     //soit il n'y a rien dans la cellue
     // et il faut initialiser une nouvelle entrée s'il une case a ette selectionne
     
       NSString *unNom=[NSString stringWithFormat: @"%@", [components objectAtIndex:0] ];
       NSString *uneKey=[NSString stringWithFormat:  @"colonne%d-%d", clickedColumn , clickedRow];
       
       dureeTmp = [[components objectAtIndex:1] integerValue];
       etatTmp =  [[components objectAtIndex:2] integerValue];
       
     
       JMRTache *nouvelleTache;
   
       nouvelleTache =[JMRTache alloc];
      
       [nouvelleTache JMRInitWithNom:unNom
                    withKey:uneKey
                    withDuree:dureeTmp
                    withEtat:etatTmp];
 
   
       [records setObject:  nouvelleTache forKey:uneKey];
       [nouvelleTache release]; 
       //[nom release];
  
       }  
   
   [self updateChangeCount:NSChangeDone]; 
   [tableView reloadData];
   return YES;
   }
   else return NO;
}
      


//---------------------------------------------------------------

-(void) done:(id)sender {
  
   NSInteger clickedRow=[tableView selectedRow];
   NSLog(@"Done colomn:%d row%d", clickedColumn, clickedRow);
  // On recupère l'objet de records et on l'ajoute à doneTask;
   if (clickedColumn%2==1){
     
     JMRTache *aDoneTask = [self getTacheAtColumn:clickedColumn atRow:clickedRow];
     NSLog(@"Done task %@",aDoneTask);
     if (aDoneTask) {
       
       NSLog(@"Valeur de index %d",index);
       [doneTasks addObject:aDoneTask ];
       NSString *key=[NSString stringWithFormat : @"colonne%d-%d", clickedColumn,clickedRow];
       NSLog(@"Valeur de key %@",key);
       [records removeObjectForKey:key];
       
       
       NSLog(@"records %@:",records);
       NSLog(@"doneTasks %@:",doneTasks);
       //On sauvegarde les données
       //[self saveDocumentWithDelegate:self
       //   didSaveSelector: @selector(document:didAutosave:contextInfo:) 
       //   contextInfo:nil];
       // et On affiche la vue   
       [tableView reloadData];
       [self updateChangeCount:NSChangeDone]; 
     }
   }
}

//---------------------------------------------------------------

- (IBAction) delete:(id)sender {
  NSLog(@"Delete");
  NSInteger clickedRow=[tableView selectedRow];
  NSString *key=[NSString stringWithFormat : @"colonne%d-%d", clickedColumn,clickedRow];
       
 [records removeObjectForKey:key];
 [tableView reloadData];
 [self updateChangeCount:NSChangeDone]; 
}



//---------------------------------------------------------------
- (IBAction)saveDocument:(id)sender {
  [super saveDocument:sender];
}  

//---------------------------------------------------------------

- (IBAction)infoPanel:(id)sender {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"About"];
    [alert setInformativeText:@"Yet Another GTD \nBut with GNUStep \n \n Nobody should have more than 60 tasks to remenber\n If you like this software, please send me a postcard at jmroutoure AT gmail DOT com"];
    [alert addButtonWithTitle:@"OK"];
    [alert runModal]; // Bloque l'exécution jusqu'à la fermeture de l'alerte
}

//---------------------------------------------------------------

- (IBAction)addCell:(id)sender {
  
  NSInteger tmp=[tableView selectedRow]+1;
  
  while ([ [clickedLines objectAtIndex:tmp] isEqual: @"N"]) tmp++;
 
  JMRTache *aTask = [self getTacheAtColumn:clickedColumn atRow:tmp-1];
  if (aTask==nil){
    int i, debut, fin;
    debut=[tableView selectedRow];
    fin=tmp-1;
    for (i=fin;i>debut;i--) {
      JMRTache *aTask2;
      NSString *key1=[NSString stringWithFormat : @"colonne%d-%d", clickedColumn,i-1];
      aTask2=[records objectForKey:key1];
      NSString *key2=[NSString stringWithFormat : @"colonne%d-%d", clickedColumn,i];
      if (aTask2!=nil) [records setObject:aTask2 forKey:key2];
      else [records removeObjectForKey:key2]; 
    }
    NSString *key3=[NSString stringWithFormat : @"colonne%d-%d", clickedColumn,debut];
    [records removeObjectForKey:key3];
    [tableView reloadData];
    [self updateChangeCount:NSChangeDone]; 
  }
}
  
//---------------------------------------------------------------

- (IBAction)removeCell:(id)sender { 
  
  //On recherche la fin de categorie
  NSInteger tmp=[tableView selectedRow]+1;
  while ([ [clickedLines objectAtIndex:tmp] isEqual: @"N"]) tmp++;
  int fin=tmp-1;
  int i, debut;
  debut=[tableView selectedRow];  
  JMRTache *aTask = [self getTacheAtColumn:clickedColumn atRow:debut];
  if (aTask==nil) {
    for (i=debut; i<fin;i++) {
      JMRTache *aTask2;
      NSString *key1=[NSString stringWithFormat : @"colonne%d-%d", clickedColumn,i+1];
      NSString *key2=[NSString stringWithFormat : @"colonne%d-%d", clickedColumn,i];
      aTask2=[records objectForKey:key1];
      if (aTask2!=nil) [records setObject:aTask2 forKey:key2];
      else  [records removeObjectForKey:key2];      
       
    }
   NSString *key3=[NSString stringWithFormat : @"colonne%d-%d", clickedColumn,fin];
   [records removeObjectForKey:key3];
   [tableView reloadData];
   [self updateChangeCount:NSChangeDone]; 
  }
}

//---------------------------------------------------------------
// A line is added below the selected cell

- (IBAction)addRow:(id)sender { 
  JMRTache *aTask = [self getTacheAtColumn:1 atRow:19];
  JMRTache *aTask1 = [self getTacheAtColumn:3 atRow:19];
  JMRTache *aTask2 = [self getTacheAtColumn:5 atRow:19];
  
  if ((aTask==nil)&& (aTask1==nil) && (aTask2==nil)){
    // On peut décaler car il y a de la place sur la dernière ligne
    //NSLog(@"On peut enlever");
    int j,i;
    
    
    int debut=[tableView selectedRow];
    // the
    for (i=19;i>debut+1;i--) for (j=0;j<3;j++) {
      //NSLog(@"i%d j%d",i,2*j+1);
      JMRTache *aTask4;
      NSString *key1=[NSString stringWithFormat : @"colonne%d-%d", 2*j+1,i-1];
      aTask4=[records objectForKey:key1];
      NSString *key2=[NSString stringWithFormat : @"colonne%d-%d", 2*j+1,i];
      if (aTask4!=nil) [records setObject:aTask4 forKey:key2];
      else [records removeObjectForKey:key2];
    }
    // On enlève la ligne sélectionné
    //NSLog(@"On enleve la dernière ligne");
    for (j=0;j<3;j++) {
      NSString *key3=[NSString stringWithFormat : @"colonne%d-%d", 2*j+1,debut+1];
      [records removeObjectForKey:key3];
    }
    
  
    // On met à jour les lignes
    for (i=19;i>debut;i--) {
      if ([ [clickedLines objectAtIndex:i-1] isEqual: @"G"]) {
        [clickedLines replaceObjectAtIndex:i-1 withObject: @"N" ];
        [clickedLines replaceObjectAtIndex:i withObject: @"G" ];
      }
    }
      
   [tableView reloadData];
   [self updateChangeCount:NSChangeDone]; 
  }
    
}

//---------------------------------------------------------------


- (IBAction) addCategory:(id)sender { 
  [rightView addCategory];
}


//---------------------------------------------------------------

- (IBAction)removeRow:(id)sender { 
  int debut=[tableView selectedRow];
  JMRTache *aTask = [self getTacheAtColumn:1 atRow:debut];
  JMRTache *aTask1 = [self getTacheAtColumn:3 atRow:debut];
  JMRTache *aTask2 = [self getTacheAtColumn:5 atRow:debut];
  
  if ((aTask==nil)&& (aTask1==nil) && (aTask2==nil)){
    // On peut décaler car il y a de la place sur la dernière ligne
    //NSLog(@"On peut enlever");
    int j,i;
    
    //int debut=[tableView selectedRow];
    // On recopie les lignes
    for (i=debut;i<19;i++) for (j=0;j<3;j++) {
      //NSLog(@"i%d j%d",i,2*j+1);
      JMRTache *aTask4;
      NSString *key1=[NSString stringWithFormat : @"colonne%d-%d", 2*j+1,i+1];
      aTask4=[records objectForKey:key1];
      NSString *key2=[NSString stringWithFormat : @"colonne%d-%d", 2*j+1,i];
      if (aTask4!=nil) [records setObject:aTask4 forKey:key2];
      else [records removeObjectForKey:key2];
    }
    // On enlève la dernière ligne 
    //NSLog(@"On enleve la dernière ligne");
    for (j=0;j<3;j++) {
      NSString *key3=[NSString stringWithFormat : @"colonne%d-%d", 2*j+1,19];
     [records removeObjectForKey:key3];
     
     }
    // On met à jour les lignes
    for (i=debut;i<18;i++) {
      if ([ [clickedLines objectAtIndex:i+1] isEqual: @"G"]) {
        [clickedLines replaceObjectAtIndex:i+1 withObject: @"N" ];
        [clickedLines replaceObjectAtIndex:i withObject: @"G" ];
      }
    }
      
   [tableView reloadData];
   [self updateChangeCount:NSChangeDone]; 
  }
    
}


@end

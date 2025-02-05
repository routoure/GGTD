/* All Rights reserved */

#import "Document.h"
#import "Model.h"

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
    
    if ([cell isKindOfClass:[NSTextFieldCell class]]) {
        NSTextFieldCell *textCell = (NSTextFieldCell *)cell;
            
        // mise à la ligne de la cellule  
        [textCell setWraps:YES];
        [textCell setLineBreakMode:NSLineBreakByWordWrapping];
        // Supprimer les bordures et le style par défa 
      
        NSInteger column= [[thisTableView tableColumns] indexOfObject:tableColumn];
        
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
    
    column = [columns objectAtIndex: 0];
    [column setWidth: 25];
    [column setEditable: NO];
    [column setResizable: NO];
    [column setIdentifier: @"colonne0"];
    [[column headerCell] setStringValue: @""];
  
    column = [columns objectAtIndex: 1];
    [column setWidth: 125];
    [column setEditable: YES];
    [column setResizable: YES];
    [column setIdentifier: @"colonne1"];
    [[column headerCell] setStringValue: @"Rapidement"];
  
    column = [columns objectAtIndex: 2];
    [column setWidth: 25];
    [column setEditable: NO];
    [column setResizable: NO];
    [column setIdentifier: @"colonne2"];
    [[column headerCell] setStringValue: @""];
    
    column = [columns objectAtIndex: 3];
    [column setWidth: 125];
    [column setEditable: YES];
    [column setResizable: YES];
    [column setIdentifier: @"colonne3"];
    [[column headerCell] setStringValue: @"Bientôt"];

    column = [columns objectAtIndex: 4];
    [column setWidth: 25];
    [column setEditable: NO];
    [column setResizable: NO];
    [column setIdentifier: @"colonne4"];
    [[column headerCell] setStringValue: @""];

    column = [[NSTableColumn alloc] initWithIdentifier: @"colonne5"];
    
    [column setWidth: 125];
    [column setEditable: YES];
    [column setResizable: YES];
    
    [[column headerCell] setStringValue: @"Pour mémoire"];
  
    [tableView addTableColumn: column];
    [column release];

    [tableView setAutoresizesAllColumnsToFit: YES];
    
    [tableView setDocument: self];
    
    // Drag and drop 
    
    // ajout d'un sous-menu
     NSMenu *myMenu = [[NSMenu alloc] initWithTitle:@"Tasks"];
     NSMenuItem *newItem1 = [[NSMenuItem alloc] initWithTitle:@"Delete"
                        action:@selector(delete:)
                        keyEquivalent:nil];
     NSMenuItem *newItem2 = [[NSMenuItem alloc] initWithTitle:@"Done"
                        action:@selector(done:)
                        keyEquivalent:@"d"];
     NSMenuItem *newItem3 = [[NSMenuItem alloc] initWithTitle:@"Show done tasks"
                        action:@selector(showDone:)
                        keyEquivalent:nil];
     // Ajouter l'élément au menu
    [myMenu addItem:newItem1];
    [myMenu addItem:newItem2];
    [myMenu addItem:newItem3];
    // Ajouter ce menu à la barre de menus principale
    [NSApp.mainMenu addItemWithTitle:@"Tasks" action:nil keyEquivalent:@""];
    [NSApp.mainMenu setSubmenu:myMenu forItem:[NSApp.mainMenu itemWithTitle:@"Tasks"]];

        
        
     // Lecture des des données    
     // IL faut aller lire les données puis demander à la Afficher
     
     // On récupère le nom du fichier 
     NSString *documentName= [self fileName];
    
     //NSLog(@"Lecture des données enregistré dans le fichier %@",documentName);
     [self readFromFile:documentName ofType:@""];
     
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
     else [resultat setString:@"o"];
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
    
    NSArray *objectsToSave =[NSArray arrayWithObjects:records, doneTasks, clickedLines,nil ];
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

  NSLog(@"%@",records);  
  
  [doneTasks release];
  doneTasks = [results objectAtIndex: 1];
  
  NSLog(@"%@",doneTasks);
  
  [clickedLines release ];
  clickedLines = [results objectAtIndex: 2];  
 
   NSLog(@"%@",clickedLines);
 
  return YES;        
  }

// ---------------------------------------------------------------------------------

- (id) init{
    self = [super init];
    records = [[NSMutableDictionary alloc] init];
    doneTasks= [[NSMutableArray alloc] init];
    clickedLines=[[NSMutableArray alloc] init];
    // Defalt name of the documen.
    // should be done with the preferences
    [self setFileName:@"MyTask.jmr"]; 
    //[self setFileType:@"jmr"];
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
       NSString *key=[[NSString alloc] initWithFormat : @"colonne%d-%d", clickedColumn,clickedRow];
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
       [key release];
     }
   }
}

- (IBAction) delete:(id)sender {
  NSLog(@"Delete");
  
}

- (IBAction)saveDocument:(id)sender {
  [super saveDocument:sender];
}  

- (IBAction)infoPanel:(id)sender {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"About"];
    [alert setInformativeText:@"Yet Another GTD \nBut with GNUStep \n \n Nobody should have more than 60 tasks to remenber\n If you like this software, please send me a postcard at jmroutoure AT gmail DOT com"];
    [alert addButtonWithTitle:@"OK"];
    [alert runModal]; // Bloque l'exécution jusqu'à la fermeture de l'alerte
}

@end

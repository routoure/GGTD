// Drag 
 - (NSImage *)tableView:(NSTableView *)aTableView draggingImageForRowsWithIndexes:(NSIndexSet *)indexes
                 event:(NSEvent *)event dragImageOffset:(NSPointPointer)dragImageOffset
{
    NSPoint point = [tableView convertPoint:[event locationInWindow] fromView:nil];
    //NSLog(@"Point cliqué x%f",point.x);
    //NSLog(@"Point cliqué y%f",point.y);
    
    NSInteger row = [tableView rowAtPoint:point];
    NSInteger column= [tableView columnAtPoint:point];
    NSLog(@"Drag sur colonne:%d ligne:%d",column,row);
    

    // Ici, crée l'image de la cellule que tu veux glisser
    NSCell *cell = [aTableView preparedCellAtColumn:column row:row];
    NSSize size = [cell cellSize]; // Taille que tu veux
    NSPoint origin = NSMakePoint(0, 0); // Origine du rectangle

// Création du NSRect en utilisant l'origine et la taille
    NSRect rect = NSMakeRect(origin.x, origin.y, size.width, size.height);
    
    NSImage *dragImage = [[NSImage alloc] initWithSize:size];
   
    
    // Pour dessiner la cellule dans l'image
    [dragImage lockFocus];
    [cell drawWithFrame:rect inView:aTableView];
    [dragImage unlockFocus];
    
    //*dragImageOffset = cell.frame.origin; // Position de départ de l'image
    return dragImage;
}

// Il faut accepter le drop   
- (NSDragOperation)tableView:(NSTableView *)aTableView validateDrop:(id <NSDraggingInfo>)info
                proposedRow:(NSInteger)row proposedColumn:(NSInteger)column
{
    if (row >= 0 && column >= 0) {
        return NSDragOperationMove; // ou NSDragOperationCopy si tu veux un comportement de copie
    }
    return NSDragOperationNone; // On ne permet pas le drop si ce n'est pas une cellule valide
}

// Et ensuite gérer le drop


- (BOOL)tableView:(NSTableView *)aTableView acceptDrop:(id <NSDraggingInfo>)info
                row:(NSInteger)row column:(NSInteger)column
{
    if (row >= 0 && column >= 0) {
        // Récupérer les données de la cellule source (ce que tu as glissé)
        // Ici, on suppose que les données sont stockées dans un tableau bidimensionnel
        //NSIndexPath *sourceIndexPath = ... // Obtenu de la source de drag
        //id dataToMove = [dataArray objectAtIndex:sourceIndexPath.row][sourceIndexPath.column];

        // Maintenant, on met à jour les données pour la cellule cible
        //NSMutableArray *targetRow = dataArray[row];
        //targetRow[column] = dataToMove;

        // On supprime la donnée de la cellule source
        //NSMutableArray *sourceRow = dataArray[sourceIndexPath.row];
        //sourceRow[sourceIndexPath.column] = nil; // ou un autre comportement

        // On rafraîchit la table
        [aTableView reloadData];
        return YES;
    }
    return NO;
}
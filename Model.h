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

#import <Foundation/Foundation.h>

@interface JMRTache : NSObject <NSCoding>
{
  NSString *nom;   // le texte de la tâche qui apparait dans le tableau
  NSString *key; // Identifiant de la colonne
  NSInteger duree; // la  durée du projet 0 : cours . / 1: moyen o / 2 : long O
  NSInteger etat;  // L'état du projet  0 : noté 1 programmé 2 
  //NSDate *dateDebut;
  //NSDate *dateFin;   
}

- (void) JMRInitWithNom: (NSString*) uneChaine 
         withKey: (NSString*) uneKey
         withDuree: (NSInteger) uneDuree 
         withEtat: (NSInteger) unEtat;

- (void) JMRSetNom: (NSString *)uneChaine;

- (void) JMRSetKey: (NSString *)uneKey;
- (void) JMRSetDuree: (NSInteger ) uneDuree;
- (void) JMRSetEtat:  (NSInteger )unEtat;
- (void) JMRIncreaseEtat;
- (void) JMRIncreaseDuree;


- (NSString *) JMRGetNom ;
- (NSString *) JMRGetKey;

- (NSInteger ) JMRGetDuree;
- (NSInteger) JMRGetEtat;

@end
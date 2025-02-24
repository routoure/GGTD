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
#import "Model.h"

@implementation JMRTache 



- (void) JMRInitWithNom: (NSString*) unNom 
         withKey: (NSString*) uneKey
         withDuree: (NSInteger) uneDuree 
         withEtat: (NSInteger) unEtat;
{
  [self JMRSetNom:unNom];
  [self JMRSetKey:uneKey];
  duree=uneDuree;
  etat=unEtat;
  }


// une chaine a ete initee quelque part et son compteur de ref=1
// si le programmeur est compétent, ce pointeur sera libéré après l'affectation
- (void) JMRSetNom: (NSString *) uneChaine{
  [uneChaine retain]; // il faut donc incrementer le pointeur de reference
  [nom release]; // liberer la mémoire occupé par nom
  nom=uneChaine; //et faire pointer nom vers uneChaine 
  }


- (void) JMRSetKey: (NSString *) uneKey {
  [uneKey retain];
  [key release];
  key=uneKey;
  }

- (void) JMRSetDuree: (NSInteger)uneDuree{
    duree=uneDuree;
  }

- (void) JMRSetEtat: (NSInteger) unEtat {
    etat=unEtat;
  }

- (NSString *) JMRGetNom {
  return nom;
}

- (NSString *) JMRGetKey{
  return key;
}

- (NSInteger) JMRGetDuree {
  return duree;
}
- (NSInteger) JMRGetEtat {
  return etat;
}

//-------------------------------------------------------
-(void) encodeWithCoder:(NSCoder *)coder{
     [coder encodeObject:nom forKey:@"JMRTacheName"];
     [coder encodeObject:key forKey:@"JMRTacheKey"];
     [coder encodeInteger:duree forKey:@"JMRTacheDuree"];
     [coder encodeInteger:etat forKey:@"JMRTacheEtat"  ];
}

//-------------------------------------------------------
-(id) initWithCoder:(NSCoder *)coder{

nom = [[coder decodeObjectForKey:@"JMRTacheName"]retain ];
key = [[coder decodeObjectForKey:@"JMRTacheKey"]retain ];
duree = [coder decodeIntegerForKey:@"JMRTacheDuree"];
etat = [coder decodeIntegerForKey:@"JMRTacheEtat"] ;
//NSLog(@"Initialisation OK");
return self;
}

//-------------------------------------------------------

-(void) JMRIncreaseDuree {
  duree=duree+1;
  if (duree==3) duree=0;
  }
  
//-------------------------------------------------------

-(void) JMRIncreaseEtat {
  etat=etat+1; 
  if (etat==4) etat=0;
 }
 
//-------------------------------------------------------


-(NSString *) description {
  NSString *result=[[NSString alloc]initWithFormat:@"%@-%d-%d", nom, duree, etat ];
  if (nom ==nil) 
     [ result stringByAppendingFormat:@"null" ];
  return result;   
}
@end 
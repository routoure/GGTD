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
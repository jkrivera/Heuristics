/*********************************************
 * OPL 12.4 Model
 * Author: jrivera6
 * Creation Date: 25/08/2021 at 7:18:46
 *********************************************/

 int n = ...;
 
 int m = ...;
 
 range J = 1..n;
 
 range Jp = 0..n;
 
 int P[i in J] = ...; // processing time
 
 dvar float+ X[Jp,Jp]; // 1 if job i is performed before job j
 
 dvar float+ Cmax; // Makespan
 
 dvar float+ T[Jp]; // starting time

 int M = sum(i in J) P[i];
 
 
 minimize
  Cmax;
    
  
 subject to {

  // Constraint 1
  forall( i in J ) 
    sum(j in Jp : i!=j) X[i][j] == 1;

  // Constraint 2
  forall( i in Jp ) 
    sum(j in Jp : i!=j) (X[i][j] - X[j][i]) == 0;

  // Constraint 3
  sum( j in J ) X[0][j] == m;
        
  // Constraint 4       
  forall( i in J, j in J : i!=j )
    T[j] >= T[i] + P[i] - M*(1 - X[i][j]);

  // Constraint 5       
  forall( i in J )
    Cmax >= T[i] + P[i];
    
  forall( i in J, j in J )
    X[i][j] <= 1;

}


execute SETTINGS {
  settings.displayComponentName = true;
  settings.displayWidth = 40;
}
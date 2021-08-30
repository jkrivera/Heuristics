/*********************************************
 * OPL 12.4 Model
 * Author: jrivera6
 * Creation Date: 25/08/2021 at 7:37:58
 *********************************************/

 int n = ...;
 
 int m = ...;
 
 range J = 1..n;
 
 range K = 1..m;
  
 int P[i in J] = ...; // processing time
 
 dvar float+ X[J,K]; // 1 if job i is performed in machine k
 
 dvar int+ Cmax; // Makespan
 

 minimize
  Cmax;
    
 subject to {

  // Constraint 1
  forall( i in J ) 
    sum( k  in K ) X[i][k] == 1;

  // Constraint 2       
  forall( k in K )
    Cmax >= sum( i in J ) P[i]*X[i][k];
    
    forall( i in J, j in K )
    X[i][j] <= 1;

}


execute SETTINGS {
  settings.displayComponentName = true;
  settings.displayWidth = 40;
}
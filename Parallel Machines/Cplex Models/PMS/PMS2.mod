 int n = ...;
 
 int m = ...;
 
 range J = 1..n;
 
 range K = 1..m;
  
 int P[i in J] = ...; // processing time
 
 dvar boolean X[J,K]; // 1 if job i is performed in machine k
 
 dvar float+ Cmax; // Makespan
 
 dvar float+ t[J];
 
execute PARAMS {
  cplex.tilim = 300;
};

 minimize
  Cmax;
    
 subject to {

  // Constraint 1
  forall( i in J ) 
    sum( k  in K ) X[i][k] == 1;

  // Constraint 2       
  forall( k in K )
    Cmax >= sum( i in J ) P[i]*X[i][k];
    
 t[1]==0;
 t[5]==110;
    
X[6][1]==1;
X[1][2]==1;
X[2][3]==1;
X[5][2]==1;
X[10][1]==1;
X[4][3]==1;
//    forall( i in J, j in K )
//    X[i][j] <= 1;

}


execute SETTINGS {
  settings.displayComponentName = true;
  settings.displayWidth = 40;
}
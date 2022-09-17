/*********************************************
 * OPL 12.4 Model
 * Author: jrivera6
 * Creation Date: 27/04/2022 at 15:11:50
 *********************************************/

int n = ...;
int P = ...;
int serv = ...;
range V = 0..2*n;
range Vl = 1..2*n;
range Vd = 1..n;
range Vp = n+1..2*n;

int d[i in V][j in V] = ...;
int a[i in Vl][j in Vl] = ...;
int q[i in Vl] = ...;

dvar boolean X[V][V];
dvar boolean Y[Vl][Vl];
dvar boolean W[Vl][Vl];
dvar float+ t[Vl];
dvar int+ L[V][V];

execute PARAMS {
  cplex.tilim = 300;
};

minimize
  sum( i in V, j in V ) d[i,j]*X[i,j] + sum( i in Vp, j in Vd ) a[i,j]*Y[i,j];
    
  subject to {

  // Constraint 4
  forall (i in Vl)
    sum(j in V : i!=j) (X[i,j] - X[j,i]) + sum(j in Vl : i!=j) (Y[i,j]  - Y[j,i]) == 0;
  
  sum(j in V : j!=0) (X[0,j] - X[j,0]) == 0;
  
  sum(j in Vp )X[j,0] == 1;
  
//  sum(j in Vd )X[0,j] == 1;

  forall( i in Vl ) 
      sum ( j in V : i!=j ) X[i,j] + sum (j in Vd) Y[i,j] == 1;
  
//  sum ( i in Vp, j in Vd ) Y[i,j] == 1;

  // Constraint 5       
  forall( j in Vl, i in Vl : i!=j )
      t[j] >= t[i] + d[i,j] - 600*1000*(1-X[i,j]);
  
  forall( j in Vd, i in Vp )
      t[j] >= t[i] + a[i,j] - 600*1000*(1-Y[i,j]);

  forall( i in Vd )
      t[i+n] >= t[i] + serv;
  
  forall( j in Vl )
  	t[j] >= d[0,j] - 10*60*1000*(1-X[0,j]);
 
  forall( j in Vd, i in Vp : i!=j )
      t[i] <= 4*60*1000 + 600*1000*(1-Y[i,j]);

  forall( j in Vd, i in Vp : i!=j )
      t[j] >= 6*60*1000 - 600*1000*(1-Y[i,j]);
    
  forall( i in Vp )
    t[i] <= (4+2+4)*60*1000;
    
  forall( i in Vp )
    t[i] + d[i,0] <= (4+2+4)*60*1000 + (4+2+4)*60*1000*(1-X[i,0]);

  // Load constraints

  forall(i in Vl)
    sum (j in V : i!=j ) (L[j,i]-L[i,j])==q[i];

  forall( j in Vl, i in Vl : i!=j )
    L[i,j] <= P*(X[i,j]+Y[i,j]);

  forall( j in Vl, i in Vl : i!=j )
    L[i,j] >= P*Y[i,j];
    
  forall( i in V )
    L[i,0] == P * X[i,0];
  
  // TSP based constraints
  
  sum( i in Vp, j in Vd )
    Y[i,j] == 1;
     
  sum( i in Vd, j in Vl )
    Y[i,j] == 0;

  sum( i in Vl, j in Vp )
    Y[i,j] == 0;
  
  sum ( i in Vd ) X[i,i+n] <= 6;
  
  // Relative positions

  forall( j in Vl, i in Vl : i!=j )
    t[j] >= t[i] + d[i,j] - 600*1000*(1-W[i,j]);
  
  forall( i in Vd )
    W[i,i+n] == 1;
    
  forall( i in Vl, j in Vl )
    X[i,j]+Y[i,j] <= W[i,j];

  forall( i in Vl, j in Vl : i!=j )
    W[i,j] + W[j,i] == 1;
  
  forall( i in Vl )
    forall( j in Vl : i!=j )
      forall( k in Vl : k!=i && k!=j )
        W[i,k] + W[k,j] - W[i,j] <= 1;
        
//  forall ( i in Vd )
//    t[i+n] - t[i] - serv <= 10000;

}
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
int TSP[0..n+1] = ...;

dvar boolean X[V][V];
dvar boolean Y[V][V];
dvar float+ t[V];
dvar int+ L[V][V];

execute PARAMS {
  cplex.tilim = 300;
};

minimize
  sum( i in V, j in V ) d[i,j]*X[i,j] + sum( i in Vp, j in Vd ) a[i,j]*Y[i,j];
    
 subject to {

  // Constraint 2
  forall( i in Vd ) 
      sum ( j in V : i!=j ) X[i,j] == 1;

  forall( i in Vp ) 
      sum ( j in V : i!=j ) X[i,j] + sum (j in Vd) Y[i,j] == 1;

  sum ( j in Vd ) X[0,j] == 1;

  sum ( j in Vp ) X[0,j] == 0;

  // Constraint 3
  forall( j in Vd ) 
      sum ( i in V : i!=j ) X[i,j] + sum ( i in Vp ) Y[i,j] == 1;

  forall( j in Vp ) 
      sum ( i in V : i!=j ) X[i,j] == 1;

  sum ( j in Vp ) X[j,0] == 1;
        
  // Constraint 4       
  forall (i in V)
    sum(j in V : i!=j) (X[i,j] + Y[i,j] - X[j,i] - Y[j,i]) == 0;

  // Constraint 5       
  forall( j in V, i in Vl : i!=j )
      t[j] >= t[i] + d[i,j] - 600*1000*(1-X[i,j]);
  
  forall( i in Vd )
      t[i+n] >= t[i] + serv;
  
  
  forall( j in V, i in Vl : i!=j )
  	t[j] >= d[0,j] - 600*1000*(1-X[0,j]);
  
  forall( j in V, i in V : i!=j )
      t[i] <= 4*60*1000 + 600*1000*(1-Y[i,j]);

  forall( j in Vl, i in V : i!=j )
      t[j] >= 6*60*1000 - 600*1000*(1-Y[i,j]);
      
  forall( i in V )
    t[i] <= (4+2+4)*60*1000;
    
  // Load constraints

  forall(i in Vl)
    sum (j in V : i!=j ) (L[j,i]-L[i,j])==q[i];
    
  forall( j in V, i in V : i!=j )
    L[i,j] <= P*X[i,j];

  forall( j in V, i in V : i!=j )
    L[i,j] >= P*Y[i,j];
    
  
  // TSP based constraints
  
  forall( i in 1..n )
     t[TSP[i+1]] >= t[TSP[i]];
     
  //sum ( i in 1..n ) X[i,i+n] <=10/P;

}
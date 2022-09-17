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
dvar boolean Y[V][V];
dvar float+ t[V];
dvar int+ L[V][V];

execute PARAMS {
  cplex.tilim = 600;
};

minimize
  sum( i in V, j in V ) d[i,j]*X[i,j] + sum( i in Vp, j in Vd ) a[i,j]*Y[i,j];
    
 subject to {

  // Constraint 2
//  forall( i in Vd ) 
//      sum ( j in V : i!=j ) X[i,j] == 1;

//  forall( i in Vp ) 
//      sum ( j in V : i!=j ) X[i,j] + sum (j in Vd) Y[i,j] == 1;

  sum ( j in Vd ) X[0,j] == 1;
  
  sum ( j in Vp ) X[0,j] == 0;

  //sum ( j in V : j!=TSP[1] ) X[0,j] == 0;

  // Constraint 3
//  forall( j in Vd ) 
//      sum ( i in V : i!=j ) X[i,j] + sum ( i in Vp ) Y[i,j] == 1;

//  forall( j in Vp ) 
//      sum ( i in V : i!=j ) X[i,j] == 1;

//  sum ( j in Vp ) X[j,0] == 1;
        
  // Constraint 4       
  forall (i in V)
    sum(j in V : i!=j) (X[i,j] + Y[i,j] - X[j,i] - Y[j,i]) == 0;

  // Constraint 5       
  forall( j in V, i in Vl : i!=j )
      t[j] >= t[i] + d[i,j] - 600*1000*(1-X[i,j]);
  
  forall( j in Vd, i in Vp )
      t[j] >= t[i] + a[i,j] - 600*1000*(1-Y[i,j]);

  forall( i in Vd )
      t[i+n] >= t[i] + serv;
  
  
  forall( j in V )
  	t[j] >= d[0,j] - 10*60*1000*(1-X[0,j]);
 
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
    L[i,j] <= P*(X[i,j]+Y[i,j]);

  forall( j in V, i in V : i!=j )
    L[i,j] >= P*Y[i,j];
  
  sum( i in Vd, j in V )
    Y[i,j] == 0;

  sum( i in V, j in Vp )
    Y[i,j] == 0;
  
  //X[0,TSP[1]] == 1;
  
  //X[TSP[1],TSP[2]] + X[TSP[1]+n,TSP[2]] == 1;
  
  //sum ( i in 1..n ) X[i,i+n] <=10/P;
  
  
  X[0,10] == 1;
  X[10,8] == 1;
  X[8,9] == 1;
  X[9,19] == 1;
  X[19,18] == 1;
  X[18,20] == 1;
//  X[20,5] == 1;
//  X[5,4] == 1;
//  X[4,14] == 1;
//  X[14,15] == 1;
//  X[15,3] == 1;
//  X[3,1] == 1;
//  X[1,11] == 1;
//  X[11,13] == 1;
    
//  Y[13,7] == 1;
  
//  X[7,17] == 1;
//  X[17,6] == 1;
//  X[6,16] == 1;
//  X[16,2] == 1;
//  X[2,12] == 1;
//  X[12,0] == 1;

}
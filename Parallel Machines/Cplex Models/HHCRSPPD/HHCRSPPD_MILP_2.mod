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
    
  L[0,TSP[1]]==P;
  
  sum( i in Vd : i!=TSP[1] ) L[0,i]==0;
  
  forall( i in V )
    L[i,0] == P * X[i,0];
  
  // TSP based constraints
  
  t[TSP[1]] >= d[0,TSP[1]];
  
  forall( i in 1..n-1 )
     t[TSP[i+1]] >= t[TSP[i]] + d[TSP[i],TSP[i+1]];
     
//  sum( i in Vp, j in Vd )
//    Y[i,j] == 1;
     
  sum( i in Vd, j in Vd : j>i )
    Y[TSP[i]+n,TSP[j]] == 1;
       
  sum( i in Vd, j in Vl )
    Y[i,j] == 0;

  sum( i in Vl, j in Vp )
    Y[i,j] == 0;
  
  //X[0,TSP[1]] == 1;
  
  //X[TSP[1],TSP[2]] + X[TSP[1]+n,TSP[2]] == 1;
  
  // TSP as destin
  
  forall( i in 1..3 )
    X[TSP[i-1],TSP[i]] + sum( j in 1..i-1 )X[TSP[j]+n,TSP[i]] == 1;
  
  sum ( j in V : j!=TSP[1] ) X[0,j] == 0;

  forall( i in 4..n )
    X[TSP[i-1],TSP[i]] + sum( j in 1..i-1 )X[TSP[j]+n,TSP[i]] + sum( j in 1..i-1 )Y[TSP[j]+n,TSP[i]] == 1;
    
  // TSP as origin
    
  forall( i in Vd )
    X[TSP[i],TSP[i+1]] + sum( j in Vp )X[TSP[i],j] == 1;
  
  // TSP+n as origin
  
  sum ( j in Vp ) X[j,0] == 1;
    
  forall( i in Vd )
    sum( j in i+1..n ) X[TSP[i]+n,TSP[j]] + sum( j in i+1..n ) Y[TSP[i]+n,TSP[j]] + sum( j in Vp ) X[TSP[i]+n,j] == 1;
  
  // TSP+n as destin
  
  forall( i in Vd )
    sum( j in i..n )X[TSP[j],TSP[i]+n] + sum( j in Vp : j!=TSP[i]+n )X[j,TSP[i]+n] == 1;

  //sum ( i in 1..n ) X[i,i+n] <=10/P;
  
  // Relative positions

  forall( j in Vl, i in Vl : i!=j )
    t[j] >= t[i] + d[i,j] - 600*1000*(1-W[i,j]);
  
  forall( i in Vd )
    W[i,i+n] == 1;
    
  forall( i in Vl, j in Vl )
    X[i,j]+Y[i,j] <= W[i,j];

  forall( i in Vd : i<n )
    W[TSP[i],TSP[i+1]] == 1;

  forall( i in Vl, j in Vl : i!=j )
    W[i,j] + W[j,i] == 1;
  
  forall( i in Vl )
    forall( j in Vl : i!=j )
      forall( k in Vl : k!=i && k!=j )
        W[i,k] + W[k,j] - W[i,j] <= 1;

//  X[0,9] == 1;
//  X[9,19] == 1;
//  X[19,10] == 1;
//  X[10,2] == 1;
//  X[2,4] == 1;
//  X[4,6] == 1;
//  X[6,16] == 1;
//  X[16,12] == 1;
//  X[12,14] == 1;
//  X[14,5] == 1;
//  X[5,3] == 1;
//  X[3,20] == 1;
//  X[20,15] == 1;
//  X[15,13] == 1;
  
//  Y[13,7] == 1;
  
//  X[7,17] == 1;
//  X[17,8] == 1;
//  X[8,18] == 1;
//  X[18,1] == 1;
//  X[1,11] == 1;
//  X[11,0] == 1;

}
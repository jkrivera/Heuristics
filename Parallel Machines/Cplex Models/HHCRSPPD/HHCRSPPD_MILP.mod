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
//  forall( i in Vd ) 
//      sum ( j in V : i!=j ) X[i,j] == 1;

//  forall( i in Vp ) 
//      sum ( j in V : i!=j ) X[i,j] + sum (j in Vd) Y[i,j] == 1;

//  sum ( j in Vd ) X[0,j] == 1;

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
  
  // TSP based constraints
  
  forall( i in 1..n )
     t[TSP[i+1]] >= t[TSP[i]] + d[TSP[i],TSP[i+1]];
     
//  sum( i in Vp, j in Vd )
//    Y[i,j] == 1;
     
  sum( i in Vd, j in Vd : j>i )
    Y[TSP[i]+n,TSP[j]] == 1;

  sum( i in Vd, j in V )
    Y[i,j] == 0;

  sum( i in V, j in Vp )
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
  
  
//  X[0,9] == 1;
//  X[9,19] == 1;
//  X[19,10] == 1;
//  X[10,2] == 1;
//  X[2,12] == 1;
//  X[12,4] == 1;
//  X[4,14] == 1;
 // X[14,6] == 1;
  //X[19,6] == 1;
  //X[6,5] == 1;
  //X[5,15] == 1;
  //X[15,16] == 1;
  
  //Y[16,3] == 1;
  
  //X[3,7] == 1;
  //X[7,8] == 1;
  //X[8,1] == 1;
  //X[1,11] == 1;
  //X[11,18] == 1;
  //X[18,17] == 1;
  //X[17,13] == 1;
  //X[13,0] == 1;

}
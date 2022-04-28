/*********************************************
 * OPL 12.4 Model
 * Author: M
 * Creation Date: 15/03/2016 at 11:04:45
 *********************************************/

using CP;

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

dvar int p[V] in V;
dvar int s[V] in V;
dvar int l[Vl] in 0..1;
dvar int t[V];
dvar int r[V] in 0..P;

//var p = cp.param;
//p.timeLimit = 120;

execute {
cp.param.TimeLimit = 60;
}


minimize 
	sum(i in V) (d[i][s[i]] );//*(1-l[i])) + sum(i in Vp) (a[i][s[i]]*l[i]);
	
	subject to {
	  
	  allDifferent(all (i in V) p[i] );
	  
	  //allDifferent(all (i in V) s[i] );
	  
	  inverse(all[V](i in V)p[i],all[V](j in V)s[j]);
	  
//	  sum(i in Vl)l[i] == 1;
	  
//	  forall(i in V) s[p[i]] == i;
	  
	  forall(i in Vl) t[s[i]] >= t[i] + d[i][s[i]];
	  
//	  t[s[0]] >= d[0][s[0]];
	  
	  forall(i in Vp) t[i] >= t[i-n] + serv; 
	  
//	  forall(i in Vl) t[i] <= 240000 * l[i];
	  
//	  forall(i in Vl) t[s[i]] >= 360000 * l[i];
	  
	  forall(i in V) t[i] <= 600000;
	  
	  forall(i in Vl) r[i] == r[p[i]] - q[i];
	  
	  r[0]==P;
	    
 }
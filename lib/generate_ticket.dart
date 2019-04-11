//https://stackoverflow.com/questions/3438456/complex-process-of-making-a-typical-housie-bingo-game-ticket
import 'dart:core';
import 'dart:math';

List<List<int>> generateColumns() {
  List<List<int>> col = new List();
  List<int> selectNums = new List<int>.generate(90, (i) => i+1);

  for(int i=0; i<9; i++) {
    col.add(new List());
  }

  var rand = new Random.secure();

  //adding 9 random numbers to their designated columns. each column will get 1 number
  for(int i=0; i<9; i++) {
    int x;
    x = rand.nextInt(10);  
    if(i==0) {
      do {
        x = rand.nextInt(10); 
      }while(x==0);   
      col[0].add(x);
      selectNums.remove(x);
      continue;
    }
    if(i==8) {
      x = rand.nextInt(11);
      int n=(80+x);
      col[i].add(n);
      selectNums.remove(n);
      continue;
    }
    col[i].add((i*10)+x);
    selectNums.remove((i*10)+x);
  }

  //adding 6 random numbers in their designated columns randomly. 
  for(int i=0; i<6; i++) {
    int a, x, n;
    do{
      a = rand.nextInt(9);
    }while(col[a].length == 3);
    do{
      do{
        x = rand.nextInt(10);
      }while(x==0);
      n = (a*10) + x;
    }while(col[a].contains(n));
    col[a].add(n);
    selectNums.remove(n);
  }

  //sorting all columns in ascending order
  for(int i=0; i<9; i++) {
    col[i].sort();
  }
  return col;
}

//return columns with 3 numbers
List<int> getCol3(List<List<int>> col) {
  List<int> temp;
  for(int i=0; i<col.length; i++) {
    if(col[i].length==3) {
      temp=col[i];
      col.removeAt(i);
      break;
    }
  }
  return temp;
}

//return columns with 2 numbers
List<int> getCol2(List<List<int>> col) {
  List<int> temp;
  for(int i=0; i<col.length; i++) {
    if(col[i].length==2) {
      temp=col[i];
      col.removeAt(i);
      break;
    }
  }
  return temp;
}

//return columns with 2 numbers
List<int> getCol1(List<List<int>> col) {
  List<int> temp;
  for(int i=0; i<col.length; i++) {
    if(col[i].length==1) {
      temp=col[i];
      col.removeAt(i);
      break;
    }
  }
  return temp;
}

List<List<int>> generateTicket() {

  List<List<int>> col = generateColumns();
  int r1c=0, r2c=0, r3c=0;

  List<List<int>> ticket = List<List<int>>.generate(3, (i) => List<int>.generate(9, (j) => 0));

  List<int> temp;
  bool flag=true;

  //adding columns with 3 numbers
  while(flag) {
    temp=getCol3(col);
    if(temp==null){
      flag=false;
      break;
    }
    r1c++;r2c++;r3c++;
    int x = (temp[0]/10).floor();
    for(int i=0; i<3; i++) {
      ticket[i][x] = temp[i];
    }
  }
  
  //adding columns with 2 numbers
  flag=true;
  int n=0;
  while(flag) {
    temp=getCol2(col);
    n++;
    if(temp==null){
      flag=false;
      break;
    }
    int x = (temp[0]/10).floor();
    if(n%3==1) {
      ticket[0][x] = temp[0];
      ticket[1][x] = temp[1];
      r1c++;r2c++;
    }
    if(n%3==2) {
      ticket[1][x] = temp[0];
      ticket[2][x] = temp[1];
      r2c++;r3c++;
    }
    if(n%3==0) {
      ticket[0][x] = temp[0];
      ticket[2][x] = temp[1];
      r1c++;r3c++;
    }
  }
  //adding columns with 1 numbers
  flag=true;
  while(flag) {
    temp = getCol1(col);
    if(temp==null){
      flag=false;
      break;
    }
    int x = (temp[0]/10).floor();
    if(temp[0] == 90) x=8;
    int c=0;
    while(r1c>0 && r2c>0 && r3c>0) {  
      r1c--;r2c--;r3c--;c++;
    }
    if(r1c==c) {
      ticket[0][x] = temp[0];
      r1c++;
    }
    else if(r2c==c) {
      ticket[1][x] = temp[0];
      r2c++;
    }
    else {
      ticket[2][x] = temp[0];
      r3c++;
    }
  }
  return transpose(ticket);
}

List<List<int>> transpose(List<List<int>> col) {
  List<List<int>> tr = new List<List<int>>();
  for(int i=0; i<col[0].length; i++) {
    tr.add(new List<int>());
  }
  for(int i=0; i<tr.length; i++) {
    for(int j=0; j<col.length; j++) {
      tr[i].add(col[j][i]);
    }
  }
  return tr;
}

// void main() {
//   List<List<int>> x =generateTicket();
//   print(x[0].toString()+"\n"+x[1].toString()+"\n"+x[2].toString()+"\n");
//   List<List<int>> y=transpose(x);
//   for(int i=0; i<y.length; i++)
//     print(y[i]);
// }
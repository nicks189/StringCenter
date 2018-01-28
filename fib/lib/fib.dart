class fib
{
  fib();
  int calculate(int n) {
    int first = 1;
    int second = 1;
    if (n == 1) {return first;}
    else if (n == 2) {return second;}
    else {
      int r = 1;
      for (int i = 3; i <= n; i++) {
        r = first + second;
        first = second;
        second = r;
      }
      return r;
    }
  }
}
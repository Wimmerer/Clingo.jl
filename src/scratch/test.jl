using Clingo
x,y = Clingo.testsolve("#const n=4. c(1..n). 1 {color(X,I) : c(I)} 1 :- v(X). :- color(X,I), color(Y,I), e(X,Y), c(I). v(1..100). e(1,55).")
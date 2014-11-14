function[daySeconds]=getSeconds()

d=datevec(now);

daySeconds=d(6)+60*d(5)+60*60*d(4);
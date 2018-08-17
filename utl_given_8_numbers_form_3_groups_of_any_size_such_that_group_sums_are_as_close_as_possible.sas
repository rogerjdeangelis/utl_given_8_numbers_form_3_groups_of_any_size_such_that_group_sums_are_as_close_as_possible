Given 8 numbers form 3 groups of any size such that group sums are as close as possible

see the amazing preferred solution by Muthia on the end
Muthia Kachirayan <muthia.kachirayan@GMAIL.COM>

github
https://tinyurl.com/y9z38wu7
https://github.com/rogerjdeangelis/utl_given_8_numbers_form_3_groups_of_any_size_such_that_group_sums_are_as_close_as_possible

INPUT ( Over 19,000 group enummerated groups)
=====

 WORK.HAVEG total obs=52,128 |  RULES
                             |
     GRP   SUBGRP EGT    NUM |  SUMS
                             |
      1      L     8      1  |
      1      L     8      2  |
      1      L     8      3  |
      1      L     8      4  |
      1      L     8      5  |
      1      L     8      7  |  22   (1+2+3+4+5+7)
                             |
      1      M     8      8  |   8    (22,8,6) quite different sums)
                             |
      1      R     8      6  |   6

   2548     L      8      1  |
   2548     L      8      2  |
   2548     L      8      3  |
   2548     L      8      6  |  12   (1+2+3+6) =12
                             |       (12,12,12) 0 coef of variation
                             |
   2548     M      8      5  |       as close as possible
   2548     M      8      7  |  12   (5+7) = 12
                             |
   2548     R      8      8  |
   2548     R      8      4  |  12   (4+8) = 12


PROCESS
=======


proc sql;
  create
    table havSum as
  select
    seq,
    cv(grpSum) as coefVar
  from
    (
      select
        seq
       ,grp
       ,sum(num) as grpSum
      from
        havEgt
      group
        by seq, grp
    )
  group
    by seq
  order
    by coefVar
;quit;


 WORK.HAVSUM total obs=6,516

 Obs     SEQ     COEFVAR

   1     2548    0.00000

 data grp;
   set havEgt(where=(seq=2548));
 run;quit;

  40 obs WORK.GRP total obs=8

    SEQ    GRP    EGT    NUM

   2548     L      8      1
   2548     L      8      2
   2548     L      8      3
   2548     L      8      6

   2548     M      8      5
   2548     M      8      7

   2548     R      8      4
   2548     R      8      8

*                _              _       _
 _ __ ___   __ _| | _____    __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \  / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/ | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|  \__,_|\__,_|\__\__,_|

;

proc datasets lib=work;
delete kall;
run;quit;

data _null_;

 do k = 6 to 1 by -1;
  call symputx("k",k);
  rc=dosubl('
  data k&k;
     array x[8]  (1 2 3 4 5 6 7 8);
     array c[&k] ;
     array i[&k];
     n=dim(x);
     k=dim(i);
     i[1]=0;
     ncomb=comb(n,k);
     do j=1 to ncomb+1;
        rc=lexcombi(n, k, of i[*]);
        do h=1 to k;
           c[h]=x[i[h]];
        end;
        put @4 j= @10 "i= " i[*] +3 "c= " c[*] +3 rc=;
        keep k c1-c6;
        output;
     end;
  run;quit;
  proc append data=k&k base=kall;
  run;quit;
 ');
 end;
 stop;

run;quit;

%array(idx,values=1-6);
proc sql;
  create
   table enum as
  select
     monotonic() as seq
    ,l.k as k1
    ,c.k as k2
    ,r.k as k3
    %do_over(idx,phrase=%str(,l.c? as l?, c.c? as m?, r.c? as r?))
  from
    kall as l, kall as c, kall as r
  where
    sum(l.k,c.k,r.k) = 8 and
    sum(l1,l2,l3,l4,l5,l6,m1,m2,m3,m4,m5,m6,r1,r2,r3,r4,r5,r6)=36
;quit;

proc transpose data=enum out=havXpo(where=(col1 ne .));
by seq k1 k2 k3 ;
run;quit;

proc sort data=havXpo ou nodupkey;
by seq _name_  col1;
run;quit;

proc sql;
  create
     table havEgt as
  select
     seq
    ,substr(_name_,1,1)   as grp
    ,count(distinct col1) as Egt
    ,col1 as num
  from
     havSrt
  group
     by seq
  having
     count(distinct col1) = 8
  order
     by seq, num
;quit;

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __
/ __|/ _ \| | | | | __| |/ _ \| '_ \
\__ \ (_) | | |_| | |_| | (_) | | | |
|___/\___/|_|\__,_|\__|_|\___/|_| |_|

;

proc sql;
  create
    table havSum as
  select
    seq,
    cv(grpSum) as coefVar
  from
    (
      select
        seq
       ,grp
       ,sum(num) as grpSum
      from
        havEgt
      group
        by seq, grp
    )
  group
    by seq
  order
    by coefVar
;quit;


data grp;
  set havEgt(where=(seq=2548));
run;quit;


  SEQ    K1    K2    K3    _NAME_    COL1

 2548     4     2     2      L1        1
 2548     4     2     2      L2        2   12
 2548     4     2     2      L3        3
 2548     4     2     2      L4        6

 2548     4     2     2      M1        5
 2548     4     2     2      M2        7   12

 2548     4     2     2      R1        4
 2548     4     2     2      R2        8   12


*__  __       _   _     _
|  \/  |_   _| |_| |__ (_) __ _
| |\/| | | | | __| '_ \| |/ _` |
| |  | | |_| | |_| | | | | (_| |
|_|  |_|\__,_|\__|_| |_|_|\__,_|

;

 Hi Max,

[1] Here is a Data Step. A random sample of numbers (&nobs) are generated
and these are assigned to 3 Groups as you wanted. Assume that number of
numbers are in multiple of 3. These numbers are stored into a _temporary_
array. The entire numbers are sorted in ascending order. Next consider the
numbers in three triplets. The first triplet will have values lesser than
the other two triplets. Assign the last value of the First triplet to First
Group and the first value to the Third Group. Similarly we do for the
Second Triplet. The first value of the Last Triplet will go to the First
Group and the third value goes to the Third Group. This arrangement tries
to equalize the Sums for each Group. Here is the program:


%let ngrp = 3;
%let nobs = 9;
data want;
array k[&nobs] _temporary_ ;
length sumlist $300;
if _N_ = 1 then do;
   call streaminit(123);
   do i = 1 to &nobs.;
      u = ceil(rand("uniform") * 99);
      k[i] = u;
   end;
   call sortN(of k[*]);
end;

array sum[&ngrp] _temporary_;
   retain j &ngrp.;
   do i = 1 to dim(k);
      select(ceil(i/&ngrp));
         when(1) do;
            group = j;
            NUM = k[i];
            sum[j] + NUM;
            output;
            j +- 1;
            if j = 0 then j = &ngrp;
         end;
         when(2) do;
            group = j;
            NUM = k[i];
            sum[j] + NUM;
            output;
            j +- 1;
         end;
         when(3) do;
            j ++ 1;
            group = j;
            NUM = k[i];
            sum[j] + NUM;
            output;
         end;
         otherwise;
      end;
   end;
   sumlist = catq('D',',', of sum[*]);
   put sumlist =;
keep group NUM;
run;

The LOG gives the Sums for the 3 Groups.(sumlist=78,78,79)

The Want Data Set is not in sorted order of Group. You may sort it if you
want to have the individual values for each Group.

proc sort data = want;
   by group;
run;

[2] You can increase the &nobs (in multiples of 3).
[3] Number of groups can be increased. You must increase the WHEN in SELECT
to match to the requirements. Also introduce codes to adjust the Sums as
done for the First and Second Triplets here.
[4] When number of observations are not in multiple of 3, this code is not
designed for it. A simple way is to take the largest multiple of 3 which
will leave at most 2 values. Use the code for grouping. After Groups are
made you can assign the left out values to specific Groups to equalize the
Sums.

Cheers.
Muthia Kachirayan






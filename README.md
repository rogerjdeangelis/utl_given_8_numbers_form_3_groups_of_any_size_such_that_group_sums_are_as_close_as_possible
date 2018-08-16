# utl_given_8_numbers_form_3_groups_of_any_size_such_that_group_sums_are_as_close_as_possible
Given 8 numbers form 3 groups of any size such that group sums are as close as possible.  Keywords: sas sql join merge big data analytics macros oracle teradata mysql sas communities stackoverflow statistics artificial inteligence AI Python R Java Javascript WPS Matlab SPSS Scala Perl C C# Excel MS Access JSON graphics maps NLP natural language processing machine learning igraph DOSUBL DOW loop stackoverflow SAS community.
    Given 8 numbers form 3 groups of any size such that group sums are as close as possible

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




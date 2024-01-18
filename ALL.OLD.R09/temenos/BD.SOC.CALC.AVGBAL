$PACKAGE BD.Soc
*
* Implementation of BD.SOC.SocGetAvgBal
*
* Y.ACCOUNTNO(IN) :
* Y.START.DATE(IN) :
* Y.END.DATE(IN) :
* Y.BALANCE.TYPE(IN) :
* Y.PROPERTY(IN) :
* Y.BALANCE(OUT) :
*
SUBROUTINE BD.SOC.CALC.AVGBAL(Y.ACCOUNTNO, Y.START.DATE, Y.END.DATE, Y.BALANCE.TYPE, Y.PROPERTY, Y.BALANCE)

    $INSERT I_COMMON
    $INSERT I_EQUATE
    
    $USING AA.Rules
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING AC.AccountOpening
    $USING EB.API

    FN.AC = 'F.ACCOUNT'
    F.AC = ''
    EB.DataAccess.Opf(FN.AC,F.AC)
    EB.DataAccess.FRead(FN.AC, accountId, R.AC, F.AC, Er.AC)
    Y.OPEN.DATE = R.AC<AC.AccountOpening.Account.OpeningDate>
    Y.TEMP.START.DATE = Y.START.DATE
    IF Y.START.DATE LT Y.OPEN.DATE THEN
        Y.START.DATE = Y.OPEN.DATE
    END
    CALL AA.GET.PERIOD.BALANCES(Y.ACCOUNTNO, Y.BALANCE.TYPE,"",Y.START.DATE,Y.END.DATE,"", BAL.DETAILS, ERROR.MESSAGE)
    IF BAL.DETAILS THEN
        Y.TRAN.DATES = FIELD(BAL.DETAILS,FM,1)
        Y.TRAN.BAL=FIELD(BAL.DETAILS,FM,4)
        CRT Y.TRAN.DATES
        CRT Y.TRAN.BAL
        Y.DATE =FIELD(Y.TRAN.DATES,VM,1)
        Y.CNT.TRAN = DCOUNT(Y.TRAN.DATES,VM)
        Y.TXN.END.DATE = FIELD(Y.TRAN.DATES,VM,Y.CNT.TRAN)
        IF Y.TXN.END.DATE LE Y.END.DATE THEN
            Y.TRAN.DATES = Y.TRAN.DATES:VM:Y.END.DATE
        END
        IF Y.START.DATE LT Y.DATE THEN
            IF Y.OPEN.DATE LE Y.START.DATE THEN
                Y.TRAN.DATES = Y.START.DATE:VM:Y.TRAN.DATES
                Y.TRAN.BAL = 0:VM:Y.TRAN.BAL
            END ELSE
                Y.TRAN.DATES<1,1> = Y.START.DATE
            END
        END
        IF Y.START.DATE GE Y.DATE THEN
            Y.TRAN.DATES<1,1> = Y.START.DATE
            Y.TRAN.BAL = Y.TRAN.BAL
        END
    END
    CONVERT VM TO FM IN Y.TRAN.DATES
    CONVERT VM TO FM IN Y.TRAN.BAL
    NO.OF.DATES = DCOUNT(Y.TRAN.BAL,FM)
    IF NO.OF.DATES > 1 THEN
        FOR I = 1 TO NO.OF.DATES
            YDATE1 = Y.TRAN.DATES<I>
            YDATE2 = Y.TRAN.DATES<I+1>
            IF YDATE2 EQ "" THEN
                YDATE2 = YDATE1    ;* include the current day balance
            END
            NO.OF.DAYS = "C"
            EB.API.Cdd("",YDATE1,YDATE2,NO.OF.DAYS) ;* No Of days the balance has contributed to the total outstanding balance
            IF I EQ NO.OF.DATES THEN
                NO.OF.DAYS +=1
            END
            TOT.NO.OF.DAYS += NO.OF.DAYS
            TEMP.AMT = Y.TRAN.BAL<I>
            TEMP.AMT = SUM(TEMP.AMT)
            TOT.WEIGHTED.AMT += TEMP.AMT * NO.OF.DAYS ;* Calculate the total amount
        NEXT I
    END ELSE
        TOT.WEIGHTED.AMT = SUM(Y.TRAN.BAL<1>) ;* Current date transaction so no of days can only be 1.
        TOT.NO.OF.DAYS = 1
    END
    TOT.AVERAGE = TOT.WEIGHTED.AMT / TOT.NO.OF.DAYS
    Y.BALANCE = DROUND(TOT.AVERAGE,2)
RETURN
END
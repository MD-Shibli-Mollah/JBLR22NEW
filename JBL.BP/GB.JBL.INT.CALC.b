SUBROUTINE GB.JBL.INT.CALC (arrId,arrProp,arrCcy,arrRes,balanceAmount,perDat)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_AA.LOCAL.COMMON
    
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING AA.Framework
    $USING AA.ProductFramework
    $USING AA.Interest
    $USING ST.RateParameters
    $USING AA.ActivityCharges
    $USING AC.AccountOpening
    $USING AC.Fees
    $USING AA.TermAmount
    
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
    
RETURN

*---------------
INIT:
*--------------
    FN.AA.ARR = 'F.AA.ARRANGEMENT'
    F.AA.ARR = ''
 
    FN.PERIODIC.INTEREST = 'FBNK.PERIODIC.INTEREST'
    F.PERIODIC.INTEREST = ''
    
    FN.BASIC.INT = 'FBNK.BASIC.INTEREST'
    F.BASIC.INT = ''
    balanceAmount = '0'
RETURN
*---------------
OPENFILES:
*---------------
    EB.DataAccess.Opf(FN.PERIODIC.INTEREST,F.PERIODIC.INTEREST)
    EB.DataAccess.Opf(FN.BASIC.INT, F.BASIC.INT)
    EB.DataAccess.Opf(FN.AA.ARR,F.AA.ARR)
RETURN
*---------------
PROCESS:
*---------------
    ArrangementId = arrId   ;*Arrangement ID
    accountId = AA.Framework.getC_aaloclinkedaccount() ;* Arrangement Account
    Y.ACTIVITY.ID = AA.Framework.getC_aaloccurractivity() ;* Arrangement Activity
    EB.DataAccess.FRead(FN.AA.ARR, ArrangementId, REC.ARR, F.AA.ARR, ERR.RES)
    yStartDate = REC.ARR<AA.Framework.Arrangement.ArrStartDate>
    yendDate = EB.SystemTables.getToday()
    
    PropertyClass1 = 'TERM.AMOUNT'
    AA.Framework.GetArrangementConditions(ArrangementId, PropertyClass1, Idproperty, Effectivedate, Returnids, Returnconditions1, Returnerror) ;* Product conditions with activities
    R.REC1 = RAISE(Returnconditions1)
    Y.TERM.AMOUNT = R.REC1<AA.TermAmount.TermAmount.AmtAmount>
* Y.TERM = R.REC1<AA.TermAmount.TermAmount.AmtTerm>

    GOSUB CALC.DAYS ; * DAYS CALCULATION
    yDays = AccrDays
*IF yDays EQ 90 OR yDays EQ 180 OR yDays EQ 360 ; * Actual
*   GOSUB MATURE.PROFIT
*END
*-------------------------------------------------------------------------------
    Y.BSC.ID = '11BDT' ;* BASIC INTEREST RATE
    SEL.CMD = 'SELECT ':FN.BASIC.INT:' WITH @ID LIKE ':Y.BSC.ID:'...'
    EB.DataAccess.Readlist(SEL.CMD, SEL.LIST, '', NO.OF.BASIC, ERR.INT)
    Y.SEPARATE.ID.1 = SEL.LIST<NO.OF.BASIC>
    Y.INT.EFF.DATE = RIGHT(Y.SEPARATE.ID.1,8)
    IF Y.INT.EFF.DATE GT EB.SystemTables.getToday() AND NO.OF.BASIC GE 2 THEN
        Y.SEPARATE.ID.1 = SEL.LIST<NO.OF.BASIC-1>
    END
    EB.DataAccess.FRead(FN.BASIC.INT,Y.SEPARATE.ID.1,REC.BASIC.INT,F.BASIC.INT, ERR.BASIC)
    Y.BASIC.INT.RT = REC.BASIC.INT<ST.RateParameters.BasicInterest.EbBinInterestRate>
*-----------------------------------------------------------------------------------------
    Y.PERIODIC.ID = '01BDT' ; * PERIODIC INTEREST RATE
    SEL.CMD = 'SELECT ':FN.PERIODIC.INTEREST:' WITH @ID LIKE ':Y.PERIODIC.ID:'...'
    EB.DataAccess.Readlist(SEL.CMD, SEL.LIST, '', NO.OF.PERIODIC, ERR.INT)
    Y.SEPARATE.ID.2 = SEL.LIST<NO.OF.PERIODIC>
    Y.INT.EFF.DATE = RIGHT(Y.SEPARATE.ID.2,8)
    IF Y.INT.EFF.DATE GT EB.SystemTables.getToday() AND NO.OF.PERIODIC GE 2 THEN
        Y.SEPARATE.ID.2 = SEL.LIST<NO.OF.PERIODIC-1>
    END
    EB.DataAccess.FRead(FN.PERIODIC.INTEREST,Y.SEPARATE.ID.2,REC.PERIODIC.INT,F.PERIODIC.INTEREST, ERR.BASIC)
    Y.REST.PERIOD = REC.PERIODIC.INT<ST.RateParameters.PeriodicInterest.PiRestPeriod>
    Y.PERIODIC.INT.RT = REC.PERIODIC.INT<ST.RateParameters.PeriodicInterest.PiBidRate>
    CONVERT @SM TO @VM IN Y.REST.PERIOD
    CONVERT @SM TO @VM IN Y.PERIODIC.INT.RT
    FOR I=1 TO DCOUNT(Y.REST.PERIOD,@VM)
        IF Y.REST.PERIOD<1,I> EQ '03M' OR Y.REST.PERIOD<1,I> EQ '3M' THEN
            Y.3M.PREOD.INT.RATE = Y.PERIODIC.INT.RT<1,I>
        END
        IF Y.REST.PERIOD<1,I> EQ '06M' OR Y.REST.PERIOD<1,I> EQ '6M' THEN
            Y.6M.PREOD.INT.RATE = Y.PERIODIC.INT.RT<1,I>
        END
            
    NEXT I
    
    IF yDays LT 90 THEN ; * Days Less then 90 premature calculation
        yPerDays = 0
        ySavDays = yDays
        GOSUB PREMATURE.PROFIT
    END
      
    IF yDays GT 90 AND yDays LT 180 THEN ; * Days grather than 90 and less than 180 premature calculation
        yPerDays = 90
        ySavDays = yDays-90
        GOSUB PREMATURE.PROFIT
    END
    
    IF yDays GT 180 AND  yDays LT 360 THEN ; * Days grather than 180 and less than 360 premature calculation
        yPerDays = 180
        ySavDays = yDays-180
        GOSUB PREMATURE.PROFIT
    END
 balanceAmount = DROUND(Y.PAY.CUS.INT,2)
   * balanceAmount = '0'
    GOSUB FILE.WRITE
RETURN

*---------
CALC.DAYS:
*---------
    Rates = 0
    BaseAmts = 0
    InterestDayBasis = 'A'
    Ccy = 'BDT'
    AC.Fees.EbInterestCalc(yStartDate, yendDate, Rates, BaseAmts, IntAmts, AccrDays, InterestDayBasis, Ccy, RoundAmts, RoundType, Customer)
RETURN
*-----------------
PREMATURE.PROFIT:
*-----------------
    Y.PERIODIC.INT.RT = 0
    IF yPerDays EQ 90 THEN
        Y.PERIODIC.INT.RT = Y.3M.PREOD.INT.RATE
    END
    IF yPerDays EQ 180 THEN
        Y.PERIODIC.INT.RT = Y.6M.PREOD.INT.RATE
    END
*Y.PRE.PROFIT = DROUND(((Y.DAYS*Y.TERM.AMOUNT*Y.INT.RATE)/(100*360)),2)
    Y.PAY.CUS.INT = ((Y.TERM.AMOUNT*Y.PERIODIC.INT.RT*yPerDays)/36000) + ((Y.TERM.AMOUNT*Y.BASIC.INT.RT*ySavDays)/36000)
    
RETURN

*--------------
FILE.WRITE:
*--------------
    Y.DATA = 'Trigger':',':ArrangementId:';':balanceAmount:';':Y.BASIC.INT.RT:';':Y.PERIODIC.INT.RT:';':Y.TERM.AMOUNT:';':Y.PAY.CUS.INT:';':Y.3M.PREOD.INT.RATE:';':Y.6M.PREOD.INT.RATE:';':ySavDays:',':yPerDays:';':Y.SEPARATE.ID.1:';':Y.SEPARATE.ID.2
    Y.DIR = '/Temenos/T24/UD/JBL.BP/'
    Y.FILE.NAME = ArrangementId:'.TEXT.txt'
    OPENSEQ Y.DIR,Y.FILE.NAME TO F.DIR THEN NULL
    WRITESEQ Y.DATA APPEND TO F.DIR ELSE
        CRT "Unable to write"
        CLOSESEQ F.DIR
    END
RETURN
END

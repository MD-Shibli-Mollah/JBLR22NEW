****************************************************
*-----------------------------------------------------------------------------
* <Rating>69</Rating>
*-----------------------------------------------------------------------------
* PROGRAM : PROGRAM TO CREATE A CSV FILE FOR ACCR INTEREST
* DEV BY      : MD. Bahar Uddin
* DEV DATE    : 2020-08-27
* UPDATE DATE : 2020-08-27
* REQ         : ICTD
****************************************************
    PROGRAM ICTD.GET.ACCR.INT.CR
    $INSERT GLOBUS.BP I_COMMON
    $INSERT GLOBUS.BP I_EQUATE
    $INSERT GLOBUS.BP I_ENQUIRY.COMMON
    $INSERT GLOBUS.BP I_GTS.COMMON
    $INSERT GLOBUS.BP I_BATCH.FILES
    $INSERT GLOBUS.BP I_F.ACCR.ACCT.CR

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
    RETURN

*----
INIT:
*----

    FN.ACCT = 'FBNK.ACCR.ACCT.CR'
    F.ACCT = ''

    Y.FILE.DIR = 'RPT.DATA.DIR'
    Y.FILE.NAME = 'ACCR.ACCT.CR.':TODAY:'.csv'
    Y.FILE = Y.FILE.DIR :'/': Y.FILE.NAME

    RETURN
*---------
OPENFILES:
*---------

    CALL OPF(FN.ACCT,F.ACCT)

!-------Check Directory----------
    CMD.STR = "CREATE.FILE RPT.DATA.DIR TYPE=UD"
    CUR.DIR = "RPT.DATA.DIR"

    OPEN CUR.DIR TO F.RPT.DATA.DIR
    ELSE
        EXECUTE CMD.STR
        OPEN CUR.DIR TO F.RPT.DATA.DIR
        ELSE
            CRT CUR.DIR "OPENING FAILED"
            RETURN
        END
    END
!-------------------------------
    RETURN
*-------
PROCESS:
*-------

    SEL.CMD='SELECT ':FN.ACCT
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)
    Y.COUNT = 0
    LOOP
        REMOVE Y.REC.ID FROM SEL.LIST SETTING Y.POS
    WHILE Y.REC.ID:Y.POS
        CALL F.READ(FN.ACCT,Y.REC.ID,R.ACCT,F.ACCT,ACCT.ERR)

        Y.INT.FINAL.AMT = 0

        FOR I = 1 TO DCOUNT(R.ACCT<IC.ACRCR.CR.INT.AMT>,@VM)
            Y.INT.AMT = FIELD(R.ACCT<IC.ACRCR.CR.INT.AMT>,@VM,I)
            Y.INT.DATE = FIELD(R.ACCT<IC.ACRCR.CR.INT.DATE>,@VM,I)

            Y.INT.MONTH = OCONV(ICONV(Y.INT.DATE,'D'),"DM")
            Y.CURR.MONTH = OCONV(DATE(),"DM")
            IF (Y.INT.MONTH EQ (Y.CURR.MONTH-3) OR Y.INT.MONTH EQ (Y.CURR.MONTH-2) OR Y.INT.MONTH EQ (Y.CURR.MONTH-1) ) THEN
                Y.INT.FINAL.AMT = Y.INT.FINAL.AMT + Y.INT.AMT
            END

        NEXT

        Y.REC<-1>=Y.REC.ID:'|':R.ACCT<IC.ACRCR.PERIOD.FIRST.DATE>:'|':R.ACCT<IC.ACRCR.PERIOD.LAST.DATE>:'|':R.ACCT<IC.ACRCR.TOTAL.INTEREST>:'|':R.ACCT<IC.ACRCR.GRAND.TOTAL>:'|':R.ACCT<IC.ACRCR.INT.POST.DATE>:'|':Y.INT.FINAL.AMT

        Y.COUNT++
        Y.PROGRESS = MOD(Y.COUNT,5000)
        IF Y.PROGRESS EQ 0 THEN
            Y.PERCENT = Y.COUNT*100/NO.OF.REC
            PRINT DROUND(Y.PERCENT,0):'% is Completed.'
        END

    REPEAT
    OPEN Y.FILE.DIR TO F.FILE.DIR ELSE NULL
    WRITE Y.REC TO F.FILE.DIR,Y.FILE.NAME
    RETURN
END

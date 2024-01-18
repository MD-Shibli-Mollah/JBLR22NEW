*-----------------------------------------------------------------------------
* <Rating>302</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE JBL.S.CALCULATE.AVG.BAL(IN.VAL,OUT.VAL)

* Subroutine to calculate average balances for accounts
* between two given dates.
* Incoming IN.VAL variable = &#1;Account.no, Start date, End date
* Outgoing OUT.VAL variable = Days in Credit , Avrg Credit Balance
*                            Days in Debit , Avrg Debit Balance
*                            Number of days at Zreo balance
*
*************************************************************************

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCT.ACTIVITY
    $INSERT I_F.ACCOUNT

*************************************************************************
*  Initialise Variables
***************************
*
    ACCOUNT.DETAILS = IN.VAL
    OUT.VAL=''
    START.DATE = ACCOUNT.DETAILS[1,8]
    END.DATE = ACCOUNT.DETAILS[9,8]
    ACCOUNT.NO = ACCOUNT.DETAILS[17,16]
    ACCREC = ""
    NO.DAYS = "C"
    ZERO.DAYS = "0"
    DR.DAYS = "0"
    CR.DAYS = "0"
    DR.AV.BAL = "0"
    CR.AV.BAL = "0"
    CURR.DATE = START.DATE
    ACCOUNT.BAL = ""
    START.YRMN = START.DATE[1,6]
    START.DAY = START.DATE[7,2]
    END.YRMN = END.DATE[1,6]
    END.DAY = END.DATE[7,2]
    CURRENCY = ""
    END.FLAG = 0
    CNT = 1

    TOT.CR.BAL = '' ;* CI_10004707s
    TOT.DR.BAL = '' ;* CI_10004707e

*
*  Check startdate not greater than enddate
*
    IF START.DATE > END.DATE THEN

        ETEXT ="AC.RTN.START.DATE.GT.THAN.END.DATE"
        GOTO PGM.EXIT
    END
*
*  Call routine to extract opening balance
*
    CALL GET.ENQ.BALANCE(ACCOUNT.NO,START.DATE,ACCOUNT.BAL)
*
*  Open and read account file to extract currency
*
    CALL OPF("F.ACCOUNT",F.ACCOUNT)
    CALL F.READ("F.ACCOUNT",ACCOUNT.NO,REC,F.ACCOUNT,READ.ERR)
    CURRENCY = REC<AC.CURRENCY>
*
*  Read Acct.Activity recs and locate correct dated entries
*  Open Acct.Activity file, locate correct mnth,year in Acct.Acct
*
    CALL GET.ACTIVITY.DATES(ACCOUNT.NO, YR.YEARM)
    CALL OPF("F.ACCT.ACTIVITY",F.ACCT.ACTIVITY)
****************************************************
* Main process
****************************************************
    LOCATE START.YRMN IN YR.YEARM<1> BY "AR" SETTING YLOC ELSE
        NULL
    END
    LOOP
        IF YR.YEARM<YLOC> <> "" THEN
*
*  Read Acct.Activity records while valid dates exist
*
            ACCID = ACCOUNT.NO:"-":YR.YEARM<YLOC>
            CALL F.READ("F.ACCT.ACTIVITY",ACCID,ACCREC,F.ACCT.ACTIVITY,READ.ERR)
            IF READ.ERR THEN
                ETEXT ="AC.RTN.NO.AC.ACTIVITY.ON.REC"
                GOTO PGM.EXIT
            END
*
*
*  Process all Acct.Activity record for valid date and call calc process
*
            D.FLAG = 0
            CNT = 1
            LOOP WHILE ACCREC<IC.ACT.DAY.NO,CNT> <> "" AND D.FLAG = 0
                REC.DATE = YR.YEARM<YLOC> : ACCREC<IC.ACT.DAY.NO,CNT>
                IF REC.DATE >= START.DATE AND REC.DATE <= END.DATE THEN
                    GOSUB CALC.FIELDS
                END ELSE
                    IF REC.DATE >= START.DATE THEN
                        REC.DATE = END.DATE
                        D.FLAG = 1
                    END
                END
                CNT += 1
            REPEAT
            YLOC +=1
        END ELSE
            REC.DATE = END.DATE
            END.FLAG = 1
        END
    WHILE END.YRMN GE YR.YEARM<YLOC> AND END.FLAG = 0
    REPEAT
    REC.DATE = END.DATE
    GOSUB CALC.FIELDS
    GOSUB FINAL.CALC
    RETURN
*
*-----------------------------------------------------------------------------
*****************************
* Calculate account balances
*  cr bal, dr bal, no of days at dr, cr and zero bal
*****************************
CALC.FIELDS:
    NO.DAYS = "C"
    CALL CDD("",CURR.DATE,REC.DATE,NO.DAYS)
    CURR.DATE = REC.DATE
    NEW.BAL = ACCREC<IC.ACT.BALANCE,CNT>
*
    BEGIN CASE
    CASE ACCOUNT.BAL < 0
        DR.DAYS += NO.DAYS
        DR.BAL = NO.DAYS * ACCOUNT.BAL
        TOT.DR.BAL += DR.BAL
    CASE ACCOUNT.BAL = "0"
        ZERO.DAYS += NO.DAYS
    CASE ACCOUNT.BAL > 0
        CR.DAYS += NO.DAYS
        CR.BAL = NO.DAYS * ACCOUNT.BAL
        TOT.CR.BAL += CR.BAL
    END CASE
*
    ACCOUNT.BAL = NEW.BAL
    RETURN
*
*--------------------------------------------------------------
FINAL.CALC:
* Credit bal - ie av credit bal for tot time in credit
    IF CR.DAYS AND CR.DAYS <> 0 THEN
        CR.AV.BAL = TOT.CR.BAL/CR.DAYS
        CALL EB.ROUND.AMOUNT(CURRENCY,CR.AV.BAL,"","")
    END
* Debit bal - ie av debit bal for total time in debit
    IF DR.DAYS AND DR.DAYS <> 0 THEN
        DR.AV.BAL = TOT.DR.BAL/DR.DAYS
        CALL EB.ROUND.AMOUNT(CURRENCY,DR.AV.BAL,"","")
    END
*
* Convert to O.Data for return to enquiry
*
*    O.DATA = CR.DAYS:">":CR.AV.BAL:">":DR.DAYS:">":DR.AV.BAL:">":ZERO.DAYS
    OUT.VAL= CR.DAYS:">":CR.AV.BAL:">":DR.DAYS:">":DR.AV.BAL:">":ZERO.DAYS
    RETURN
*
PGM.EXIT:
    COMI = ""
    RETURN
*
*--------------------------------------------------------------
*
END

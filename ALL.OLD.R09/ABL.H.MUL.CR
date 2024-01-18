*-----------------------------------------------------------------------------
* <Rating>451</Rating>
*-----------------------------------------------------------------------------
* Version 9 15/11/00  GLOBUS Release No. G11.1.01 11/12/00

    SUBROUTINE  ABL.H.MUL.CR
******************************************************************

    $INSERT GLOBUS.BP I_COMMON
    $INSERT GLOBUS.BP I_EQUATE
    $INSERT JBL.BP I_F.ABL.H.MUL.CR
    $INSERT GLOBUS.BP I_F.CATEGORY
    $INSERT GLOBUS.BP I_F.ACCOUNT
    $INSERT GLOBUS.BP I_F.POSTING.RESTRICT
    $INSERT GLOBUS.BP I_F.CHEQUE.TYPE.ACCOUNT
    $INSERT GLOBUS.BP I_F.CHEQUE.REGISTER
    $INSERT GLOBUS.BP I_F.CHEQUES.PRESENTED
*************************************************************************

    GOSUB DEFINE.PARAMETERS

    IF LEN(V$FUNCTION) GT 1 THEN
        GOTO V$EXIT
    END

    CALL MATRIX.UPDATE

    GOSUB INITIALISE          ;* Special Initialising

*************************************************************************

* Main Program Loop

    LOOP

        CALL RECORDID.INPUT

    UNTIL (MESSAGE EQ 'RET')

        V$ERROR = ''

        IF MESSAGE EQ 'NEW FUNCTION' THEN

            GOSUB CHECK.FUNCTION        ;* Special Editing of Function

            IF V$FUNCTION EQ 'E' OR V$FUNCTION EQ 'L' THEN
                CALL FUNCTION.DISPLAY
                V$FUNCTION = ''
            END

        END ELSE

            GOSUB CHECK.ID    ;* Special Editing of ID
            IF V$ERROR THEN GOTO MAIN.REPEAT

            CALL RECORD.READ

            IF MESSAGE EQ 'REPEAT' THEN
                GOTO MAIN.REPEAT
            END

            CALL MATRIX.ALTER

            GOSUB CHECK.RECORD          ;* Special Editing of Record
            IF V$ERROR THEN GOTO MAIN.REPEAT

            LOOP
                GOSUB PROCESS.FIELDS    ;* ) For Input
                GOSUB PROCESS.MESSAGE   ;* ) Applications
            WHILE (MESSAGE EQ 'ERROR') REPEAT

        END

MAIN.REPEAT:
    REPEAT

    V$EXIT:
    RETURN          ;* From main program

*************************************************************************
*                      S u b r o u t i n e s                            *
*************************************************************************


PROCESS.FIELDS:

* Input or display the record fields.

    LOOP
        IF SCREEN.MODE EQ 'MULTI' THEN
            IF FILE.TYPE EQ 'I' THEN
                CALL FIELD.MULTI.INPUT
            END ELSE
                CALL FIELD.MULTI.DISPLAY
            END
        END ELSE
            IF FILE.TYPE EQ 'I' THEN
                CALL FIELD.INPUT
            END ELSE
                CALL FIELD.DISPLAY
            END
        END

    WHILE NOT(MESSAGE)

        GOSUB CHECK.FIELDS    ;* Special Field Editing

        IF T.SEQU NE '' THEN T.SEQU<-1> = A + 1

    REPEAT

    RETURN

*************************************************************************

PROCESS.MESSAGE:

* Processing after exiting from field input (PF5)

    IF MESSAGE = 'DEFAULT' THEN
        MESSAGE = 'ERROR'     ;* Force the processing back
        IF V$FUNCTION <> 'D' AND V$FUNCTION <> 'R' THEN
            GOSUB CROSS.VALIDATION
        END
    END

    IF MESSAGE = 'PREVIEW' THEN
        MESSAGE = 'ERROR'     ;* Force the processing back
        IF V$FUNCTION <> 'D' AND V$FUNCTION <> 'R' THEN
            GOSUB CROSS.VALIDATION
            IF NOT(V$ERROR) THEN
REM >               GOSUB DELIVERY.PREVIEW   ; * Activate print preview
            END
        END
    END

    IF MESSAGE EQ 'VAL' THEN
        MESSAGE = ''
        BEGIN CASE
        CASE V$FUNCTION EQ 'D'
            GOSUB CHECK.DELETE          ;* Special Deletion checks
        CASE V$FUNCTION EQ 'R'
            GOSUB CHECK.REVERSAL        ;* Special Reversal checks
        CASE OTHERWISE
            GOSUB CROSS.VALIDATION      ;* Special Cross Validation
            IF NOT(V$ERROR) THEN
                GOSUB OVERRIDES
            END
        END CASE
        IF NOT(V$ERROR) THEN
            GOSUB BEFORE.UNAU.WRITE     ;* Special Processing before write
        END
        IF NOT(V$ERROR) THEN
            CALL UNAUTH.RECORD.WRITE
            IF MESSAGE NE "ERROR" THEN
                GOSUB AFTER.UNAU.WRITE  ;* Special Processing after write
            END
        END

    END

    IF MESSAGE EQ 'AUT' THEN
        GOSUB AUTH.CROSS.VALIDATION     ;* Special Cross Validation
        IF NOT(V$ERROR) THEN
            GOSUB BEFORE.AUTH.WRITE     ;* Special Processing before write
        END

        IF NOT(V$ERROR) THEN

            CALL AUTH.RECORD.WRITE

            IF MESSAGE NE "ERROR" THEN
                GOSUB AFTER.AUTH.WRITE  ;* Special Processing after write
            END
        END

    END

    RETURN

*************************************************************************
*                      Special Tailored Subroutines                     *
*************************************************************************

CHECK.ID:

* Validation and changes of the ID entered.  Set ERROR to 1 if in error.
    CALL EB.FORMAT.ID("BKACC")

    IF E THEN V$ERROR = 1

    RETURN

*************************************************************************

CHECK.RECORD:
* Validation and changes of the Record.  Set ERROR to 1 if in error.
!    FN.CAT='F.CATEGORY'
!    F.CAT=''
!    REC.CAT=''
!    Y.CAT.ID=''
!
!    FN.AC='F.ACCOUNT'
!    F.AC=''
!    REC.AC=''
!    Y.AC.ID=''
!
!    FN.POS.RES='F.POSTING.RESTRICT'
!    F.POS.RES=''
!    REC.POS.RES=''
!
!    FN.CHEQUE.REGISTER = 'F.CHEQUE.REGISTER'
!    F.CHEQUE.REGISTER = ''
!    CALL OPF(FN.CHEQUE.REGISTER,F.CHEQUE.REGISTER)
!
!    FN.CHEQUES.STOPPED = 'F.CHEQUES.STOPPED'
!    F.CHEQUES.STOPPED = ''
!    CALL OPF(FN.CHEQUES.STOPPED,F.CHEQUES.STOPPED)
!
!    FN.CHEQUES.PRESENTED = 'F.CHEQUES.PRESENTED'
!    F.CHEQUES.PRESENTED = ''
!    CALL OPF(FN.CHEQUES.PRESENTED,F.CHEQUES.PRESENTED)
!
!    FN.CHEQUE.TYPE.ACCOUNT = 'F.CHEQUE.TYPE.ACCOUNT'
!    F.CHEQUE.TYPE.ACCOUNT = ''
!    CALL OPF(FN.CHEQUE.TYPE.ACCOUNT,F.CHEQUE.TYPE.ACCOUNT)
!    R.CHEQUE.TYPE.ACCOUNT=''
!    Y.CHEQUE.TYPE =''
!    Y.CHQ.REG.ID=''
!    R.CHEQUE.REGISTER=''
!    CR.ISSUE.RANGE=''
!    CR.ISSUE.RANGE.CNT=''
!    Y.CHEQUE.NO=''
!    Y.CHQ.PRESENTED.ID=''
!    R.CHQ.PRESENT=''
!    Y.CHQ.STOPPED.ID=''
!    R.CHQ.STOPPED=''
!
!    CALL OPF(FN.CAT,N.CAT)
!    CALL OPF(FN.AC,F.AC)
!    CALL OPF(FN.POS.RES,F.POS.RES)
!
!!!1) Check debit account is customer account,internal account or PL account.For customer and internal account check in ACCOUNT application and for PL check the CATEGORY file.
!!!2) If debit account internal account then Orderding Bank is mandatory
!!!3) If debit account PL category then Profit centre customer is mandatory
!!!4) If debit account PL category then Cheque field should be blank
!!!5) Unauthorise overdraft in case of customer account(unauthorise category should be parameterised)
!!!6) If cheque is input then check cheque issued,presented,stopped
!!!7) If debit account is customer account then check posting restriction(DEBIT,ALL)
!!!8) Debit amount must be equal to sum of credit amount.
!!!9) If credit account is customer account then check posting restriction(Credit,ALL)
!!!10)Check the SYSTEM parameter file(Where suspense category,unauthorise overdraft category)
!!!11)Check suspense account is define for the originating company or not
!
!    IF V$FUNCTION EQ 'I' OR V$FUNCTION EQ 'A' THEN
!        IF R.NEW(MULCR.DEBIT.ACCT.NO) NE '' THEN
!            BEGIN CASE
!            CASE R.NEW(MULCR.DEBIT.ACCT.NO)[1,2] EQ 'PL'
!!----1/3/4-------!
!                Y.CAT.ID=R.NEW(MULCR.DEBIT.ACCT.NO)[3,5]
!                CALL F.READ(FN.CAT,Y.CAT.ID,REC.CAT,F.CAT,ERR.CAT)
!                IF REC.CAT EQ '' THEN
!                    AF=MULCR.DEBIT.ACCT.NO
!                    E="Invalid PL Category"
!                    CALL ERR
!                END
!                ELSE
!                    N(MULCR.PROFIT.CENTRE.CUST)="15.1."
!                    IF R.NEW(MULCR.CHEQUE.NUMBER) NE '' THEN
!                        AF=MULCR.DEBIT.ACCT.NO
!                        E="Cheque Number Should be Null For PL Category"
!                        CALL ERR
!                    END
!                END
!
!            CASE R.NEW(MULCR.DEBIT.ACCT.NO) MATCHES '3A...'
!!----1/2------!
!                Y.AC.ID=R.NEW(MULCR.DEBIT.ACCT.NO)
!                CALL F.READ(FN.AC,Y.AC.ID,REC.AC,F.AC,ERR.AC)
!                IF REC.AC EQ '' THEN
!                    AF=MULCR.DEBIT.ACCT.NO
!                    E="Invalid Internal Account"
!                    CALL ERR
!                END
!                ELSE
!                    N(MULCR.ORDERING.BANK)="15.1."
!                END
!            CASE OTHERWISE
!!----1/6/7------!
!                Y.AC.ID=R.NEW(MULCR.DEBIT.ACCT.NO)
!                CALL F.READ(FN.AC,Y.AC.ID,REC.AC,F.AC,ERR.AC)
!                IF REC.AC EQ '' THEN
!                    AF=MULCR.DEBIT.ACCT.NO
!                    E="Invalid Account Number"
!                    CALL ERR
!                END
!                ELSE
!                    IF REC.AC<AC.POSTING.RESTRICT> NE '' THEN
!                        CALL F.READ(FN.POS.RES,REC.AC<AC.POSTING.RESTRICT>,REC.POS.RES,F.POS.RES,ERR.POS.RES)
!                        IF ( REC.POS.RES<AC.POS.RESTRICTION.TYPE> EQ 'DEBIT') OR ( REC.POS.RES<AC.POS.RESTRICTION.TYPE> EQ 'ALL') THEN
!                            AF=MULCR.DEBIT.ACCT.NO
!                            E = "Posting Restrict In":Y.AC.ID
!                            CALL ERR
!                        END
!                    END
!                    IF R.NEW(MULCR.CHEQUE.NUMBER) NE '' THEN
!                        Y.CHEQUE.NO=R.NEW(MULCR.CHEQUE.NUMBER)
!                        CALL F.READ(FN.CHEQUE.TYPE.ACCOUNT,Y.AC.ID,R.CHEQUE.TYPE.ACCOUNT,F.CHEQUE.TYPE.ACCOUNT,CTA.READ.ERR)
!                        IF NOT(R.CHEQUE.TYPE.ACCOUNT) THEN
!                            AF=MULCR.CHEQUE.NUMBER
!                            E = 'MISSING CHEQUE TYPE'
!                            CALL ERR
!                        END ELSE
!                            Y.CHEQUE.TYPE = R.CHEQUE.TYPE.ACCOUNT<CHQ.TYP.CHEQUE.TYPE,1>
!                        END
!
!                        Y.CHQ.REG.ID = Y.CHEQUE.TYPE:'.':Y.AC.ID
!                        CALL F.READ(FN.CHEQUE.REGISTER,Y.CHQ.REG.ID,R.CHEQUE.REGISTER,F.CHEQUE.REGISTER,CR.READ.ERR)
!                        IF NOT(CR.READ.ERR) THEN
!                            CR.ISSUE.RANGE = R.CHEQUE.REGISTER<CHEQUE.REG.CHEQUE.NOS>
!                            CR.ISSUE.RANGE.CNT = DCOUNT(CR.ISSUE.RANGE,@VM)
!                            Y.START.NO = ''
!                            FOR I = 1 TO CR.ISSUE.RANGE.CNT
!                                Y.RANGE.FLD = ''
!                                Y.RANGE.FLD = CR.ISSUE.RANGE<1,I>
!                                Y.START.NO = Y.CHEQUE.NO
!                                Y.END.NO = ''
!                                Y.RESULT = ''
!                                Y.ERROR = ''
!                                CALL EB.MAINTAIN.RANGES(Y.RANGE.FLD,Y.START.NO,Y.END.NO,'ENQ',Y.RESULT,Y.ERROR)
!                                IF Y.RESULT EQ 1 THEN EXIT
!                            NEXT I
!                            IF NOT(Y.RESULT) THEN
!                                AF=MULCR.CHEQUE.NUMBER
!                                E = "CHEQUE NUMBER ":Y.CHEQUE.NO:" NOT ISSUED TO THE ACCOUNT ":Y.AC.ID
!                                CALL ERR
!
!                            END
!                            CR.RET.RANGE = R.CHEQUE.REGISTER<CHEQUE.REG.RETURNED.CHQS>
!                            LOCATE Y.CHEQUE.NO IN CR.RET.RANGE<1,1> SETTING Y.RET.RG.POS THEN
!                                AF=MULCR.CHEQUE.NUMBER
!                                E = "CHEQUE NUMBER ":Y.CHEQUE.NO:" ALREADY CANCELLED"
!                                CALL ERR
!
!                            END
!
!                            Y.CHQ.PRESENTED.ID = Y.CHEQUE.TYPE:'.':Y.AC.ID:'-':Y.CHEQUE.NO
!                            CALL F.READ(FN.CHEQUES.PRESENTED,Y.CHQ.PRESENTED.ID,R.CHQ.PRESENT,F.CHEQUES.PRESENTED,CHQ.PRESENT.READ.ERR)
!                            IF R.CHQ.PRESENT THEN
!                                AF=MULCR.CHEQUE.NUMBER
!                                E = "CHEQUE NUMBER ":Y.CHEQUE.NO:" ALREADY PRESENTED ON ":R.CHQ.PRESENT<CHQ.PRE.DATE.PRESENTED,1>
!                                CALL ERR
!
!                            END
!
!                            Y.CHQ.STOPPED.ID = Y.AC.ID:'*':Y.CHEQUE.NO
!                            CALL F.READ(FN.CHEQUES.STOPPED,Y.CHQ.STOPPED.ID,R.CHQ.STOPPED,F.CHEQUES.STOPPED,CHQ.STOP.READ.ERR)
!                            IF R.CHQ.STOPPED THEN
!                                E = "CHEQUE NUMBER ":Y.CHEQUE.NO:" ALREADY STOPPED"
!                                CALL ERR
!
!                            END
!
!                        END ELSE
!                            E = "CHEQUE REGISTER NOT AVAILABLE FOR ACCOUNT NUMBER ":Y.AC.ID
!                            CALL ERR
!
!                        END
!
!                    END
!                END
!
!
!            END CASE
!        END
!!-----5/8/9----!
!        IF R.NEW(MULCR.CREDIT.ACCT.NO) NE '' THEN
!            CR.AC.CNT=''
!            Y.TOT.CR.AMT=''
!            CR.AC.CNT=DCOUNT(R.NEW(MULCR.CREDIT.ACCT.NO),VM)
!            FOR I=1 TO CR.AC.CNT
!                Y.CR.AC.ID=''
!                REC.CR.AC=''
!                Y.TOT.CR.AMT=Y.TOT.CR.AMT+R.NEW(MULCR.CREDIT.AMOUNT)<1,I>
!                Y.CR.AC.ID=R.NEW(MULCR.CREDIT.ACCT.NO)<1,I>
!                CALL F.READ(FN.AC,Y.AC.ID,REC.CR.AC,F.AC,ERR.AC)
!                   IF REC.CR.AC<AC.POSTING.RESTRICT> NE '' THEN
!                        CALL F.READ(FN.POS.RES,REC.CR.AC<AC.POSTING.RESTRICT>,REC.POS.RES,F.POS.RES,ERR.POS.RES)
!                        IF ( REC.POS.RES<AC.POS.RESTRICTION.TYPE> EQ 'CREDIT') OR ( REC.POS.RES<AC.POS.RESTRICTION.TYPE> EQ 'ALL') THEN
!                            AF=MULCR.CREDIT.ACCT.NO
!                            E = "Posting Restrict In":Y.CR.AC.ID
!                            CALL ERR
!                        END
!                    END
!
!                NEXT
!        END
!
!        IF R.NEW(MULCR.DEBIT.AMOUNT) NE Y.TOT.CR.AMT THEN
!          AF=MULCR.DEBIT.AMOUNT
!          E="Total Debit And Total Credit Should Be Same"
!          CALL ERR
!        END
!        ELSE
!                Y.AC.ID=R.NEW(MULCR.DEBIT.ACCT.NO)
!                REC.AC=''
!                CALL F.READ(FN.AC,Y.AC.ID,REC.AC,F.AC,ERR.AC)
!                IF REC.AC<AC.WORKING.BALANCE> LT R.NEW(MULCR.DEBIT.AMOUNT) THEN
!                 AF=MULCR.DEBIT.ACCT.NO
!                 E="Debit A/c ":R.NEW(MULCR.DEBIT.ACCT.NO):" Doesn't Have Sufficient Balance"
!                 CALL ERR
!                END
!        END
!
!
!        END
!

    RETURN

*************************************************************************

CHECK.FIELDS:

    IF E THEN
        T.SEQU = "IFLD"
        CALL ERR
    END

    RETURN

*************************************************************************

CROSS.VALIDATION:

*
    V$ERROR = ''
    ETEXT = ''
    TEXT = ''
*
!    CALL AB.H.ASSET.CLASS.PARAM.CROSSVAL
*
* If END.ERROR has been set then a cross validation error has occurred
*
*    IF END.ERROR THEN
*        A = 1
*        LOOP UNTIL T.ETEXT<A> <> "" DO A = A+1 ; REPEAT
*        T.SEQU = A
*        V$ERROR = 1
*        MESSAGE = 'ERROR'
*    END
    RETURN          ;* Back to field input via UNAUTH.RECORD.WRITE

*************************************************************************

OVERRIDES:
*
*  Overrides should reside here.
*
    V$ERROR = ''
    ETEXT = ''
    TEXT = ''
REM > CALL XX.OVERRIDE
*

*
    IF TEXT = "NO" THEN       ;* Said NO to override
        V$ERROR = 1
        MESSAGE = "ERROR"     ;* Back to field input

    END
    RETURN

*************************************************************************

AUTH.CROSS.VALIDATION:


    RETURN

*************************************************************************

CHECK.DELETE:


    RETURN

*************************************************************************

CHECK.REVERSAL:


    RETURN

*************************************************************************
DELIVERY.PREVIEW:

    RETURN

*************************************************************************

BEFORE.UNAU.WRITE:
*
*  Contract processing code should reside here.
*
REM > CALL XX.         ;* Accounting, Schedule processing etc etc

    IF TEXT = "NO" THEN       ;* Said No to override
        CALL TRANSACTION.ABORT          ;* Cancel current transaction
        V$ERROR = 1
        MESSAGE = "ERROR"     ;* Back to field input
        RETURN
    END
* Validation that will not allow more than 40 multivalue of Credit Account

    IF V$FUNCTION EQ 'I' THEN
        IF R.NEW(MULCR.CREDIT.ACCT.NO) NE '' THEN
            CR.ACCT.CNT = DCOUNT(R.NEW(MULCR.CREDIT.ACCT.NO),@VM)
            IF CR.ACCT.CNT GT 40 THEN
                AF=MULCR.CREDIT.ACCT.NO
                E="More than 40 accounts are not allowed"
                CALL ERR
            END
        END
    END
*
* Additional updates should be performed here
*
REM > CALL XX...



    RETURN

*************************************************************************

AFTER.UNAU.WRITE:


    RETURN

*************************************************************************

AFTER.AUTH.WRITE:


    RETURN

*************************************************************************

BEFORE.AUTH.WRITE:

    BEGIN CASE
    CASE R.NEW(V-8)[1,3] = "INA"        ;* Record status
REM > CALL XX.AUTHORISATION
    CASE R.NEW(V-8)[1,3] = "RNA"        ;* Record status
REM > CALL XX.REVERSAL

    END CASE

    RETURN

*************************************************************************

CHECK.FUNCTION:

* Validation of function entered.  Set FUNCTION to null if in error.

    IF INDEX('V',V$FUNCTION,1) THEN
        E = 'FUNCTION NOT ALLOWED FOR THIS APPLICATION'
        CALL ERR
        V$FUNCTION = ''
    END

    RETURN

*************************************************************************

INITIALISE:

    RETURN

*************************************************************************

DEFINE.PARAMETERS:  * SEE 'I_RULES' FOR DESCRIPTIONS *

    CALL  ABL.H.MUL.CR.FIELD.DEF



    RETURN

*************************************************************************



END

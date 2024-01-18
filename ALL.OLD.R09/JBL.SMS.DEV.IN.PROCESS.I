*-----------------------------------------------------------------------------
* <Rating>723</Rating>
*-----------------------------------------------------------------------------
****************************************************************************************************************
*Objective: This subroutine read parameters(application wise) from EB.SMS.TEMPLATE and build SMS string based  *
*on SMS TEXT and SMS VARIABLE defined on EB.SMS.TEMPLATE.Then write that SMS in SMS.OUT folder.This message    *
*will be send to SMS TARGET on SMS EVENT defined on EB.SMS.TEMPLATE.                                           *
*Developer      : Md. Imran Hasan                                                                               *
*Release Date   : 20201217                                                                                      *
****************************************************************************************************************
    SUBROUTINE JBL.SMS.DEV.IN.PROCESS.I

    $INSERT GLOBUS.BP I_COMMON
    $INSERT GLOBUS.BP I_EQUATE
    $INSERT JBL.BP I_F.SMS.TEMPLATE.DEFINE
    $INSERT GLOBUS.BP I_F.STANDARD.SELECTION
    $INSERT GLOBUS.BP I_F.CUSTOMER
    $INSERT GLOBUS.BP I_F.COMPANY
    $INSERT GLOBUS.BP I_F.TELLER
    $INSERT GLOBUS.BP I_F.FUNDS.TRANSFER
    $INSERT GLOBUS.BP I_F.CHEQUE.COLLECTION
    $INSERT GLOBUS.BP I_F.ACCOUNT


    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
    RETURN

*--------
INIT:
*--------
    FN.SMS = 'F.EB.SMS.TEMPLATE.DEFINE'
    F.SMS = ''
    FN.CUS = 'F.CUSTOMER'
    F.CUS = ''
    FN.COM = 'F.COMPANY'
    F.COM = ''


    FN.CC = 'FBNK.CHEQUE.COLLECTION'
    F.CC = ''
    FN.ACCT = 'FBNK.ACCOUNT'
    F.ACCT = ''

    SMS.BUILD = ''
    SMS.DIR = 'SMS.OUT'
    DR.CR.IND = ''
    Y.AMT.FCY = ''
    Y.PRIORITY = 6
    RETURN

*----------
OPENFILES:
*----------
    CALL OPF(FN.SMS,F.SMS)
    CALL F.READ(FN.SMS,APPLICATION,R.SMS,F.SMS,ERR.SMS)
    CALL GET.STANDARD.SELECTION.DETS(APPLICATION,R.SS)
    CALL GET.LOC.REF('CUSTOMER','SMS.ALERT',CUS.SMS.ALERT.POS)
    CALL GET.LOC.REF('COMPANY','SMS.ALERT',COM.SMS.ALERT.POS)


    CALL OPF(FN.CC,F.CC)
    CALL OPF(FN.ACCT,F.ACCT)

    RETURN

*----------
PROCESS:
*----------


    IF APPLICATION EQ 'TELLER' THEN
        DR.CR.IND = R.NEW(TT.TE.DR.CR.MARKER)
        Y.AMT = R.NEW(TT.TE.AMOUNT.LOCAL.1)
        Y.AMT.FCY = R.NEW(TT.TE.AMOUNT.FCY.1)
    END
    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        Y.AMT = R.NEW(FT.AMOUNT.DEBITED)
        Y.AMT = SUBSTRINGS(Y.AMT,4,LEN(Y.AMT)-3)
        Y.TRNS.TYPE = R.NEW(FT.TRANSACTION.TYPE)
        IF Y.AMT EQ '' THEN
            Y.AMT = R.NEW(FT.AMOUNT.CREDITED)
            Y.AMT = SUBSTRINGS(Y.AMT,4,LEN(Y.AMT)-3)
        END
    END
    IF APPLICATION EQ 'CHEQUE.COLLECTION' THEN

        CALL GET.LOC.REF("CHEQUE.COLLECTION","CHQ.COLL.STATUS",Y.CHQ.COLL.STATUS.POS)

        Y.CHQ.COLL.STATUS = R.NEW(CHQ.COL.LOCAL.REF)<1,Y.CHQ.COLL.STATUS.POS>

        Y.AMT = R.NEW(CHQ.COL.AMOUNT)
    END

    IF R.SMS THEN
        IF R.SMS<EB.SMS7.SMS.EVENT> EQ '' THEN
            SMS.COUNT = 1
        END
        ELSE
            SMS.COUNT = DCOUNT(R.SMS<EB.SMS7.SMS.EVENT>,@VM)
        END
        EVENT.CHECK = 0
        FOR J=1 TO SMS.COUNT

            IF R.SMS<EB.SMS7.SMS.TARGET,J> EQ '@ID' THEN
                CALL F.READ(FN.CUS,ID.NEW,R.CUS,F.CUS,E.CUS)
                MOBILE.NO = R.CUS<EB.CUS.SMS.1>
                SMS.ALERT.VAL = R.CUS<EB.CUS.LOCAL.REF,CUS.SMS.ALERT.POS>
                COM.BOOK.VAL = R.CUS<EB.CUS.COMPANY.BOOK>
            END
            ELSE
                IF APPLICATION EQ 'CHEQUE.COLLECTION' THEN
                    Y.ACCT.ID = R.NEW(CHQ.COL.CREDIT.ACC.NO)
                    CALL F.READ(FN.ACCT,Y.ACCT.ID,R.ACCT,F.ACCT,ERR.ACCT)
                    SMS.TARGET = R.ACCT<AC.CUSTOMER>
                END
                ELSE
                    LOCATE FIELD(R.SMS<EB.SMS7.SMS.TARGET>,@VM,J) IN R.SS<SSL.SYS.FIELD.NAME,1> SETTING POS2 THEN
                        AF = R.SS<SSL.SYS.FIELD.NO,POS2>
                        SMS.TARGET = R.NEW(AF)
                    END
                END
                CALL F.READ(FN.CUS,SMS.TARGET,R.CUS,F.CUS,E.CUS)
                MOBILE.NO = R.CUS<EB.CUS.SMS.1>
                SMS.ALERT.VAL = R.CUS<EB.CUS.LOCAL.REF,CUS.SMS.ALERT.POS>
                COM.BOOK.VAL = R.CUS<EB.CUS.COMPANY.BOOK>
            END
            CALL F.READ(FN.COM,COM.BOOK.VAL,R.COM,F.COM,E.COM)
            COM.SMS.ALERT.VAL = R.COM<EB.COM.LOCAL.REF,COM.SMS.ALERT.POS>

            IF COM.SMS.ALERT.VAL EQ 'Y' AND SMS.ALERT.VAL EQ 'Y' AND MOBILE.NO NE '' THEN
                GOSUB BUILD.MSG
            END
            EVENT.CHECK =1
        NEXT
    END
    RETURN
*----------
BUILD.MSG:
*----------


    Y.ACCT.NO = ''
    Y.CURRENCY = ''
    SMS.TXT.NO = DCOUNT(R.SMS<EB.SMS7.SMS.TEXT,J>,@SM)
    FOR I=1 TO SMS.TXT.NO
        SMS.TXT = FIELD(R.SMS<EB.SMS7.SMS.TEXT,J>,@SM,I)
        SMS.FLD = FIELD(R.SMS<EB.SMS7.SMS.VARIABLE,J>,@SM,I)
        LOCATE SMS.FLD IN R.SS<SSL.SYS.FIELD.NAME,1> SETTING POS1 THEN
            AF = R.SS<SSL.SYS.FIELD.NO,POS1>
            SMS.VAR = R.NEW(AF)

            IF FIELD (R.SMS<EB.SMS7.VAR.CONVERSION,J>,@SM,I) EQ 'MASKING' THEN
                Y.ACCT.NO = SMS.VAR
                TEMP.SMS.VAR = SMS.VAR[LEN(SMS.VAR)-3,4]
                SMS.VAR = FMT(TEMP.SMS.VAR,'R*':LEN(SMS.VAR) - 8)
            END
!----------------FOR Remaining Balance start-------
            IF FIELD (R.SMS<EB.SMS7.VAR.CONVERSION,J>,@SM,I) EQ 'ONLINE.ACTUAL.BAL' THEN
                CALL F.READ(FN.ACCT,Y.ACCT.NO,R.ACCT,F.ACCT,ERR.ACCT)
                SMS.VAR = R.ACCT<AC.ONLINE.ACTUAL.BAL>
                Y.ACCT.NO = ''
            END
!----------------FOR Remaining Balance end-------

            IF APPLICATION EQ 'TELLER' THEN
                IF DR.CR.IND NE R.SMS<EB.SMS7.SMS.EVENT,1> THEN
                    IF EVENT.CHECK EQ 0 THEN
                        SMS.TXT = FIELD(R.SMS<EB.SMS7.SMS.TEXT,J+1>,@SM,I)
                    END
                    ELSE
                        SMS.TXT = FIELD(R.SMS<EB.SMS7.SMS.TEXT,J-1>,@SM,I)
                    END
                END
                IF SMS.FLD EQ 'CURRENCY.1' OR SMS.FLD EQ 'CURRENCY.2' THEN
                    Y.CURRENCY = SMS.VAR
                END

                IF SMS.FLD EQ 'AMOUNT.LOCAL.1' AND Y.CURRENCY NE 'BDT' THEN
                    SMS.VAR = Y.AMT.FCY
                    Y.CURRENCY = ''
                END
            END

            IF SMS.FLD EQ 'CO.CODE' THEN
                SMS.VAR = R.COMPANY(1)[1,30]
            END
            ELSE
                IF SMS.FLD EQ 'DATE.TIME' THEN
                    SMS.VAR = OCONV(OCONV(DATE(),'D2'),"MCT"):' ':OCONV(TIME(),'MTS')
                END
            END

        END
        SMS.BUILD:= SMS.TXT:' ':SMS.VAR:' '
    NEXT
    Y.PRIORITY.CNT = DCOUNT(R.SMS<EB.SMS7.PRIORITY>,@VM)
    FOR I=1 TO Y.PRIORITY.CNT
        IF Y.AMT GE R.SMS<EB.SMS7.AMT.FROM,I> AND Y.AMT LE R.SMS<EB.SMS7.AMT.TO,I> THEN
            Y.PRIORITY = R.SMS<EB.SMS7.PRIORITY,I>
            I = Y.PRIORITY.CNT +1
        END
    NEXT I
    FINDSTR 'credited' IN SMS.BUILD SETTING POS THEN
        Y.ID= ID.NEW:"-C"
    END ELSE
        Y.ID= ID.NEW:"-D"
    END

    Y.DEBIT.COMP = R.NEW(FT.DEBIT.COMP.CODE)
    Y.CREDIT.COMP = R.NEW(FT.CREDIT.COMP.CODE)


    IF Y.DEBIT.COMP NE Y.CREDIT.COMP THEN
        FINDSTR 'deposited' IN SMS.BUILD SETTING POS THEN
            SMS.BUILD = EREPLACE(SMS.BUILD,"with","through")
            SMS.BUILD = SMS.BUILD:"|":"1":"|":Y.PRIORITY
        END ELSE
            SMS.BUILD = SMS.BUILD:"|":"1":"|":Y.PRIORITY
        END
    END ELSE
        IF Y.TRNS.TYPE EQ 'ACOR' OR Y.TRNS.TYPE EQ 'ACIR' THEN
            SMS.BUILD = SMS.BUILD:" through RTGS":"|":"1":"|":Y.PRIORITY
        END ELSE
            SMS.BUILD = SMS.BUILD:"|":"1":"|":Y.PRIORITY
        END
    END
    IF Y.CHQ.COLL.STATUS EQ 'RETURNED' THEN
        SMS.BUILD = EREPLACE(SMS.BUILD,"credited","returned agt clg")
    END


    IF SMS.BUILD THEN
        Y.SMS.BUILD = ''
        Y.CUR = 0
        IF LEFT(ID.NEW,2) EQ 'TT' THEN
            Y.CUR = R.NEW(TT.TE.CURR.NO)
        END
        IF LEFT(ID.NEW,2) EQ 'FT' THEN
            Y.CUR = R.NEW(FT.CURR.NO)
        END
        IF LEFT(ID.NEW,2) EQ 'CC' THEN
            Y.CUR = R.NEW(CHQ.COL.CURR.NO)
        END

        IF V$FUNCTION EQ 'I' AND Y.CUR EQ 1 OR Y.TRNS.TYPE EQ 'ACIR' OR (APPLICATION EQ 'CHEQUE.COLLECTION' AND Y.CUR EQ 2) THEN
            Y.MOB.LEN = DCOUNT(MOBILE.NO,@VM)
            FOR Y=1 TO Y.MOB.LEN
                Y.MOBILE.NO = FIELD(MOBILE.NO,@VM,Y)
                SMS.FILE = SMS.DIR:'/':Y.MOBILE.NO:'-':Y.ID:'-':J:V$FUNCTION:'.csv'
                Y.SMS.BUILD = Y.ID:"|":Y.MOBILE.NO:"|":SMS.BUILD


                OPENSEQ SMS.FILE TO SMS.FILE.POINT ELSE
                    CRT 'OPEN FAILED'
                END
                WRITESEQ Y.SMS.BUILD TO SMS.FILE.POINT ELSE
                    CRT 'WRITE FAILED'
                END
                CLOSESEQ SMS.FILE.POINT

            NEXT Y
        END
    END
    Y.CUR = ''
    SMS.BUILD = ''
    RETURN
END

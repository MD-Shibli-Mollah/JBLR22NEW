*-----------------------------------------------------------------------------
* <Rating>214</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ACC.STMT.ENT.CIBTA.TF(Y.DATA)

    $INSERT GLOBUS.BP I_COMMON
    $INSERT GLOBUS.BP I_EQUATE
    $INSERT GLOBUS.BP I_F.ACCOUNT
    $INSERT GLOBUS.BP I_F.STMT.ENTRY
    $INSERT GLOBUS.BP I_ENQUIRY.COMMON
    $INSERT JBL.BP I_F.ABL.H.NM.ER

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
    RETURN

*****
INIT:
*****
    FN.AC = 'FBNK.ACCOUNT'
    F.AC = ''
    FN.ST.ENT = 'FBNK.STMT.ENTRY'
    F.ST.ENT = ''
    FN.NM = 'F.ABL.H.NM.ER'
    F.NM = ''
    ID.LIST = ''
    RETURN


**********
OPENFILES:
**********

    LOCATE 'ENTRY.DATE' IN ENQ.SELECTION<2,1> SETTING INWARD.OUTWARD.POS THEN
        FROM.DATE = ENQ.SELECTION<4,INWARD.OUTWARD.POS>
        END.DATE = FROM.DATE
    END

!   FROM.DATE = "20200608"
!   END.DATE = FROM.DATE

*------------- ADDED BY MD. GOLAM RASED 20181018 ---------------

    IF LEN(FROM.DATE) EQ 2 THEN
        Y.TODAY = TODAY
        FROM.DATE = SUBSTRINGS(Y.TODAY,1,6):"":FROM.DATE
        END.DATE = FROM.DATE
    END
    IF LEN(FROM.DATE) EQ 1 THEN
        Y.TODAY = TODAY
        FROM.DATE = SUBSTRINGS(Y.TODAY,1,6):"0":FROM.DATE
        END.DATE = FROM.DATE
    END


    Y.REPORT.DATE = ICONV(FROM.DATE,'D')
    Y.REPORT.DATE = OCONV(Y.REPORT.DATE,'D2')
*----------------------- END -----------------------------------

    LOCATE 'CATEGORY' IN ENQ.SELECTION<2,1> SETTING INWARD.OUTWARD.POS THEN
        Y.CATEGORY = ENQ.SELECTION<4,INWARD.OUTWARD.POS>
    END

!  Y.CATEGORY = "12820"

    CALL OPF(FN.AC,F.AC)
    CALL OPF(FN.ST.ENT,F.ST.ENT)
    RETURN


********
PROCESS:
********
    Y.ID.COMPANY = ID.COMPANY

    SEL.CMD = 'SELECT FBNK.ACCOUNT WITH CATEGORY EQ ':Y.CATEGORY:' AND CO.CODE EQ ':Y.ID.COMPANY
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.RECORD,RET.CODE)

    LOOP
        REMOVE Y.AC.ID FROM SEL.LIST SETTING Y.AC.POS
    WHILE Y.AC.ID:Y.AC.POS
        CALL EB.ACCT.ENTRY.LIST(Y.AC.ID,FROM.DATE,END.DATE,ID.LIST,OPENING.BAL,ER)

        IF ID.LIST NE '' THEN
            GOSUB AC.STMT.DATA
        END

    REPEAT
    RETURN

*************
AC.STMT.DATA:
*************

    Y.AMT = 0
    FOR I = 1 TO DCOUNT(ID.LIST,FM)

        Y.STMT.ID = FIELD(ID.LIST,FM,I)
        CALL F.READ(FN.ST.ENT,Y.STMT.ID,R.ST.ENT,F.ST.ENT,ST.ENT.ERR)

        Y.REC.STATUS = R.ST.ENT<AC.STE.RECORD.STATUS>
        Y.TXN.REF = R.ST.ENT<AC.STE.TRANS.REFERENCE>

        IF Y.TXN.REF EQ '' THEN
            Y.TXN.REF = R.ST.ENT<AC.STE.OUR.REFERENCE>
        END


        IF LEFT(Y.TXN.REF,2) EQ 'TF' AND Y.REC.STATUS NE 'REVE' THEN

            Y.TXN.AMT = R.ST.ENT<AC.STE.AMOUNT.LCY>

            IF Y.TXN.AMT LT 0 THEN
                Y.AMT.CRDR = 'DR'
            END ELSE
                Y.AMT.CRDR = 'CR'
            END

            Y.NM.ID = Y.TXN.REF

            CALL F.READ(FN.NM,Y.NM.ID,R.NM,F.NM,Y.ERR.NM)

            IF R.NM NE '' THEN

                Y.AMT = ABS(Y.TXN.AMT)
                CALL EB.ROUND.AMOUNT("BDT",Y.AMT,2,"")
                Y.NMAMT = ABS(R.NM<NM.AMOUNT>)
                CALL EB.ROUND.AMOUNT("BDT",Y.NMAMT,2,"")
                Y.NM.CRDR = R.NM<NM.DR.CR.MARKER>

                IF Y.AMT NE Y.NMAMT OR Y.NM.CRDR NE Y.AMT.CRDR THEN
                    CALL F.READ(FN.NM,Y.STMT.ID,R.NM,F.NM,Y.ERR.NM)
                END

            END
            ELSE
                CALL F.READ(FN.NM,Y.STMT.ID,R.NM,F.NM,Y.ERR.NM)
            END
            Y.ZONAL.CODE = ''
            Y.BRANCH.CODE = ''
            Y.OE.RE = ''
            Y.TRANS.CODE = ''
            Y.ADVICE.NO = ''

            IF R.NM NE '' THEN
                Y.ZONAL.CODE = R.NM<NM.ZONAL.CODE>
                Y.BRANCH.CODE = RIGHT(R.NM<NM.BRANCH.CODE>,4)
                Y.TRANS.CODE = R.NM<NM.TRANS.CODE>
                Y.ADVICE.NO = R.NM<NM.ADVICE.NO>
                Y.OE.RE = R.NM<NM.OE.RE>

                Y.DATA<-1> = Y.AC.ID:'~':Y.TXN.REF:'~':Y.TXN.AMT:'~':Y.ZONAL.CODE:'~':Y.BRANCH.CODE:'~':Y.OE.RE:'~':Y.TRANS.CODE:'~':Y.ADVICE.NO:'~':Y.REPORT.DATE:'~':Y.STMT.ID
            END
            ELSE
                Y.DATA<-1> = Y.AC.ID:'~':Y.TXN.REF:'~':Y.TXN.AMT:'~':Y.ZONAL.CODE:'~':Y.BRANCH.CODE:'~':Y.OE.RE:'~':Y.TRANS.CODE:'~':Y.ADVICE.NO:'~':Y.REPORT.DATE:'~':Y.STMT.ID
            END
        END

        Y.AMT = 0

    NEXT I

    ID.LIST = ''
    Y.TXN.REF = ''

    RETURN
END

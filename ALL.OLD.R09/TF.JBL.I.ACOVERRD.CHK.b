SUBROUTINE TF.JBL.I.ACOVERRD.CHK
*-----------------------------------------------------------------------------
*Subroutine Description:
*Subroutine Type:
*Attached To    : LOANDS.AND.DEPOSITS Version (LD.LOANS.AND.DEPOSITS,TF.JBL.EXP.PC)
*Attached As    : INPUT ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 22/10/2019 -                            Retrofit   - MD.KAMRUL HASAN
*                                                 FDS Pvt Ltd
*-----------------------------------------------------------------------------
    $INSERT  I_COMMON
    $INSERT  I_EQUATE
    $INSERT  I_F.ACCOUNT
*$INSERT JBL.BP I_F.ABL.H.MULT.PRM
    $INSERT  I_F.JBL.H.MUL.PRM
    $USING   AC.AccountOpening
    $USING   EB.LocalReferences
    $USING   EB.SystemTables
    $USING   EB.DataAccess
    $USING   EB.ErrorProcessing
    $USING   EB.OverrideProcessing

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    R.ACCOUNT  = ''
    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)
    
    FN.MUL.PARAM ='F.ABL.H.MUL.PRM'
    F.MUL.PARAM =''
    EB.DataAccess.Opf(FN.MUL.PARAM,F.MUL.PARAM)
    REC.MUL.PARAM=''
    Y.RES.OVERDRAFT.CATEG=''
    Y.DEBIT.AC = ''
    Y.DEBIT.AC.CAT = ''
    Y.OVERRIDE.VAL = ''
    Y.OVRRD.NO = ''
    Y.LEGAL.CHRG="LEGAL.CHARGE"
    Y.LEGAL.CHRG.POS=""
    Y.LEG.CHG=""


    EB.DataAccess.FRead(FN.MUL.PARAM,'SYSTEM',REC.MUL.PARAM,F.MUL.PARAM,ERR.MUL.PARAM)

    IF REC.MUL.PARAM EQ '' THEN
        EB.SystemTables.setEtext("Parameter File Missing For Overdraft Missing")
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END
    ELSE
        Y.RES.OVERDRAFT.CATEG=REC.MUL.PARAM<MUL.PRM.OVERDRAFT.RES.CATEG>
    END

    POS = 1
    Y.OVERRIDE.VAL = EB.SystemTables.getRNew(EB.SystemTables.getV()-9)
    Y.OVRRD.NO = DCOUNT(Y.OVERRIDE.VAL,VM)
    FOR I=1 TO Y.OVRRD.NO
        Y.DEBIT.AC = ''
        Y.DEBIT.AC.CAT = ''
        Y.OVRRD.DETLS = ''
        Y.OVRRD.ID = ''

        Y.OVRRD.DETLS = FIELD(Y.OVERRIDE.VAL,VM,I)
        Y.OVRRD.ID = FIELD(Y.OVRRD.DETLS,'}',1)

        BEGIN CASE
            CASE Y.OVRRD.ID EQ 'ACCT.UNAUTH.OD'
                Y.DEBIT.AC = FIELD(FIELD(Y.OVRRD.DETLS,'}',4),'{',1)
                EB.DataAccess.FRead(FN.ACCOUNT,Y.DEBIT.AC,R.ACCOUNT,F.ACCOUNT,ERR.AC)
                Y.DEBIT.AC.CAT = R.ACCOUNT<AC.CATEGORY>
                GOSUB ACCT.UNAUTH.OD

            CASE Y.OVRRD.ID EQ 'ST-CHQ.INST.FOR.STOP'
                GOSUB ST.CHQ.INST.FOR.STOP

            CASE Y.OVRRD.ID EQ 'CHQ.NOT.IN.REG'
                GOSUB CHQ.NOT.IN.REG

            CASE Y.OVRRD.ID EQ 'CHQ.TYPE.MISS'
                GOSUB CHQ.TYPE.MISS

            CASE Y.OVRRD.ID EQ 'CHQ.PRESENTED'
                GOSUB CHQ.PRESENTED

            CASE Y.OVRRD.ID EQ 'ACCT.BAL.LT.LOCKED'
                GOSUB ACCT.BAL.LT.LOCKED

            CASE Y.OVRRD.ID EQ 'TT.CR.TILL.CLOS.BAL'
                GOSUB TT.CR.TILL.CLOS.BAL

            CASE Y.OVRRD.ID EQ 'EXCESS.ID'
                GOSUB EXCESS.ID

            CASE Y.OVRRD.ID EQ 'POSTING.RESTRICT'
                GOSUB POSTING.RESTRICT
        END CASE
    NEXT I
RETURN

ACCT.UNAUTH.OD:
    EB.SystemTables.setAf(I)
    !ETEXT = 'Unauthorised Overdraft Not Possible'
    !CALL STORE.END.ERROR
    LOCATE Y.DEBIT.AC.CAT IN  Y.RES.OVERDRAFT.CATEG<1,1> SETTING Y.POS ELSE Y.POS = ''
    IF Y.POS THEN
        EB.SystemTables.setEtext('Unauthorised Overdraft Not Possible')
        EB.ErrorProcessing.StoreEndError()
    END
    ELSE
        IF NOT(Y.LEG.CHG) THEN
            EB.SystemTables.setEtext('Unauthorised Overdraft Not Possible')

            EB.ErrorProcessing.StoreEndError()
        END
        ELSE
            EB.SystemTables.setEtext("Unauthorised Overdraft Due to ":Y.LEG.CHG)
            EB.OverrideProcessing.StoreOverride(Y.OVRRD.NO+1)
        END
    END

RETURN
ST.CHQ.INST.FOR.STOP:
    EB.SystemTables.setAf(I)
    EB.SystemTables.setEtext('CHQ IS ALREADY INST FOR STOP')
    EB.ErrorProcessing.StoreEndError()

RETURN
CHQ.TYPE.MISS:

    EB.SystemTables.setAf(I)
    EB.SystemTables.setEtext('CHEQUE TYPE MISSING')
    EB.ErrorProcessing.StoreEndError()
RETURN
CHQ.NOT.IN.REG:

    EB.SystemTables.setAf(I)
    EB.SystemTables.setEtext('CHEQUE NUMBER NOT IN REG')
    EB.ErrorProcessing.StoreEndError()
RETURN
CHQ.PRESENTED:

    EB.SystemTables.setAf(I)
    EB.SystemTables.setEtext('CHEQUE NUMBER ALREADY PRESENTED')
    EB.ErrorProcessing.StoreEndError()
RETURN
TT.CR.TILL.CLOS.BAL:
    EB.SystemTables.setAf(I)
    EB.SystemTables.setEtext('CREDIT TILL CLOSING BALANCE')
    EB.ErrorProcessing.StoreEndError()
RETURN

ACCT.BAL.LT.LOCKED:
    EB.SystemTables.setAf(I)
    EB.SystemTables.setEtext('Account Balance will fall in Locked Amount')
    EB.ErrorProcessing.StoreEndError()

RETURN

EXCESS.ID:
    EB.SystemTables.setAf(I)
    IF NOT(Y.LEG.CHG) THEN
        EB.SystemTables.setEtext('Execss Over Limit')
        EB.ErrorProcessing.StoreEndError()
    END
    ELSE
        EB.SystemTables.setEtext("Execss Over Limit Due to ":Y.LEG.CHG)
        EB.ErrorProcessing.StoreEndError()
    END

RETURN
POSTING.RESTRICT:
    EB.SystemTables.setAf(I)
    EB.SystemTables.setEtext('Posting Restriction')
    EB.ErrorProcessing.StoreEndError()
RETURN
END

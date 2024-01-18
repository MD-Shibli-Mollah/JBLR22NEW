SUBROUTINE TF.JBL.I.LN.AMT.CHK.WTH.LMT.AMT
*-----------------------------------------------------------------------------
*Subroutine Description: check PAD Account Loan Amount Grater Than Limit Available Amount.
*Subroutine Type       :
*Attached To           : Activity.Api - JBL.TF.PAD.CASH.API
*Attached As           : INPUT Routine
*Developed by          : #-mahmudur rahman udoy-#
*Incoming Parameters   :
*Outgoing Parameters   :
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_AA.LOCAL.COMMON
*
    $USING EB.SystemTables
    $USING AA.Framework
    $USING AA.Limit
    $USING LI.Config
    $USING EB.DataAccess
    $USING AA.Account
    $USING EB.LocalReferences
    $USING EB.ErrorProcessing
*
    GOSUB INIT
    GOSUB OPENFILE
    GOSUB PROCESS
RETURN
*-------
INIT:
*-------
    FN.LIMIT = 'FBNK.LIMIT'
    F.LIMIT = ''
    
    Y.LIMIT.AVAL.AMT = ''
    Y.ACCT.LN.AMT = ''
RETURN
*---------
OPENFILE:
*---------
    EB.DataAccess.Opf(FN.LIMIT,F.LIMIT)
RETURN
*-------
PROCESS:
*-------
    Y.CUS.ID = c_aalocArrActivityRec<AA.Framework.ArrangementActivity.ArrActCustomer>
    ArrangementId = c_aalocArrActivityRec<AA.Framework.ArrangementActivity.ArrActArrangement>
    PROP.CLASS.TRM = 'LIMIT'
    AA.Framework.GetArrangementConditions(ArrangementId,PROP.CLASS.TRM,'LIMIT','',RETURN.IDS.TRM,RETURN.VALUES.TRM,ERR.MSG.TRM)
    IF RETURN.VALUES.TRM THEN
        RETURN.VALUES.TRM = RAISE(RETURN.VALUES.TRM)
        Y.LIMIT.REF = RETURN.VALUES.TRM<AA.Limit.Limit.LimLimitReference>
        Y.LIMIT.SL = RETURN.VALUES.TRM<AA.Limit.Limit.LimLimitSerial>
        Y.LIMIT.ID = Y.CUS.ID:'.000':Y.LIMIT.REF:'.':Y.LIMIT.SL
        EB.DataAccess.FRead(FN.LIMIT, Y.LIMIT.ID, R.LIMIT.REC, F.LIMIT , LIMIT.ERR)
        !*********this code is for join customer limit start**************
        IF R.LIMIT.REC EQ '' THEN
            Y.JOIN.LIMIT.LK = '...000':Y.LIMIT.REF:'.':Y.LIMIT.SL:'.':Y.CUS.ID
            SEL.CMD = 'SELECT ':FN.LIMIT:' WITH @ID LIKE ': Y.JOIN.LIMIT.LK
            EB.DataAccess.Readlist(SEL.CMD,SEL.LIST,'',TOT.REC,RET.CODE)
            Y.LIMIT.ID = SEL.LIST<1>
            EB.DataAccess.FRead(FN.LIMIT, Y.LIMIT.ID, R.LIMIT.REC, F.LIMIT , LIMIT.ERR)
            IF R.LIMIT.REC EQ '' THEN RETURN
        END
        !*********this code is for join customer limit start**************
        Y.LIMIT.AVAL.AMT = R.LIMIT.REC<LI.Config.Limit.AvailAmt>
        Y.ACCT.LN.AMT.FLD = "LT.ACCT.LN.AMT"
        ACCT.AMOUNT.POS = ""
        EB.LocalReferences.GetLocRef("AA.ARR.ACCOUNT",Y.ACCT.LN.AMT.FLD,ACCT.AMOUNT.POS)
        Y.ALL.LRF = EB.SystemTables.getRNew(AA.Account.Account.AcLocalRef)
        Y.ACCT.LN.AMT = Y.ALL.LRF<1,ACCT.AMOUNT.POS>
        IF Y.LIMIT.AVAL.AMT EQ '' THEN
            Y.LIMIT.AVAL.AMT = R.LIMIT.REC<LI.Config.Limit.InternalAmount>
        END
        IF (Y.ACCT.LN.AMT GT Y.LIMIT.AVAL.AMT) AND (Y.ACCT.LN.AMT NE '') THEN
            EB.SystemTables.setAf(AA.Account.Account.AcLocalRef)
            EB.SystemTables.setAv(ACCT.AMOUNT.POS)
            EB.SystemTables.setEtext("Loan Amount Grater Then Limit Available Amount")
            EB.ErrorProcessing.StoreEndError()
        END
    END
RETURN

END


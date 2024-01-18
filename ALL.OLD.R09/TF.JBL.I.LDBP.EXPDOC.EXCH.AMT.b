SUBROUTINE TF.JBL.I.LDBP.EXPDOC.EXCH.AMT
*-----------------------------------------------------------------------------
*Subroutine Description: This routine Calculate LD.AMOUNT based in Exchange Rate & Purchase Fc Amount
*Subroutine Type:
*Attached To    : ACTIVITY API:-  JBL.TF.FDBP.API & JBL.TF.IDBP.API
*Attached As    : INPUT ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 27/04/2020 -                            create by   - Mahmudur Rahman Udoy,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_AA.LOCAL.COMMON
    
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING EB.OverrideProcessing
    $USING EB.LocalReferences
    $USING AA.Account
    $USING AA.TermAmount
    $USING AA.Framework
    $USING EB.API
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    EB.LocalReferences.GetLocRef("AA.ARR.ACCOUNT","LT.TF.EXCH.RATE",Y.RATE.POS)
    EB.LocalReferences.GetLocRef("AA.ARR.ACCOUNT","LT.LN.BIL.DOCVL",Y.BILL.POS)
    EB.LocalReferences.GetLocRef("AA.ARR.ACCOUNT","LT.LN.PUR.FCAMT",Y.FCY.POS)
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    APP.NAME = 'AA.ARR.ACCOUNT'
    EB.API.GetStandardSelectionDets(APP.NAME, R.SS)
    Y.FIELD.NAME = 'LOCAL.REF'
    LOCATE Y.FIELD.NAME IN R.SS<AA.Account.Account.AcLocalRef> SETTING Y.POS THEN
    END
    CALL AA.GET.ACCOUNT.RECORD(R.PROPERTY.RECORD, PROPERTY.ID)
    TMP.DATA = R.PROPERTY.RECORD<1,Y.POS>
    Y.EXCH.RATE = FIELD(TMP.DATA,SM, Y.RATE.POS)
    Y.FCY = FIELD(TMP.DATA,SM, Y.FCY.POS)

    Y.PUR.AMT = Y.FCY[4,LEN(Y.FCY)]
 
    PROP.CLASS = 'TERM.AMOUNT'
    AA.Framework.GetArrangementConditions(Y.ARR.ID,PROP.CLASS,PROPERTY,'',RETURN.IDS,RETURN.VALUES,ERR.MSG)
    AC.R.REC = RAISE(RETURN.VALUES)
    Y.TERM.AMOUNT = AC.R.REC<AA.TermAmount.TermAmount.AmtAmount>
    IF Y.TERM.AMOUNT EQ '' THEN
        Y.TERM.AMOUNT = DROUND(Y.PUR.AMT * Y.EXCH.RATE, 2)
************ Rounding amount****************
        Y.TERM.AMOUNT.DC.AMT = FIELD(Y.TERM.AMOUNT,'.',2)
        Y.FST.NUM = Y.TERM.AMOUNT.DC.AMT[1,1]
        IF Y.FST.NUM GE '5' THEN
            Y.TERM.AMOUNT.RND = ('1' + FIELD(Y.TERM.AMOUNT,'.',1))
        END
        ELSE
            Y.TERM.AMOUNT.RND = FIELD(Y.TERM.AMOUNT,'.',1)
        END
        EB.SystemTables.setRNew(AA.TermAmount.TermAmount.AmtAmount, Y.TERM.AMOUNT.RND)
************  end    ****************
    END ELSE
        Y.NEW.LD.AMT = Y.PUR.AMT * Y.EXCH.RATE
        IF Y.TERM.AMOUNT NE Y.NEW.LD.AMT THEN
            EB.SystemTables.setText("Loan amount and new calculated amount differs")
            EB.ErrorProcessing.StoreEndError()
        END
    END
RETURN
*** </region>
END

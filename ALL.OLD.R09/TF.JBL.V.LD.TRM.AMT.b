SUBROUTINE TF.JBL.V.LD.TRM.AMT
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_AA.LOCAL.COMMON
    
    $USING EB.SystemTables
    $USING AA.Framework
    $USING AA.Account
    $USING AA.TermAmount
    $USING EB.Utility
    $USING EB.LocalReferences
*-----------------------------------------------------------------------------

    GOSUB INIT
    GOSUB PROCESS
RETURN
   
INIT:
    EB.LocalReferences.GetLocRef('AA.ARR.TERM.AMOUNT', 'LT.LN.OR.DISAMT', Y.DISAMT.POS)
    EB.LocalReferences.GetLocRef('AA.ARR.TERM.AMOUNT', 'LT.LN.DISB.AMT', Y.DISB.AMT.POS)
RETURN
    
PROCESS:
  

    
    Y.AMT = EB.SystemTables.getRNew(AA.TermAmount.TermAmount.AmtAmount)

    IF Y.AMT NE '' THEN
        Y.TEMP = EB.SystemTables.getRNew(AA.TermAmount.TermAmount.AmtLocalRef)
        Y.TEMP<1,Y.DISAMT.POS> = DROUND(Y.AMT,'2')
        Y.TEMP<1,Y.DISB.AMT.POS> = DROUND(Y.AMT,'2')
        EB.SystemTables.setRNew(AA.TermAmount.TermAmount.AmtLocalRef, Y.TEMP)
    END
    
RETURN
END

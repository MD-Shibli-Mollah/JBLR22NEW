SUBROUTINE TF.JBL.CAL.ON.DOC.AMT(arrId,arrProp,arrCcy,arrRes,balanceAmount,perDat)
*-----------------------------------------------------------------------------
*Subroutine Description: Cal on Doc Amount
*Subroutine Type: AA.SOURCE.CALC.TYPE()
*Attached To    :
*Attached As    :
*-----------------------------------------------------------------------------
* Modification History :
* 15/11/2020 -                            Create   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    
    $USING EB.SystemTables
    $USING AA.Framework
    $USING AA.ProductFramework
    $USING AA.Account
    $USING EB.DataAccess
    $USING EB.LocalReferences
    
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    ArrangementId = ''
    balanceAmount = ''
    Y.TOT.DOC.AMT = ''
    EB.LocalReferences.GetLocRef('AA.ARR.ACCOUNT',"LT.LN.BIL.DOCVL",Y.DOC.AMT.POS)
    EB.LocalReferences.GetLocRef('AA.ARR.ACCOUNT',"LT.TF.EXCH.RATE",Y.EX.RATE.POS)
RETURN
*** </region>


*-----------------------------------------------------------------------------


*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    ArrangementId =arrId
*
*
    PROP.CLASS.TRM = 'ACCOUNT'
    AA.Framework.GetArrangementConditions(ArrangementId,PROP.CLASS.TRM,'ACCOUNT','',RETURN.IDS.TRM,RETURN.VALUES.TRM,ERR.MSG.TRM)
    RETURN.VALUES.TRM = RAISE(RETURN.VALUES.TRM)
    Y.ACCOUNT.LT = RETURN.VALUES.TRM<AA.Account.Account.AcLocalRef>
    Y.DOC.AMT = Y.ACCOUNT.LT<1,Y.DOC.AMT.POS>
    Y.DOC.AMT = Y.DOC.AMT[4,LEN(Y.DOC.AMT)]
    Y.EX.RATE = Y.ACCOUNT.LT<1,Y.EX.RATE.POS>
*
*
    Y.TOT.DOC.AMT = Y.DOC.AMT * Y.EX.RATE
    balanceAmount = Y.TOT.DOC.AMT
    
RETURN
*** </region>
END


SUBROUTINE TF.JBL.I.CUS.LT.UPDT.AC
*-----------------------------------------------------------------------------
*Subroutine Description: CUSTOMER LT UPDATE FROM AA.ARRANGMENT.ACTIVITY
*Subroutine Type:
*Attached To    : ACTIVITY API
*Attached As    : PRE ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 8/07/2020 -                            Create   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_AA.APP.COMMON
    $INSERT I_AA.LOCAL.COMMON
    
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING EB.OverrideProcessing
    $USING EB.LocalReferences
    $USING AA.Framework
    $USING AA.Account
    $USING AA.Settlement
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    EB.LocalReferences.GetLocRef('AA.ARR.ACCOUNT','LT.AA.CUSTOMER',Y.POS)
    EB.LocalReferences.GetLocRef('AA.ARR.SETTLEMENT','LT.AA.CUSTOMER',Y.POS.1)
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.ARR.ID = AA.Framework.getC_aalocarrid()

    Y.AA.REC = AA.Framework.Arrangement.Read(Y.ARR.ID, E.AA)
    Y.CUS.ID = c_aalocArrActivityRec<AA.Framework.ArrangementActivity.ArrActCustomer>

    Y.TEMPA = EB.SystemTables.getRNew(AA.Account.Account.AcLocalRef)
    Y.TEMPA<1,Y.POS> = Y.CUS.ID
    EB.SystemTables.setRNew(AA.Account.Account.AcLocalRef,Y.TEMPA)

    Y.TEMPB = EB.SystemTables.getRNew(AA.Settlement.Settlement.SetLocalRef)
    Y.TEMPB<1,Y.POS.1> = Y.CUS.ID
    EB.SystemTables.setRNew(AA.Settlement.Settlement.SetLocalRef,Y.TEMPB)

RETURN
*** </region>

END

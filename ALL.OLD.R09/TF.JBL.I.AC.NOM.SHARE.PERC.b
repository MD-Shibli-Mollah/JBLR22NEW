SUBROUTINE TF.JBL.I.AC.NOM.SHARE.PERC
*-----------------------------------------------------------------------------
*Subroutine Description:This routine will calculates the Nomine share percentage and display
*                       error messages if nominee share is above 100%
*Subroutine Type:
*Attached To    : AA.ARR.ACCOUNT,AA.AC Version
*Attached As    : INPUT ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 03/03/2020 -                            retrofite   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING ST.Customer
    $USING EB.ErrorProcessing
    $USING EB.OverrideProcessing
    $USING AA.Framework
    $USING AA.Account
    $USING AA.Customer
    $USING EB.LocalReferences
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    Y.NULL = ''
    
    EB.LocalReferences.GetLocRef('AA.ARR.ACCOUNT', 'LT.AC.NM.SHARE', Y.AC.POS)
    EB.LocalReferences.GetLocRef('AA.ARR.ACCOUNT', 'LT.AC.NOM.NAME', Y.NAME.POS)
RETURN
*** </region>


*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.ARR.ID = AA.Framework.getC_aalocarrid()
    
    PROP.CLASS = 'ACCOUNT'
    AA.Framework.GetArrangementConditions(Y.ARR.ID,PROP.CLASS,PROPERTY,'',RETURN.IDS,RETURN.VALUES,ERR.MSG)
    AC.R.REC = RAISE(RETURN.VALUES)
    Y.TEMP.DATA = AC.R.REC<AA.Account.Account.AcLocalRef>
    Y.NOM.SHARE = Y.TEMP.DATA<1,Y.AC.POS>
    Y.NOM.NAME = Y.TEMP.DATA<1,Y.NAME.POS>
    
    Y.CNT = DCOUNT(Y.NOM.SHARE,@SM)
    Y.TOT = 0
    
    FOR I = 1 TO Y.CNT
        Y.VAL = Y.NOM.SHARE<1,1,I>
        Y.TOT += Y.VAL
    NEXT I
    
    EB.SystemTables.setAf(EB.SystemTables.getLocalRefField())
    
    IF Y.TOT NE '100' THEN
        EB.SystemTables.setAv(Y.AC.POS)
        EB.SystemTables.setEtext("Total Nominee Share shouldnot be LT 100 or GT 100")
        EB.ErrorProcessing.StoreEndError()
    END
        
RETURN
*** </region>


END

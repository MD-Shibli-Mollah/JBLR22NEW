SUBROUTINE TF.JBL.I.LOC.LIMIT.UPD
*-----------------------------------------------------------------------------
*Subroutine Description: effective date LT maturity date check
*Subroutine Type:
*Attached To    : Activity API
*Attached As    : INPUT ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
*  04/03/2020 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING ST.Customer
    $USING EB.ErrorProcessing
    $USING AA.Framework
    $USING EB.LocalReferences
    $USING LC.Contract
    $USING AA.Account
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT  = ''
    EB.LocalReferences.GetLocRef('AA.ARR.ACCOUNT','LT.AC.BD.LNMADT',Y.MAT.POS)
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.AA.ARRANGEMENT, F.AA.ARRANGEMENT)
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.ARR.ID = AA.Framework.getC_aalocarrid()
    Y.AA.REC = AA.Framework.Arrangement.Read(Y.ARR.ID, E.AA)
    Y.LN.ST.DT = Y.AA.REC<AA.Framework.Arrangement.ArrProdEffDate>
    
    PROP.CLASS = 'ACCOUNT'
    AA.Framework.GetArrangementConditions(Y.ARR.ID,PROP.CLASS,PROPERTY,'',RETURN.IDS,RETURN.VALUES,ERR.MSG)
    AC.R.REC = RAISE(RETURN.VALUES)
    Y.TEMP.DATA = AC.R.REC<AA.Account.Account.AcLocalRef>
    Y.LN.MA.DT = Y.TEMP.DATA<1, Y.MAT.POS>
    
    
    IF Y.LN.MA.DT LT Y.LN.ST.DT THEN
        EB.SystemTables.setAf(AA.Account.Account.AcLocalRef)
        EB.SystemTables.setAv(Y.MAT.POS)
        EB.SystemTables.setEtext("Loan maturity date can't less then effective date")
        EB.ErrorProcessing.StoreEndError()
    END
    
RETURN
*** </region>
          
END
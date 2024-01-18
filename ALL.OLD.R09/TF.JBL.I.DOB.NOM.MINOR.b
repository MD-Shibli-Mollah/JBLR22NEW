SUBROUTINE TF.JBL.I.DOB.NOM.MINOR
*-----------------------------------------------------------------------------
*Subroutine Description:This Rtn makes the Error msg if user select Minor DOB
*Subroutine Type:
*Attached To    : activity api
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
    $USING EB.Utility
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    Y.TODAY = EB.SystemTables.getToday()
    Y.MINOR.DATE = "18Y"
    Y.NULL = ''
    EB.Utility.CalendarDay(Y.TODAY,'-',Y.MINOR.DATE)
    
    EB.LocalReferences.GetLocRef('AA.ARR.ACCOUNT', 'LT.AC.NOM.FNAME', Y.FAT.POS)
    EB.LocalReferences.GetLocRef('AA.ARR.ACCOUNT', 'LT.AC.NOM.DOB', Y.DOB.POS)
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
    Y.DOB = Y.TEMP.DATA<1,Y.DOB.POS>
    Y.FATHER.NAME = Y.TEMP.DATA<1,Y.FAT.POS>
    
    EB.SystemTables.setAf(EB.SystemTables.getLocalRefField())
    
    IF Y.DOB GT Y.MINOR.DATE THEN
        IF Y.FATHER.NAME EQ Y.NULL THEN
            EB.SystemTables.setAv(Y.FAT.POS)
            EB.SystemTables.setEtext("DOB is Minor; Father/Guardian Name is mandatory")
            EB.ErrorProcessing.StoreEndError()
        END
    END
        
RETURN
*** </region>


END

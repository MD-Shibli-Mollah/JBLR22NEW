SUBROUTINE TF.JBL.I.AC.SB.OPEN
*-----------------------------------------------------------------------------
*Subroutine Description: This Rtn makes the Error msg if user select forward date
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
    
    EB.LocalReferences.GetLocRef("AA.ARR.ACCOUNT","LT.AC.NOM.DOB",Y.DOB.POS)
    EB.LocalReferences.GetLocRef("AA.ARR.ACCOUNT","LT.AC.MPA.DOB",Y.POA.DOB.POS)
    EB.LocalReferences.GetLocRef("AA.ARR.ACCOUNT","LT.AC.MPA.DTEXP",Y.POA.DOE.POS)
    EB.LocalReferences.GetLocRef("AA.ARR.ACCOUNT","LT.AC.NOM.FNAME",Y.FAT.POS)
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
    Y.NOM.DOB = Y.TEMP.DATA<1,1,Y.DOB.POS>
    Y.POA.DOB = Y.TEMP.DATA<1,Y.POA.DOB.POS>
    Y.POA.DOE = Y.TEMP.DATA<1,Y.POA.DOE.POS>
    Y.FATHER.NAME = Y.TEMP.DATA<1,Y.FAT.POS>
    
    EB.SystemTables.setAf(EB.SystemTables.getLocalRefField())
    
*    IF Y.DOB GT Y.MINOR.DATE THEN
*        IF Y.FATHER.NAME EQ Y.NULL THEN
*            EB.SystemTables.setAv(Y.FAT.POS)
*            EB.SystemTables.setEtext("DOB is Minor; Father/Guardian Name is mandatory")
*            EB.ErrorProcessing.StoreEndError()
*        END
*    END

*    IF Y.DOB AND Y.DOB GT Y.TODAY THEN
*        AF = AC.LOCAL.REF
*        AV = Y.POS2
*!V$ERROR = 1
*        EB.SystemTables.setEtext("Date of Issue is Future Date"
*!END.ERROR = 1
*        EB.ErrorProcessing.StoreEndError()
*        RETURN
*    END

    !S - V.JBL.AC.EXP.DATE

    !Y.EXP.DOB = COMI

*    IF Y.EXP.DOB AND Y.EXP.DOB LT Y.TODAY THEN
*        AF = AC.LOCAL.REF
*        AV = Y.POS3
*        EB.SystemTables.setEtext("Date of Expiry is Back date"
*        EB.ErrorProcessing.StoreEndError()
*        RETURN
*    END


    IF Y.NOM.DOB AND Y.NOM.DOB GT Y.TODAY THEN
        EB.SystemTables.setAf(EB.SystemTables.getLocalRefField())
        EB.SystemTables.setAv(Y.DOB.POS)
        EB.SystemTables.setEtext("Date of Birth is Future Date")
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END

    IF Y.POA.DOB AND Y.POA.DOB GT Y.TODAY THEN
        EB.SystemTables.setAf(AA.Account.Account.AcLocalRef)
        EB.SystemTables.setAv(Y.POA.DOB.POS)
        EB.SystemTables.setEtext("Date of Birth is Future Date")
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END

    !E

    !S - V.JBL.POA.ISS.DATE

*    IF Y.POA.DOI AND Y.POA.DOI GT Y.TODAY THEN
*        AF = AC.LOCAL.REF
*        EB.SystemTables.setAv(Y.POA.DOI.POS
*        !V$ERROR = 1
*        EB.SystemTables.setEtext("Date of Issue is Future Date")
*        !END.ERROR = 1
*        EB.ErrorProcessing.StoreEndError()
*        RETURN
*    END
    !E

    IF Y.POA.DOE AND Y.POA.DOE LT Y.TODAY THEN
        EB.SystemTables.setAf(AA.Account.Account.AcLocalRef)
        EB.SystemTables.setAv(Y.POA.DOE.POS)
        EB.SystemTables.setEtext("Date of Expiry is Back date")
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END

    CALL CALENDAR.DAY(Y.TODAY,'-',Y.MINOR.DATE)
    IF Y.NOM.DOB GT Y.MINOR.DATE AND NOT(Y.FATHER.NAME) THEN
        EB.SystemTables.setAf(EB.SystemTables.getLocalRefField())
        EB.SystemTables.setAv(Y.FAT.POS)
        EB.SystemTables.setEtext("DOB is Minor; Father/Guardian Name is mandatory ")
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END
        
RETURN
*** </region>


END

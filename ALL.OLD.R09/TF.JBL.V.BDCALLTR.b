SUBROUTINE TF.JBL.V.BDCALLTR
*-----------------------------------------------------------------------------
*Subroutine Description:
*Subroutine Type:
*Attached To    : LD.LOANS.AND.DEPOSITS Version (LD.LOANS.AND.DEPOSITS,JBL.DISB.LTR)
*Attached As    : VALIDATION ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 28/10/2019 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $USING LD.Contract
    
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.API
    $USING EB.Display
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.LD="F.LD.LOANS.AND.DEPOSITS"
    F.LD=""
    
    R.LD.LOANS.AND.DEPOSITS.REC = ''
    Y.LD.LOANS.AND.DEPOSITS.ERR = ''


    Y.ACC.DATE = ''
    Y.TENOR = 0
    Y.NEW.TENOR = 0
    Y.NEG.DATE = ''
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.LD,F.LD)
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.TENOR = EB.SystemTables.getComi()


    IF Y.TENOR EQ "AT SIGHT" THEN
        Y.TENOR = "21"
    END


    Y.NEW.TENOR = "+":Y.TENOR:"C"
    Y.ACC.DATE = EB.SystemTables.getRNew(LD.Contract.LoansAndDeposits.ValueDate)

    IF Y.ACC.DATE NE '' THEN
        EB.API.Cdt("",Y.ACC.DATE,Y.NEW.TENOR)
        EB.SystemTables.setRNew(LD.Contract.LoansAndDeposits.FinMatDate, Y.ACC.DATE)
    END
    Y.TENOR = ''
    Y.NEW.TENOR = ''
    EB.Display.RefreshField(EB.SystemTables.getAf(),"")
RETURN
*** </region>
END

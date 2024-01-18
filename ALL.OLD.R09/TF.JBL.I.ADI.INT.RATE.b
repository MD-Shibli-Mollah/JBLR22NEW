SUBROUTINE TF.JBL.I.ADI.INT.RATE
*-----------------------------------------------------------------------------
*Subroutine Description:  This Routine will do Customer,category,currency and
*                         Deposit field as default in Account Version
*Subroutine Type:
*Attached To    : ACCOUNT Version (ACCOUNT.DEBIT.INT,JBL.CC.LOAN.ADI)
*Attached As    : INPUT ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 28/10/2019 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING LI.Config
    $USING IC.Config
    
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.ADI = 'F.ACCOUNT.DEBIT.INT'
    F.ADI = ''
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.ADI,F.ADI)
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.NEW.INT.RATE = EB.SystemTables.getRNew(IC.Config.AccountDebitInt.AdiDrIntRate)<1,1>
    Y.EOL.INT.RATE = EB.SystemTables.getRNew(IC.Config.AccountDebitInt.AdiDrIntRate)<1,2>
!DEBUG
    IF Y.NEW.INT.RATE GT 25 THEN
        EB.SystemTables.setAf(IC.Config.AccountDebitInt.AdiDrIntRate)
        EB.SystemTables.setEtext("Invalid Interest Rate")
        EB.ErrorProcessing.StoreEndError()
    END
    IF Y.EOL.INT.RATE GT 25 THEN
        !AF=IC.Config.AccountDebitInt.AdiDrIntRate<1,2>
        EB.SystemTables.setEtext("Invalid EOL Interest Rate")
        EB.ErrorProcessing.StoreEndError()
    END
    IF Y.EOL.INT.RATE LT Y.NEW.INT.RATE THEN
        !AF=IC.Config.AccountDebitInt.AdiDrIntRate
        EB.SystemTables.setEtext("EOL Interest Rate can't be less then Regular Interest Rate")
        EB.ErrorProcessing.StoreEndError()
    END
RETURN
*** </region>
END
    
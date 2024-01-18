SUBROUTINE TF.JBL.I.ADI.RATE
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
    $USING AC.AccountOpening
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
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ' '
    
    FN.ADI = 'F.ACCOUNT.DEBIT.INT'
    F.ADI = ''
    
    Y.TODAY = EB.SystemTables.getToday()
    Y.BKDAY = EB.SystemTables.getToday()-7
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)
    EB.DataAccess.Opf(FN.ADI,F.ADI)
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.ADI.ID = EB.SystemTables.getIdNew()
    Y.ADI.AC = FIELD(Y.ADI.ID,'-',1)
    Y.DATE = FIELD(Y.ADI.ID,'-',2)

    IF Y.DATE GT Y.TODAY THEN
        EB.SystemTables.setAf(IC.Config.AccountDebitInt.AdiDrIntRate)
        EB.SystemTables.setEtext("ADI FUTURE DATE NOT ALLOW ")
        EB.ErrorProcessing.StoreEndError()

    END

    EB.DataAccess.FRead(FN.ACCOUNT,Y.ADI.AC,AC.REC,F.ACCOUNT,AC.ERR)
    IF AC.REC THEN
        Y.CAP.DATE = AC.REC<AC.AccountOpening.Account.CapDateDrInt,1>
        IF Y.DATE LE Y.CAP.DATE THEN
            EB.SystemTables.setAf(IC.Config.AccountDebitInt.AdiDrIntRate)

            EB.SystemTables.setEtext("ADI DATE MUST BE GREATER THAN LAST CAPITALIZATION DATE ":Y.CAP.DATE)
            EB.ErrorProcessing.StoreEndError()
        END
    END
RETURN
*** </region>
END


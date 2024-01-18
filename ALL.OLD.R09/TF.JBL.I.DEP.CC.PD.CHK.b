SUBROUTINE TF.JBL.I.DEP.CC.PD.CHK
*-----------------------------------------------------------------------------
*Subroutine Description: Card FT overdraft and exvess available funds check
*Subroutine Type:
*Attached To    : FUNDS.TRANSFER Version (FUNDS.TRANSFER,JBL.ACTR , FUNDS.TRANSFER,JBL.CARD.FCY)
*Attached As    : INPUT ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 14/11/2019 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
*-----------------------------------------------------------------------------
*GOSUB INITIALISE ; *INITIALISATION
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
*-----------------------------------------------------------------------------

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.OVERRIDE.VAL = EB.SystemTables.getRNew(EB.SystemTables.getV() -9)
    Y.OVRRD.NO = DCOUNT(Y.OVERRIDE.VAL,VM)

    Y.OVRRD.ID = ''

    FOR I=1 TO Y.OVRRD.NO
        Y.OVRRD.DETLS = FIELD(Y.OVERRIDE.VAL,VM,I)
        Y.OVRRD.ID = FIELD(Y.OVRRD.DETLS,'}',1)

        IF (Y.OVRRD.ID='AVAILABLE.BALANCE.OVERDRAFT') THEN
            EB.SystemTables.setEtext('Overdraft on Available Balance !!!')
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END

        IF (Y.OVRRD.ID = 'AVAILABLE.FUNDS.EXCESS') THEN
            EB.SystemTables.setEtext("Limit Excess on Available Funds !!!")
            EB.ErrorProcessing.StoreEndError()
            RETURN

        END
    NEXT I
RETURN
*** </region>
END


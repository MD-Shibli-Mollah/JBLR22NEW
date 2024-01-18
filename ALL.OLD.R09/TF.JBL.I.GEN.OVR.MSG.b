SUBROUTINE TF.JBL.I.GEN.OVR.MSG
*-----------------------------------------------------------------------------
*Subroutine Description: INCOME.ACCT.DEBITED OVERRIDE showing for card FT
*Subroutine Type:
*Attached To    : FUNDS.TRANSFER Version (FUNDS.TRANSFER,JBL.ACTR , FUNDS.TRANSFER,JBL.CARD.FCY , FUNDS.TRANSFER,JBL.CIBIT.AUTH )
*Attached As    : INPUT ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 14/11/2019 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING AC.AccountOpening
    $USING EB.OverrideProcessing
    $USING TT.Contract
    $USING FT.Contract
*    $INSERT T24.BP I_ENQUIRY.COMMON
    $USING EB.DataAccess
    $USING EB.SystemTables
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.OVERRIDE = "F.OVERRIDE"
    F.OVERRIDE = ''
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.OVERRIDE, F.OVERRIDE)
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    IF EB.SystemTables.getApplication() EQ 'TELLER' AND EB.SystemTables.getRNew(TT.Contract.Teller.TeAccountTwo)[3,8] THEN
        Y.CATEGORY = EB.SystemTables.getRNew(TT.Contract.Teller.TeAccountTwo)[3,8]
    END ELSE
        IF EB.SystemTables.getApplication() EQ 'FUNDS.TRANSFER' AND EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)[3,8] THEN
            Y.CATEGORY = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)[3,8]
        END
    END
    !
    IF Y.CATEGORY GE '51000' AND Y.CATEGORY LE '52999' THEN
        CALL F.READ(FN.OVERRIDE, 'INCOME.ACCT.DEBITED', R.OVR, F.OVERRIDE, OVR.ERR)
        IF R.OVR THEN
            EB.SystemTables.setText(R.OVR<EB.OR.MESSAGE><1,1>)
            !
            IF EB.SystemTables.getApplication() EQ 'TELLER' THEN
                GOSUB TELLER.OVR
            END
            IF EB.SystemTables.getApplication() EQ 'FUNDS.TRANSFER' THEN
                GOSUB FT.OVR
            END
        END
    END
RETURN
*** </region>

*** <region name= TELLER.OVR>
TELLER.OVR:
*** <desc>TELLER.OVR </desc>
    CURR.NO = DCOUNT(EB.SystemTables.getRNew(TT.Contract.Teller.TeOverride), VM) + 1
    EB.OverrideProcessing.StoreOverride(CURR.NO)
RETURN
*** </region>

*** <region name= FT.OVR>
FT.OVR:
*** <desc>FT.OVR </desc>
    CURR.NO = DCOUNT(EB.SystemTables.getRNew(FT.Contract.FundsTransfer.Override), VM) + 1
    EB.OverrideProcessing.StoreOverride(CURR.NO)
RETURN
*** </region>
END

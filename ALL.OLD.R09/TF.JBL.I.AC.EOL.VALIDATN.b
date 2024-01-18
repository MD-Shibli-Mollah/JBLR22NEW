SUBROUTINE TF.JBL.I.AC.EOL.VALIDATN
*-----------------------------------------------------------------------------
*Subroutine Description:This routine will not allow Excess over Limit of loan amount more than the
*                        Limit Sanction Amount
*Subroutine Type:
*Attached To    : FUNDS.TRANSFER Version (FUNDS.TRANSFER,CARD.FCY)
*Attached As    : INPUT ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 14/11/2019 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING FT.Contract
 
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.AC='F.ACCOUNT'
    F.AC=''

    FN.FTR='F.FUNDS.TRANSFER'
    F.FTR=''
RETURN
*** </region>




*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.OVERRIDE.VAL = EB.SystemTables.getRNew(EB.SystemTables.getV()-9)
    Y.OVRRD.NO = DCOUNT(Y.OVERRIDE.VAL,VM)

    Y.OVRRD.ID = ''

    Y.LEGAL.CHRG="LEGAL.CHARGE"
    Y.LEGAL.CHRG.POS=""

    IF EB.SystemTables.getApplication() EQ 'FUNDS.TRANSFER' THEN

        CALL GET.LOC.REF("FUNDS.TRANSFER",Y.LEGAL.CHRG,Y.LEGAL.CHRG.POS)
        Y.LEG.CHG = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1,Y.LEGAL.CHRG.POS>
    END

    Y.AMT.INCS=EB.SystemTables.getRNew(LD.Contract.LoansAndDeposits.AmountIncrease)

    FOR I=1 TO Y.OVRRD.NO
        Y.OVRRD.DETLS = FIELD(Y.OVERRIDE.VAL,VM,I)
        Y.OVRRD.ID = FIELD(Y.OVRRD.DETLS,'}',1)
        IF (Y.OVRRD.ID='EXCESS.ID') THEN
            GOSUB STOP.EXCESS.LIMIT
            BREAK
        END

        !        IF Y.AMT.INCS GT 0 THEN

        IF (Y.OVRRD.ID = 'LIMIT.EXPIRED') THEN
            GOSUB STOP.LIMIT.EXPIRED
            BREAK
        END
        !        END
    NEXT I
RETURN
*** </region>

*-----------------------------------------------------------------------------

*** <region name= STOP.EXCESS.LIMIT>
STOP.EXCESS.LIMIT:
*** <desc>STOP.EXCESS.LIMIT </desc>
    EB.SystemTables.setAf(I)
    IF Y.LEG.CHG NE 'YES' OR Y.LEG.CHG NE 'Y' THEN
        EB.SystemTables.setEtext('Excess Over Limit is not Allowed')
        EB.ErrorProcessing.StoreEndError()
    END
    ELSE
        EB.SystemTables.setEtext("Excess Over Limit")
        CALL STORE.OVERRIDE(CURR.NO)
    END
RETURN
*** </region>

*-----------------------------------------------------------------------------

*** <region name= STOP.LIMIT.EXPIRED>
STOP.LIMIT.EXPIRED:
*** <desc>STOP.LIMIT.EXPIRED</desc>
    EB.SystemTables.setAf(I)
    EB.SystemTables.setEtext("Customer Limit Expired! Cannot do Transaction")
    EB.ErrorProcessing.StoreEndError()
RETURN
*** </region>
END

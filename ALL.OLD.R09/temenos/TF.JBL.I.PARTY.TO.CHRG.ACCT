SUBROUTINE TF.JBL.I.PARTY.TO.CHRG.ACCT
*-----------------------------------------------------------------------------
*Subroutine Description: account set for charge in drawings
*Subroutine Type:
*Attached To    : DRAWINGS,JBL.BTBDOCREJ , DRAWINGS,JBL.BTBMAT , DRAWINGS,JBL.BTBSHIPGTEE  , DRAWINGS,JBL.BTBSP , DRAWINGS,JBL.BTBSP.T , DRAWINGS,JBL.IMPDOCREJ
* DRAWINGS,JBL.IMPLODGE , DRAWINGS,JBL.IMPMAT , DRAWINGS,JBL.IMPSP , DRAWINGS,JBL.IMPSP.T
*Attached As    :
*-----------------------------------------------------------------------------
* Modification History :
* 01/11/2020 -                            Create   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING EB.OverrideProcessing
    $USING EB.LocalReferences
    $USING LC.Contract
    
*-----------------------------------------------------------------------------
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
*-----------------------------------------------------------------------------



*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.PARTY.CHARGE = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrPartyCharged)
    Y.CHARGE.ACCOUNT = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrChargeAccount)
    Y.DEBIT.ACCT = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrDrawdownAccount)
    Y.CREDIT.ACCT = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrPaymentAccount)
    Y.COUNT = DCOUNT(Y.PARTY.CHARGE,@VM)
    FOR I = 1 TO Y.COUNT
        IF Y.PARTY.CHARGE<1,I> EQ 'O' THEN Y.CHARGE.ACCOUNT<1,I> = Y.DEBIT.ACCT
        IF Y.PARTY.CHARGE<1,I> EQ 'B' THEN Y.CHARGE.ACCOUNT<1,I> = Y.CREDIT.ACCT
    NEXT I
    Y.CHANGER.ACCOUNT = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrChargeAccount)
    IF Y.CHANGER.ACCOUNT EQ "" THEN
        EB.SystemTables.setRNew(LC.Contract.Drawings.TfDrChargeAccount, Y.CHARGE.ACCOUNT)
    END
    
RETURN
*** </region>
END
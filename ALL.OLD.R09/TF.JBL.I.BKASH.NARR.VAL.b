SUBROUTINE TF.JBL.I.BKASH.NARR.VAL
*-----------------------------------------------------------------------------
*Subroutine Description: FT TT Narr set
*Subroutine Type:
*Attached To    : FUNDS.TRANSFER Version (FUNDS.TRANSFER,JBL.ACTR)
*Attached As    : INPUT ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 14/11/2019 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    
    $USING TT.Contract
    $USING FT.Contract
    $USING AC.AccountOpening
    $USING ST.Customer
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
*-----------------------------------------------------------------------------
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
    RETURN
*-----------------------------------------------------------------------------

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.APPLICATION = EB.SystemTables.getApplication()

    IF Y.APPLICATION EQ 'TELLER' THEN
        Y.CR.AC.ID = EB.SystemTables.getRNew(TT.Contract.Teller.TeAccountTwo)
        Y.NARR=EB.SystemTables.getRNew(TT.Contract.Teller.TeNarrativeTwo)
    END
    IF Y.APPLICATION EQ 'FUNDS.TRANSFER' THEN
        Y.CR.AC.ID = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAcctNo)
        Y.NARR=EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1,109>
    END


    Y.DIST.NAME=FIELD(Y.NARR,'-',1)
    Y.DIST.CODE=FIELD(Y.NARR,'-',2)
    
* will be change with mig data
    IF Y.CR.AC.ID EQ "111613120722698" THEN
        IF (Y.DIST.NAME EQ '') OR (Y.DIST.CODE EQ '') THEN
            EB.SystemTables.setEtext('For bKash A/C Credit, Cr. Narr. Required. Format:Dist. Name-Dist. Code')
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END
    END
RETURN
*** </region>
END

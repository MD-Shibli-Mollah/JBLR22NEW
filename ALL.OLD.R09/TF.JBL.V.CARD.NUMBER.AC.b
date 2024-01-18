SUBROUTINE TF.JBL.V.CARD.NUMBER.AC
*-----------------------------------------------------------------------------
*Subroutine Description:
*Subroutine Type:
*Attached To    : FUNDS.TRANSFER Version
*Attached As    : VALIDATION ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 14/11/2019 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING FT.Contract
    
    $INSERT I_F.JBL.CREDIT.CARD.DETAILS
    
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING EB.LocalReferences
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.CARD = 'F.JBL.CREDIT.CARD.DETAILS'
    F.CARD = ''

    FN.FT = 'F.FUNDS.TRANSFER'
    F.FT = ''
    
    Y.CARD.NO = ''
    Y.CARD.TYPE = ''
    Y.CUST.NAME = ''
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.CARD,F.CARD)
    EB.DataAccess.Opf(FN.FT,F.FT)
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.CARD.NO = EB.SystemTables.getComi()

    EB.DataAccess.FRead(FN.CARD,Y.CARD.NO,R.CARD,F.CARD,CARD.ERR)

    IF R.CARD THEN
        Y.CUST.NAME = R.CARD<CR.CARD.CUST.NAME>

        EB.LocalReferences.GetLocRef("FUNDS.TRANSFER","LT.CIBT.BCOD",Y.NAME.POS)
        Y.TEMP = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
        Y.TEMP<1,Y.NAME.POS> = Y.CUST.NAME
        EB.SystemTables.setRNew(FT.Contract.FundsTransfer.LocalRef, Y.TEMP)
    END

    ELSE
        Y.TEMP = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
        Y.TEMP<1,Y.NAME.POS> = ''
        EB.SystemTables.setRNew(FT.Contract.FundsTransfer.LocalRef, Y.TEMP)

        EB.LocalReferences.GetLocRef("FUNDS.TRANSFER","LT.FT.CR.NARR",Y.CARD.NO.POS)
        
        EB.SystemTables.setAf(FT.Contract.FundsTransfer.LocalRef)
        EB.SystemTables.setAf(Y.CARD.NO.POS)
        EB.SystemTables.setEtext('Invalid Card No')
        EB.ErrorProcessing.StoreEndError()
    END


    IF EB.SystemTables.getPgmVersion() EQ ",JBL.CARD.FCY" THEN
        Y.FCY.ACC =R.CARD<CR.CARD.FCY>

        IF Y.FCY.ACC EQ '' THEN
            EB.SystemTables.setEtext('NOT AN INTERNATIONAL CARD')
            EB.ErrorProcessing.StoreEndError()
        END

    END

RETURN
*** </region>
END

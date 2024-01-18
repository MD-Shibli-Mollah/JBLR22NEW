SUBROUTINE TF.JBL.I.BTB.OPEN.AMD
*-----------------------------------------------------------------------------
*Subroutine Description: BTB amend data validation
*Subroutine Type:
*Attached To    : LETTER.OF.CREDIT Version (LETTER.OF.CREDIT,JBL.BTB.AMD.JOB , LETTER.OF.CREDIT,JBL.BTBAMDINT
* LETTER.OF.CREDIT,JBL.BTBAMDEXT , LETTER.OF.CREDIT,TEST.JBL.BTBAMDINT)
*Attached As    : INPUT ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 07/11/2019 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING LC.Contract
    $INSERT I_GTS.COMMON
    $INSERT I_F.BD.BTB.JOB.REGISTER
    
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING EB.LocalReferences
    $USING ST.CurrencyConfig
*-----------------------------------------------------------------------------
    IF OFS.VAL.ONLY THEN RETURN
    IF EB.SystemTables.getVFunction() EQ 'I' AND EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcOperation) EQ "A" THEN
	    GOSUB INITIALISE ; *INITIALISATION
	    GOSUB OPENFILE ; *FILE OPEN
	    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
    END
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.BD.BTB.JOB.REGISTER = "F.BD.BTB.JOB.REGISTER"
    F.BD.BTB.JOB.REGISTER = ""
    FN.CCY = 'F.CURRENCY'
    F.CCY = ''
RETURN
*** </region>

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.CCY,F.CCY)
    EB.DataAccess.Opf(FN.BD.BTB.JOB.REGISTER,F.BD.BTB.JOB.REGISTER)
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    GOSUB GET.LOC.REF.POS
    Y.CCY = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLcCurrency)
    Y.JOB.NO = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.JOB.NUMBER.POS>
    CALL F.READ(FN.BD.BTB.JOB.REGISTER,Y.JOB.NO,R.BTB.JOB.REGISTER,F.BD.BTB.JOB.REGISTER,Y.BTB.JOB.REG.ERR)
   
    IF EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLcAmount) GT EB.SystemTables.getROld(LC.Contract.LetterOfCredit.TfLcLcAmount) THEN
        Y.INC.BTB.LCAMT = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLcAmount) - EB.SystemTables.getROld(LC.Contract.LetterOfCredit.TfLcLcAmount)

*if LC CCY is 'BDT'
        IF Y.CCY EQ 'BDT' THEN
            Y.CCY = 'USD'
            GOSUB GET.SELL.RATE
            Y.INC.BTB.LCAMT = Y.INC.BTB.LCAMT / Y.SELL.RATE
        END
        
*if LC CCY not 'BDT' and 'USD'
        IF Y.CCY NE 'BDT' AND Y.CCY NE 'USD' THEN
            GOSUB GET.SELL.RATE
            Y.LC.CCY.SELL.RATE = Y.SELL.RATE
            Y.CCY = 'USD'
            GOSUB GET.SELL.RATE
            Y.USD.CCY.SELL.RATE = Y.SELL.RATE
            Y.INC.BTB.LCAMT = (Y.LC.CCY.SELL.RATE / Y.USD.CCY.SELL.RATE) * Y.INC.BTB.LCAMT
        END
        
        IF NOT(R.BTB.JOB.REGISTER) THEN
            EB.SystemTables.setAf(LC.Contract.LetterOfCredit.TfLcLocalRef)
            EB.SystemTables.setAv(Y.JOB.NUMBER.POS)
            EB.SystemTables.setEtext("JOB Number Should not be Null")
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END
    
        Y.JOB.ENT.AMT = R.BTB.JOB.REGISTER<BTB.JOB.TOT.BTB.AVL.AMT>
        Y.TEMP = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)
        Y.TEMP<1,Y.JOB.BTB.ENT.AMT.POS> = R.BTB.JOB.REGISTER<BTB.JOB.TOT.BTB.AVL.AMT>
        EB.SystemTables.setRNew(LC.Contract.LetterOfCredit.TfLcLocalRef, Y.TEMP)
        
        IF Y.INC.BTB.LCAMT GT R.BTB.JOB.REGISTER<BTB.JOB.TOT.BTB.AVL.AMT> THEN
            Y.DIFF = Y.INC.BTB.LCAMT - R.BTB.JOB.REGISTER<BTB.JOB.TOT.BTB.AVL.AMT>
            EB.SystemTables.setAf(LC.Contract.LetterOfCredit.TfLcLcAmount)
            EB.SystemTables.setEtext("EXCEEDS BY JOB ENTITLEMENT AMOUNT  ":Y.DIFF)
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END
    END
    
    IF EB.SystemTables.getRNew(TF.LC.ADVICE.EXPIRY.DATE) GT R.BTB.JOB.REGISTER<BTB.JOB.JOB.EXPIRY.DATE> THEN
        EB.SystemTables.setAf(TF.LC.ADVICE.EXPIRY.DATE)
        EB.SystemTables.setEtext("BTB Expiry Date GT Job Expiry Date")
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END
RETURN
*** </region>

*** <region name= GET.SELL.RATE>
GET.SELL.RATE:
    EB.DataAccess.FRead(FN.CCY,Y.CCY,R.CCY,F.CCY,CCY.ERR)
    Y.CCY.MKT = '3'
    Y.SELL.RATE = ''
    FIND Y.CCY.MKT IN R.CCY<ST.CurrencyConfig.Currency.EbCurCurrencyMarket> SETTING Y.CCY.MKT.POS1, Y.CCY.MKT.POS2, Y.CCY.MKT.POS3 THEN
        Y.SELL.RATE = R.CCY<ST.CurrencyConfig.Currency.EbCurSellRate, Y.CCY.MKT.POS2>
    END ELSE
        EB.SystemTables.setE('Currency Market ':Y.CCY.MKT:' Missing')
        EB.ErrorProcessing.Err()
    END
RETURN

*** <region name= GET.LOC.REF.POS>
GET.LOC.REF.POS:
*** <desc>GET.LOC.REF.POS </desc>
    EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.TF.JOB.NUMBR",Y.JOB.NUMBER.POS)
    EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.TF.JOB.ENTAM",Y.JOB.BTB.ENT.AMT.POS)
RETURN
*** </region>
END

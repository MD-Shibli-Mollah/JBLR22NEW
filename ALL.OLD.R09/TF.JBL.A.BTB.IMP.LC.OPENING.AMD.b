SUBROUTINE TF.JBL.A.BTB.IMP.LC.OPENING.AMD
*-----------------------------------------------------------------------------
*Subroutine Description: BTB LC opening record amend data write in BD.BTB.JOB.REGISTER
*Attached To    : LETTER.OF.CREDIT Version (LETTER.OF.CREDIT,JBL.BTBAMDINT, LETTER.OF.CREDIT,JBL.BTBAMDEXT)
*Attached As    : AUTH ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 07/11/2019 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BD.BTB.JOB.REGISTER

    $USING LC.Contract
    $USING EB.DataAccess
    $USING EB.LocalReferences
    $USING EB.SystemTables
    $USING ST.CurrencyConfig
*-----------------------------------------------------------------------------
    IF EB.SystemTables.getVFunction() EQ 'A' THEN
	    GOSUB INITIALISE ; *INITIALISATION
	    GOSUB OPENFILE ; *FILE OPEN
	    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
    END
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.BD.BTB.JOB.REGISTER = 'F.BD.BTB.JOB.REGISTER'
    F.BD.BTB.JOB.REGISTER = ''
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
    Y.JOB.NUMBER = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.JOB.NO.POS>
    EB.DataAccess.FRead(FN.BD.BTB.JOB.REGISTER,Y.JOB.NUMBER,R.BTB.JOB.REGISTER,F.BD.BTB.JOB.REGISTER,Y.BD.JOB.REG.ERR)

    IF R.BTB.JOB.REGISTER THEN
        Y.IMP.LC.REF = R.BTB.JOB.REGISTER<BTB.JOB.IM.TF.REF>
        LOCATE EB.SystemTables.getIdNew() IN Y.IMP.LC.REF<1,1> SETTING Y.CNT.POS THEN
            Y.COUNT = Y.CNT.POS
            GOSUB UPDATE.JOB.REGISTER
        END
    END
RETURN
*** </region>

*** <region name= UPDATE.JOB.REGISTER>
UPDATE.JOB.REGISTER:
*** <desc>UPDATE.JOB.REGISTER </desc>
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
        
        R.BTB.JOB.REGISTER<BTB.JOB.IM.LC.AMOUNT,Y.COUNT> = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLcAmount)
        IF EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcAdviceExpiryDate) NE R.BTB.JOB.REGISTER<BTB.JOB.IM.EXPIRY.DATE,Y.COUNT> THEN
            R.BTB.JOB.REGISTER<BTB.JOB.IM.EXPIRY.DATE,Y.COUNT> = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcAdviceExpiryDate)
        END
        R.BTB.JOB.REGISTER<BTB.JOB.TOT.BTB.AMT> += Y.INC.BTB.LCAMT
        R.BTB.JOB.REGISTER<BTB.JOB.TOT.BTB.AVL.AMT> -= Y.INC.BTB.LCAMT
    END
    
    IF EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLcAmount) LT EB.SystemTables.getROld(LC.Contract.LetterOfCredit.TfLcLcAmount) THEN
        Y.DEC.BTB.LCAMT = EB.SystemTables.getROld(LC.Contract.LetterOfCredit.TfLcLcAmount) - EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLcAmount)
*if LC CCY is 'BDT'
        IF Y.CCY EQ 'BDT' THEN
            Y.CCY = 'USD'
            GOSUB GET.SELL.RATE
            Y.DEC.BTB.LCAMT = Y.DEC.BTB.LCAMT / Y.SELL.RATE
        END
*if LC CCY not 'BDT' and 'USD'
        IF Y.CCY NE 'BDT' AND Y.CCY NE 'USD' THEN
            GOSUB GET.SELL.RATE
            Y.LC.CCY.SELL.RATE = Y.SELL.RATE
            Y.CCY = 'USD'
            GOSUB GET.SELL.RATE
            Y.USD.CCY.SELL.RATE = Y.SELL.RATE
            Y.DEC.BTB.LCAMT = (Y.LC.CCY.SELL.RATE / Y.USD.CCY.SELL.RATE) * Y.DEC.BTB.LCAMT
        END
        
        R.BTB.JOB.REGISTER<BTB.JOB.IM.LC.AMOUNT,Y.COUNT> = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLcAmount)
        IF EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcAdviceExpiryDate) NE R.BTB.JOB.REGISTER<BTB.JOB.IM.EXPIRY.DATE,Y.COUNT> THEN
            R.BTB.JOB.REGISTER<BTB.JOB.IM.EXPIRY.DATE,Y.COUNT> = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcAdviceExpiryDate)
        END
    
        R.BTB.JOB.REGISTER<BTB.JOB.TOT.BTB.AMT> -= Y.DEC.BTB.LCAMT
        R.BTB.JOB.REGISTER<BTB.JOB.TOT.BTB.AVL.AMT> += Y.DEC.BTB.LCAMT
    END
    EB.DataAccess.FWrite(FN.BD.BTB.JOB.REGISTER,Y.JOB.NUMBER,R.BTB.JOB.REGISTER)
RETURN
*** </region>

*** <region name= GET.SELL.RATE>
GET.SELL.RATE:
    EB.DataAccess.FRead(FN.CCY,Y.CCY,R.CCY,F.CCY,CCY.ERR)
    Y.CCY.MKT = '3'
    Y.SELL.RATE = ''
    FIND Y.CCY.MKT IN R.CCY<ST.CurrencyConfig.Currency.EbCurCurrencyMarket> SETTING Y.CCY.MKT.POS1, Y.CCY.MKT.POS2, Y.CCY.MKT.POS3 THEN
        Y.SELL.RATE = R.CCY<ST.CurrencyConfig.Currency.EbCurSellRate, Y.CCY.MKT.POS2>
    END
RETURN

*** <region name= GET.LOC.REF.POS>
GET.LOC.REF.POS:
*** <desc>GET.LOC.REF.POS </desc>
    Y.JOB.NO.POS=''
    EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.TF.JOB.NUMBR",Y.JOB.NO.POS)
RETURN
*** </region>

END

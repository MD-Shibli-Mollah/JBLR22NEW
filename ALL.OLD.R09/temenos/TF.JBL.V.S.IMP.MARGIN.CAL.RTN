SUBROUTINE TF.JBL.V.S.IMP.MARGIN.CAL.RTN
*-----------------------------------------------------------------------------
*Subroutine Description: Calculate Margin Amount from Doc amount and exchange Rate
*Subroutine Type:
*Attached To    : LETTER.OF.CREDIT Version (LETTER.OF.CREDIT,JBL.IMPSIGH)
*Attached As    : VALIDATION ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 22/10/2019 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING LC.Contract
    $USING LC.Config
    $USING ST.CurrencyConfig
    $INSERT I_GTS.COMMON
    $USING EB.API
    
    $USING EB.DataAccess
    $USING EB.LocalReferences
    $USING EB.Display
    $USING ST.Config
    $USING EB.Updates
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
    FN.LC = 'F.LETTER.OF.CREDIT'
    F.LC = ''
    R.LC.REC = ''
    Y.LC.ERR = ''

    FN.CUR = 'F.CURRENCY'
    F.CUR = ''
    R.CUR.REC = ''
    Y.CUR.ERR = ''
    
    Y.LC.CURRENCY = ''
    Y.LC.AMOUNT = ''
    Y.CCY.MARKET = ''
    Y.LC.CCY.MKT = ''
    Y.EXCHANGE.RATE = ''
    Y.PROV.PERC = ''
    Y.PROV.AMT = ''
    Y.PROV.AMT.LCY = ''
    
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.LC,F.LC)
    EB.DataAccess.Opf(FN.CUR,F.CUR)
    EB.LocalReferences.GetLocRef('LETTER.OF.CREDIT','LT.TF.LC.MGN.RT',Y.LC.MARGRATE.POS)
    EB.LocalReferences.GetLocRef('LETTER.OF.CREDIT','LT.TF.LC.DOCAMT',Y.LC.DOC.AMT.POS)
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.PROV.PERC = EB.SystemTables.getComi()
    IF EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcProvision)[1,1] EQ 'Y' THEN
        Y.LC.CURRENCY = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLcCurrency)
        Y.LC.AMOUNT = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLcAmount)
        IF Y.LC.CURRENCY NE EB.SystemTables.getLccy() THEN
            EB.DataAccess.FRead(FN.CUR,Y.LC.CURRENCY,R.CUR.REC,F.CUR,Y.CUR.ERR)
            Y.CCY.MARKET = R.CUR.REC<ST.CurrencyConfig.Currency.EbCurCurrencyMarket>
            Y.LC.CCY.MKT = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcCurrencyMarket)

            IF NOT(Y.LC.CCY.MKT) THEN
                Y.LC.CCY.MKT = 3
            END

            LOCATE Y.LC.CCY.MKT IN Y.CCY.MARKET<1,1> SETTING POS1 THEN
                Y.EXCHANGE.RATE = R.CUR.REC<ST.CurrencyConfig.Currency.EbCurMidRevalRate,POS1>
            END
        END ELSE
            Y.EXCHANGE.RATE = 1
        END
        IF Y.PROV.PERC NE '' THEN
            Y.PROV.AMT = (Y.LC.AMOUNT * Y.PROV.PERC)/100

            Y.DOC.AMOUNT = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.LC.DOC.AMT.POS>
            IF Y.DOC.AMOUNT THEN
                Y.PROV.AMT = (Y.DOC.AMOUNT * Y.PROV.PERC)/100
            END
            
            Y.PROV.AMT.LCY = Y.PROV.AMT * Y.EXCHANGE.RATE
            
            EB.API.RoundAmount(EB.SystemTables.getLccy(),Y.PROV.AMT.LCY,'','')
            EB.SystemTables.setRNew(LC.Contract.LetterOfCredit.TfLcProvisAmount, Y.PROV.AMT.LCY)
            EB.Display.RefreshField(EB.SystemTables.getAf(), "")
        END
    END
RETURN
*** </region>
END

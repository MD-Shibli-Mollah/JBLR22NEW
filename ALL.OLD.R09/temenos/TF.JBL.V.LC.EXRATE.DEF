SUBROUTINE TF.JBL.V.LC.EXRATE.DEF
*-----------------------------------------------------------------------------
*Subroutine Description: Exchange Rate Validation
*Subroutine Type:
*Attached To    : LETTER.OF.CREDIT Version (LETTER.OF.CREDIT,JBL.BTBRECORD)
*Attached As    : VALIDATION ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 06/11/2019 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING LC.Contract
    $USING ST.CurrencyConfig
    
    $USING EB.LocalReferences
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Display
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    Y.EXCHG.RATE=''
    FN.CCY = 'F.CURRENCY'
    F.CCY = ''
    
    EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.TF.EXCH.RATE",XE.POS)
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.CCY,F.CCY)
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.LC.CCY = EB.SystemTables.getComi()

    IF EB.SystemTables.getAf() EQ LC.Contract.LetterOfCredit.TfLcLcCurrency AND EB.SystemTables.getComi() NE '' THEN
        EB.DataAccess.FRead(FN.CCY,Y.LC.CCY,R.CCY,F.CCY,CCY.ERR)
        Y.EXCHG.RATE = R.CCY<ST.CurrencyConfig.Currency.EbCurMidRevalRate,1>
        
        IF (Y.EXCHG.RATE) THEN
*CALL GET.LOC.REF("LETTER.OF.CREDIT","EXCHANGE.RATE",XE.POS)
            Y.TEMP = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)
            Y.TEMP<1,XE.POS> = Y.EXCHG.RATE
            EB.SystemTables.setRNew(LC.Contract.LetterOfCredit.TfLcLocalRef, Y.TEMP)
        END ELSE
            Y.EXCHG.RATE="1.00"
            Y.TEMP = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)
            Y.TEMP<1,XE.POS>=Y.EXCHG.RATE
            EB.SystemTables.setRNew(LC.Contract.LetterOfCredit.TfLcLocalRef, Y.TEMP)
            
          
            Y.EXCHANGE.RATE=EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,XE.POS>
*EB.Display.RefreshField((LC.Contract.LetterOfCredit.TfLcLocalRef,<1,XE.POS>),"")
            EB.Display.RefreshField(Y.EXCHANGE.RATE,"")           
            EB.Display.RebuildScreen()
        END 
    END
RETURN 
*** </region> 
END

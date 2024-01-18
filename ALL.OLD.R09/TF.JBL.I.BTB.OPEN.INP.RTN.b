SUBROUTINE TF.JBL.I.BTB.OPEN.INP.RTN
*-----------------------------------------------------------------------------
*Subroutine Description: BTB open data validation
*Subroutine Type:
*Attached To    : LETTER.OF.CREDIT Version (LETTER.OF.CREDIT,JBL.BTBSIGHT   , LETTER.OF.CREDIT,JBL.BTBUSANCE , LETTER.OF.CREDIT,JBL.EDFOPEN)
*Attached As    : INPUT ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 06/11/2019 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* Modification History :
* 07/07/2020 -                            Modify   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING LC.Contract
    $INSERT I_F.BD.BTB.JOB.REGISTER
    
     
    $USING EB.DataAccess
    $USING EB.LocalReferences
    $USING EB.ErrorProcessing
    $USING EB.Updates
    $USING EB.SystemTables
    $USING ST.CurrencyConfig
*-----------------------------------------------------------------------------
    IF EB.SystemTables.getVFunction() EQ 'I' AND (EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcOperation) EQ "O" OR EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcOperation) EQ "A") THEN
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
    
    FN.CCY = "F.CURRENCY"
    F.CCY = ""
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.BD.BTB.JOB.REGISTER,F.BD.BTB.JOB.REGISTER)
    EB.DataAccess.Opf(FN.CCY,F.CCY)
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    GOSUB GET.LOC.REF.POS
    Y.JOB.NO = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.JOB.NUMBER.POS>

    EB.DataAccess.FRead(FN.BD.BTB.JOB.REGISTER,Y.JOB.NO,R.BTB.JOB.REGISTER,F.BD.BTB.JOB.REGISTER,Y.BTB.JOB.REG.ERR)
    IF R.BTB.JOB.REGISTER THEN
        Y.JOB.ENT.AMT = R.BTB.JOB.REGISTER<BTB.JOB.TOT.BTB.AVL.AMT>
        Y.JOB.CCY = R.BTB.JOB.REGISTER<BTB.JOB.JOB.CURRENCY>

        IF EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLcCurrency) NE R.BTB.JOB.REGISTER<BTB.JOB.JOB.CURRENCY> THEN
        
***************************** M1 Start **************************************************************************
            Y.LC.CCY = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLcCurrency)
        
        
            EB.DataAccess.FRead(FN.CCY,Y.LC.CCY,R.LC.CCY,F.CCY, LC.CCY.ERR)
            Y.CCY.MKT = '3'
            FIND Y.CCY.MKT IN R.LC.CCY<ST.CurrencyConfig.Currency.EbCurCurrencyMarket> SETTING Y.CCY.MKT.POS1, Y.CCY.MKT.POS2, Y.CCY.MKT.POS3 THEN
                Y.LC.EXCHG.RATE = R.LC.CCY<ST.CurrencyConfig.Currency.EbCurMidRevalRate, Y.CCY.MKT.POS2>
            END

            EB.DataAccess.FRead(FN.CCY,Y.JOB.CCY,R.JOB.CCY,F.CCY,JOB.CCY.ERR)
            Y.CCY.MKT = '3'
            FIND Y.CCY.MKT IN R.JOB.CCY<ST.CurrencyConfig.Currency.EbCurCurrencyMarket> SETTING Y.CCY.MKT.POS1, Y.CCY.MKT.POS2, Y.CCY.MKT.POS3 THEN
                Y.JOB.EXCHG.RATE = R.JOB.CCY<ST.CurrencyConfig.Currency.EbCurMidRevalRate, Y.CCY.MKT.POS2>
            END

            Y.EXCHG.RATE = Y.LC.EXCHG.RATE / Y.JOB.EXCHG.RATE

            Y.TF.USED.ENTAMT = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLcAmount) * Y.EXCHG.RATE
            
            Y.TEMP = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)
            Y.TEMP<1,Y.USED.ENTAMT.POS> = DROUND(Y.TF.USED.ENTAMT,2)
            EB.SystemTables.setRNew(LC.Contract.LetterOfCredit.TfLcLocalRef, Y.TEMP)
***************************** M1 End **************************************************************************
*        Y.TF.USED.ENTAMT = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.USED.ENTAMT.POS>
            GOSUB CHECK.JOB.ENT.AMT
        END ELSE
            IF EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.USED.ENTAMT.POS> NE "" THEN
                EB.SystemTables.setAf(LC.Contract.LetterOfCredit.TfLcLocalRef)
                EB.SystemTables.setAv(Y.USED.ENTAMT.POS)
                EB.SystemTables.setEtext("Job Used Ent Amt Not Allow")
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END
            Y.TF.USED.ENTAMT = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLcAmount)
            GOSUB CHECK.JOB.ENT.AMT
        END


        IF EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcAdviceExpiryDate) GT R.BTB.JOB.REGISTER<BTB.JOB.JOB.EXPIRY.DATE> THEN
            EB.SystemTables.setAf(LC.Contract.LetterOfCredit.TfLcAdviceExpiryDate)
            EB.SystemTables.setEtext("BTB Expiry Date GT JOB Expiry Date")
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END
    END
RETURN
*** </region>

*** <region name= CHECK.JOB.ENT.AMT>
CHECK.JOB.ENT.AMT:
*** <desc>CHECK.JOB.ENT.AMT</desc>
    IF Y.TF.USED.ENTAMT GT Y.JOB.ENT.AMT THEN
        Y.DIFF = Y.TF.USED.ENTAMT - Y.JOB.ENT.AMT
        EB.SystemTables.setAf(LC.Contract.LetterOfCredit.TfLcLcAmount)
        EB.SystemTables.setEtext("BTB LC AMOUNT EXCEEDS BY JOB ENTITLEMENT AMOUNT: ":Y.JOB.CCY:" ":DROUND(Y.DIFF,2))
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END
RETURN
*** </region>

*** <region name= GET.LOC.REF.POS>
GET.LOC.REF.POS:
*** <desc>GET.LOC.REF.POS </desc>
    EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.TF.JOB.NUMBR",Y.JOB.NUMBER.POS)
    EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.TF.BTBUSE.EA",Y.USED.ENTAMT.POS)
RETURN
*** </region>


END

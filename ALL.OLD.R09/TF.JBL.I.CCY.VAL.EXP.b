SUBROUTINE TF.JBL.I.CCY.VAL.EXP
*-----------------------------------------------------------------------------
*Subroutine Description:
*Subroutine Type:
*Attached To    : LETTER.OF.CREDIT Version (LETTER.OF.CREDIT,JBL.IMPSIGH)
*Attached As    : INPUT ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 23/10/2019 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*10/20/2020
*Modifided line 78 to 86 for if we set Buyers Credit.Report as YES,
*Credit.Ref.No will be mandatory
*and if Credit.Ref.No found system will consider as credit report received.
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING LC.Contract
    $USING ST.CurrencyConfig
    $USING EB.ErrorProcessing
    $USING EB.DataAccess
    $USING EB.OverrideProcessing
    $USING EB.SystemTables
    $USING EB.Updates
    $USING EB.API
    $USING ST.Customer
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.CCY = 'F.CURRENCY'
    F.CCY = ''
    FN.CUS = 'F.CUSTOMER'
    F.CUS = ''

    APPLICATION.NAMES = 'LETTER.OF.CREDIT':FM:'CUSTOMER'
    LOCAL.FIELDS = 'LT.TF.EX.CRRPNO':VM:'LT.TF.EX.CR.REP':FM:'LT.CR.RP.ISS.DT':VM:'LT.CR.RP.REF'
    EB.Updates.MultiGetLocRef(APPLICATION.NAMES, LOCAL.FIELDS, FLD.POS)
    Y.LT.TF.EX.CRRPNO.POS = FLD.POS<1,1>
    Y.LT.TF.EX.CR.REP.POS = FLD.POS<1,2>
    Y.LT.CR.RP.ISS.DT.POS = FLD.POS<2,1>
    Y.LT.CR.RP.REF.POS = FLD.POS<2,2>
RETURN
*** </region>

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.CCY,F.CCY)
    EB.DataAccess.Opf(FN.CUS,F.CUS)

RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
*    Y.BENEFICIARY = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcBeneficiaryCustno)
    Y.APPLICANTE = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcApplicantCustno)
    Y.CCY = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLcCurrency)
    Y.AMOUNT = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLcAmount)
    
* Assign Customer Credit report reference to LC credit Report No field
    EB.DataAccess.FRead(FN.CUS,Y.APPLICANTE,R.CUS,F.CUS,Y.CUS.ERR)
    IF R.CUS THEN
        Y.LT.CR.RP.REF = R.CUS<ST.Customer.Customer.EbCusLocalRef><1,Y.LT.CR.RP.REF.POS>
    END
    IF Y.LT.CR.RP.REF THEN
        Y.LC.LOC.REF =  EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)
        Y.LC.LOC.REF<1,Y.LT.TF.EX.CRRPNO.POS> = Y.LT.CR.RP.REF
        Y.LC.LOC.REF<1,Y.LT.TF.EX.CR.REP.POS> = 'YES'
        EB.SystemTables.setRNew(LC.Contract.LetterOfCredit.TfLcLocalRef, Y.LC.LOC.REF)
    END ELSE
        Y.LC.LOC.REF =  EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)
        Y.CRRPNO.CK = Y.LC.LOC.REF<1,Y.LT.TF.EX.CR.REP.POS>
        Y.CRRPNO.NO = Y.LC.LOC.REF<1,Y.LT.TF.EX.CRRPNO.POS>
        IF Y.CRRPNO.CK EQ 'YES' AND Y.CRRPNO.NO EQ '' THEN
            EB.SystemTables.setAf(LC.Contract.LetterOfCredit.TfLcLocalRef)
            EB.SystemTables.setAv(Y.LT.TF.EX.CRRPNO.POS)
            EB.SystemTables.setEtext('When Credit.Report is YES Credit.Ref.No is mandatory')
            EB.ErrorProcessing.StoreEndError()
        END
        IF Y.CRRPNO.CK NE 'YES' THEN
            Y.LC.LOC.REF<1,Y.LT.TF.EX.CRRPNO.POS> = ''
            Y.LC.LOC.REF<1,Y.LT.TF.EX.CR.REP.POS> = 'NO'
            EB.SystemTables.setRNew(LC.Contract.LetterOfCredit.TfLcLocalRef, Y.LC.LOC.REF)
        END
    END
    Y.CRRPNO = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.LT.TF.EX.CRRPNO.POS>

*if LC CCY is 'USD'
    IF Y.CCY EQ 'USD' AND Y.AMOUNT GT '10000' THEN
        IF Y.CRRPNO EQ '' THEN
            GOSUB TRIGGER.OVERRIDE
*           RETURN
        END
    END
    
*if LC CCY is 'BDT'
    Y.CONV.USD.AMT = ''
    IF Y.CCY EQ 'BDT' THEN
        Y.CCY = 'USD'
        GOSUB GET.SELL.RATE
        Y.CONV.USD.AMT = Y.AMOUNT/Y.SELL.RATE
        IF Y.CONV.USD.AMT GT '10000' AND Y.CRRPNO EQ '' THEN
            GOSUB TRIGGER.OVERRIDE
*            RETURN
        END
    END
    
*if LC CCY not 'BDT' and 'USD'
    Y.CONV.USD.AMT = ''
    IF Y.CCY NE 'BDT' AND Y.CCY NE 'USD' THEN
        GOSUB GET.SELL.RATE
        Y.LC.CCY.SELL.RATE = Y.SELL.RATE
        Y.CCY = 'USD'
        GOSUB GET.SELL.RATE
        Y.USD.CCY.SELL.RATE = Y.SELL.RATE
        Y.CONV.USD.AMT = (Y.LC.CCY.SELL.RATE / Y.USD.CCY.SELL.RATE) * Y.AMOUNT
        IF Y.CONV.USD.AMT GE '10000' AND Y.CRRPNO EQ '' THEN
            GOSUB TRIGGER.OVERRIDE
*            RETURN
        END
    END
    
*Credit Report Issue date cross more than one year
    IF R.CUS THEN
        Y.LT.CR.RP.ISS.DT = R.CUS<ST.Customer.Customer.EbCusLocalRef><1,Y.LT.CR.RP.ISS.DT.POS>
        Y.TODAY = EB.SystemTables.getToday()
        Y.NO.DAYS='C'
        IF Y.LT.CR.RP.ISS.DT EQ '' THEN
            Y.OVERRIDES = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcOverride)
            OVERRIDE.NO = DCOUNT(Y.OVERRIDES,VM)
            OVERRIDE.NO += 1
            EB.SystemTables.setText("Credit Report Issue Date is found Blank")
            EB.OverrideProcessing.StoreOverride(OVERRIDE.NO)
        END ELSE
            EB.API.Cdd('',Y.LT.CR.RP.ISS.DT,Y.TODAY,Y.NO.DAYS)
            IF Y.NO.DAYS GT '365' THEN
                Y.OVERRIDES = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcOverride)
                OVERRIDE.NO = DCOUNT(Y.OVERRIDES,VM)
                OVERRIDE.NO += 1
                EB.SystemTables.setText("Credit Report Expired")
                EB.OverrideProcessing.StoreOverride(OVERRIDE.NO)
            END
        END
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

*** <region name= TRIGGER.OVERRIDE>
TRIGGER.OVERRIDE:
*** <desc> TRIGGER OVERRIDE </desc>
    Y.OVERRIDES = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcOverride)
    OVERRIDE.NO = DCOUNT(Y.OVERRIDES,VM)
    OVERRIDE.NO += 1
    EB.SystemTables.setText("Credit Report for Importer/Exporter Required")
    EB.OverrideProcessing.StoreOverride(OVERRIDE.NO)
RETURN
*** </region>

END

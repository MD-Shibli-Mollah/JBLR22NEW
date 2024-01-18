SUBROUTINE TF.JBL.I.SALE.CON.CCY.VAL
*-----------------------------------------------------------------------------
*Attached To    : Sales Contact recording Version (BD.SCT.CAPTURE,CONT.RECORD)
*Attached As    : INPUT ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 11/05/2020 -                            Retrofit   - Mahmudur Rahman,
*                                                 FDS Bangladesh Limited
*Description:
*if we set Buyers Credit.Report as YES,
*Credit.Ref.No will be mandatory
*and if Credit.Ref.No found system will consider as credit report received.
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BD.SCT.CAPTURE
    
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
RETURN
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.CCY = 'F.CURRENCY'
    F.CCY  = ''
    FN.CUS = 'F.CUSTOMER'
    F.CUS  = ''

    APPLICATION.NAMES = 'CUSTOMER'
    LOCAL.FIELDS = 'LT.CR.RP.ISS.DT':VM:'LT.CR.RP.REF'
    EB.Updates.MultiGetLocRef(APPLICATION.NAMES, LOCAL.FIELDS, FLD.POS)
    Y.LT.CR.RP.ISS.DT.POS = FLD.POS<1,1>
    Y.LT.CR.RP.REF.POS = FLD.POS<1,2>
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
    Y.BUYER.ID = EB.SystemTables.getRNew(SCT.APPLICANT.CUSTNO)
    Y.CCY = EB.SystemTables.getRNew(SCT.CURRENCY)
    Y.AMOUNT = EB.SystemTables.getRNew(SCT.CONTRACT.AMT)
    
* Assign Customer Credit report reference to LC credit Report No field
    EB.DataAccess.FRead(FN.CUS,Y.BUYER.ID,R.CUS,F.CUS,Y.CUS.ERR)
    IF R.CUS EQ '' THEN RETURN
    Y.LT.CR.RP.REF = R.CUS<ST.Customer.Customer.EbCusLocalRef><1,Y.LT.CR.RP.REF.POS>
    IF Y.LT.CR.RP.REF THEN
        EB.SystemTables.setRNew(SCT.BUYER.CRD.REPORT, 'YES')
        EB.SystemTables.setRNew(SCT.CREDIT.REF.NO, Y.LT.CR.RP.REF)
    END ELSE
        Y.CRRPNO.CK = EB.SystemTables.getRNew(SCT.BUYER.CRD.REPORT)
        Y.CRRPNO.NO = EB.SystemTables.getRNew(SCT.CREDIT.REF.NO)
        IF Y.CRRPNO.CK EQ 'YES' AND Y.CRRPNO.NO EQ '' THEN
            EB.SystemTables.setAf(SCT.CREDIT.REF.NO)
            EB.SystemTables.setEtext('When Credit.Report is YES Credit.Ref.No is mandatory')
            EB.ErrorProcessing.StoreEndError()
        END
        IF Y.CRRPNO.CK NE 'YES' THEN
            EB.SystemTables.setRNew(SCT.BUYER.CRD.REPORT,'NO')
            EB.SystemTables.setRNew(SCT.CREDIT.REF.NO,'')
        END
    END
    Y.CRRPNO = EB.SystemTables.getRNew(SCT.CREDIT.REF.NO)

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
            Y.OVERRIDES = EB.SystemTables.getRNew(SCT.OVERRIDE)
            OVERRIDE.NO = DCOUNT(Y.OVERRIDES,VM)
            OVERRIDE.NO += 1
            EB.SystemTables.setText("Credit Report Issue Date is found Blank")
            EB.OverrideProcessing.StoreOverride(OVERRIDE.NO)
        END ELSE
            EB.API.Cdd('',Y.LT.CR.RP.ISS.DT,Y.TODAY,Y.NO.DAYS)
            IF Y.NO.DAYS GT '365' THEN
                Y.OVERRIDES = EB.SystemTables.getRNew(SCT.OVERRIDE)
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
    IF R.CCY THEN
        Y.CCY.MKT = '3'
        Y.SELL.RATE = ''
        FIND Y.CCY.MKT IN R.CCY<ST.CurrencyConfig.Currency.EbCurCurrencyMarket> SETTING Y.CCY.MKT.POS1, Y.CCY.MKT.POS2, Y.CCY.MKT.POS3 THEN
            Y.SELL.RATE = R.CCY<ST.CurrencyConfig.Currency.EbCurSellRate, Y.CCY.MKT.POS2>
        END ELSE
            EB.SystemTables.setE('Currency Market ':Y.CCY.MKT:' Missing')
            EB.ErrorProcessing.Err()
        END
    END
RETURN

*** <region name= TRIGGER.OVERRIDE>
TRIGGER.OVERRIDE:
*** <desc> TRIGGER OVERRIDE </desc>
    Y.OVERRIDES = EB.SystemTables.getRNew(SCT.OVERRIDE)
    OVERRIDE.NO = DCOUNT(Y.OVERRIDES,VM)
    OVERRIDE.NO += 1
    EB.SystemTables.setText("Credit Report for Importer/Exporter Required")
    EB.OverrideProcessing.StoreOverride(OVERRIDE.NO)
RETURN
*** </region>

END


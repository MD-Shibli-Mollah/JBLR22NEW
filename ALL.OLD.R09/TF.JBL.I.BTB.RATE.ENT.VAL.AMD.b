SUBROUTINE TF.JBL.I.BTB.RATE.ENT.VAL.AMD
*-----------------------------------------------------------------------------
*Subroutine Description:This Rtn calculates the LC Wise BTB & PC Entitlement Amount base on BTB & PC
*                       entitlement Rate is given
*Subroutine Type:
*Attached To    : LETTER.OF.CREDIT Version (LETTER.OF.CREDIT,BD.BTBRECORD.AMD)
*Attached As    : INPUT ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 06/11/2019 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING LC.Contract
    $USING ST.CompanyCreation
    $INSERT I_F.BD.BTB.JOB.REGISTER
    $USING EB.DataAccess
    $USING EB.Updates
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING EB.LocalReferences
    $USING ST.CurrencyConfig
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.LETTER.OF.CREDIT = "F.LETTER.OF.CREDIT"
    F.LETTER.OF.CREDIT = ""
    Y.LC.ERR = ''

    IF EB.SystemTables.getIdNew() EQ '' THEN
        Y.LC.ID = EB.SystemTables.getIdOld()
    END ELSE
        Y.LC.ID = EB.SystemTables.getIdNew()
    END

    FN.COM = 'F.COMPANY'
    F.COM = ''

    FN.CURR = 'F.CURRENCY'
    F.CURR = ''
    
    FN.BD.BTB.JOB.REGISTER = 'F.BD.BTB.JOB.REGISTER'
    F.BD.BTB.JOB.REGISTER = ''

    Y.FREIGHT.CHRG = ''
    Y.FOREIGN.CHRG = ''
    Y.LOC.AGT.COMM = ''
    Y.INSURANC.COMM = ''
    Y.TOT.CHRG = 0
    Y.LC.OUTSTAND.AMT = ''
    Y.FOB.VALUE = ''
    
    Y.CCY.MKT = '1'
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.LETTER.OF.CREDIT,F.LETTER.OF.CREDIT)
    EB.DataAccess.Opf(FN.COM,F.COM)
    EB.DataAccess.Opf(FN.BD.BTB.JOB.REGISTER,F.BD.BTB.JOB.REGISTER)
    EB.DataAccess.Opf(FN.CURR,F.CURR)
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    GOSUB GET.LOC.REF
    Y.TEMPB = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)
    Y.NEW.EXIST = Y.TEMPB<1,Y.NEW.EXIST.POS>
    Y.JOB.NO = Y.TEMPB<1,Y.JOB.NO.POS>
    Y.JOB.CCY =  Y.TEMPB<1,Y.JOB.CUR.POS>
    Y.LC.CCY = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLcCurrency)
    
    EB.DataAccess.FRead(FN.BD.BTB.JOB.REGISTER,Y.JOB.NO,R.BTB.JOB.REGISTER,F.BD.BTB.JOB.REGISTER,R.BTB.JOB.REG.ERR)
    
    IF Y.JOB.NO EQ "" THEN
        EB.SystemTables.setAf(LC.Contract.LetterOfCredit.TfLcLocalRef)
        EB.SystemTables.setAv(Y.JOB.NO.POS)
        EB.SystemTables.setEtext("JOB NUMBER MISSING")
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END
    IF R.BTB.JOB.REG.ERR THEN
        EB.SystemTables.setAf(LC.Contract.LetterOfCredit.TfLcLocalRef)
        EB.SystemTables.setAv(Y.JOB.NO.POS)
        EB.SystemTables.setEtext("JOB NUMBER DOES NOT EXIST")
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END
    GOSUB PROCESS.EXIST.RECORD
RETURN
*** </region>

*** <region name= PROCESS.EXIST.RECORD>
PROCESS.EXIST.RECORD:
*** <desc>PROCESS.EXIST.RECORD </desc>
    GOSUB PROCESS.ENT.CALC
    Y.OLD.FOB.VALUE = EB.SystemTables.getROld(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.FOB.POS>
    Y.NEW.FOB.VALUE = Y.FOB.VALUE
    Y.TEMP = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)
    Y.TEMP<1,Y.FOB.POS> = Y.NEW.FOB.VALUE
    EB.SystemTables.setRNew(LC.Contract.LetterOfCredit.TfLcLocalRef, Y.TEMP)
*    IF Y.NEW.FOB.VALUE LT Y.OLD.FOB.VALUE THEN
*        EB.SystemTables.setAf(LC.Contract.LetterOfCredit.TfLcLocalRef)
*        EB.SystemTables.setAv(Y.FOB.POS)
*        EB.SystemTables.setEtext("FOB Value Decrease NOT Allow")
*        EB.ErrorProcessing.StoreEndError()
*        RETURN
*    END
*    Y.OLD.BTB.ENT.RATE = EB.SystemTables.getROld(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.BTB.RATE.POS>
*    Y.OLD.PC.ENT.RATE = EB.SystemTables.getROld(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.PC.RATE.POS>
*    Y.NEW.BTB.ENT.RATE = Y.BTB.RATE
*    Y.NEW.PC.ENT.RATE = Y.PC.RATE
*    Y.OLD.BTB.ENT.VALUE = EB.SystemTables.getROld(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.BTB.ENT.POS>
*    Y.OLD.PC.ENT.VALUE = EB.SystemTables.getROld(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.PC.ENT.POS>

*    IF Y.NEW.BTB.ENT.RATE LT Y.OLD.BTB.ENT.RATE THEN
*        EB.SystemTables.setAf(LC.Contract.LetterOfCredit.TfLcLocalRef)
*        EB.SystemTables.setAv(Y.BTB.RATE.POS)
*        EB.SystemTables.setE( "BTB Entitlement Rate Decrease NOT Allow")
*        EB.ErrorProcessing.StoreEndError()
*        RETURN
*    END
*    IF Y.NEW.PC.ENT.RATE LT Y.OLD.PC.ENT.RATE THEN
*        EB.SystemTables.setAf(LC.Contract.LetterOfCredit.TfLcLocalRef)
*        EB.SystemTables.setAv(Y.PC.RATE.POS)
*        EB.SystemTables.setEtext("PC/ECC Entitlement Rate Decrease NOT Allow")
*        EB.ErrorProcessing.StoreEndError()
*        RETURN
*    END
    IF Y.TOT.ENT.PERC GE 100 THEN
        EB.SystemTables.setE( "Total Entitlement percentage should not be GE 100")
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END ELSE
*****************************************Modification by erian@fortress-global.com*******DATE:20201010*****************
        Y.JOB.EXC.RATE = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.JOB.EXC.RATE.POS>
        
        IF Y.LC.CCY EQ "" THEN
            EB.SystemTables.setAf(LC.Contract.LetterOfCredit.TfLcLcCurrency)
            EB.SystemTables.setEtext("Currency not set")
            EB.ErrorProcessing.StoreEndError()
        END
        IF Y.JOB.CCY EQ "" THEN
            EB.SystemTables.setAf(LC.Contract.LetterOfCredit.TfLcLocalRef)
            EB.SystemTables.setAv(Y.JOB.CUR.POS)
            EB.SystemTables.setEtext("Currency not set")
            EB.ErrorProcessing.StoreEndError()
        END
        
        IF Y.LC.CCY EQ 'BDT' THEN Y.LC.EXCHANGE.RATE = 1 ELSE
            EB.DataAccess.FRead(FN.CURR,Y.LC.CCY,R.LC.CCY.REC,F.CURR,Y.LC.CCY.ERR)
            Y.LC.CCY.MARKET = R.LC.CCY.REC<ST.CurrencyConfig.Currency.EbCurCurrencyMarket>
            Y.LC.MID.REVAL.RATE = R.LC.CCY.REC<ST.CurrencyConfig.Currency.EbCurMidRevalRate>
            IF R.LC.CCY.REC THEN
                LOCATE Y.CCY.MKT IN Y.LC.CCY.MARKET<1,1> SETTING Y.CCY.POS THEN
                    Y.LC.EXCHANGE.RATE = Y.LC.MID.REVAL.RATE<1,Y.CCY.POS>
                END
            END
        END
        IF Y.JOB.CCY EQ 'BDT' THEN Y.JOB.EXCHANGE.RATE = 1 ELSE
            EB.DataAccess.FRead(FN.CURR,Y.JOB.CCY,R.JOB.CCY.REC,F.CURR,Y.JOB.CCY.ERR)
            Y.JOB.CCY.MARKET = R.JOB.CCY.REC<ST.CurrencyConfig.Currency.EbCurCurrencyMarket>
            Y.JOB.MID.REVAL.RATE = R.JOB.CCY.REC<ST.CurrencyConfig.Currency.EbCurMidRevalRate>
            IF R.JOB.CCY.REC THEN
                LOCATE Y.CCY.MKT IN Y.JOB.CCY.MARKET<1,1> SETTING Y.CCY.POS THEN
                    Y.JOB.EXCHANGE.RATE = Y.JOB.MID.REVAL.RATE<1,Y.CCY.POS>
                END
            END
        END
        IF Y.LC.EXCHANGE.RATE EQ "" OR Y.LC.EXCHANGE.RATE EQ "0" OR Y.JOB.EXCHANGE.RATE EQ "0" OR Y.JOB.EXCHANGE.RATE EQ "" THEN
            EB.SystemTables.setEtext("Currency Rate missing. Please update currency market")
            EB.ErrorProcessing.StoreEndError()
        END
        Y.JOB.EXC.RATE = DROUND((Y.LC.EXCHANGE.RATE / Y.JOB.EXCHANGE.RATE),4)
        
        Y.BTB.ENT.VALUE = (Y.FOB.VALUE * Y.BTB.RATE * Y.JOB.EXC.RATE)/100
        Y.PC.ENT.VALUE = (Y.FOB.VALUE * Y.PC.RATE * Y.JOB.EXC.RATE)/100
************************END*****************Modification by erian@fortress-global.com*******DATE:20201010*****************
*        Y.BTB.ENT.VALUE = (Y.FOB.VALUE * Y.BTB.RATE)/100
*        Y.PC.ENT.VALUE = (Y.FOB.VALUE * Y.PC.RATE)/100
*******************************************************************************************************************
        Y.TOT.JOB.VALUE = Y.BTB.ENT.VALUE + Y.PC.ENT.VALUE
        Y.TEMP = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)
        Y.TEMP<1,Y.JOB.EXC.RATE.POS> = DROUND(Y.JOB.EXC.RATE,4)
        Y.TEMP<1,Y.FOB.POS> = DROUND(Y.FOB.VALUE,2)
        Y.TEMP<1,Y.BTB.ENT.POS> = DROUND(Y.BTB.ENT.VALUE,2)
        Y.TEMP<1,Y.PC.ENT.POS> = DROUND(Y.PC.ENT.VALUE,2)
        Y.TEMP<1,Y.TOT.JOB.POS> = DROUND(Y.TOT.JOB.VALUE,2)
        EB.SystemTables.setRNew(LC.Contract.LetterOfCredit.TfLcLocalRef, Y.TEMP)
    END
    
*Added by Huraira
*if ELC Amendment BTB Entitlement Less than Used JOB BTB Entitlement then show Error message
    Y.TEMPA = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)
********************** erian@fortress-global.com*********20201021******************
*    IF Y.JOB.CCY NE Y.LC.CCY THEN
*        Y.ELC.BTB.ENT.VALUE = Y.BTB.ENT.VALUE * Y.TEMPA<1,Y.JOB.EXC.RATE.POS>
*    END ELSE
*    Y.ELC.BTB.ENT.VALUE = Y.BTB.ENT.VALUE
*    END
    
    
*********************
*    Y.TOT.BTB.JOB.ENT.AMT = R.BTB.JOB.REGISTER<BTB.JOB.TOT.BTB.ENT.AMT>
*    WRITE.FILE.VAR = "Y.JOB.NO.POS: ":Y.JOB.NO.POS
*    GOSUB FILE.WRITE
*    WRITE.FILE.VAR = "Y.JOB.NO: ":Y.JOB.NO
*    GOSUB FILE.WRITE
*    WRITE.FILE.VAR = "R.BTB.JOB.REGISTER: ":R.BTB.JOB.REGISTER
*    GOSUB FILE.WRITE
*    WRITE.FILE.VAR = "Y.BTB.ENT.VALUE: ":Y.BTB.ENT.VALUE
*    GOSUB FILE.WRITE
*    WRITE.FILE.VAR = "Y.JOB.EXC.RATE.POS: ":Y.JOB.EXC.RATE.POS
*    GOSUB FILE.WRITE
*    WRITE.FILE.VAR = "Y.TEMPA: ":Y.TEMPA
*    GOSUB FILE.WRITE
*    WRITE.FILE.VAR = "Y.ELC.BTB.ENT.VALUE: ":Y.ELC.BTB.ENT.VALUE
*    GOSUB FILE.WRITE
*    WRITE.FILE.VAR = "Y.TOT.BTB.JOB.USE.AMT: ":Y.TOT.BTB.JOB.USE.AMT
*    GOSUB FILE.WRITE
*    WRITE.FILE.VAR = "Y.TOT.BTB.JOB.ENT.AMT: ":Y.TOT.BTB.JOB.ENT.AMT
*    GOSUB FILE.WRITE
********************
    Y.EX.TF.REF = R.BTB.JOB.REGISTER<BTB.JOB.EX.TF.REF>
    Y.COUNT.POS = '0'
    LOOP
        REMOVE Y.LC.POS FROM Y.EX.TF.REF SETTING POS
    WHILE Y.LC.POS: POS
        Y.COUNT.POS++
        IF Y.LC.ID EQ Y.LC.POS THEN BREAK
    REPEAT

    Y.EXP.BTB.ENT.AMT = R.BTB.JOB.REGISTER<BTB.JOB.EX.BTB.ENT.AMT,Y.COUNT.POS>
    Y.TOT.BTB.ENT.AMT = R.BTB.JOB.REGISTER<BTB.JOB.TOT.BTB.ENT.AMT>
    Y.TOT.BTB.JOB.USE.AMT = R.BTB.JOB.REGISTER<BTB.JOB.TOT.BTB.AMT>
    Y.ELC.BTB.ENT.VALUE = Y.TOT.BTB.ENT.AMT - Y.EXP.BTB.ENT.AMT + Y.BTB.ENT.VALUE
    IF Y.ELC.BTB.ENT.VALUE LT Y.TOT.BTB.JOB.USE.AMT THEN
        EB.SystemTables.setAf(LC.Contract.LetterOfCredit.TfLcLocalRef)
        EB.SystemTables.setAv(Y.BTB.ENT.POS)
        EB.SystemTables.setEtext("New BTB entitlement amount falls below the BTB used amount")
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END
*if ELC PC Entitlement Less than Used JOB PC Entitlement then show Error message
  
*    IF Y.JOB.CCY NE Y.LC.CCY THEN
*        Y.ELC.PC.ENT.VALUE = Y.PC.ENT.VALUE * Y.TEMPA<1,Y.JOB.EXC.RATE.POS>
*    END ELSE
*        Y.ELC.PC.ENT.VALUE = Y.PC.ENT.VALUE
*    END
    
    Y.EXP.PC.ENT.AMT = R.BTB.JOB.REGISTER<BTB.JOB.EX.PC.ENT.AMT,Y.COUNT.POS>
    Y.TOT.PC.ENT.AMT = R.BTB.JOB.REGISTER<BTB.JOB.TOT.PC.ENT.AMT>
    Y.TOT.PC.JOB.USE.AMT = R.BTB.JOB.REGISTER<BTB.JOB.TOT.PC.AMT>
    Y.ELC.PC.ENT.VALUE = Y.TOT.PC.ENT.AMT - Y.EXP.PC.ENT.AMT + Y.PC.ENT.VALUE
    IF Y.ELC.PC.ENT.VALUE LT Y.TOT.PC.JOB.USE.AMT THEN
        EB.SystemTables.setAf(LC.Contract.LetterOfCredit.TfLcLocalRef)
        EB.SystemTables.setAv(Y.PC.ENT.POS)
        EB.SystemTables.setEtext("New PC entitlement amount falls below the PC used amount")
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END
*****end***************** erian@fortress-global.com*********20201021******************
*end

RETURN
*** </region>

*** <region name= PROCESS.ENT.CALC>
PROCESS.ENT.CALC:
*** <desc>PROCESS.ENT.CALC </desc>
    Y.FREIGHT.CHRG = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.CHRG.POS>
    Y.FOREIGN.CHRG = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.FC.POS>
    Y.LOC.AGT.COMM = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.LOC.AGT.POS>
    Y.INSURANC.COMM = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.INS.COM.POS>
    Y.TOT.CHRG = Y.FREIGHT.CHRG + Y.FOREIGN.CHRG + Y.LOC.AGT.COMM + Y.INSURANC.COMM
    Y.LC.OUTSTAND.AMT = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.LCAMT.OUTSTAND.POS>
*    IF EB.SystemTables.getRNew(TF.LC.LC.AMOUNT) GT EB.SystemTables.getROld(TF.LC.LC.AMOUNT) THEN
    Y.INC.LC.AMT = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLcAmount) - EB.SystemTables.getROld(LC.Contract.LetterOfCredit.TfLcLcAmount)
*    END

*Change by Huraira
*    IF Y.LC.OUTSTAND.AMT THEN
*        Y.FOB.VALUE = (Y.LC.OUTSTAND.AMT + Y.INC.LC.AMT) - Y.TOT.CHRG
*    END ELSE
*        Y.FOB.VALUE = EB.SystemTables.getRNew(TF.LC.LC.AMOUNT) - Y.TOT.CHRG
*    END
    Y.FOB.VALUE = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLcAmount) - Y.TOT.CHRG
****end
    
    Y.BTB.RATE = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.BTB.RATE.POS>
    Y.PC.RATE = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.PC.RATE.POS>
    Y.TOT.ENT.PERC = Y.BTB.RATE + Y.PC.RATE
    
RETURN
*** </region>


*** <region name= GET.LOC.REF>
GET.LOC.REF:
*** <desc>GET.LOC.REF </desc>
    EB.DataAccess.FRead(FN.COM,EB.SystemTables.getIdCompany(),R.COM.REC,F.COM,Y.COM.ERR)
    EB.DataAccess.FRead(FN.LETTER.OF.CREDIT,Y.LC.ID,R.LETTER.OF.CREDIT,F.LETTER.OF.CREDIT,Y.LC.ERR)

    EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.TF.JOB.NUMBR",Y.JOB.NO.POS)
    EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.TF.NW.EX.JOB",Y.NEW.EXIST.POS)
    EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.TF.JOB.ENCUR",Y.JOB.CUR.POS)
    EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.TF.JOB.EX.RT",Y.JOB.EXC.RATE.POS)
    EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.TF.INS.AGCOM",Y.INS.COM.POS)
    EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.TF.LAGENTCOM",Y.LOC.AGT.POS)
    EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.TF.FORGN.CHG",Y.FC.POS)
    EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.TF.FRGHT.CHG",Y.CHRG.POS)
    EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.TF.NET.FOBVL",Y.FOB.POS)
    EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.TF.BTB.ENTRT",Y.BTB.RATE.POS)
    EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.TF.PC.ENT.RT",Y.PC.RATE.POS)
    EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.TF.BTB.ENTAM",Y.BTB.ENT.POS)
    EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.TF.PC.ENT.AM",Y.PC.ENT.POS)
    EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.TF.TOT.ENTAM",Y.TOT.JOB.POS)
    EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.TF.LC.OUSAMT",Y.LCAMT.OUTSTAND.POS)
RETURN
*** </region>

*FILE.WRITE:
*    Y.LOG.FILE='ELC.AMEND.TextFile.txt'
*    Y.FILE.ELC ='./DFE.TEST'
*    OPENSEQ Y.FILE.ELC,Y.LOG.FILE TO FILE.ELC ELSE NULL
*    WRITESEQ WRITE.FILE.VAR APPEND TO FILE.ELC ELSE NULL
*    CLOSESEQ FILE.ELC
*RETURN

END

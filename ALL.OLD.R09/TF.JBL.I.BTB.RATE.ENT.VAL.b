SUBROUTINE TF.JBL.I.BTB.RATE.ENT.VAL
*-----------------------------------------------------------------------------
*Subroutine Description:This Rtn calculates the LC Wise BTB & PC Entitlement Amount base on BTB & PC
*                       entitlement Rate is given
*Subroutine Type:
*Attached To    : LETTER.OF.CREDIT Version (LETTER.OF.CREDIT,JBL.BTBRECORD)
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
    $INSERT I_F.BD.LC.AD.CODE

    $USING EB.LocalReferences
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING ST.CurrencyConfig
    $USING EB.Updates
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

    Y.CCY.MKT = '1'

    FN.COM = 'F.COMPANY'
    F.COM = ''

    FN.BD.BTB.JOB.REGISTER = 'F.BD.BTB.JOB.REGISTER'
    F.BD.BTB.JOB.REGISTER = ''

    FN.BD.LC.AD.CODE= 'F.BD.LC.AD.CODE'
    F.BD.LC.AD.CODE = ''
    
    FN.CURR = 'F.CURRENCY'
    F.CURR = ''
    
    Y.APPL= "LETTER.OF.CREDIT"
    Y.FIELDS = "LT.TF.JOB.NUMBR":VM:"LT.TF.NW.EX.JOB":VM:"LT.TF.JOB.ENCUR":VM:"LT.TF.JOB.EX.RT":VM:"LT.TF.INS.AGCOM":VM:"LT.TF.LAGENTCOM":VM:"LT.TF.FORGN.CHG":VM:"LT.TF.FRGHT.CHG":VM:"LT.TF.NET.FOBVL":VM:"LT.TF.BTB.ENTRT":VM:"LT.TF.PC.ENT.RT":VM:"LT.TF.BTB.ENTAM":VM:"LT.TF.PC.ENT.AM":VM:"LT.TF.TOT.ENTAM":VM:"LT.TF.INCOTERM":VM:"LT.TF.LC.OUSAMT"
    Y.LC.POS = ""
    EB.Updates.MultiGetLocRef(Y.APPL, Y.FIELDS, Y.LC.POS)
    Y.JOB.NO.POS = Y.LC.POS<1,1>
    Y.NEW.EXIST.POS = Y.LC.POS<1,2>
    Y.JOB.CUR.POS = Y.LC.POS<1,3>
    Y.JOB.EXC.RATE.POS = Y.LC.POS<1,4>
    Y.INS.COM.POS = Y.LC.POS<1,5>
    Y.LOC.AGT.POS = Y.LC.POS<1,6>
    Y.FC.POS = Y.LC.POS<1,7>
    Y.CHRG.POS = Y.LC.POS<1,8>
    Y.FOB.POS = Y.LC.POS<1,9>
    Y.BTB.RATE.POS = Y.LC.POS<1,10>
    Y.PC.RATE.POS = Y.LC.POS<1,11>
    Y.BTB.ENT.POS = Y.LC.POS<1,12>
    Y.PC.ENT.POS = Y.LC.POS<1,13>
    Y.TOT.JOB.POS = Y.LC.POS<1,14>
    Y.SALTERM.POS = Y.LC.POS<1,15>
    Y.LCAMT.OUTSTAND.POS = Y.LC.POS<1,16>
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.LETTER.OF.CREDIT,F.LETTER.OF.CREDIT)
    EB.DataAccess.Opf(FN.COM,F.COM)
    EB.DataAccess.Opf(FN.BD.BTB.JOB.REGISTER,F.BD.BTB.JOB.REGISTER)
    EB.DataAccess.Opf(FN.BD.LC.AD.CODE,F.BD.LC.AD.CODE)
    EB.DataAccess.Opf(FN.CURR,F.CURR)
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    EB.DataAccess.FRead(FN.COM,EB.SystemTables.getIdCompany(),R.COM.REC,F.COM,Y.COM.ERR)
    EB.DataAccess.FRead(FN.LETTER.OF.CREDIT,Y.LC.ID,R.LEETER.OF.CREDIT,F.LETTER.OF.CREDIT,Y.LC.ERR)
    
    Y.NEW.EXIST = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.NEW.EXIST.POS>
    Y.JOB.NO = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.JOB.NO.POS>
    EB.DataAccess.FRead(FN.BD.BTB.JOB.REGISTER,Y.JOB.NO,R.BTB.JOB.REGISTER,F.BD.BTB.JOB.REGISTER,R.BTB.JOB.REG.ERR)
    Y.JOB.REG.CCY = R.BTB.JOB.REGISTER<BTB.JOB.JOB.CURRENCY>
*****************************************Modification by erian@fortress-global.com*******DATE:20200917*****************
    Y.LC.CCY = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLcCurrency)
    Y.JOB.CCY = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.JOB.CUR.POS>
    Y.JOB.EXC.RATE = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.JOB.EXC.RATE.POS>
    
*    IF Y.JOB.CCY NE Y.LC.CCY AND Y.JOB.EXC.RATE EQ '' THEN
*        EB.SystemTables.setAf(LC.Contract.LetterOfCredit.TfLcLocalRef)
*        EB.SystemTables.setAv(Y.JOB.EXC.RATE.POS)
*        EB.SystemTables.setEtext("Should not be Null")
*        EB.ErrorProcessing.StoreEndError()
*        RETURN
*    END
*    IF Y.JOB.CCY EQ Y.LC.CCY AND Y.JOB.EXC.RATE NE '' THEN
*        EB.SystemTables.setAf(LC.Contract.LetterOfCredit.TfLcLocalRef)
*        EB.SystemTables.setAv(Y.JOB.EXC.RATE.POS)
*        EB.SystemTables.setEtext("Should not Allow Any Value")
*        EB.ErrorProcessing.StoreEndError()
*        RETURN
*    END
*********************************************************************************************************************

    EB.DataAccess.FRead(FN.BD.LC.AD.CODE,EB.SystemTables.getIdCompany(),R.BD.LC.AD.CODE,F.BD.LC.AD.CODE,BD.LC.AD.CODE.ERR)
    IF BD.LC.AD.CODE.ERR THEN
        EB.SystemTables.setEtext("AD CODE DOES NOT EXIST FOR THIS COMPANY")
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END

    BEGIN CASE
        CASE Y.NEW.EXIST EQ "NEW"
            IF Y.JOB.NO EQ '' THEN
                GOSUB PROCESS.NEW.RECORD
            END ELSE
                EB.SystemTables.setEtext("For New Recording JOB Number Should Not Exist")
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END
        CASE Y.NEW.EXIST = "EXIST"
            IF Y.JOB.NO EQ "" THEN
                EB.SystemTables.setAf(LC.Contract.LetterOfCredit.TfLcLocalRef)
                EB.SystemTables.setAv(Y.JOB.NO.POS)
                EB.SystemTables.setEtext("JOB NUMBER MISSING" )
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
*****************************************Modification by erian@fortress-global.com*******DATE:20200917*****************
            IF Y.JOB.REG.CCY NE Y.JOB.CCY THEN
                EB.SystemTables.setAf(LC.Contract.LetterOfCredit.TfLcLocalRef)
                EB.SystemTables.setAv(Y.JOB.CUR.POS)
                EB.SystemTables.setEtext("Job Currency Differ with existing")
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END
*******************************************************************************************************************
            GOSUB PROCESS.NEW.RECORD
    END CASE
RETURN
*** </region>


*** <region name= PROCESS.NEW.RECORD>
PROCESS.NEW.RECORD:
*** <desc>PROCESS.NEW.RECORD </desc>
    GOSUB PROCESS.ENT.CALC
    IF Y.TOT.ENT.PERC GE 100 THEN
        EB.SystemTables.setEtext("Total Entitlement percentage should not be GE 100")
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END ELSE
*****************************************Modification by erian@fortress-global.com*******DATE:20200917*****************
*****************************************Modification by erian@fortress-global.com*******DATE:20200929*****************
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
************************END*****************Modification by erian@fortress-global.com*******DATE:20200929*****************
*        Y.BTB.ENT.VALUE = (Y.FOB.VALUE * Y.BTB.RATE)/100
*        Y.PC.ENT.VALUE = (Y.FOB.VALUE * Y.PC.RATE)/100
*********************************END*********************Modification by erian@fortress-global.com*******DATE:20200917*************************************************************
        Y.TOT.JOB.VALUE = Y.BTB.ENT.VALUE + Y.PC.ENT.VALUE
        Y.TEMP = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)
        Y.TEMP<1,Y.JOB.EXC.RATE.POS> = DROUND(Y.JOB.EXC.RATE,4)
        Y.TEMP<1,Y.FOB.POS> = DROUND(Y.FOB.VALUE,2)
        Y.TEMP<1,Y.BTB.ENT.POS> = DROUND(Y.BTB.ENT.VALUE,2)
        Y.TEMP<1,Y.PC.ENT.POS> = DROUND(Y.PC.ENT.VALUE,2)
        Y.TEMP<1,Y.TOT.JOB.POS> = DROUND(Y.TOT.JOB.VALUE,2)
        EB.SystemTables.setRNew(LC.Contract.LetterOfCredit.TfLcLocalRef, Y.TEMP)
    END
RETURN
*** </region>


*** <region name= PROCESS.ENT.CALC>
PROCESS.ENT.CALC:
*** <desc>PROCESS.ENT.CALC </desc>

    Y.FREIGHT.CHRG = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.CHRG.POS>
    Y.FOREIGN.CHRG = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.FC.POS>
    Y.LOC.AGT.COMM = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.LOC.AGT.POS>
    Y.INSURANC.COMM = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.INS.COM.POS>
    GOSUB CHECK.INCO.TERMS
    Y.TOT.CHRG = Y.FREIGHT.CHRG + Y.FOREIGN.CHRG + Y.LOC.AGT.COMM + Y.INSURANC.COMM
    Y.LC.OUTSTAND.AMT = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.LCAMT.OUTSTAND.POS>
    
*****************************************************
    WRITE.FILE.VAR = "Y.LC.OUTSTAND.AMT: ": Y.LC.OUTSTAND.AMT
    GOSUB FILE.WRITE
*****************************************************

    IF Y.LC.OUTSTAND.AMT THEN
        Y.FOB.VALUE = Y.LC.OUTSTAND.AMT - Y.TOT.CHRG
        
*****************************************************
        WRITE.FILE.VAR = "Y.FOB.VALUE---: ": Y.FOB.VALUE
        GOSUB FILE.WRITE
*****************************************************

    END ELSE
        Y.FOB.VALUE = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLcAmount) - Y.TOT.CHRG
        
*****************************************************
        WRITE.FILE.VAR = "Y.FOB.VALUE+++: ": Y.FOB.VALUE
        GOSUB FILE.WRITE
*****************************************************

    END
    !Y.FOB.VALUE = EB.SystemTables.getRNew(TF.LC.LC.AMOUNT) - Y.TOT.CHRG
    Y.BTB.RATE = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.BTB.RATE.POS>
    Y.PC.RATE = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.PC.RATE.POS>
    Y.TOT.ENT.PERC = Y.BTB.RATE + Y.PC.RATE
RETURN
*** </region>


*** <region name= CHECK.INCO.TERMS>
CHECK.INCO.TERMS:
*** <desc>CHECK.INCO.TERMS </desc>
    Y.SALES.TERM = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.SALTERM.POS>
    IF Y.SALES.TERM EQ 'FOB' AND Y.FREIGHT.CHRG NE '' THEN
        EB.SystemTables.setAf(LC.Contract.LetterOfCredit.TfLcLocalRef)
        EB.SystemTables.setAv(Y.SALTERM.POS)
        EB.SystemTables.setEtext("IncoTerms FOB Not Allows Fregiht Charge")
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END
RETURN
*** </region>

************
FILE.WRITE:
************
*    Y.LOG.FILE='SCTTextFile.txt'
*    Y.FILE.SCT ='./DFE.TEST'
*    OPENSEQ Y.FILE.SCT,Y.LOG.FILE TO FILE.SCT ELSE NULL
*    WRITESEQ WRITE.FILE.VAR APPEND TO FILE.SCT ELSE NULL
*    CLOSESEQ FILE.SCT
RETURN

END

SUBROUTINE TF.JBL.A.GEN.JOB.NUMBER.AMD
*-----------------------------------------------------------------------------
*Subroutine Description:This is an AUTHORIZATION RTN used for generating Job Number if JOB.NEW.EXIST is "NEW". If JOB.NEW.EXIST
*                       is "Exist" then existing Job number will be updated accordingly.
*Subroutine Type:
*Attached To    : LETTER.OF.CREDIT Version (LETTER.OF.CREDIT,BD.BTBRECORD.AMD)
*Attached As    : AUTH ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 06/11/2019 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING LC.Contract
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.LocalReferences
    $USING EB.ErrorProcessing
    $INSERT I_F.BD.BTB.JOB.REGISTER
    $INSERT I_F.BD.BTB.CUSTOMER.SEQ.NO
    
*-----------------------------------------------------------------------------
    IF EB.SystemTables.getVFunction() EQ "A" THEN
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

    FN.BD.BTB.JOB.CUS.SEQNO = 'F.BD.BTB.CUSTOMER.SEQ.NO'
    F.BD.BTB.JOB.CUS.SEQNO = ''
    
    FN.LETTER.OF.CREDIT = 'F.LETTER.OF.CREDIT'
    F.LETTER.OF.CREDIT = ""
    
    Y.LC.ERR = ''
    Y.NEW.EXIST = ''
    Y.JOB.NO = ''
    Y.LC.TYPE = ''

    IF EB.SystemTables.getIdNew() EQ '' THEN
        Y.LC.ID = EB.SystemTables.getIdOld()
    END ELSE
        Y.LC.ID = EB.SystemTables.getIdNew()
    END

    FN.COM = 'F.COMPANY'
    F.COM = ''
    EB.DataAccess.Opf(FN.COM,F.COM)
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.BD.BTB.JOB.REGISTER,F.BD.BTB.JOB.REGISTER)
    EB.DataAccess.Opf(FN.BD.BTB.JOB.CUS.SEQNO,F.BD.BTB.JOB.CUS.SEQNO)
    EB.DataAccess.Opf(FN.LETTER.OF.CREDIT,F.LETTER.OF.CREDIT)
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    GOSUB GET.LOC.REF
    Y.LC.CURR = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLcCurrency)
    Y.JOB.CURR = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.JOB.CUR.POS>
    Y.JOB.EXC.RATE = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.JOB.EXC.RATE.POS>

    Y.NEW.EXIST = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.NEW.EXIST.POS>
    Y.JOB.NO = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.JOB.NO.POS>
    Y.LC.TYPE = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLcType)
    Y.OLD.LC.AMT = EB.SystemTables.getROld(LC.Contract.LetterOfCredit.TfLcLcAmount)
    Y.NEW.LC.AMT = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLcAmount)
    Y.OLD.FOB.VALUE = EB.SystemTables.getROld(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.FOB.VALUE.POS>
    Y.NEW.FOB.VALUE = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.FOB.VALUE.POS>
    Y.OLD.BTB.ENT.VALUE = EB.SystemTables.getROld(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.BTB.ENT.POS>
    Y.OLD.PC.ENT.VALUE = EB.SystemTables.getROld(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.PC.ENT.POS>
    Y.NEW.BTB.ENT.VALUE = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.BTB.ENT.POS>
    Y.NEW.PC.ENT.VALUE = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.PC.ENT.POS>

*****************************************Modification by erian@fortress-global.com*******DATE:20201010*****************
*    IF Y.JOB.CURR NE Y.LC.CURR THEN
*        Y.CCY.MKT = '3'
*        Y.CCY.BUY = Y.LC.CURR
*        Y.BUY.AMT = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.FOB.VALUE.POS>
*        Y.CCY.SELL = Y.JOB.CURR
*        Y.SELL.AMT = ''
*        Y.BASE.CCY = ''
*        Y.EXCHANGE.RATE = Y.JOB.EXC.RATE
*        Y.DIFFERENCE = ''
*        Y.LCY.AMT = ''
*        Y.RETURN.CODE = ''
*        ST.ExchangeRate.Exchrate(Y.CCY.MKT,Y.CCY.BUY,Y.BUY.AMT,Y.CCY.SELL,Y.SELL.AMT,Y.BASE.CCY,Y.EXCHANGE.RATE,Y.DIFFERENCE,Y.LCY.AMT,Y.RETURN.CODE)
*    END
*******************end**********************Modification by erian@fortress-global.com*******DATE:20201010*****************

*    IF Y.NEW.LC.AMT GT Y.OLD.LC.AMT THEN
    Y.INC.LC.AMT = Y.NEW.LC.AMT - Y.OLD.LC.AMT
*    END
*    IF Y.NEW.BTB.ENT.VALUE GT Y.OLD.BTB.ENT.VALUE THEN
    Y.INC.BTB.VALUE = Y.NEW.BTB.ENT.VALUE - Y.OLD.BTB.ENT.VALUE
*    END
*    IF Y.NEW.PC.ENT.VALUE GT Y.OLD.PC.ENT.VALUE THEN
    Y.INC.PC.VALUE = Y.NEW.PC.ENT.VALUE - Y.OLD.PC.ENT.VALUE
*    END
    Y.NEW.FOB.VALUE = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.FOB.VALUE.POS>

*****************************************Modification by erian@fortress-global.com*******DATE:20201010*****************
*    IF Y.JOB.CURR NE Y.LC.CURR THEN
*        Y.BUY.AMT = Y.NEW.FOB.VALUE
*        GOSUB EXCH.JOB.AMT
*        Y.NEW.FOB.VALUE = Y.SELL.AMT
*        Y.SELL.AMT = ''
*        Y.BUY.AMT = ''
*
*        Y.BUY.AMT = Y.INC.BTB.VALUE
*        GOSUB EXCH.JOB.AMT
*        Y.INC.BTB.VALUE = Y.SELL.AMT
*        Y.SELL.AMT = ''
*        Y.BUY.AMT = ''
*
*        Y.BUY.AMT = Y.INC.PC.VALUE
*        GOSUB EXCH.JOB.AMT
*        Y.INC.PC.VALUE = Y.SELL.AMT
*        Y.SELL.AMT = ''
*        Y.BUY.AMT = ''
*    END
****************end*************************Modification by erian@fortress-global.com*******DATE:20201010*****************

    CALL F.READ(FN.BD.BTB.JOB.REGISTER,Y.JOB.NO,R.BTB.JOB.REGISTER,F.BD.BTB.JOB.REGISTER,R.BTB.JOB.REG.ERR)
    IF Y.JOB.NO EQ "" THEN
        EB.SystemTables.setE("JOB NUMBER MISSING")
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END
    IF NOT(R.BTB.JOB.REGISTER) THEN
        EB.SystemTables.setE("JOB NUMBER DOES NOT EXIST")
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END
    IF EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcAdviceExpiryDate) GT R.BTB.JOB.REGISTER<BTB.JOB.JOB.EXPIRY.DATE> THEN
        R.BTB.JOB.REGISTER<BTB.JOB.JOB.EXPIRY.DATE> = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcAdviceExpiryDate)
    END
    IF Y.LC.TYPE EQ "SCNT" THEN
        GOSUB GET.VM.COUNT.CONTRACT
    END ELSE
        GOSUB GET.VM.COUNT.EXPORTLC
    END
RETURN
*** </region>

*** <region name= GET.VM.COUNT.EXPORTLC>
GET.VM.COUNT.EXPORTLC:
*** <desc>GET.VM.COUNT.EXPORTLC </desc>
    Y.EX.TF.NO = R.BTB.JOB.REGISTER<BTB.JOB.EX.TF.REF>
    LOCATE EB.SystemTables.getIdNew() IN Y.EX.TF.NO<1,1> SETTING Y.COUNT.POS THEN
        Y.COUNT = Y.COUNT.POS
        GOSUB UPDATE.JOB.REGISTER.EXPORTLC
    END
RETURN
*** </region>

*** <region name= GET.VM.COUNT.CONTRACT>
GET.VM.COUNT.CONTRACT:
*** <desc>GET.VM.COUNT.CONTRACT </desc>
********************************* CONTRACT *************************************
*    Y.CONT.TF.NO = R.BTB.JOB.REGISTER<BTB.JOB.CON.TF.REF.NO>
*    LOCATE EB.SystemTables.getIdNew() IN Y.CONT.TF.NO<1,1> SETTING Y.COUNT.POS THEN
*        Y.COUNT = Y.COUNT.POS
*        GOSUB UPDATE.JOB.REGISTER.CONTRACT
*    END
********************************* CONTRACT *************************************
RETURN
*** </region>

*** <region name= GET.LOC.REF>
GET.LOC.REF:
*** <desc>GET.LOC.REF </desc>
    Y.JOB.NO.POS=''
    Y.JOB.ENT.POS=''
    Y.NEW.EXIST.POS=''
    Y.LC.AMT.LCY.POS = ''
    Y.EXCH.RATE.POS = ''
    
*EB.LocalReferences.GetLocRef("COMPANY","AD.BRANCH.CODE",Y.ADCODE.POS)
    EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.TF.JOB.NUMBR",Y.JOB.NO.POS)
    EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.TF.BTB.CNTNO",Y.CONT.NO.POS)
    EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.TF.BTB.ENTRT",Y.BTB.RATE.POS)
    EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.TF.PC.ENT.RT",Y.PC.RATE.POS)
    EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.TF.BTB.ENTAM",Y.BTB.ENT.POS)
    EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.TF.PC.ENT.AM",Y.PC.ENT.POS)
    EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.TF.NW.EX.JOB",Y.NEW.EXIST.POS)
    EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.TF.NET.FOBVL",Y.FOB.VALUE.POS)
    EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.TF.JOB.ENCUR",Y.JOB.CUR.POS)
    EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.TF.JOB.EX.RT",Y.JOB.EXC.RATE.POS)
RETURN
*** </region>

*** <region name= UPDATE.JOB.REGISTER.EXPORTLC>
UPDATE.JOB.REGISTER.EXPORTLC:
*** <desc>UPDATE.JOB.REGISTER.EXPORTLC</desc>
*    IF EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLcAmount) GT R.BTB.JOB.REGISTER<BTB.JOB.EX.LC.AMOUNT,Y.COUNT> THEN
    R.BTB.JOB.REGISTER<BTB.JOB.EX.LC.AMOUNT,Y.COUNT> = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLcAmount)
*    END
*    IF EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.FOB.VALUE.POS> GT R.BTB.JOB.REGISTER<BTB.JOB.EX.NET.FOB.VALUE,Y.COUNT> THEN
    R.BTB.JOB.REGISTER<BTB.JOB.EX.NET.FOB.VALUE,Y.COUNT> = Y.NEW.FOB.VALUE
*    END
*    IF EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.BTB.RATE.POS> GT R.BTB.JOB.REGISTER<BTB.JOB.EX.BTB.ENT.PER,Y.COUNT> THEN
    R.BTB.JOB.REGISTER<BTB.JOB.EX.BTB.ENT.PER,Y.COUNT> = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.BTB.RATE.POS>
*    END
*    IF EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.BTB.ENT.POS> GT R.BTB.JOB.REGISTER<BTB.JOB.EX.BTB.ENT.AMT,Y.COUNT> THEN
    R.BTB.JOB.REGISTER<BTB.JOB.EX.BTB.ENT.AMT,Y.COUNT> = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.BTB.ENT.POS>
*    END
*    IF EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.PC.RATE.POS> GT R.BTB.JOB.REGISTER<BTB.JOB.EX.PC.ENT.PER,Y.COUNT> THEN
    R.BTB.JOB.REGISTER<BTB.JOB.EX.PC.ENT.PER,Y.COUNT> = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.PC.RATE.POS>
*    END
*    IF EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.PC.ENT.POS> GT R.BTB.JOB.REGISTER<BTB.JOB.EX.PC.ENT.AMT,Y.COUNT> THEN
    R.BTB.JOB.REGISTER<BTB.JOB.EX.PC.ENT.AMT,Y.COUNT> = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.PC.ENT.POS>
*    END
*    IF EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcAdviceExpiryDate) GT R.BTB.JOB.REGISTER<BTB.JOB.EX.EXPIRY.DATE,Y.COUNT> THEN
    R.BTB.JOB.REGISTER<BTB.JOB.EX.EXPIRY.DATE,Y.COUNT> = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcAdviceExpiryDate)
*    END
**********************start***************erian@fortress-global.com*******date:20201201***********************
*    R.BTB.JOB.REGISTER<BTB.JOB.TOT.EX.LC.AMT> += EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLcAmount)
*    R.BTB.JOB.REGISTER<BTB.JOB.TOT.NET.FOB.VALUE> += Y.NEW.FOB.VALUE
**********************end***************erian@fortress-global.com******************************
**********************start***************erian@fortress-global.com*******date:20201201***********************
    R.BTB.JOB.REGISTER<BTB.JOB.TOT.EX.LC.AMT> += EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLcAmount) - EB.SystemTables.getROld(LC.Contract.LetterOfCredit.TfLcLcAmount)
    R.BTB.JOB.REGISTER<BTB.JOB.TOT.NET.FOB.VALUE> += Y.NEW.FOB.VALUE - EB.SystemTables.getROld(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.FOB.VALUE.POS>
**********************end***************erian@fortress-global.com******************************
    IF Y.INC.BTB.VALUE THEN
        R.BTB.JOB.REGISTER<BTB.JOB.EX.BTB.AVL.AMT,Y.COUNT> += Y.INC.BTB.VALUE
        R.BTB.JOB.REGISTER<BTB.JOB.TOT.BTB.ENT.AMT> += Y.INC.BTB.VALUE
        R.BTB.JOB.REGISTER<BTB.JOB.TOT.BTB.AVL.AMT> += Y.INC.BTB.VALUE
    END
    IF Y.INC.PC.VALUE THEN
        R.BTB.JOB.REGISTER<BTB.JOB.EX.PC.AVL.AMT,Y.COUNT> += Y.INC.PC.VALUE
        R.BTB.JOB.REGISTER<BTB.JOB.TOT.PC.ENT.AMT> += Y.INC.PC.VALUE
        R.BTB.JOB.REGISTER<BTB.JOB.TOT.PC.AVL.AMT> += Y.INC.PC.VALUE
    END
    EB.DataAccess.FWrite(FN.BD.BTB.JOB.REGISTER,Y.JOB.NO,R.BTB.JOB.REGISTER)
RETURN
*** </region>

**** <region name= UPDATE.JOB.REGISTER.CONTRACT>
*UPDATE.JOB.REGISTER.CONTRACT:
**** <desc>UPDATE.JOB.REGISTER.CONTRACT </desc>
**    IF EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLcAmount) GT R.BTB.JOB.REGISTER<BTB.JOB.CON.CONT.AMT,Y.COUNT> THEN
*    R.BTB.JOB.REGISTER<BTB.JOB.CON.CONT.AMT,Y.COUNT> = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLcAmount)
**    END
**    IF EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.FOB.VALUE.POS> GT R.BTB.JOB.REGISTER<BTB.JOB.CON.NET.FOB.VALUE,Y.COUNT> THEN
*    R.BTB.JOB.REGISTER<BTB.JOB.CON.NET.FOB.VALUE,Y.COUNT> = Y.NEW.FOB.VALUE
**    END
**    IF EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.BTB.RATE.POS> GT R.BTB.JOB.REGISTER<BTB.JOB.CON.BTB.ENT.PER,Y.COUNT> THEN
*    R.BTB.JOB.REGISTER<BTB.JOB.CON.BTB.ENT.PER,Y.COUNT> = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.BTB.RATE.POS>
**    END
**    IF EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.BTB.ENT.POS> GT R.BTB.JOB.REGISTER<BTB.JOB.CON.BTB.ENT.AMT,Y.COUNT> THEN
*    R.BTB.JOB.REGISTER<BTB.JOB.CON.BTB.ENT.AMT,Y.COUNT> = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.BTB.ENT.POS>
**    END
**    IF EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.PC.RATE.POS> GT R.BTB.JOB.REGISTER<BTB.JOB.CON.PC.ENT.PER,Y.COUNT> THEN
*    R.BTB.JOB.REGISTER<BTB.JOB.CON.PC.ENT.PER,Y.COUNT> = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.PC.RATE.POS>
**    END
**    IF EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.PC.ENT.POS> GT R.BTB.JOB.REGISTER<BTB.JOB.CON.PC.ENT.AMT,Y.COUNT> THEN
*    R.BTB.JOB.REGISTER<BTB.JOB.CON.PC.ENT.AMT,Y.COUNT> = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.PC.ENT.POS>
**    END
**    IF EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcAdviceExpiryDate) GT R.BTB.JOB.REGISTER<BTB.JOB.CON.EXP.DATE,Y.COUNT> THEN
*    R.BTB.JOB.REGISTER<BTB.JOB.CON.EXP.DATE,Y.COUNT> = EB.SystemTables.getRNew(TF.LC.EXPIRY.DATE)
**    END
*    IF Y.INC.LC.AMT THEN
*        R.BTB.JOB.REGISTER<BTB.JOB.CON.OUTST.AMT,Y.COUNT> += Y.INC.LC.AMT
*    END
*    IF Y.INC.BTB.VALUE THEN
*        R.BTB.JOB.REGISTER<BTB.JOB.CON.BTB.AVL.AMT,Y.COUNT> += Y.INC.BTB.VALUE
*        R.BTB.JOB.REGISTER<BTB.JOB.TOT.BTB.ENT.AMT> += Y.INC.BTB.VALUE
*        R.BTB.JOB.REGISTER<BTB.JOB.TOT.BTB.AVL.AMT> += Y.INC.BTB.VALUE
*    END
*    IF Y.INC.PC.VALUE THEN
*        R.BTB.JOB.REGISTER<BTB.JOB.CON.PC.AVL.AMT,Y.COUNT> += Y.INC.PC.VALUE
*        R.BTB.JOB.REGISTER<BTB.JOB.TOT.PC.ENT.AMT> += Y.INC.PC.VALUE
*        R.BTB.JOB.REGISTER<BTB.JOB.TOT.PC.AVL.AMT> += Y.INC.PC.VALUE
*    END
*    EB.DataAccess.FWrite(FN.BD.BTB.JOB.REGISTER,Y.JOB.NO,R.BTB.JOB.REGISTER)
*RETURN
*** </region>

*****************************************Modification by erian@fortress-global.com*******DATE:20201010*****************
**** <region name= EXCH.JOB.AMT>
*EXCH.JOB.AMT:
**** <desc>EXCH.JOB.AMT </desc>
*    Y.CCY.MKT = '3'
*    Y.CCY.BUY = Y.LC.CURR
*    Y.CCY.SELL = Y.JOB.CURR
*    Y.SELL.AMT = ''
*    Y.BASE.CCY = ''
*    Y.EXCHANGE.RATE = Y.JOB.EXC.RATE
*    Y.DIFFERENCE = ''
*    Y.LCY.AMT = ''
*    Y.RETURN.CODE = ''
*    ST.ExchangeRate.Exchrate(Y.CCY.MKT,Y.CCY.BUY,Y.BUY.AMT,Y.CCY.SELL,Y.SELL.AMT,Y.BASE.CCY,Y.EXCHANGE.RATE,Y.DIFFERENCE,Y.LCY.AMT,Y.RETURN.CODE)
*    Y.BUY.AMT = ''
*RETURN
**** </region>

******************end***********************Modification by erian@fortress-global.com*******DATE:20201010*****************
END

SUBROUTINE TF.JBL.I.LD.JOB.NO
*-----------------------------------------------------------------------------
*Subroutine Description: job data set in PC loan
*Subroutine Type:
*Attached To    : JBL.TF.PC.OPEN.API-19990601
*Attached As    : INPUT ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 31/03/2020 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE

    $INSERT I_F.BD.BTB.JOB.REGISTER
    
    $USING LC.Contract
    $USING LD.Contract
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING EB.LocalReferences
    $USING AA.Account
    $USING EB.API
    $USING ST.CurrencyConfig
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.BD.BTB.JOB.REGISTER = "F.BD.BTB.JOB.REGISTER"
    F.BD.BTB.JOB.REGISTER = ""
    FN.CCY = "F.CURRENCY"
    F.CCY = ""
    
    EB.LocalReferences.GetLocRef('AA.ARR.ACCOUNT',"LT.TF.JOB.NUMBR",Y.LD.PC.JOB.NO.POS)
    EB.LocalReferences.GetLocRef('AA.ARR.ACCOUNT',"LT.TF.JOB.ENCUR",Y.LD.PC.ENT.CUR.POS)
    EB.LocalReferences.GetLocRef('AA.ARR.ACCOUNT',"LT.TF.JOB.ENTAM",Y.LD.PC.ENT.AMT.POS)
    EB.LocalReferences.GetLocRef('AA.ARR.ACCOUNT',"LT.TF.EXCH.RATE",Y.LD.PC.EX.RATE.POS)
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
    APP.NAME = 'AA.ARR.ACCOUNT'
    EB.API.GetStandardSelectionDets(APP.NAME, R.SS)
    Y.FIELD.NAME = 'LOCAL.REF'
    LOCATE Y.FIELD.NAME IN R.SS<AA.Account.Account.AcLocalRef> SETTING Y.POS THEN
    END
    CALL AA.GET.ACCOUNT.RECORD(R.PROPERTY.RECORD, PROPERTY.ID)
    TMP.DATA = R.PROPERTY.RECORD<1,Y.POS>

    Y.JOB.NO = FIELD(TMP.DATA,SM,Y.LD.PC.JOB.NO.POS)
    
    EB.DataAccess.FRead(FN.BD.BTB.JOB.REGISTER,Y.JOB.NO,R.BD.BTB.JOB.REGISTER,F.BD.BTB.JOB.REGISTER,Y.JOB.REG.ERR)

    IF R.BD.BTB.JOB.REGISTER THEN
        Y.JOB.CCY = R.BD.BTB.JOB.REGISTER<BTB.JOB.JOB.CURRENCY>
        Y.TOT.PC.AVL.AMT = R.BD.BTB.JOB.REGISTER<BTB.JOB.TOT.PC.AVL.AMT>
        EB.DataAccess.FRead(FN.CCY,Y.JOB.CCY,R.JOB.CCY,F.CCY,JOB.CCY.ERR)
        Y.CCY.MKT = '15'
        FIND Y.CCY.MKT IN R.JOB.CCY<ST.CurrencyConfig.Currency.EbCurCurrencyMarket> SETTING Y.CCY.MKT.POS1, Y.CCY.MKT.POS2, Y.CCY.MKT.POS3 THEN
            Y.JOB.EXCHG.RATE = R.JOB.CCY<ST.CurrencyConfig.Currency.EbCurMidRevalRate, Y.CCY.MKT.POS2>
        END
        
        Y.TEMPA = EB.SystemTables.getRNew(AA.Account.Account.AcLocalRef)
        Y.TEMPA<1, Y.LD.PC.ENT.CUR.POS> = Y.JOB.CCY
        Y.TEMPA<1, Y.LD.PC.EX.RATE.POS> = Y.JOB.EXCHG.RATE
        Y.TEMPA<1, Y.LD.PC.ENT.AMT.POS> = Y.TOT.PC.AVL.AMT
        EB.SystemTables.setRNew(AA.Account.Account.AcLocalRef,Y.TEMPA)
    END ELSE
        EB.SystemTables.setEtext('JOB NUMBER DOES NOT EXIST')
        EB.ErrorProcessing.StoreEndError()
    END
    
    
RETURN
*** </region>
END


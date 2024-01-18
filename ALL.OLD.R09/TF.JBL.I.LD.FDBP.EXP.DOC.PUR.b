SUBROUTINE TF.JBL.I.LD.FDBP.EXP.DOC.PUR
*-----------------------------------------------------------------------------
*Subroutine Description: This routine is fatch record from DRAWINGS
*Subroutine Type:
*Attached To    : ACTIVITY API   -  JBL.TF.FDBP.API
*Attached As    : INPUT ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 27/04/2020 -                            Retrofit   - Mahmudur Rahman,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_AA.LOCAL.COMMON
    
    $USING LC.Contract
    $USING LC.Config
    $USING ST.CurrencyConfig
    $INCLUDE I_F.BD.BTB.JOB.REGISTER
     
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING EB.OverrideProcessing
    $USING EB.LocalReferences
    $USING EB.Updates
    $USING AA.Account
    $USING EB.API
    $USING AA.Framework
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.LETTER.OF.CREDIT = 'F.LETTER.OF.CREDIT'
    F.LETTER.OF.CREDIT  = ''
    R.LETTER.OF.CREDIT  = ''

    FN.BD.BTB.JOB.REGISTER = 'F.BD.BTB.JOB.REGISTER'
    F.BD.BTB.JOB.REGISTER = ''
    R.BD.BTB.JOB.REGISTER = ''

    FN.DRAWINGS = 'F.DRAWINGS'
    F.DRAWINGS = ''
    R.DRAWINGS = ''
    Y.DRAWINGS.ERR = ''

    FN.LC.TYPES = 'F.LC.TYPES'
    F.LC.TYPES = ''
    R.LC.TYPES = ''
    Y.LC.TYPES.ERR = ''

    FN.CURR = 'F.CURRENCY'
    F.CURR = ''

    Y.AMT = ''
    Y.CCY = ''
    R.CCY.REC = ''
    Y.CCY.ERR = ''
    Y.EXCHANGE.RATE = ''
    Y.CCY.MKT = '1'
    Y.CCY.MARKET = ''
    Y.MID.REVAL.RATE = ''
    Y.CCY.POS = ''
    Y.EXLC.COLL.NO = ''
    
    FLD.POS = ''
    APPLICATION.NAMES = 'LETTER.OF.CREDIT':FM:'DRAWINGS':FM:'AA.ARR.ACCOUNT'
    LOCAL.FIELDS = 'LT.TF.BTB.CNTNO':VM:'LT.TF.JOB.NUMBR':FM:'LT.TF.DOC.TYPE':VM:'LT.TF.TENOR':VM:'LT.TF.ELC.COLNO':FM:'LT.AC.LINK.TFNO':VM:'LT.LN.BIL.DOCVL':VM:'LT.LN.PUR.FCAMT':VM:'LT.TF.EXCH.RATE':VM:'LT.TF.EXP.LC.NO':VM:'LT.TF.BTB.CNTNO':VM:'LT.TF.JOB.NUMBR':VM:'LT.TF.TENOR':VM:'LT.LEGACY.ID':VM:'LINKED.TFDR.REF'
*                           1                   2                   1                 2                   3                   1                     2                   3                     4                    5                   6                    7                  8                 9                  10
    EB.Updates.MultiGetLocRef(APPLICATION.NAMES, LOCAL.FIELDS, FLD.POS)
    Y.CONT.NO.POS       = FLD.POS<1,1>
    Y.JOB.NO.POS        = FLD.POS<1,2>
    Y.DR.DOC.TY.POS     = FLD.POS<2,1>
    Y.DR.TENOR.POS      = FLD.POS<2,2>
    Y.EXLC.COLL.NO.POS  = FLD.POS<2,3>
    Y.LD.TFNO.POS       = FLD.POS<3,1>
    Y.LD.DOC.VAL.POS    = FLD.POS<3,2>
    Y.LD.PUR.AMT.POS    = FLD.POS<3,3>
    Y.LD.XRATE.POS      = FLD.POS<3,4>
    Y.LD.EXP.LCNO.POS   = FLD.POS<3,5>
    Y.LD.CONT.NO.POS    = FLD.POS<3,6>
    Y.LD.JOB.NO.POS     = FLD.POS<3,7>
    Y.LD.TENOR.POS      = FLD.POS<3,8>
    Y.OLD.LEGACY.ID.POS = FLD.POS<3,9>
    Y.LINKED.TFDR.REF.POS = FLD.POS<3,10>
RETURN
*** </region>
 

*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.LETTER.OF.CREDIT,F.LETTER.OF.CREDIT)
    EB.DataAccess.Opf(FN.BD.BTB.JOB.REGISTER,F.BD.BTB.JOB.REGISTER)
    EB.DataAccess.Opf(FN.DRAWINGS,F.DRAWINGS)
    EB.DataAccess.Opf(FN.LC.TYPES,F.LC.TYPES)
    EB.DataAccess.Opf(FN.CURR,F.CURR)
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
    Y.LINKED.TFDR.REF = FIELD(TMP.DATA,SM, Y.LINKED.TFDR.REF.POS)
*    Y.EXLC.COLL.NO = FIELD(TMP.DATA,SM, Y.OLD.LEGACY.ID.POS)


    Y.DR.ID = Y.LINKED.TFDR.REF
    Y.LC.REF.NO = Y.DR.ID[1,12]
    EB.DataAccess.FRead(FN.LETTER.OF.CREDIT,Y.LC.REF.NO,R.LETTER.OF.CREDIT,F.LETTER.OF.CREDIT,Y.LETTER.OF.CREDIT.ERR)
    IF R.LETTER.OF.CREDIT EQ '' THEN RETURN
    Y.EXP.LC.NO = R.LETTER.OF.CREDIT<LC.Contract.LetterOfCredit.TfLcIssBankRef>
    Y.CON.NO = R.LETTER.OF.CREDIT<LC.Contract.LetterOfCredit.TfLcLocalRef, Y.CONT.NO.POS>
    Y.CUSTO = R.LETTER.OF.CREDIT<LC.Contract.LetterOfCredit.TfLcBeneficiaryCustno>
    Y.JOB.NO = R.LETTER.OF.CREDIT<LC.Contract.LetterOfCredit.TfLcLocalRef, Y.JOB.NO.POS>
    Y.LC.TYPE = R.LETTER.OF.CREDIT<LC.Contract.LetterOfCredit.TfLcLcType>
    Y.LC.CATEGORY = R.LETTER.OF.CREDIT<LC.Contract.LetterOfCredit.TfLcCategoryCode>


    EB.DataAccess.FRead(FN.LC.TYPES,Y.LC.TYPE,R.LC.TYPES,F.LC.TYPES,Y.LC.TYPES.ERR)
    IF R.LC.TYPES THEN
        Y.LC.IMP.EXP = R.LC.TYPES<LC.Config.Types.TypImportExport>
        IF Y.LC.IMP.EXP EQ 'E' THEN
            EB.DataAccess.FRead(FN.DRAWINGS,Y.DR.ID,R.DRAWINGS,F.DRAWINGS,ERR.DRAWINGS)
            IF R.DRAWINGS THEN
                Y.EXLC.COLL.NO = R.DRAWINGS<LC.Contract.Drawings.TfDrLocalRef, Y.EXLC.COLL.NO.POS>
                Y.AMT = R.DRAWINGS<LC.Contract.Drawings.TfDrDocumentAmount>
                Y.CCY = R.DRAWINGS<LC.Contract.Drawings.TfDrDrawCurrency>
            END
            Y.ARR.CUR = c_aalocArrActivityRec<AA.Framework.ArrangementActivity.ArrActCurrency>
            IF Y.ARR.CUR NE Y.CCY THEN
*******************************IF BANK WANT ARR CURR & DOC CURR differ override message*******************************
                EB.SystemTables.setEtext("Arrangement and Document currrency are Differ!")
                Y.OVERRIDE.VAL = EB.SystemTables.getRNew(V-9)
                Y.OVRRD.NO = DCOUNT(Y.OVERRIDE.VAL,VM) + 1
                EB.OverrideProcessing.StoreOverride(Y.OVRRD.NO)
****************************************************END******************************************************
                EB.DataAccess.FRead(FN.CURR,Y.CCY,R.CCY.REC,F.CURR,Y.CCY.ERR)
                Y.CCY.MARKET = R.CCY.REC<ST.CurrencyConfig.Currency.EbCurCurrencyMarket>
                Y.MID.REVAL.RATE = R.CCY.REC<ST.CurrencyConfig.Currency.EbCurMidRevalRate>
                IF Y.CCY EQ 'BDT' THEN
                    Y.DOC.CURR.RATE = '1'
                END
                IF R.CCY.REC THEN
                    LOCATE Y.CCY.MKT IN Y.CCY.MARKET<1,1> SETTING Y.CCY.POS THEN
                        Y.DOC.CURR.RATE = Y.MID.REVAL.RATE<1,Y.CCY.POS>
                    END
                END
                EB.DataAccess.FRead(FN.CURR,Y.ARR.CUR,R.CCY.REC,F.CURR,Y.CCY.ERR)
                Y.CCY.MARKET = R.CCY.REC<ST.CurrencyConfig.Currency.EbCurCurrencyMarket>
                Y.MID.REVAL.RATE = R.CCY.REC<ST.CurrencyConfig.Currency.EbCurMidRevalRate>
                IF Y.ARR.CUR EQ 'BDT' THEN
                    Y.ARR.CURR.RATE = '1'
                END
                IF R.CCY.REC THEN
                    LOCATE Y.CCY.MKT IN Y.CCY.MARKET<1,1> SETTING Y.CCY.POS THEN
                        Y.ARR.CURR.RATE = Y.MID.REVAL.RATE<1,Y.CCY.POS>
                    END
                END
                Y.EXCHANGE.RATE = Y.DOC.CURR.RATE/Y.ARR.CURR.RATE

            END
            IF Y.ARR.CUR EQ Y.CCY THEN
                Y.EXCHANGE.RATE = '1'
            END
    
            Y.BILL.DOC.VAL = Y.CCY : Y.AMT
            Y.DR.TENOR = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)<1,Y.DR.TENOR.POS>

            Y.TEMP = EB.SystemTables.getRNew(AA.Account.Account.AcLocalRef)
            Y.TEMP<1,Y.OLD.LEGACY.ID.POS>= Y.EXLC.COLL.NO
            Y.TEMP<1,Y.LD.EXP.LCNO.POS> = Y.EXP.LC.NO
            Y.TEMP<1,Y.LD.TFNO.POS> = Y.LC.REF.NO
            Y.TEMP<1,Y.LD.CONT.NO.POS> = Y.CON.NO
            Y.TEMP<1,Y.LD.JOB.NO.POS> = Y.JOB.NO
            Y.TEMP<1,Y.LD.DOC.VAL.POS> = Y.BILL.DOC.VAL
            Y.TEMP<1,Y.LD.XRATE.POS> = DROUND(Y.EXCHANGE.RATE,4)
            Y.TEMP<1,Y.LD.TENOR.POS> = Y.DR.TENOR

            EB.SystemTables.setRNew(AA.Account.Account.AcLocalRef, Y.TEMP)
        END ELSE
            EB.SystemTables.setEtext("Not Export LC Type")
            EB.ErrorProcessing.StoreEndError()
        END
    END
RETURN
*** </region>

END

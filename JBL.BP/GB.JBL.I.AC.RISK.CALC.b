SUBROUTINE GB.JBL.I.AC.RISK.CALC
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.EB.JBL.PRODUCT.CHANNEL.RISK
    
    $USING ST.Customer
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates
    $USING AC.AccountOpening
    $USING AA.Framework

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
    GOSUB TRACER
RETURN

*-------
INIT:
*-------
    FN.CUS = 'F.CUSTOMER'
    F.CUS = ''
    FN.CUS.ACC = 'F.CUSTOMER.ACCOUNT'
    F.CUS.ACC = ''
    FN.CATG = 'F.CATEGORY'
    F.CATG = ''
    FN.ACCT = 'F.ACCOUNT'
    F.ACCT = ''
    FN.PRD.RISK = 'F.EB.JBL.PRODUCT.CHANNEL.RISK'
    F.PRD.RISK = ''
    FN.AA = 'F.AA.ARRANGEMENT'
    F.AA = ''
    
RETURN

*-----------
OPENFILES:
*------------
    EB.DataAccess.Opf(FN.CUS, F.CUS)
    EB.DataAccess.Opf(FN.CUS.ACC, F.CUS.ACC)
    EB.DataAccess.Opf(FN.CATG, F.CATG)
    EB.DataAccess.Opf(FN.ACCT, F.ACCT)
    EB.DataAccess.Opf(FN.AA, F.AA)
    EB.DataAccess.Opf(FN.PRD.RISK, F.PRD.RISK)
    
RETURN

*--------
PROCESS:
*--------
    Y.APP.NAME = 'CUSTOMER'
    LOCAL.FIELDS = 'LT.TYP.ON.BOARD':VM:'LT.GEO.GRH.RISK':VM:'LT.CLS.CUNT.ORG':VM:'LT.PEP.CUS':VM:'LT.IP.CUS':VM:'LT.AVG.YR.TXN':VM:'LT.RISK.SCORE':VM:'LT.SOURCE.FUND'
    FLD.POS = ""
    EB.Updates.MultiGetLocRef(Y.APP.NAME,LOCAL.FIELDS,FLD.POS)
    Y.LT.TYP.ON.BOARD.POS = FLD.POS<1,1>
    Y.LT.GEO.GRH.RISK.POS = FLD.POS<1,2>
    Y.LT.CLS.CUNT.ORG.POS = FLD.POS<1,3>
    Y.LT.PEP.CUS.POS = FLD.POS<1,4>
    Y.LT.IP.CUS.POS = FLD.POS<1,5>
    Y.LT.AVG.YR.TXN.POS = FLD.POS<1,6>
    Y.LT.RISK.SCORE.POS = FLD.POS<1,7>
    Y.LT.SOURCE.FUNDS.POS = FLD.POS<1,8>

    Y.ARR.ID = AA.Framework.getC_aalocarrid()
    EB.DataAccess.FRead(FN.AA, Y.ARR.ID, REC.AA, FN.AA, ERR.AA)
    Y.CUS.ID = REC.AA<AA.Framework.Arrangement.ArrCustomer>
    
    EB.DataAccess.FRead(FN.CUS.ACC,Y.CUS.ID, R.CUS.ACC, F.CUS.ACC, ERR.CUS.ACC)
    IF R.CUS.ACC NE '' THEN
        FOR I=1 TO DCOUNT(R.CUS.ACC,@FM)
            EB.DataAccess.FRead(FN.ACCT, R.CUS.ACC<I>, REC.ACCT, F.ACCT, ERR.ACCT)
            Y.CATEG = REC.ACCT<AC.AccountOpening.Account.Category>
            EB.DataAccess.FRead(FN.PRD.RISK, 'SYSTEM', REC.PRD.RISK, F.PRD.RISK, ERR.PRD.RISK)
            Y.CATEG.LIST = REC.PRD.RISK<EB.JBL.RISK.CATEGORY>
            LOCATE Y.CATEG IN Y.CATEG.LIST<1,1> SETTING Y.POS THEN
                Y.RISK.SCORE = REC.PRD.RISK<EB.JBL.RISK.RISK.SCORE,Y.POS>
                IF Y.RISK.SCORE GT Y.FINAL.RISK.SCORE THEN
                    Y.FINAL.RISK.SCORE = Y.RISK.SCORE
                END
            END
        NEXT I
    END
    
    EB.DataAccess.FRead(FN.CUS,Y.CUS.ID, R.CUS, F.CUS, ERR.CUS)
*Y.CUS.LOC.REF = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)
    Y.CUS.LOC.REF = R.CUS<ST.Customer.Customer.EbCusLocalRef>
    Y.TYP.NO.BOARD = FIELD(Y.CUS.LOC.REF<1,Y.LT.TYP.ON.BOARD.POS>,'-',2,1)
    Y.GEO.GRPH.RISK = FIELD(Y.CUS.LOC.REF<1,Y.LT.GEO.GRH.RISK.POS>,'-',2,1)
    Y.COUNTRY.ORGIN = FIELD(Y.CUS.LOC.REF<1,Y.LT.CLS.CUNT.ORG.POS>,'-',2,1)
    Y.PEP.CUS = FIELD(Y.CUS.LOC.REF<1,Y.LT.PEP.CUS.POS>,'-',2,1)
    Y.IP.CUS = FIELD(Y.CUS.LOC.REF<1,Y.LT.IP.CUS.POS>,'-',2,1)
    Y.AVG.YR.TXN = FIELD(Y.CUS.LOC.REF<1,Y.LT.AVG.YR.TXN.POS>,'-',2,1)
    Y.SOURCE.FUNDS = FIELD(Y.CUS.LOC.REF<1,Y.LT.SOURCE.FUNDS.POS>,'-',2,1)
    
    Y.RISK.SUM = Y.TYP.NO.BOARD + Y.GEO.GRPH.RISK + Y.COUNTRY.ORGIN + Y.PEP.CUS + Y.IP.CUS + Y.AVG.YR.TXN + Y.SOURCE.FUNDS

    Y.CUS.LOC.REF<1,Y.LT.RISK.SCORE.POS> = Y.RISK.SUM + Y.FINAL.RISK.SCORE
*EB.SystemTables.setRNew(ST.Customer.Customer.EbCusLocalRef,Y.CUS.LOC.REF)
R.CUS<ST.Customer.Customer.EbCusLocalRef>=Y.CUS.LOC.REF


*Y.CUS.LOC.REF = R.CUS<ST.Customer.Customer.EbCusLocalRef>
*Y.CUS.LOC.REF<1,Y.LT.RISK.SCORE.POS> = Y.RISK.SUM + Y.FINAL.RISK.SCORE
    WRITE R.CUS ON F.CUS,Y.CUS.ID
RETURN

*------
TRACER:
*------
    WriteData = ''
    WriteData = 'ARRANGEMENT.ID - ':Y.ARR.ID:'|':'Y.CUS.ID - ':Y.CUS.ID:'|':'Y.TOTAL.RISK - ':Y.RISK.SUM:'|':'Y.CATEG.RISK - ': Y.FINAL.RISK.SCORE:'|':'REC.CUS - ': R.CUS
    FileName = 'TRACER.txt'
    FilePath = '/Temenos/T24/UD/JBL.BP'
    OPENSEQ FilePath,FileName TO FileOutput THEN
        NULL
    END ELSE
        CREATE FileOutput ELSE
        END
    END
    WRITESEQ WriteData APPEND TO FileOutput ELSE
        CLOSESEQ FileOutput
    END
    CLOSESEQ FileOutput
RETURN

END
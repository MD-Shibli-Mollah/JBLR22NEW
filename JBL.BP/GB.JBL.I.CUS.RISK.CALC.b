SUBROUTINE GB.JBL.I.CUS.RISK.CALC
*-----------------------------------------------------------------------------
*Subroutine Description: Calculate the risk scores of customer.
*Attached To           :
*Attached As           : Input Routine
*Developed by          : #-Kamran-#
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

*Y.ACC.ID = EB.SystemTables.getIdNew()
    Y.ARR.ID = AA.Framework.getC_aalocarrid()
    EB.DataAccess.FRead(FN.AA, Y.ARR.ID, REC.AA, FN.AA, ERR.AA)
    Y.ACC.ID = REC.AA<AA.Framework.Arrangement.ArrLinkedApplId>
*Y.ACC.ID = AA.Framework.getC_aaloclinkedaccount()
    EB.DataAccess.FRead(FN.ACCT, Y.ACC.ID, REC.ACCT, F.ACCT, ERR.ACCT)
    Y.CUS.ID = REC.ACCT<AC.AccountOpening.Account.Customer>
    
*    Y.CURR.CATEG = EB.SystemTables.getRNew(AC.AccountOpening.Account.Category)
*    EB.DataAccess.FRead(FN.PRD.RISK, 'SYSTEM', REC.CURR.PRD.RISK, F.PRD.RISK, ERR.CURR.PRD.RISK)
*    Y.CURR.CATEG.LIST = REC.CURR.PRD.RISK<EB.JBL.RISK.CATEGORY>
*    LOCATE Y.CURR.CATEG IN Y.CURR.CATEG.LIST<1,1> SETTING Y.POS THEN
*        Y.CURR.RISK.SCORE = REC.CURR.PRD.RISK<EB.JBL.RISK.RISK.SCORE,Y.POS>
*        IF Y.CURR.RISK.SCORE GT Y.FINAL.RISK.SCORE THEN
*            Y.FINAL.RISK.SCORE = Y.CURR.RISK.SCORE
*        END
*    END
    
    EB.DataAccess.FRead(FN.CUS.ACC,Y.CUS.ID, R.CUS.ACC, F.CUS.ACC, ERR.CUS)
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
    
    Y.CUS.LOC.REF = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)
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
    WRITE R.CUS.ACC TO F.CUS.ACC,Y.CUS.ID
 
RETURN

END
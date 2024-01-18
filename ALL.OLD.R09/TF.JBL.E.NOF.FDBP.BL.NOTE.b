SUBROUTINE TF.JBL.E.NOF.FDBP.BL.NOTE(Y.RETURN)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Creation History :
*Enquiry Name: JBL.ENQ.FDBP.BILL.NOTE
*SS - NOFILE.JBL.FDBP.BL.NOTE
*-----------------------------------------------------------------------------
*                                                  RETROFIT - SHAJJAD HOSSEN,
*  25/02/2021                                      FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BD.BTB.JOB.REGISTER
    
    $USING EB.Reports
    $USING EB.Updates
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING AA.Framework
    $USING ST.CompanyCreation
    $USING AA.Settlement
    $USING AA.Interest
    $USING AA.TermAmount
    $USING AC.AccountOpening
    $USING ST.Customer
    $USING LC.Contract
    $USING ST.Config
    $USING AA.Account
    $USING AC.EntryCreation
    $USING AA.Fees
*    $USING ST.ChargeConfig
		$USING CG.ChargeConfig
    $USING AA.ActivityCharges
    $USING ST.CurrencyConfig
    $USING AC.CashFlow
    
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
INIT:
*******
    FN.AA = 'F.AA.ARRANGEMENT'
    F.AA = ''
    FN.SET = 'F.AA.ARR.SETTLEMENT'
    F.SET = ''
    FN.COM ='F.COMPANY'
    F.COM=''
    FN.AC='F.ACCOUNT'
    F.AC=''
    FN.DR='F.DRAWINGS'
    F.DR=''
    FN.LC='F.LETTER.OF.CREDIT'
    F.LC=''
    FN.CUS='F.CUSTOMER'
    F.CUS=''
    FN.FTCOM = 'F.FT.COMMISSION.TYPE'
    F.FTCOM = ''
    FN.JOB = 'F.BD.BTB.JOB.REGISTER'
    F.JOB = ''
    FN.CUR = 'F.CURRENCY'
    F.CUR = ''
    
    
    FLD.POS = ''
    APPLICATION.NAME ='AA.ARR.ACCOUNT':FM:'LETTER.OF.CREDIT':FM:'DRAWINGS'
    LOCAL.FIELD = 'LINKED.TFDR.REF':VM:'LT.TF.JOB.NUMBR':VM:'LT.LN.PUR.PCT':VM:'LT.LN.BIL.DOCVL':VM:'LT.LN.PUR.FCAMT':VM:'LT.TF.EXCH.RATE':VM:'LT.LEGACY.ID':VM:'LT.TF.CIB.RPTRF':VM:'LT.TF.DSCRPNCY':VM:'LT.TF.FC.HELD':VM:'LT.TF.FCAD.AMT':VM:'LT.TF.SPCL.CMNT':VM:'LT.TF.EXP.LC.NO':VM:'LT.AC.LINK.TFNO':FM:'LT.TF.LC.TENOR':FM:'LT.TF.EXP.FM.NO'
*---------------------1------------------------2------------------3------------------4---------------------5--------------------6--------------------7-----------------8---------------------9-------------------10------------------11-----------------12-----------------13-------------------14--------
    
    EB.Updates.MultiGetLocRef(APPLICATION.NAME,LOCAL.FIELD,FLD.POS)
    Y.TF.POS = FLD.POS<1,1>
    Y.JOB.NUM.POS = FLD.POS<1,2>
    Y.PUR.PER.POS = FLD.POS<1,3>
    Y.BL.DOCVL.POS = FLD.POS<1,4>
    Y.PR.FCAMT.POS = FLD.POS<1,5>
    Y.EXCH.RT.POS = FLD.POS<1,6>
    Y.EXP.BL.NO.POS = FLD.POS<1,7>
    Y.LN.CIB.BDREF.POS = FLD.POS<1,8>
    Y.DISCREPENCY.POS = FLD.POS<1,9>
    Y.FC.HELD.POS = FLD.POS<1,10>
    Y.FCAD.POS = FLD.POS<1,11>
    Y.SPCL.CMNT.POS = FLD.POS<1,12>
    Y.EX.LC.NO.POS = FLD.POS<1,13>
    Y.LT.LC.REF.POS = FLD.POS<1,14>
    
    Y.TENOR.POS = FLD.POS<2,1>
    
    Y.EXP.FM.NO.POS = FLD.POS<3,1>
    
    Y.BR.NAME = ''
    Y.BR.NAME = ''
    Y.CUS.N1 = ''
    Y.EX.LC.REF = ''
    Y.EXP.BL.NO = ''
    Y.LC.CURVAL = ''
    Y.TF.REF = ''
    Y.LC.EXP.DT = ''
    Y.DR.VAL.DT = ''
    Y.TENOR = ''
    Y.BL.DOCVL = ''
    Y.EXP.FM.NO = ''
    Y.JOB.NUM = ''
    TotalAllBal = ''
    Y.JOB.EXP.MD = ''
    TotalAllOdBal = ''
    PCTotalAllBal = ''
    COUNTOD = ''
    Y.DISCREPENCE = ''
    Y.DR.CUR = ''
    Y.FC.HELD.AMT = ''
    Y.FCAD.AMT = ''
    Y.CAL = ''
    Y.PUR.PCT = ''
    Y.PR.FCAMT = ''
    Y.AA.ID = ''
    Y.LN.AA.AMT = ''
    Y.ACC.NO = ''
    Y.AA.MT.DT = ''
    Y.EFF.DT = ''
    Y.EXCH.RT = ''
    Y.LCCR.PLCAT = ''
    Y.LCCR.DES = ''
    Y.LCCR.AMT = ''
    Y.LCSTX.CAT = ''
    Y.LCSTX.DES = ''
    Y.LCSTX.AMT = ''
    Y.LCCOL.PLCAT = ''
    Y.LCCOL.DES = ''
    Y.LCCOL.AMT = ''
    Y.LCTXEX.CAT = ''
    Y.LCTXEX.DES = ''
    Y.LCTXEX.AMT = ''
    Y.LCEXCG.PLCAT = ''
    Y.LCEXCG.DES = ''
    Y.LCEXCG.AMT = ''
    Y.LCPRC.PLCAT = ''
    Y.LCPRC.DES = ''
    Y.LCPRC.AMT = ''
    Y.LCTXRM.CAT = ''
    Y.LCTXRM.DES = ''
    Y.LCTXRM.AMT = ''
    Y.LCINS.CAT = ''
    Y.LCINS.DES = ''
    Y.LCINS.AMT = ''
    Y.LCCF.CAT = ''
    Y.LCCF.DES = ''
    Y.LCCF.AMT = ''
    Y.AA.CR.ACC = ''
    Y.CR.ACC.DES = ''
    Y.AA.CR.AMT = ''
    Y.LN.CIB.BDREF = ''
    Y.SP.CMNT = ''
    Y.AA.CUR = ''
    Y.AA.CO.CD = ''
    Y.CCY.MKT = '1'
    TotalBal = ''
    TotalOdBal = ''
    
    
    LOCATE 'AA.ID' IN EB.Reports.getEnqSelection()<2,1> SETTING AA.ID.POS THEN
        Y.AA.ID = EB.Reports.getEnqSelection()<4,AA.ID.POS>
    END
RETURN

OPENFILES:
    EB.DataAccess.Opf(FN.AA, F.AA)
    EB.DataAccess.Opf(FN.SET, F.SET)
    EB.DataAccess.Opf(FN.COM, F.COM)
    EB.DataAccess.Opf(FN.AC, F.AC)
    EB.DataAccess.Opf(FN.DR, F.DR)
    EB.DataAccess.Opf(FN.LC, F.LC)
    EB.DataAccess.Opf(FN.CUS, F.CUS)
    EB.DataAccess.Opf(FN.FTCOM, F.FTCOM)
    EB.DataAccess.Opf(FN.JOB, F.JOB)
    EB.DataAccess.Opf(FN.CUR, F.CUR)
        
*******
RETURN
PROCESS:

*=====================
    Y.PROD.LINE = "LENDING"
    Y.PROD.GRP = "JBL.FDBP.LN"
    
    Y.AA.ID.LEN = LEN(Y.AA.ID)
    IF Y.AA.ID.LEN NE '12' THEN
        RETURN
    END ELSE
*============================================================AA.ARRANGEMENT
*Read AA.ARR Application for Y.AA.CUS, Y.EFF.DT, Y.AA.STATUS, Y.ACC.NO, Y.AA.CO.CD Fields
        EB.DataAccess.FRead(FN.AA, Y.AA.ID,REC.AA,F.AA , E.AA)
        Y.AA.CUS = REC.AA<AA.Framework.Arrangement.ArrCustomer>
        Y.EFF.DT = REC.AA<AA.Framework.Arrangement.ArrStartDate>
        Y.AA.STATUS = REC.AA<AA.Framework.Arrangement.ArrArrStatus>
        Y.ACC.NO = REC.AA<AA.Framework.Arrangement.ArrLinkedApplId>
        Y.AA.CUR = REC.AA<AA.Framework.Arrangement.ArrCurrency>
        Y.AA.CO.CD = REC.AA<AA.Framework.Arrangement.ArrCoCode>
*=====================================================================CURRENCY MARKET
        EB.DataAccess.FRead(FN.CUR,Y.AA.CUR,R.CCY.REC,F.CUR,Y.CCY.ERR)
        Y.CCY.MARKET = R.CCY.REC<ST.CurrencyConfig.Currency.EbCurCurrencyMarket>
        Y.LC.MID.REVAL.RATE = R.CCY.REC<ST.CurrencyConfig.Currency.EbCurMidRevalRate>
    
        LOCATE Y.CCY.MKT IN Y.CCY.MARKET<1,1> SETTING Y.CCY.POS THEN
            Y.LC.EXCHANGE.RATE = Y.LC.MID.REVAL.RATE<1,Y.CCY.POS>
        END
*=============================================================COMPANY
*Read COMPANY Application for Brance Name
        EB.DataAccess.FRead(FN.COM, Y.AA.CO.CD,REC.COM,F.COM , E.COM)
        Y.BR.NAME = REC.COM<ST.CompanyCreation.Company.EbComCompanyName>
*=================================================================ACCOUNT PROP
        Y.AA.PROP = 'ACCOUNT'
*Read AA.PRD.DES.ACCOUNT Property for bellow Fields
        AA.Framework.GetArrangementConditions(Y.AA.ID, Y.AA.PROP.CL, Y.AA.PROP, '', RETURN.IDS, RET.VAL.AA, RET.ERROR)
        R.REC.AC = RAISE(RET.VAL.AA)
        Y.TF.REF = R.REC.AC<AA.Account.Account.AcLocalRef,Y.TF.POS>
        Y.EX.LC.REF = R.REC.AC<AA.Account.Account.AcLocalRef,Y.EX.LC.NO.POS>
        Y.LC.REF = R.REC.AC<AA.Account.Account.AcLocalRef,Y.LT.LC.REF.POS>
        Y.JOB.NUM = R.REC.AC<AA.Account.Account.AcLocalRef,Y.JOB.NUM.POS>
        Y.PUR.PCT = R.REC.AC<AA.Account.Account.AcLocalRef,Y.PUR.PER.POS>
        Y.BL.DOCVL = R.REC.AC<AA.Account.Account.AcLocalRef,Y.BL.DOCVL.POS>
        Y.BL.DCBL.LEN = LEN(Y.BL.DOCVL)
        Y.BL.DCBL = Y.BL.DOCVL[4,Y.BL.DCBL.LEN]
        Y.PR.FCAMT = R.REC.AC<AA.Account.Account.AcLocalRef,Y.PR.FCAMT.POS>
        Y.PR.FCAMNT.LEN = LEN(Y.PR.FCAMT)
        Y.PR.FCAMNT = Y.PR.FCAMT[4,Y.PR.FCAMNT.LEN]
        Y.EXCH.RATE = R.REC.AC<AA.Account.Account.AcLocalRef,Y.EXCH.RT.POS>
        Y.EXCH.RT = Y.EXCH.RATE:"%"
        Y.EXP.BL.NO = R.REC.AC<AA.Account.Account.AcLocalRef,Y.EXP.BL.NO.POS>
        Y.FC.HLD.AMT = R.REC.AC<AA.Account.Account.AcLocalRef,Y.FC.HELD.POS>
        Y.FCAD.AMNT = R.REC.AC<AA.Account.Account.AcLocalRef,Y.FCAD.POS>
        Y.DISCREPENCE = R.REC.AC<AA.Account.Account.AcLocalRef,Y.DISCREPENCY.POS>
        Y.LN.CIB.BDREF = R.REC.AC<AA.Account.Account.AcLocalRef,Y.LN.CIB.BDREF.POS>
        Y.SP.CMNT = R.REC.AC<AA.Account.Account.AcLocalRef,Y.SPCL.CMNT.POS>
        Y.SUB.TOTAL = Y.PR.FCAMNT + Y.FC.HLD.AMT + Y.FCAD.AMNT
        Y.CALC = Y.BL.DCBL - Y.SUB.TOTAL

*==========================================LC VALUE
        EB.DataAccess.FRead(FN.JOB, Y.JOB.NUM,REC.LC.JOB,F.JOB , E.JOB)
        IF REC.LC.JOB THEN
            Y.CONT.DR = REC.LC.JOB<BTB.JOB.COLL.DR.REFNO>
            Y.LC.DR = REC.LC.JOB<BTB.JOB.EX.DR.ID>
            Y.JOB.LC.CUR = REC.LC.JOB<BTB.JOB.CONT.CURRENCY>
            IF Y.TF.REF EQ Y.CONT.DR THEN
                Y.CONT.AMT.ALL = REC.LC.JOB<BTB.JOB.CONT.AMOUNT>
                IF Y.CONT.AMT.ALL NE '' THEN
                    Y.CONT.AMT.ALL.LIST = DCOUNT(Y.CONT.AMT.ALL, @VM)
                    FOR M = 1 TO Y.CONT.AMT.ALL.LIST
                        Y.CONT.AMT = Y.CONT.AMT.ALL<1,M>
                        Y.LC.VAL = Y.LC.VAL + Y.CONT.AMT
                    NEXT M
                END
                Y.LC.CURVAL = Y.JOB.LC.CUR : Y.LC.VAL
            END ELSE
                EB.DataAccess.FRead(FN.LC, Y.LC.REF, REC.JOB.LC, F.LC, E.LC)
                IF REC.JOB.LC THEN
                    Y.JOB.LC.CUR = REC.JOB.LC<LC.Contract.LetterOfCredit.TfLcLcCurrency>
                    Y.LC.VAL = REC.JOB.LC<LC.Contract.LetterOfCredit.TfLcLcAmount>
                    Y.LC.CURVAL = Y.JOB.LC.CUR : Y.LC.VAL
                END
            END
        END
*======================================================COMMITMENT PROP
        Y.TA.PROP = 'COMMITMENT'
*Read AA.PRD.DES.TERM.AMOUNT Property for bellow Fields
        AA.Framework.GetArrangementConditions(Y.AA.ID, Y.AA.PROP.CL, Y.TA.PROP, '', RETURN.IDS, RET.VAL.TA, RET.ERROR)
        R.REC.TA = RAISE(RET.VAL.TA)
        Y.AA.AMT = R.REC.TA<AA.TermAmount.TermAmount.AmtAmount>
        Y.AA.MT.DT = R.REC.TA<AA.TermAmount.TermAmount.AmtMaturityDate>
        Y.LN.AA.AMT = Y.AA.CUR : Y.AA.AMT
*=============================================================DRAWING APPL
        EB.DataAccess.FRead(FN.DR, Y.TF.REF,REC.DR,F.DR , E.DR)
*Read DRAWINGS Application
        IF REC.DR THEN
            Y.DR.CUR = REC.DR<LC.Contract.Drawings.TfDrDrawCurrency>
            Y.DR.AMT = REC.DR<LC.Contract.Drawings.TfDrDocumentAmount>
            Y.DR.VAL.DT = REC.DR<LC.Contract.Drawings.TfDrValueDate>
            Y.EXP.FM.NO = REC.DR<LC.Contract.Drawings.TfDrLocalRef,Y.EXP.FM.NO.POS>
*========================================================================
            Y.CAL = Y.DR.CUR:" ":Y.CALC
            Y.FC.HELD.AMT = Y.DR.CUR:" ":Y.FC.HLD.AMT
            Y.FCAD.AMT =  Y.DR.CUR:" ":Y.FCAD.AMNT
        END
*==============================================================LC APPL
        EB.DataAccess.FRead(FN.LC, Y.LC.REF, REC.LC, F.LC, E.LC)
*Read LETTER.OF.CREDIT Application
        Y.LC.CUR = REC.LC<LC.Contract.LetterOfCredit.TfLcLcCurrency>
        Y.LC.AMT = REC.LC<LC.Contract.LetterOfCredit.TfLcLcAmount>
        Y.TENOR = REC.LC<LC.Contract.LetterOfCredit.TfLcLocalRef,Y.TENOR.POS>
        Y.LC.ISS.BNK.NO = REC.LC<LC.Contract.LetterOfCredit.TfLcIssuingBankNo>
        Y.LC.APPLI = REC.LC<LC.Contract.LetterOfCredit.TfLcApplicant>
        Y.LC.APPL = FIELD(Y.LC.APPLI,VM,1)
        Y.LC.ISS.BNK.REF = REC.LC<LC.Contract.LetterOfCredit.TfLcIssBankRef>
        Y.LC.ISS.DT = REC.LC<LC.Contract.LetterOfCredit.TfLcIssueDate>
        Y.LC.EXP.DT = REC.LC<LC.Contract.LetterOfCredit.TfLcExpiryDate>
        
*==============================================================
*Read CUSTOMER Application

        EB.DataAccess.FRead(FN.CUS, Y.AA.CUS, REC.CUS, F.CUS, E.CUS)
        Y.CUS.N1 = REC.CUS< ST.Customer.Customer.EbCusNameOne>
        EB.DataAccess.FRead(FN.CUS, Y.LC.ISS.BNK.NO, REC.BANK.CUS, F.CUS, E.CUS)
        Y.BK.CUS.N1 = REC.BANK.CUS< ST.Customer.Customer.EbCusNameOne>
*=======================================================================
        Y.AA.CRG.PROP = 'ACTIVITY.CHARGES'
**Read AA.PRD.DES.CHARGE Property for bellow Fields
        AA.Framework.GetArrangementConditions(Y.AA.ID, Y.AA.PROP.CL, Y.AA.CRG.PROP, '', RETURN.IDS, RET.VAL.AACRG, RET.ERROR)
        R.REC.AACRG = RAISE(RET.VAL.AACRG)
        Y.ALL.CRG = R.REC.AACRG<AA.ActivityCharges.ActivityCharges.ActChgCharge>
        IF Y.ALL.CRG NE '' THEN
            Y.ALL.CRG.LIST = DCOUNT(Y.ALL.CRG, @VM)
            FOR Y.M = 1 TO Y.ALL.CRG.LIST
                Y.CHARGES = Y.ALL.CRG<1,Y.M>
                Y.CHARGES.LIST = DCOUNT(Y.CHARGES, @SM)
                FOR Y.N = 1 TO Y.CHARGES.LIST
                    CHARGE1 = Y.CHARGES<1,1,Y.N>
                
*======================================================================
                    BEGIN CASE
                        CASE CHARGE1 EQ 'COURIERFEE'
                            Y.LCCOUR.PROP = 'COURIERFEE'
**Read AA.PRD.DES.CHARGE Property for bellow Fields
                            AA.Framework.GetArrangementConditions(Y.AA.ID, Y.AA.PROP.CL, Y.LCCOUR.PROP, '', RETURN.IDS, RET.VAL.LCCR, RET.ERROR)
                            R.REC.LCCR = RAISE(RET.VAL.LCCR)
                            Y.LCCR.AMNT = R.REC.LCCR<AA.Fees.Charge.FixedAmount>
                            EB.DataAccess.FRead(FN.FTCOM, Y.LCCOUR.PROP,REC.FTLCCR,F.FTCOM , E.FTCOM)
*                            Y.CR.DES = REC.FTLCCR<ST.ChargeConfig.FtCommissionType.FtFouDescription>
*                            Y.CR.PLCAT = REC.FTLCCR<ST.ChargeConfig.FtCommissionType.FtFouCategoryAccount>
                            Y.CR.DES = REC.FTLCCR<CG.ChargeConfig.FtCommissionType.FtFouDescription>
                            Y.CR.PLCAT = REC.FTLCCR<CG.ChargeConfig.FtCommissionType.FtFouCategoryAccount>
                            IF Y.LCCR.AMNT THEN
                                Y.LCCR.AMT = DROUND((Y.LCCR.AMNT / Y.LC.EXCHANGE.RATE),2)
                                Y.LCCR.DES = Y.CR.DES
                                Y.LCCR.PLCAT = Y.CR.PLCAT
                            END ELSE
                                Y.LCCR.AMT = ""
                                Y.LCCR.DES = ""
                                Y.LCCR.PLCAT = ""
                            END
*======================================================================
                        CASE CHARGE1 EQ 'LCSOURCETAX'
                            Y.LCSTX.PROP = 'LCSOURCETAX'
**Read AA.PRD.DES.CHARGE Property for bellow Fields
                            AA.Framework.GetArrangementConditions(Y.AA.ID, Y.AA.PROP.CL, Y.LCSTX.PROP, '', RETURN.IDS, RET.VAL.LCSTX, RET.ERROR)
                            R.REC.LCSTX = RAISE(RET.VAL.LCSTX)
                            Y.LCSTX.CRGRT = R.REC.LCSTX<AA.Fees.Charge.ChargeRate>
                            EB.DataAccess.FRead(FN.FTCOM,Y.LCSTX.PROP,REC.LCSTX,F.FTCOM , E.FTCOM)
*                            Y.STX.DES = REC.LCSTX<ST.ChargeConfig.FtCommissionType.FtFouDescription>
*                            Y.STX.CATF = REC.LCSTX<ST.ChargeConfig.FtCommissionType.FtFouCategoryAccount>
                            Y.STX.DES = REC.LCSTX<CG.ChargeConfig.FtCommissionType.FtFouDescription>
                            Y.STX.CATF = REC.LCSTX<CG.ChargeConfig.FtCommissionType.FtFouCategoryAccount>                            
                            Y.STX.CAT = Y.STX.CATF[1,8]
                            IF Y.LCSTX.CRGRT THEN
                                Y.LCSTX.AMT = (Y.LCSTX.CRGRT * Y.BL.DCBL) / 100
                                Y.LCSTX.DES = Y.STX.DES
                                Y.LCSTX.CAT = Y.STX.CAT
                            END ELSE
                                Y.LCSTX.DES = ""
                                Y.LCSTX.CAT = ""
                            END
*======================================================================
                        CASE CHARGE1 EQ 'LCCOLLCOM'
                            Y.LCCOL.PROP = 'LCCOLLCOM'
**Read AA.PRD.DES.CHARGE Property for bellow Fields
                            AA.Framework.GetArrangementConditions(Y.AA.ID, Y.AA.PROP.CL, Y.LCCOL.PROP, '', RETURN.IDS, RET.VAL.LCCOL, RET.ERROR)
                            R.REC.LCCOL = RAISE(RET.VAL.LCCOL)
                            Y.LCCOL.AMNT = R.REC.LCCOL<AA.Fees.Charge.FixedAmount>
                            EB.DataAccess.FRead(FN.FTCOM, Y.LCCOL.PROP,REC.FTLCCOL,F.FTCOM , E.FTCOM)
*                            Y.COL.DES = REC.FTLCCOL<ST.ChargeConfig.FtCommissionType.FtFouDescription>
*                            Y.LCCOL.CAT = REC.FTLCCOL<ST.ChargeConfig.FtCommissionType.FtFouCategoryAccount>
                            Y.COL.DES = REC.FTLCCOL<CG.ChargeConfig.FtCommissionType.FtFouDescription>
                            Y.LCCOL.CAT = REC.FTLCCOL<CG.ChargeConfig.FtCommissionType.FtFouCategoryAccount>                            
                            Y.COL.PLCAT = "PL":Y.LCCOL.CAT
        
                            IF Y.LCCOL.AMNT THEN
                                Y.LCCOL.AMT = DROUND((Y.LCCOL.AMNT / Y.LC.EXCHANGE.RATE),2)
                                Y.LCCOL.DES = Y.COL.DES
                                Y.LCCOL.PLCAT = Y.COL.PLCAT
                            END ELSE
                                Y.LCCOL.DES = ""
                                Y.LCCOL.PLCAT = ""
                            END
*======================================================================
                        CASE CHARGE1 EQ 'LCTAXEXP'
                            Y.LCTXEX.PROP = 'LCTAXEXP'
**Read AA.PRD.DES.CHARGE Property for bellow Fields
                            AA.Framework.GetArrangementConditions(Y.AA.ID, Y.AA.PROP.CL, Y.LCTXEX.PROP, '', RETURN.IDS, RET.VAL.LCTXEX, RET.ERROR)
                            R.REC.LCTXEX = RAISE(RET.VAL.LCTXEX)
                            Y.LCTXEX.RT = R.REC.LCTXEX<AA.Fees.Charge.ChargeRate>
                            EB.DataAccess.FRead(FN.FTCOM,Y.LCTXEX.PROP,REC.LCTXEX,F.FTCOM , E.FTCOM)
*                            Y.TXEX.DES = REC.LCTXEX<ST.ChargeConfig.FtCommissionType.FtFouDescription>
*                            Y.TXEX.CATF = REC.LCTXEX<ST.ChargeConfig.FtCommissionType.FtFouCategoryAccount>
                            Y.TXEX.DES = REC.LCTXEX<CG.ChargeConfig.FtCommissionType.FtFouDescription>
                            Y.TXEX.CATF = REC.LCTXEX<CG.ChargeConfig.FtCommissionType.FtFouCategoryAccount>
                            Y.TXEX.CAT = Y.TXEX.CATF[1,8]
                        
                            IF Y.LCTXEX.RT THEN
                                Y.LCTXEX.AMT = (Y.LCTXEX.RT * Y.BL.DCBL) / 100
                                Y.LCTXEX.DES = Y.TXEX.DES
                                Y.LCTXEX.CAT = Y.TXEX.CAT
                            END ELSE
                                Y.LCTXEX.DES = ""
                                Y.LCTXEX.CAT = ""
                            END
*======================================================================
                        CASE CHARGE1 EQ 'LCEXPCHG'
                            Y.LCEXCG.PROP = 'LCEXPCHG'
**Read AA.PRD.DES.CHARGE Property for bellow Fields
                            AA.Framework.GetArrangementConditions(Y.AA.ID, Y.AA.PROP.CL, Y.LCEXCG.PROP, '', RETURN.IDS, RET.VAL.LCEXCG, RET.ERROR)
                            R.REC.LCEXCG = RAISE(RET.VAL.LCEXCG)
                            Y.LCEXCG.AMNT = R.REC.LCEXCG<AA.Fees.Charge.FixedAmount>
                            EB.DataAccess.FRead(FN.FTCOM, Y.LCEXCG.PROP,REC.FTEXCG,F.FTCOM , E.FTCOM)
*                            Y.EXCG.DES = REC.FTEXCG<ST.ChargeConfig.FtCommissionType.FtFouDescription>
*                            Y.LCPOS.CAT = REC.FTEXCG<ST.ChargeConfig.FtCommissionType.FtFouCategoryAccount>
                            Y.EXCG.DES = REC.FTEXCG<CG.ChargeConfig.FtCommissionType.FtFouDescription>
                            Y.LCPOS.CAT = REC.FTEXCG<CG.ChargeConfig.FtCommissionType.FtFouCategoryAccount>                            
                            Y.EXCG.PLCAT = "PL":Y.LCPOS.CAT
        
                            IF Y.LCEXCG.AMNT THEN
                                Y.LCEXCG.AMT = DROUND((Y.LCEXCG.AMNT / Y.LC.EXCHANGE.RATE),2)
                                Y.LCEXCG.DES = Y.EXCG.DES
                                Y.LCEXCG.PLCAT = Y.EXCG.PLCAT
                            END ELSE
                                Y.LCEXCG.DES = ""
                                Y.LCEXCG.PLCAT = ""
                            END
*======================================================================
                        CASE CHARGE1 EQ 'LCPRECISSUE'
                            Y.LCPRC.PROP = 'LCPRECISSUE'
**Read AA.PRD.DES.CHARGE Property for bellow Fields
                            AA.Framework.GetArrangementConditions(Y.AA.ID, Y.AA.PROP.CL, Y.LCPRC.PROP, '', RETURN.IDS, RET.VAL.LCPRC, RET.ERROR)
                            R.REC.LCPRC = RAISE(RET.VAL.LCPRC)
                            Y.LCPRC.AMNT = R.REC.LCPRC<AA.Fees.Charge.FixedAmount>
                            EB.DataAccess.FRead(FN.FTCOM,Y.LCPRC.PROP,REC.LCPRC,F.FTCOM , E.FTCOM)
*                            Y.PRC.DES = REC.LCPRC<ST.ChargeConfig.FtCommissionType.FtFouDescription>
*                            Y.LCPRC.CAT = REC.LCPRC<ST.ChargeConfig.FtCommissionType.FtFouCategoryAccount>
                            Y.PRC.DES = REC.LCPRC<CG.ChargeConfig.FtCommissionType.FtFouDescription>
                            Y.LCPRC.CAT = REC.LCPRC<CG.ChargeConfig.FtCommissionType.FtFouCategoryAccount>                            
        
                            IF Y.LCPRC.AMNT THEN
                                Y.LCPRC.AMT = DROUND((Y.LCPRC.AMNT / Y.LC.EXCHANGE.RATE),2)
                                Y.LCPRC.DES = Y.PRC.DES
                                Y.LCPRC.PLCAT = Y.LCPRC.CAT
                            END ELSE
                                Y.LCPRC.DES = ""
                                Y.LCPRC.PLCAT = ""
                            END
*======================================================================
                        CASE CHARGE1 EQ 'LCSTAXRMG'
                            Y.LCTXRM.PROP = 'LCSTAXRMG'
**Read AA.PRD.DES.CHARGE Property for bellow Fields
                            AA.Framework.GetArrangementConditions(Y.AA.ID, Y.AA.PROP.CL, Y.LCTXRM.PROP, '', RETURN.IDS, RET.VAL.LCTXRM, RET.ERROR)
                            R.REC.LCTXRM = RAISE(RET.VAL.LCTXRM)
                            Y.LCTXRM.RT = R.REC.LCTXRM<AA.Fees.Charge.ChargeRate>
                            EB.DataAccess.FRead(FN.FTCOM,Y.LCTXRM.PROP,REC.LCTXRM,F.FTCOM , E.FTCOM)
*                            Y.TXRM.DES = REC.LCTXRM<ST.ChargeConfig.FtCommissionType.FtFouDescription>
*                            Y.TXRM.CATF = REC.LCTXRM<ST.ChargeConfig.FtCommissionType.FtFouCategoryAccount>
                            Y.TXRM.DES = REC.LCTXRM<CG.ChargeConfig.FtCommissionType.FtFouDescription>
                            Y.TXRM.CATF = REC.LCTXRM<CG.ChargeConfig.FtCommissionType.FtFouCategoryAccount>                            
                            Y.TXRM.CAT = Y.TXRM.CATF[1,8]
        
                            IF Y.LCTXRM.RT THEN
                                Y.LCTXRM.AMT = (Y.LCTXRM.RT * Y.BL.DCBL) / 100
                                Y.LCTXRM.DES = Y.TXRM.DES
                                Y.LCTXRM.CAT = Y.TXRM.CAT
                            END ELSE
                                Y.LCTXRM.DES = ""
                                Y.LCTXRM.CAT = ""
                            END
*======================================================================
                        CASE CHARGE1 EQ 'LCINSPFEE'
                            Y.LCINS.PROP = 'LCINSPFEE'
**Read AA.PRD.DES.CHARGE Property for bellow Fields
                            AA.Framework.GetArrangementConditions(Y.AA.ID, Y.AA.PROP.CL, Y.LCINS.PROP, '', RETURN.IDS, RET.VAL.LCINS, RET.ERROR)
                            R.REC.LCINS = RAISE(RET.VAL.LCINS)
                            Y.LCINS.RT = R.REC.LCINS<AA.Fees.Charge.ChargeRate>
                            EB.DataAccess.FRead(FN.FTCOM,Y.LCINS.PROP,REC.LCINS,F.FTCOM , E.FTCOM)
*                            Y.INS.DES = REC.LCINS<ST.ChargeConfig.FtCommissionType.FtFouDescription>
*                            Y.INS.CATF = REC.LCINS<ST.ChargeConfig.FtCommissionType.FtFouCategoryAccount>
                            Y.INS.DES = REC.LCINS<CG.ChargeConfig.FtCommissionType.FtFouDescription>
                            Y.INS.CATF = REC.LCINS<CG.ChargeConfig.FtCommissionType.FtFouCategoryAccount>                            
                            Y.INS.CAT = Y.INS.CAT[1,8]
        
                            IF Y.LCINS.RT THEN
                                Y.LCINS.AMT = (Y.LCINS.RT * Y.BL.DCBL) / 100
                                Y.LCINS.DES = Y.INS.DES
                                Y.LCINS.CAT = Y.INS.CAT
                            END ELSE
                                Y.LCINS.DES = ""
                                Y.LCINS.CAT = ""
                            END
*======================================================================
                        CASE CHARGE1 EQ 'CFRMG'
                            Y.LCCF.PROP = 'CFRMG'
**Read AA.PRD.DES.CHARGE Property for bellow Fields
                            AA.Framework.GetArrangementConditions(Y.AA.ID, Y.AA.PROP.CL, Y.LCCF.PROP, '', RETURN.IDS, RET.VAL.LCCF, RET.ERROR)
                            R.REC.LCCF = RAISE(RET.VAL.LCCF)
                            Y.LCCF.RT = R.REC.LCCF<AA.Fees.Charge.ChargeRate>
                            EB.DataAccess.FRead(FN.FTCOM,Y.LCCF.PROP,REC.LCCF,F.FTCOM , E.FTCOM)
*                            Y.CF.DES = REC.LCCF<ST.ChargeConfig.FtCommissionType.FtFouDescription>
*                            Y.CF.CATF = REC.LCCF<ST.ChargeConfig.FtCommissionType.FtFouCategoryAccount>
                            Y.CF.DES = REC.LCCF<CG.ChargeConfig.FtCommissionType.FtFouDescription>
                            Y.CF.CATF = REC.LCCF<CG.ChargeConfig.FtCommissionType.FtFouCategoryAccount>
                            Y.CF.CAT = Y.CF.CATF[1,8]
        
                            IF Y.LCCF.RT THEN
                                Y.LCCF.AMT = (Y.LCCF.RT * Y.BL.DCBL) / 100
                                Y.LCCF.DES = Y.CF.DES
                                Y.LCCF.CAT = Y.CF.CAT
                            END ELSE
                                Y.LCCF.DES = ""
                                Y.LCCF.CAT = ""
                            END
                    END CASE
*====================================================================
                NEXT Y.N
            NEXT Y.M
        END
*===============================================================
        Y.TOTAL.CRG = Y.LCCR.AMT + Y.LCSTX.AMT + Y.LCCOL.AMT + Y.LCSTX.AMT + Y.LCEXCG.AMT + Y.LCPRC.AMT + Y.LCTXRM.AMT + Y.LCINS.AMT + Y.LCCF.AMT
*=================================================================TOTAL OUTSTANDING FDBP
        SEL.CMD = 'SELECT ':FN.AA:' WITH PRODUCT.LINE EQ ':Y.PROD.LINE:' AND PRODUCT.GROUP EQ ':Y.PROD.GRP:' AND CUSTOMER EQ ':Y.AA.CUS:' AND ARR.STATUS EQ CURRENT EXPIRED'
        EB.DataAccess.Readlist(SEL.CMD, SEL.LIST, '', NO.OF.REC, SystemReturnCode)
        LOOP
            REMOVE Y.TOT.AA.ID FROM SEL.LIST SETTING POS
        WHILE Y.TOT.AA.ID:POS
            EB.DataAccess.FRead(FN.AA, Y.TOT.AA.ID, REC.OUT.AA, F.AA, Er.AAA)
            IF REC.OUT.AA THEN
                Y.AA.OUT.ACC = REC.OUT.AA<AA.Framework.Arrangement.ArrLinkedApplId>
                Y.AA.ARR.STS = REC.OUT.AA<AA.Framework.Arrangement.ArrArrStatus>
        
                AC.CashFlow.AccountserviceGetworkingbalance(Y.AA.OUT.ACC, REC.WRK.BAL, response.Details)
                Y.CUR.AMT = REC.WRK.BAL<AC.CashFlow.BalanceWorkingbal>

                TotalBal = TotalBal + Y.CUR.AMT
                IF Y.AA.ARR.STS EQ 'EXPIRED' THEN
                    TotalOdBal = TotalOdBal + Y.CUR.AMT
                    COUNTOD =  COUNTOD + 1
                END
            END
        REPEAT
        TotalAllBal = '-1' * TotalBal
        TotalAllOdBal = '-1' * TotalOdBal

*===============================================PC OUTSTADNING
        EB.DataAccess.FRead(FN.JOB, Y.JOB.NUM,REC.JOB.PC,F.JOB , E.JOB)
        IF REC.JOB.PC THEN
            Y.JOB.EXP.MD = REC.JOB.PC<BTB.JOB.TOT.EX.LC.DRAW.AMT>
            Y.LOAN.ID.ALL = REC.JOB.PC<BTB.JOB.PCECC.LOAN.ID>
            IF Y.LOAN.ID.ALL NE '' THEN
                Y.LOAN.ID.ALL.LIST = DCOUNT(Y.LOAN.ID.ALL, @VM)
                FOR Y.J = 1 TO Y.LOAN.ID.ALL.LIST
                    Y.LOAN.ID1 = Y.LOAN.ID.ALL<1,Y.J>
                    EB.DataAccess.FRead(FN.AA, Y.LOAN.ID1, REC.PC.AA, F.AA, Er.AAA)
                    Y.AA.OUT.ACC1 = REC.PC.AA<AA.Framework.Arrangement.ArrLinkedApplId>
                    Y.AA.ARR.STS = REC.PC.AA<AA.Framework.Arrangement.ArrArrStatus>
            
                    AC.CashFlow.AccountserviceGetworkingbalance(Y.AA.OUT.ACC1, REC.WRK.BAL1, response.Details)
                    Y.PC.CUR.AMT = REC.WRK.BAL1<AC.CashFlow.BalanceWorkingbal>

                    PCTotalBal = PCTotalBal + Y.PC.CUR.AMT
                NEXT Y.J
            END
            PCTotalAllBal = '-1' * PCTotalBal
        END
*===============================================================
        Y.STM.PROP = 'SETTLEMENT'
**Read AA.PRD.DES.TERM.AMOUNT Property for bellow Fields
        AA.Framework.GetArrangementConditions(Y.AA.ID, Y.AA.PROP.CL, Y.STM.PROP, '', RETURN.IDS, RET.VAL.STM, RET.ERROR)
        R.REC.STM = RAISE(RET.VAL.STM)
        Y.AA.CR.ACC = R.REC.STM<AA.Settlement.Settlement.SetPayoutAccount>
        EB.DataAccess.FRead(FN.AC, Y.AA.CR.ACC,REC.CR.AC,F.AC , E.ACCR)
        Y.CR.ACC.DES = REC.CR.AC<AC.AccountOpening.Account.AccountTitleOne>
        Y.AA.CR.AMT = Y.AA.AMT - Y.TOTAL.CRG

        Y.RETURN<-1> = Y.BR.NAME:'*':Y.CUS.N1:'*':Y.EX.LC.REF:'*':Y.EXP.BL.NO:'*':Y.LC.CURVAL:'*':Y.TF.REF:'*':Y.LC.EXP.DT:'*':Y.DR.VAL.DT:'*':Y.TENOR:'*':Y.BL.DOCVL:'*':Y.EXP.FM.NO:'*':Y.JOB.NUM:'*':TotalAllBal:'*':Y.JOB.EXP.MD:'*':TotalAllOdBal:'*':PCTotalAllBal:'*':COUNTOD:'*':Y.DISCREPENCE:'*':Y.DR.CUR:'*':Y.FC.HELD.AMT:'*':Y.FCAD.AMT:'*':Y.CAL:'*':Y.PUR.PCT:'*':Y.PR.FCAMT:'*':Y.AA.ID:'*':Y.LN.AA.AMT:'*':Y.ACC.NO:'*':Y.AA.MT.DT:'*':Y.EFF.DT:'*':Y.EXCH.RT:'*':Y.LCCR.PLCAT:'*':Y.LCCR.DES:'*':Y.LCCR.AMT:'*':Y.LCSTX.CAT:'*':Y.LCSTX.DES:'*':Y.LCSTX.AMT:'*':Y.LCCOL.PLCAT:'*':Y.LCCOL.DES:'*':Y.LCCOL.AMT:'*':Y.LCTXEX.CAT:'*':Y.LCTXEX.DES:'*':Y.LCTXEX.AMT:'*':Y.LCEXCG.PLCAT:'*':Y.LCEXCG.DES:'*':Y.LCEXCG.AMT:'*':Y.LCPRC.PLCAT:'*':Y.LCPRC.DES:'*':Y.LCPRC.AMT:'*':Y.LCTXRM.CAT:'*':Y.LCTXRM.DES:'*':Y.LCTXRM.AMT:'*':Y.LCINS.CAT:'*':Y.LCINS.DES:'*':Y.LCINS.AMT:'*':Y.LCCF.CAT:'*':Y.LCCF.DES:'*':Y.LCCF.AMT:'*':Y.AA.CR.ACC:'*':Y.CR.ACC.DES:'*':Y.AA.CR.AMT:'*':Y.LN.CIB.BDREF:'*':Y.SP.CMNT:'*':Y.AA.CUR
*--------------------------1------------2-------------3------------4--------------5-------------6---------------7----------------8-------------9-------------10-------------11------------12-------------13--------------14---------------15-----------------16-------------17-------------18--------------19---------------20------------21------------22----------23-----------24-------------25------------26-------------27-----------28-------------29-----------30--------------31-------------32-------------33---------------34--------------35--------------36----------------37---------------38-------------39---------------40-------------41----------------42-------------43--------------44-------------------45---------------46----------------47-------------48---------------49----------------50--------------51--------------52---------------53--------------54------------55-------------56-------------57--------------58--------------59--------------60----------------61---------------62-----------63-----------
    END
RETURN
END

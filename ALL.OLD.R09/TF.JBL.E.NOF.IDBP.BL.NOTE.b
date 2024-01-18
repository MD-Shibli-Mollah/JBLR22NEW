SUBROUTINE TF.JBL.E.NOF.IDBP.BL.NOTE(Y.RETURN)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Creation History :
*ENQUIRY NAME: JBL.ENQ.IDBP.BILL.NOTE
*SS - NOFILE.JBL.IDBP.BL.NOTE
*-----------------------------------------------------------------------------
*                                                  Created By - SHAJJAD HOSSEN,
*  16/01/2021                                      FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    
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
    
    
    FLD.POS = ''
    APPLICATION.NAME ='AA.ARR.ACCOUNT':FM:'LETTER.OF.CREDIT'
    LOCAL.FIELD = 'LINKED.TFDR.REF':VM:'LT.TF.JOB.NUMBR':VM:'LT.LN.PUR.PCT':VM:'LT.LN.BIL.DOCVL':VM:'LT.LN.PUR.FCAMT':VM:'LT.TF.EXCH.RATE':VM:'LT.LEGACY.ID':VM:'LT.TF.CIB.RPTRF':VM:'LT.TF.ACT.MT.DT':VM:'LT.TF.SPCL.CMNT':FM:'LT.TF.LC.TENOR'
*-------------------1----------------------2-------------------3-------------------4--------------------5-------------------6-------------------7--------------------8----------------9-------------------------10--------
    EB.Updates.MultiGetLocRef(APPLICATION.NAME,LOCAL.FIELD,FLD.POS)
    Y.TF.POS = FLD.POS<1,1>
    Y.JOB.NUM.POS = FLD.POS<1,2>
    Y.PUR.PER.POS = FLD.POS<1,3>
    Y.BL.DOCVL.POS = FLD.POS<1,4>
    Y.PR.FCAMT.POS = FLD.POS<1,5>
    Y.EXCH.RT.POS = FLD.POS<1,6>
    Y.EXP.BL.NO.POS = FLD.POS<1,7>
    Y.LN.CIB.BDREF.POS = FLD.POS<1,8>
    Y.ACT.MT.DT.POS = FLD.POS<1,9>
    Y.SPCL.CMNT.POS = FLD.POS<1,10>
    Y.TENOR.POS = FLD.POS<2,1>
    
    TotalBal = 0
    TotalOdBal = 0
    TotalAllBal = 0
    TotalAllOdBal = 0
    COUNTOD = 0
    Y.LCSTX.AMT = 0
    Y.LCCOL.RT = 0
    Y.BR.NAME = ''
    Y.DR.CUR = ''
    Y.DR.AMT = ''
    Y.CUS.N1 = ''
    Y.BK.CUS.N1 = ''
    Y.LC.APPL = ''
    Y.LN.CIB.BDREF = ''
    Y.EXP.BL.NO = ''
    Y.TF.REF = ''
    Y.DR.VAL.DT = ''
    Y.LC.ISS.BNK.REF = ''
    Y.LC.ISS.DT = ''
    Y.LC.CUR = ''
    Y.LC.AMT = ''
    Y.TENOR = ''
    Y.ACT.MT.DT = ''
    Y.JOB.NUM = ''
    Y.PUR.PCT = ''
    TotalAllBal = ''
    TotalAllOdBal = ''
    COUNTOD = ''
    Y.AA.ID = ''
    Y.EFF.DT = ''
    Y.ACC.NO = ''
    Y.AA.AMT = ''
    Y.AA.MT.DT = ''
    Y.BL.DOCVL = ''
    Y.PR.FCAMT = ''
    Y.CAL = ''
    Y.EXCH.RT = ''
    Y.LCAD.PLCAT = ''
    Y.LCAD.DES = ''
    Y.LCAD.AMT = ''
    Y.LCCOL.PLCAT = ''
    Y.LCCOL.DES = ''
    Y.LCCOL.AMT = ''
    Y.LCPOS.PLCAT = ''
    Y.LCPOS.DES = ''
    Y.LCPOS.AMT = ''
    Y.LCSTX.AMT = ''
    Y.AA.CR.ACC = ''
    Y.CR.ACC.DES = ''
    Y.AA.CR.AMT = ''
    Y.LCSTX.DES = ''
    Y.LCSTX.CAT = ''
    Y.AA.CUS = ''
    Y.SPCL.CMNT = ''
    
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
        
*******
RETURN
PROCESS:
*=====================
    Y.PROD.LINE = "LENDING"
    Y.PROD.GRP = "JBL.IDBP.LN"
*============================================================AA.ARRANGEMENT
*Read AA.ARR Application for Y.AA.CUS, Y.EFF.DT, Y.AA.STATUS, Y.ACC.NO, Y.AA.CO.CD Fields

    Y.AA.ID.LEN = LEN(Y.AA.ID)
    IF Y.AA.ID.LEN NE '12' THEN
        RETURN
    END ELSE
        
        EB.DataAccess.FRead(FN.AA, Y.AA.ID,REC.AA,F.AA , E.AA)
    
        Y.AA.CUS = REC.AA<AA.Framework.Arrangement.ArrCustomer>
        Y.EFF.DT = REC.AA<AA.Framework.Arrangement.ArrStartDate>
        Y.AA.STATUS = REC.AA<AA.Framework.Arrangement.ArrArrStatus>
        Y.ACC.NO = REC.AA<AA.Framework.Arrangement.ArrLinkedApplId>
        
        Y.AA.CO.CD = REC.AA<AA.Framework.Arrangement.ArrCoCode>
*=============================================================COMPANY
*Read COMPANY Application for Brance Name
        EB.DataAccess.FRead(FN.COM, Y.AA.CO.CD,REC.COM,F.COM , E.COM)
        Y.BR.NAME = REC.COM<ST.CompanyCreation.Company.EbComCompanyName>
*=================================================================

        SEL.CMD = 'SELECT ':FN.AA:' WITH PRODUCT.LINE EQ ':Y.PROD.LINE:' AND PRODUCT.GROUP EQ ':Y.PROD.GRP:' AND CUSTOMER EQ ':Y.AA.CUS:' AND ARR.STATUS EQ CURRENT EXPIRED'
        EB.DataAccess.Readlist(SEL.CMD, SEL.LIST, '', NO.OF.REC, SystemReturnCode)
        IF SEL.LIST THEN
            LOOP
                REMOVE Y.TOT.AA.ID FROM SEL.LIST SETTING POS
            WHILE Y.TOT.AA.ID:POS
                EB.DataAccess.FRead(FN.AA, Y.TOT.AA.ID, REC.OUT.AA, F.AA, Er.AAA)
                Y.AA.OUT.ACC = REC.OUT.AA<AA.Framework.Arrangement.ArrLinkedApplId>
                Y.AA.ARR.STS = REC.OUT.AA<AA.Framework.Arrangement.ArrArrStatus>
        
                AC.CashFlow.AccountserviceGetworkingbalance(Y.AA.OUT.ACC, REC.WRK.BAL, response.Details)
                Y.CUR.AMT = REC.WRK.BAL<AC.CashFlow.BalanceWorkingbal>

                TotalBal = TotalBal + Y.CUR.AMT
            
                IF Y.AA.ARR.STS EQ 'EXPIRED' THEN
                    TotalOdBal = TotalOdBal + Y.CUR.AMT
                    COUNTOD =  COUNTOD + 1
                END

            REPEAT
        END
        TotalAllBal = '-1' * TotalBal
        TotalAllOdBal = '-1' * TotalOdBal
*=================================================================ACCOUNT PROP
        Y.AA.PROP = 'ACCOUNT'
*Read AA.PRD.DES.ACCOUNT Property for bellow Fields
        AA.Framework.GetArrangementConditions(Y.AA.ID, Y.AA.PROP.CL, Y.AA.PROP, '', RETURN.IDS, RET.VAL.AA, RET.ERROR)
        R.REC.AC = RAISE(RET.VAL.AA)
        Y.TF.REF = R.REC.AC<AA.Account.Account.AcLocalRef,Y.TF.POS>
        Y.JOB.NUM = R.REC.AC<AA.Account.Account.AcLocalRef,Y.JOB.NUM.POS>
        Y.PUR.PRCT = R.REC.AC<AA.Account.Account.AcLocalRef,Y.PUR.PER.POS>
        Y.PUR.PCT = Y.PUR.PRCT:"%"
        Y.BL.DOCVL = R.REC.AC<AA.Account.Account.AcLocalRef,Y.BL.DOCVL.POS>
        Y.BL.DCBL.LEN = LEN(Y.BL.DOCVL)
        Y.BL.DCBL = Y.BL.DOCVL[4,Y.BL.DCBL.LEN]
        Y.PR.FCAMT = R.REC.AC<AA.Account.Account.AcLocalRef,Y.PR.FCAMT.POS>
        Y.PR.FCAMNT.LEN = LEN(Y.PR.FCAMT)
        Y.PR.FCAMNT = Y.PR.FCAMT[4,Y.PR.FCAMNT.LEN]
        Y.CALC = Y.BL.DCBL - Y.PR.FCAMNT
        Y.EXCH.RATE = R.REC.AC<AA.Account.Account.AcLocalRef,Y.EXCH.RT.POS>
        Y.EXCH.RT = Y.EXCH.RATE:"%"
        Y.EXP.BL.NO = R.REC.AC<AA.Account.Account.AcLocalRef,Y.EXP.BL.NO.POS>
        Y.ACT.MT.DT = R.REC.AC<AA.Account.Account.AcLocalRef,Y.ACT.MT.DT.POS>
        Y.LN.CIB.BDREF = R.REC.AC<AA.Account.Account.AcLocalRef,Y.LN.CIB.BDREF.POS>
        Y.SPCL.CMNT = R.REC.AC<AA.Account.Account.AcLocalRef,Y.SPCL.CMNT.POS>
        
*======================================================COMMITMENT PROP
        Y.TA.PROP = 'COMMITMENT'
*Read AA.PRD.DES.TERM.AMOUNT Property for bellow Fields
        AA.Framework.GetArrangementConditions(Y.AA.ID, Y.AA.PROP.CL, Y.TA.PROP, '', RETURN.IDS, RET.VAL.TA, RET.ERROR)
        R.REC.TA = RAISE(RET.VAL.TA)
        Y.AA.AMT = R.REC.TA<AA.TermAmount.TermAmount.AmtAmount>
        Y.AA.MT.DT = R.REC.TA<AA.TermAmount.TermAmount.AmtMaturityDate>
        
*=============================================================DRAWING APPL
        EB.DataAccess.FRead(FN.DR, Y.TF.REF,REC.DR,F.DR , E.DR)
        IF REC.DR THEN
*Read DRAWINGS Application
            Y.DR.CUR = REC.DR<LC.Contract.Drawings.TfDrDrawCurrency>
            Y.DR.AMT = REC.DR<LC.Contract.Drawings.TfDrDocumentAmount>
            Y.DR.VAL.DT = REC.DR<LC.Contract.Drawings.TfDrValueDate>
        END
*========================================================================
        Y.CAL = Y.DR.CUR:Y.CALC
        
*==============================================================LC APPL
        Y.LC.NO = Y.TF.REF[1,12]
        EB.DataAccess.FRead(FN.LC, Y.LC.NO, REC.LC, F.LC, E.LC)
*Read LETTER.OF.CREDIT Application
        Y.LC.CUR = REC.LC<LC.Contract.LetterOfCredit.TfLcLcCurrency>
        Y.LC.AMT = REC.LC<LC.Contract.LetterOfCredit.TfLcLcAmount>
        Y.TENOR = REC.LC<LC.Contract.LetterOfCredit.TfLcLocalRef,Y.TENOR.POS>
        Y.LC.ISS.BNK.NO = REC.LC<LC.Contract.LetterOfCredit.TfLcIssuingBankNo>
        Y.LC.APPLI = REC.LC<LC.Contract.LetterOfCredit.TfLcApplicant>
        Y.LC.APPL = FIELD(Y.LC.APPLI,VM,1)
        Y.LC.ISS.BNK.REF = REC.LC<LC.Contract.LetterOfCredit.TfLcIssBankRef>
        Y.LC.ISS.DT = REC.LC<LC.Contract.LetterOfCredit.TfLcIssueDate>
*==============================================================
*Read CUSTOMER Application

        EB.DataAccess.FRead(FN.CUS, Y.AA.CUS, REC.CUS, F.CUS, E.CUS)
        Y.CUS.N1 = REC.CUS< ST.Customer.Customer.EbCusNameOne>
        EB.DataAccess.FRead(FN.CUS, Y.LC.ISS.BNK.NO, REC.BANK.CUS, F.CUS, E.CUS)
        Y.BK.CUS.N1 = REC.BANK.CUS< ST.Customer.Customer.EbCusNameOne>
*=======================================================================ACTIVITY.CHARGE
        Y.AA.CRG.PROP = 'ACTIVITY.CHARGES'
**Read AA.PRD.DES.CHARGE Property for bellow Fields
        AA.Framework.GetArrangementConditions(Y.AA.ID, Y.AA.PROP.CL, Y.AA.CRG.PROP, '', RETURN.IDS, RET.VAL.AACRG, RET.ERROR)
        R.REC.AACRG = RAISE(RET.VAL.AACRG)
        Y.ALL.CRG = R.REC.AACRG<AA.ActivityCharges.ActivityCharges.ActChgCharge>
        IF Y.ALL.CRG NE '' THEN
            Y.ALL.CRG.LIST = DCOUNT(Y.ALL.CRG, @VM)
            FOR Y.P = 1 TO Y.ALL.CRG.LIST
                Y.CHARGES = Y.ALL.CRG<1,Y.P>
                Y.CHARGES.LIST = DCOUNT(Y.CHARGES, @SM)
                FOR Y.Q = 1 TO Y.CHARGES.LIST
                    CHARGE1 = Y.CHARGES<1,1,Y.Q>
*======================================================================
                    BEGIN CASE
                        CASE CHARGE1 EQ 'LCADVISE'
                            Y.LCAD.PROP = 'LCADVISE'
**Read AA.PRD.DES.CHARGE Property for bellow Fields
                            AA.Framework.GetArrangementConditions(Y.AA.ID, Y.AA.PROP.CL, Y.LCAD.PROP, '', RETURN.IDS, RET.VAL.LCAD, RET.ERROR)
                            R.REC.LCAD = RAISE(RET.VAL.LCAD)
                            Y.LCAD.AMT = R.REC.LCAD<AA.Fees.Charge.FixedAmount>
                            EB.DataAccess.FRead(FN.FTCOM, Y.LCAD.PROP,REC.FTLCAD,F.FTCOM , E.FTCOM)
*                            Y.LCAD.DES = REC.FTLCAD<ST.ChargeConfig.FtCommissionType.FtFouDescription>
*                            Y.LCAD.CAT = REC.FTLCAD<ST.ChargeConfig.FtCommissionType.FtFouCategoryAccount>
                            Y.LCAD.DES = REC.FTLCAD<CG.ChargeConfig.FtCommissionType.FtFouDescription>
                            Y.LCAD.CAT = REC.FTLCAD<CG.ChargeConfig.FtCommissionType.FtFouCategoryAccount>
                            Y.LCAD.PLCAT = "PL":Y.LCAD.CAT
*======================================================================
                        CASE CHARGE1 EQ 'LCCOLLCOM'
                            Y.LCCOL.PROP = 'LCCOLLCOM'
**Read AA.PRD.DES.CHARGE Property for bellow Fields
                            AA.Framework.GetArrangementConditions(Y.AA.ID, Y.AA.PROP.CL, Y.LCCOL.PROP, '', RETURN.IDS, RET.VAL.LCCOL, RET.ERROR)
                            R.REC.LCCOL = RAISE(RET.VAL.LCCOL)
                            Y.LCCOL.AMT = R.REC.LCCOL<AA.Fees.Charge.FixedAmount>
                            EB.DataAccess.FRead(FN.FTCOM, Y.LCCOL.PROP,REC.FTLCCOL,F.FTCOM , E.FTCOM)
*                            Y.COL.DES = REC.FTLCCOL<ST.ChargeConfig.FtCommissionType.FtFouDescription>
*                            Y.LCCOL.CAT = REC.FTLCCOL<ST.ChargeConfig.FtCommissionType.FtFouCategoryAccount>
                            Y.COL.DES = REC.FTLCCOL<CG.ChargeConfig.FtCommissionType.FtFouDescription>
                            Y.LCCOL.CAT = REC.FTLCCOL<CG.ChargeConfig.FtCommissionType.FtFouCategoryAccount>
                            Y.COL.PLCAT = "PL":Y.LCCOL.CAT
        
                            IF Y.LCCOL.AMT THEN
                                Y.LCCOL.DES = Y.COL.DES
                                Y.LCCOL.PLCAT = Y.COL.PLCAT
                            END ELSE
                                Y.LCCOL.DES = ""
                                Y.LCCOL.PLCAT = ""
                            END
*======================================================================
                        CASE CHARGE1 EQ 'LCPOSTAGE'
                            Y.LCPOS.PROP = 'LCPOSTAGE'
**Read AA.PRD.DES.CHARGE Property for bellow Fields
                            AA.Framework.GetArrangementConditions(Y.AA.ID, Y.AA.PROP.CL, Y.LCPOS.PROP, '', RETURN.IDS, RET.VAL.LCPOS, RET.ERROR)
                            R.REC.LCPOS = RAISE(RET.VAL.LCPOS)
                            Y.LCPOS.AMT = R.REC.LCPOS<AA.Fees.Charge.FixedAmount>
                            EB.DataAccess.FRead(FN.FTCOM, Y.LCPOS.PROP,REC.FTPOS,F.FTCOM , E.FTCOM)
*                            Y.POS.DES = REC.FTPOS<ST.ChargeConfig.FtCommissionType.FtFouDescription>
*                            Y.LCPOS.CAT = REC.FTPOS<ST.ChargeConfig.FtCommissionType.FtFouCategoryAccount>
                           Y.POS.DES = REC.FTPOS<CG.ChargeConfig.FtCommissionType.FtFouDescription>
                            Y.LCPOS.CAT = REC.FTPOS<CG.ChargeConfig.FtCommissionType.FtFouCategoryAccount>                            
                            Y.POS.PLCAT = "PL":Y.LCPOS.CAT
        
                            IF Y.LCCOL.AMT THEN
                                Y.LCPOS.DES = Y.POS.DES
                                Y.LCPOS.PLCAT = Y.POS.PLCAT
                            END ELSE
                                Y.LCPOS.DES = ""
                                Y.LCPOS.PLCAT = ""
                            END
*======================================================================
                        CASE CHARGE1 EQ 'LCSTAXDMEXP'
                            Y.LCSTX.PROP = 'LCSTAXDMEXP'
**Read AA.PRD.DES.CHARGE Property for bellow Fields
                            AA.Framework.GetArrangementConditions(Y.AA.ID, Y.AA.PROP.CL, Y.LCSTX.PROP, '', RETURN.IDS, RET.VAL.LCSTX, RET.ERROR)
                            R.REC.LCSTX = RAISE(RET.VAL.LCSTX)
                            Y.LCSTX.RT = R.REC.LCSTX<AA.Fees.Charge.ChargeRate>
                            EB.DataAccess.FRead(FN.FTCOM, Y.LCSTX.PROP,REC.LCSTX,F.FTCOM , E.FTCOM)
*                            Y.STX.DES = REC.LCSTX<ST.ChargeConfig.FtCommissionType.FtFouDescription>
*                            Y.STX.CATF = REC.LCSTX<ST.ChargeConfig.FtCommissionType.FtFouCategoryAccount>
                            Y.STX.DES = REC.LCSTX<CG.ChargeConfig.FtCommissionType.FtFouDescription>
                            Y.STX.CATF = REC.LCSTX<CG.ChargeConfig.FtCommissionType.FtFouCategoryAccount>
                            Y.STX.CAT = Y.STX.CATF[1,8]
                            IF Y.LCSTX.RT THEN
                                Y.LCSTX.AMT = (Y.LCSTX.RT * Y.AA.AMT) / 100
                                Y.LCSTX.DES = Y.STX.DES
                                Y.LCSTX.CAT = Y.STX.CAT
                            END ELSE
                                Y.LCSTX.AMT = ""
                                Y.LCSTX.DES = ""
                                Y.LCSTX.CAT = ""
                            END
                    END CASE
*====================================================================
                NEXT Y.Q
            NEXT Y.P
        END
*===============================================================
        Y.TOTAL.CRG = Y.LCAD.AMT + Y.LCCOL.AMT + Y.LCPOS.AMT + Y.LCSTX.AMT

*===============================================================
        Y.STM.PROP = 'SETTLEMENT'
**Read AA.PRD.DES.TERM.AMOUNT Property for bellow Fields
        AA.Framework.GetArrangementConditions(Y.AA.ID, Y.AA.PROP.CL, Y.STM.PROP, '', RETURN.IDS, RET.VAL.STM, RET.ERROR)
        R.REC.STM = RAISE(RET.VAL.STM)
        Y.AA.CR.ACC = R.REC.STM<AA.Settlement.Settlement.SetPayoutAccount>
        EB.DataAccess.FRead(FN.AC, Y.AA.CR.ACC,REC.CR.AC,F.AC , E.ACCR)
        Y.CR.ACC.DES = REC.CR.AC<AC.AccountOpening.Account.AccountTitleOne>
        Y.AA.CR.AMT = Y.AA.AMT - Y.TOTAL.CRG

        Y.RETURN<-1> = Y.BR.NAME:'*':Y.DR.CUR:'*':Y.DR.AMT:'*':Y.CUS.N1:'*':Y.BK.CUS.N1:'*':Y.LC.APPL:'*':Y.LN.CIB.BDREF:'*':Y.EXP.BL.NO:'*':Y.TF.REF:'*':Y.DR.VAL.DT:'*':Y.LC.ISS.BNK.REF:'*':Y.LC.ISS.DT:'*':Y.LC.CUR:'*':Y.LC.AMT:'*':Y.TENOR:'*':Y.ACT.MT.DT:'*':Y.JOB.NUM:'*':Y.PUR.PCT:'*':TotalAllBal:'*':TotalAllOdBal:'*':COUNTOD:'*':Y.AA.ID:'*':Y.EFF.DT:'*':Y.ACC.NO:'*':Y.AA.AMT:'*':Y.AA.MT.DT:'*':Y.BL.DOCVL:'*':Y.PR.FCAMT:'*':Y.CAL:'*':Y.EXCH.RT:'*':Y.LCAD.PLCAT:'*':Y.LCAD.DES:'*':Y.LCAD.AMT:'*':Y.LCCOL.PLCAT:'*':Y.LCCOL.DES:'*':Y.LCCOL.AMT:'*':Y.LCPOS.PLCAT:'*':Y.LCPOS.DES:'*':Y.LCPOS.AMT:'*':Y.LCSTX.AMT:'*':Y.AA.CR.ACC:'*':Y.CR.ACC.DES:'*':Y.AA.CR.AMT:'*':Y.LCSTX.DES:'*':Y.LCSTX.CAT:'*':Y.AA.CUS:'*':Y.SPCL.CMNT
*-------------------------1------------2------------3------------4--------------5-------------6---------------7----------------8-------------9-------------10----------------11----------------12-------------13-----------14-----------15-------------16-------------17------------18----------19---------------20--------------21----------22-----------23----------24-----------25------------26-------------27--------------28----------29-----------30--------------31-------------32-------------33---------------34--------------35--------------36----------------37---------------38-------------39---------------40-------------41----------------42-------------43--------------44---------------45------------46-------------47-------
    END
RETURN
END

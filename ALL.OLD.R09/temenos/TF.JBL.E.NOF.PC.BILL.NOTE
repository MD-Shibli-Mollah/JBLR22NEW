SUBROUTINE TF.JBL.E.NOF.PC.BILL.NOTE(Y.RETURN)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Creation History :
* Enquiry Name : JBL.ENQ.PC.BILL.NOTE
* SS - NOFILE.JBL.PC.BILL.NOTE
*-----------------------------------------------------------------------------
*                                                  RETROFIT - SHAJJAD HOSSEN,
*  01/02/2021                                      FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BD.BTB.JOB.REGISTER
    $INSERT I_F.BD.SCT.CAPTURE
    
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
    $USING AA.Limit
    $USING LI.Config
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
    FN.LMT = 'F.LIMIT'
    F.LMT = ''
    FN.JOB = 'F.BD.BTB.JOB.REGISTER'
    F.JOB = ''
    FN.SC = 'F.BD.SCT.CAPTURE'
    F.SC = ''
   
    
    
    FLD.POS = ''
    APPLICATION.NAME ='AA.ARR.ACCOUNT':FM:'LETTER.OF.CREDIT'
    LOCAL.FIELD = 'LT.TF.JOB.NUMBR':VM:'LT.TF.EXCH.RATE':VM:'LT.TF.DOC.VL.FC':VM:'LT.TF.CIB.RPTRF':VM:'LT.TF.SPCL.CMNT':FM:'LT.TF.FRGHT.CHG':VM:'LT.TF.INS.AGCOM':VM:'LT.TF.LAGENTCOM':VM:'LT.TF.FORGN.CHG':VM:'LT.TF.BTB.ENTRT'
    EB.Updates.MultiGetLocRef(APPLICATION.NAME,LOCAL.FIELD,FLD.POS)
    Y.JOB.NUM.POS = FLD.POS<1,1>
    Y.EXCH.RT.POS = FLD.POS<1,2>
    Y.EXP.BL.NO.POS = FLD.POS<1,3>
    Y.CIB.RPTRF.POS = FLD.POS<1,4>
    Y.SPCL.CMNT.POS = FLD.POS<1,5>

    Y.FRGHT.POS = FLD.POS<2,1>
    Y.COMCRG.POS = FLD.POS<2,2>
    Y.AGNTCOM.POS = FLD.POS<2,3>
    Y.LC.FRGN.CRG.POS = FLD.POS<2,4>
    Y.BTB.ENT.POS = FLD.POS<2,5>
    
    TotalBal = 0
    TotalOdBal = 0
    TotalAllBal = 0
    TotalAllOdBal = 0
    COUNTOD = 0
    Y.RMR.AMT = 0
    Y.PC.AVL.LCY = 0
    Y.LC.SPDT = 0
    Y.SC.SPDT = 0
    Y.LC.FRGHT.TOT = 0
    Y.LC.COM.TOT = 0
    Y.LC.CRG.TOT = 0
    Y.TOT.CT.CRG = 0
    Y.TOT.CT.CM = 0
    Y.TOT.CT.FR = 0
    Y.SC.CT.NO = 0
    Y.LSHIP.DT = 0
    Y.LS.FRT = 0
    Y.FOB.VAL = 0
    Y.TOT.CRG = 0
    Y.TOT.COM = 0
    Y.TCRG.TCOM = 0
    Y.NET.FOB = 0
    Y.TOT.INT.AMT = 0
    Y.EXP.LCNO = 0
    Y.TOT.INT.AMT.GRP = 0
    Y.LC.CRG.TOT1 = 0
    Y.LC.CRG.TOT2 = 0
    COUNTRT1 = 0
    COUNTRT2 = 0
    Y.LC.BTB.ENTRT = 0
    Y.SC.BTB.ENTRT = 0
    Y.ENT.FOB.PER = 0
    Y.BTB.ENT.RT = 0
    Y.SC.CT.NO.ALL = ''
    Y.EX.LC.NO.ALL = ''
    
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
    EB.DataAccess.Opf(FN.LMT, F.LMT)
    EB.DataAccess.Opf(FN.JOB, F.JOB)
    EB.DataAccess.Opf(FN.SC, F.SC)
        
*******
RETURN
PROCESS:

*=====================
    Y.PROD.LINE = "LENDING"
    Y.PROD.GRP = "JBL.PACK.CR.LN"
    
    Y.AA.ID.LEN = LEN(Y.AA.ID)
    IF Y.AA.ID.LEN NE '12' THEN
        RETURN
    END ELSE
*============================================================AA.ARRANGEMENT
*Read AA.ARR Application for Y.AA.CUS, Y.EFF.DT, Y.AA.STATUS, Y.ACC.NO, Y.AA.CO.CD Fields
        EB.DataAccess.FRead(FN.AA, Y.AA.ID,REC.AA,F.AA , E.AA)
        Y.AA.CUS = REC.AA<AA.Framework.Arrangement.ArrCustomer>
        Y.EFF.DT = REC.AA<AA.Framework.Arrangement.ArrStartDate>
        Y.AA.CUR = REC.AA<AA.Framework.Arrangement.ArrCurrency>
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
*==============================LIMIT PROPERTY
        Y.LMT.PROP = 'LIMIT'
*Read AA.PRD.DES.ACCOUNT Property for bellow Fields
        AA.Framework.GetArrangementConditions(Y.AA.ID, Y.AA.PROP.CL, Y.LMT.PROP, '', RETURN.IDS, RET.VAL.LMT, RET.ERROR)
        R.REC.LMT = RAISE(RET.VAL.LMT)
        Y.CUS.LMT = R.REC.LMT<AA.Limit.Limit.LimLimitReference>
*=================================================================ACCOUNT PROP
        Y.AA.PROP = 'ACCOUNT'
*Read AA.PRD.DES.ACCOUNT Property for bellow Fields
        AA.Framework.GetArrangementConditions(Y.AA.ID, Y.AA.PROP.CL, Y.AA.PROP, '', RETURN.IDS, RET.VAL.AA, RET.ERROR)
        R.REC.AC = RAISE(RET.VAL.AA)
        Y.JOB.NUM = R.REC.AC<AA.Account.Account.AcLocalRef,Y.JOB.NUM.POS>
        Y.EXCH.RATE = R.REC.AC<AA.Account.Account.AcLocalRef,Y.EXCH.RT.POS>
        Y.DOC.VL.FC = R.REC.AC<AA.Account.Account.AcLocalRef,Y.EXP.BL.NO.POS>
        Y.EXCH.RT = Y.EXCH.RATE:"%"
        Y.CIB.RPTRF = R.REC.AC<AA.Account.Account.AcLocalRef,Y.CIB.RPTRF.POS>
        Y.SPCL.CMNT = R.REC.AC<AA.Account.Account.AcLocalRef,Y.SPCL.CMNT.POS>
        
*==========================================================JOB.REGISTER
        EB.DataAccess.FRead(FN.JOB, Y.JOB.NUM,REC.JOB,F.JOB , E.JOB)
        Y.TF.REF = REC.JOB<BTB.JOB.EX.TF.REF>
        Y.JOB.CUR = REC.JOB<BTB.JOB.JOB.CURRENCY>
        Y.SC.ALL = REC.JOB<BTB.JOB.CONT.REFNO>
        Y.EXP.DT = REC.JOB<BTB.JOB.JOB.EXPIRY.DATE>
        Y.EX.LC.NO = REC.JOB<BTB.JOB.EX.LC.NUMBER>
        Y.IMP.ENT = REC.JOB<BTB.JOB.TOT.BTB.ENT.AMT>
        Y.BTB.OP = REC.JOB<BTB.JOB.TOT.BTB.AMT>
        Y.JOB.AMT = REC.JOB<BTB.JOB.TOT.EX.LC.AMT>
        Y.JSHIP.MD = REC.JOB<BTB.JOB.TOT.EX.LC.DRAW.AMT>
        Y.PC.ENT = REC.JOB<BTB.JOB.TOT.PC.ENT.AMT>
        Y.PC.AVL.US = REC.JOB<BTB.JOB.TOT.PC.AMT>
        Y.PC.AVL.RM = REC.JOB<BTB.JOB.TOT.PC.AVL.AMT>
        Y.AVL.RM = Y.EXCH.RATE * Y.PC.AVL.RM
        Y.RMR.DR.ALL = REC.JOB<BTB.JOB.IM.TF.REF>
        Y.PC.AVL.TK = REC.JOB<BTB.JOB.LOAN.AMT.LCY>
        Y.JSHIP.DU = Y.JOB.AMT - Y.JSHIP.MD
    
        Y.TT.NT.FOB.VAL = REC.JOB<BTB.JOB.TOT.NET.FOB.VALUE>
        Y.TT.BTB.ENT.AMT = REC.JOB<BTB.JOB.TOT.BTB.ENT.AMT>
        
*********************** Dr Amount of IM.TF.REF Field In JOB Application*************************
        IF Y.RMR.DR.ALL NE '' THEN
            Y.RMR.DR.LIST = DCOUNT(Y.RMR.DR.ALL, @VM)
            FOR Y.I = 1 TO Y.RMR.DR.LIST
                Y.RMR.DR.ID = Y.RMR.DR.ALL<1,Y.I>
                EB.DataAccess.FRead(FN.LC, Y.RMR.DR.ID,REC.LC2,F.LC , E.LC2)
*Read DRAWINGS Application
                Y.DR.AMT = REC.LC2<LC.Contract.LetterOfCredit.TfLcDrawings>
*            Y.DR.VAL.DT = REC.DR<LC.Contract.Drawings.TfDrValueDate>
                Y.RMR.AMT = Y.RMR.AMT + Y.DR.AMT
            NEXT Y.I
        END ELSE
            Y.RMR.AMT = '0'
        END
    
*---------------------- PC Available AMount Calculation LCY --------
        IF Y.PC.AVL.TK NE '' THEN
            Y.PC.AVL.TK.LIST = DCOUNT(Y.PC.AVL.TK, @VM)
            FOR Y.J = 1 TO Y.PC.AVL.TK.LIST
                Y.PC.AVL.TK1 = Y.PC.AVL.TK<1,Y.J>
                Y.PC.AVL.LCY = Y.PC.AVL.LCY + Y.PC.AVL.TK1
            NEXT Y.J
        END ELSE
            Y.PC.AVL.LCY = '0'
        END
    
*********************Read Applicant Name.1 ****************************
        IF Y.SC.ALL NE '' THEN
            Y.SC.ID1 = FIELD(Y.SC.ALL,VM,1)
            EB.DataAccess.FRead(FN.SC, Y.SC.ID1, REC.SC1, F.SC, E.SC1)
            Y.BUR.NAME = REC.SC1<SCT.BUYER.NAME>
            Y.APP.N1 = FIELD(Y.BUR.NAME,VM,1)
        END ELSE
            Y.TF.REF1 = FIELD(Y.TF.REF,VM,1)
            EB.DataAccess.FRead(FN.LC, Y.TF.REF1, REC.LC1, F.LC, E.LC1)
            Y.LC.APPLI = REC.LC1<LC.Contract.LetterOfCredit.TfLcApplicant>
            Y.APP.N1 = FIELD(Y.LC.APPLI,VM,1)
        END
    
*====================Read LC Application ================================
        IF Y.TF.REF NE '' THEN
            Y.TF.REF.LIST = DCOUNT(Y.TF.REF, @VM)
            FOR Y.K = 1 TO Y.TF.REF.LIST
                Y.TF.REF.LC = Y.TF.REF<1,Y.K>
                EB.DataAccess.FRead(FN.LC, Y.TF.REF.LC, REC.LC, F.LC, E.LC)
                Y.LC.SHP.DT = REC.LC<LC.Contract.LetterOfCredit.TfLcLatestShipment>
                IF Y.LC.SHP.DT GT Y.LC.SPDT THEN
                    Y.LC.SPDT = Y.LC.SHP.DT
                END
            
                Y.FRGHT.AMT = REC.LC<LC.Contract.LetterOfCredit.TfLcLocalRef,Y.FRGHT.POS>
                Y.LC.FRGHT.TOT = Y.LC.FRGHT.TOT + Y.FRGHT.AMT
                
                Y.LC.FRNG.AMT = REC.LC<LC.Contract.LetterOfCredit.TfLcLocalRef,Y.LC.FRGN.CRG.POS>
                Y.LC.CRG.TOT1 = Y.LC.CRG.TOT1 + Y.LC.FRNG.AMT
                
                Y.CRG.AMT = REC.LC<LC.Contract.LetterOfCredit.TfLcLocalRef,Y.COMCRG.POS>
                Y.LC.CRG.TOT2 = Y.LC.CRG.TOT2 + Y.CRG.AMT
                
                Y.COM.AMT = REC.LC<LC.Contract.LetterOfCredit.TfLcLocalRef,Y.AGNTCOM.POS>
                Y.LC.COM.TOT = Y.LC.COM.TOT + Y.COM.AMT
                
                Y.BTB.ENT = REC.LC<LC.Contract.LetterOfCredit.TfLcLocalRef,Y.BTB.ENT.POS>
                Y.LC.BTB.ENTRT = Y.LC.BTB.ENTRT + Y.BTB.ENT
                IF Y.BTB.ENT THEN
                    COUNTRT1 = COUNTRT1 + 1
                END
            NEXT Y.K
        END
        
         
*========================Read SC Templete =============================
        IF Y.SC.ALL NE '' THEN
            Y.SC.ALL.LIST = DCOUNT(Y.SC.ALL, @VM)
            FOR Y.M = 1 TO Y.SC.ALL.LIST
                Y.SC.ID = Y.SC.ALL<1,Y.M>
                EB.DataAccess.FRead(FN.SC, Y.SC.ID, REC.SC, F.SC, E.SC)
                Y.CONT.SHIPDT = REC.SC<SCT.SHIPMENT.DATE>
                IF Y.CONT.SHIPDT GT Y.SC.SPDT THEN
                    Y.SC.SPDT = Y.CONT.SHIPDT
                END
            
                Y.CONT.REF = REC.SC<SCT.CONTRACT.NUMBER>
                Y.SC.CT.NO = Y.SC.CT.NO : Y.CONT.REF
                
                Y.CONT.FRGHT = REC.SC<SCT.FREIGHT.CHARGES>
                Y.TOT.CT.FR = Y.TOT.CT.FR + Y.CONT.FRGHT
                
                Y.CONT.CRG = REC.SC<SCT.FOREIGN.CHARGES>
                Y.TOT.CT.CRG = Y.TOT.CT.CRG + Y.CONT.CRG
                
                Y.CONT.COM = REC.SC<SCT.LOC.AGENT.COMM>
                Y.TOT.CT.CM = Y.TOT.CT.CM + Y.CONT.COM
                
                Y.SC.BTB.ENT = REC.SC<SCT.BTB.ENT.RATE>
                Y.SC.BTB.ENTRT = Y.SC.BTB.ENTRT + Y.SC.BTB.ENT
                IF Y.SC.BTB.ENT THEN
                    COUNTRT2 = COUNTRT2 + 1
                END
                
            NEXT Y.M
        END
*===========================================EX LC SEPERATOR===============================
        IF Y.EX.LC.NO NE '' THEN
            Y.EX.LC.NO.LIST = DCOUNT(Y.EX.LC.NO, @VM)
            FOR Y.X = 1 TO Y.EX.LC.NO.LIST
                Y.EX.LC.NO1 = Y.EX.LC.NO<1,Y.X>
                Y.EX.LC.NO.ALL = Y.EX.LC.NO.ALL : Y.EX.LC.NO1 : '| '
            NEXT Y.X
        END
        ELSE
            Y.EX.LC.NO.ALL = '...'
        END
        
*===========================================SC NO SEPERATOR===============================
        IF Y.SC.CT.NO NE '' THEN
            Y.SC.CT.NO.LIST = DCOUNT(Y.SC.CT.NO, @VM)
            FOR Y.Y = 1 TO Y.SC.CT.NO.LIST
                Y.SC.CT.NO1 = Y.SC.CT.NO<1,Y.Y>
                Y.SC.CT.NO.ALL = Y.SC.CT.NO.ALL : Y.SC.CT.NO1 : '| '
            NEXT Y.Y
        END
        ELSE
            Y.SC.CT.NO.ALL = '-'
        END
*====================TF & SC Calculation ===============================

        IF Y.LC.SPDT GT Y.SC.SPDT THEN
            Y.LSHIP.DT =  Y.LC.SPDT
        END ELSE
            Y.LSHIP.DT =  Y.SC.SPDT
        END
        Y.LS.FRT = Y.LC.FRGHT.TOT + Y.TOT.CT.FR
        Y.FOB.VAL = Y.JOB.AMT - Y.LS.FRT
        Y.LC.CRG.TOT = Y.LC.CRG.TOT1 + Y.LC.CRG.TOT2
        Y.TOT.CRG = Y.LC.CRG.TOT + Y.TOT.CT.CRG
        Y.TOT.COM = Y.LC.COM.TOT + Y.TOT.CT.CM
        
        Y.TCRG.TCOM = Y.TOT.CRG + Y.TOT.COM
        Y.NET.FOB = Y.FOB.VAL - Y.TCRG.TCOM
        
        Y.EXP.LCNO = Y.EX.LC.NO.ALL : Y.SC.CT.NO.ALL
        Y.EXP.LCLEN = LEN(Y.EXP.LCNO)
        IF Y.EXP.LCLEN GT 150 THEN
            Y.EX.LCNO = Y.EXP.LCNO[1,150]
        END ELSE
            Y.EX.LCNO = Y.EXP.LCNO
        END
        
        Y.ENT.FOB.PER = DROUND((Y.TT.BTB.ENT.AMT/Y.TT.NT.FOB.VAL),4)
        Y.BTB.ENT.RT = (Y.ENT.FOB.PER*100) : ' %'
        
*=====================================LIMIT AMOUNT =============================
        Y.LIMIT.ID = Y.AA.CUS : "..." : Y.CUS.LMT : "..."
        SEL.CMD.LMT = 'SELECT ':FN.LMT:' WITH @ID LIKE ':Y.LIMIT.ID
        EB.DataAccess.Readlist(SEL.CMD.LMT, SEL.LIST.LMT, '', NO.OF.REC.LMT, SystemReturnCode)
        LOOP
            REMOVE Y.TOT.LMT.ID FROM SEL.LIST.LMT SETTING POS.LMT1
        WHILE Y.TOT.LMT.ID:POS.LMT1
            EB.DataAccess.FRead(FN.LMT, Y.TOT.LMT.ID, REC.LMT, F.LMT, E.LMT)
            Y.INT.AMT = REC.LMT<LI.Config.Limit.InternalAmount>
            Y.TOT.INT.AMT = Y.TOT.INT.AMT + Y.INT.AMT
        REPEAT
        Y.LIMIT.ID.GRP = "..." : Y.CUS.LMT : "..." : Y.AA.CUS
        SEL.CMD.LMT.GRP = 'SELECT ':FN.LMT:' WITH @ID LIKE ':Y.LIMIT.ID.GRP
        EB.DataAccess.Readlist(SEL.CMD.LMT.GRP, SEL.LIST.LMT.GRP, '', NO.OF.REC.LMT, SystemReturnCode)
        LOOP
            REMOVE Y.TOT.LMT.ID.GRP FROM SEL.LIST.LMT.GRP SETTING POS.LMT2
        WHILE Y.TOT.LMT.ID.GRP:POS.LMT2
            EB.DataAccess.FRead(FN.LMT, Y.TOT.LMT.ID.GRP, REC.LMT.GRP, F.LMT, E.LMT)
            Y.INT.AMT.GRP = REC.LMT.GRP<LI.Config.Limit.InternalAmount>
            Y.TOT.INT.AMT.GRP = Y.TOT.INT.AMT.GRP + Y.INT.AMT.GRP
        REPEAT
        
        Y.TOT.INT.AMT.TOT = Y.TOT.INT.AMT + Y.TOT.INT.AMT.GRP
        Y.CAL.AVL.LMT = Y.TOT.INT.AMT - TotalAllBal
        Y.FOB.EXVL = DROUND((Y.RMR.AMT * Y.NET.FOB)/Y.IMP.ENT,2)
        
*======================================================COMMITMENT PROP
        Y.TA.PROP = 'COMMITMENT'
*Read AA.PRD.DES.TERM.AMOUNT Property for bellow Fields
        AA.Framework.GetArrangementConditions(Y.AA.ID, Y.AA.PROP.CL, Y.TA.PROP, '', RETURN.IDS, RET.VAL.TA, RET.ERROR)
        R.REC.TA = RAISE(RET.VAL.TA)
        Y.AA.AMT = R.REC.TA<AA.TermAmount.TermAmount.AmtAmount>
        Y.AA.MT.DT = R.REC.TA<AA.TermAmount.TermAmount.AmtMaturityDate>

*==============================================================
*Read CUSTOMER Application

        EB.DataAccess.FRead(FN.CUS, Y.AA.CUS, REC.CUS, F.CUS, E.CUS)
        Y.CUS.N1 = REC.CUS< ST.Customer.Customer.EbCusNameOne>
                
*======================================================================
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
                        CASE CHARGE1 EQ 'LCOTHER'
                            Y.LCAD.PROP = 'LCOTHER'
**Read AA.PRD.DES.CHARGE Property for bellow Fields
                            AA.Framework.GetArrangementConditions(Y.AA.ID, Y.AA.PROP.CL, Y.LCAD.PROP, '', RETURN.IDS, RET.VAL.LCAD, RET.ERROR)
                            R.REC.LCAD = RAISE(RET.VAL.LCAD)
                            Y.LCAD.AMT = R.REC.LCAD<AA.Fees.Charge.FixedAmount>
                            EB.DataAccess.FRead(FN.FTCOM, Y.LCAD.PROP,REC.FTLCAD,F.FTCOM , E.FTCOM)
*                            Y.AD.DES = REC.FTLCAD<ST.ChargeConfig.FtCommissionType.FtFouDescription>
*                            Y.LCAD.CAT = REC.FTLCAD<ST.ChargeConfig.FtCommissionType.FtFouCategoryAccount>
                            Y.AD.DES = REC.FTLCAD<CG.ChargeConfig.FtCommissionType.FtFouDescription>
                            Y.LCAD.CAT = REC.FTLCAD<CG.ChargeConfig.FtCommissionType.FtFouCategoryAccount>
                            Y.AD.PLCAT = "PL":Y.LCAD.CAT
         
                            IF Y.LCAD.AMT THEN
                                Y.LCAD.DES = Y.AD.DES
                                Y.LCAD.PLCAT = Y.AD.PLCAT
                            END ELSE
                                Y.LCAD.DES = ""
                                Y.LCAD.PLCAT = ""
                            END
                    END CASE
*====================================================================
                NEXT Y.Q
            NEXT Y.P
        END
*===============================================================
        Y.STM.PROP = 'SETTLEMENT'
**Read AA.PRD.DES.TERM.AMOUNT Property for bellow Fields
        AA.Framework.GetArrangementConditions(Y.AA.ID, Y.AA.PROP.CL, Y.STM.PROP, '', RETURN.IDS, RET.VAL.STM, RET.ERROR)
        R.REC.STM = RAISE(RET.VAL.STM)
        Y.AA.CR.ACC = R.REC.STM<AA.Settlement.Settlement.SetPayoutAccount>
        EB.DataAccess.FRead(FN.AC, Y.AA.CR.ACC,REC.CR.AC,F.AC , E.ACCR)
        Y.CR.ACC.DES = REC.CR.AC<AC.AccountOpening.Account.AccountTitleOne>
        Y.AA.CR.AMT = Y.AA.AMT - Y.LCAD.AMT

        Y.RETURN<-1> = Y.BR.NAME:'*':Y.AA.CUR:'*':Y.AA.AMT:'*':Y.EX.LCNO:'*':Y.CUS.N1:'*':Y.TOT.INT.AMT.TOT:'*':Y.APP.N1:'*':TotalAllBal:'*':Y.CAL.AVL.LMT:'*':TotalAllOdBal:'*':Y.JOB.NUM:'*':Y.RMR.AMT:'*':Y.LSHIP.DT:'*':Y.FOB.EXVL:'*':Y.EXP.DT:'*':Y.PC.ENT:'*':Y.JOB.CUR:'*':Y.JOB.AMT:'*':Y.PC.AVL.LCY:'*':Y.LS.FRT:'*':Y.AVL.RM:'*':Y.PC.AVL.RM:'*':Y.FOB.VAL:'*':Y.DOC.VL.FC:'*':Y.EXCH.RT:'*':Y.TOT.CRG:'*':Y.TOT.COM:'*':Y.NET.FOB:'*':Y.IMP.ENT:'*':Y.BTB.OP:'*':Y.JSHIP.MD:'*':Y.JSHIP.DU:'*':Y.AA.ID:'*':Y.PC.AVL.US:'*':Y.ACC.NO:'*':Y.AA.MT.DT:'*':Y.EFF.DT:'*':Y.LCAD.PLCAT:'*':Y.LCAD.DES:'*':Y.LCAD.AMT:'*':Y.AA.CR.ACC:'*':Y.CR.ACC.DES:'*':Y.AA.CR.AMT:'*':Y.CIB.RPTRF:'*':Y.SPCL.CMNT:'*':COUNTOD:'*':Y.BTB.ENT.RT
*--------------------------1------------2------------3-------------4--------------5-------------6---------------7----------------8---------------9-----------------10---------------11------------12-------------13------------14------------15-----------16-----------17------------18--------------19-------------20-----------21-------------22-------------23------------24-------------25-------------26------------27-------------28----------29------------30-------------31------------32------------33--------------34--------------35---------36------------37-------------38-------------39-------------40----------41----------------42-------------43--------------44----------------45------------46------------47
    END
RETURN
END


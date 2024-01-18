* @ValidationCode : MjoyMDAzMzQ3NzM5OkNwMTI1MjoxNjAxMTg4NDQxODg1OnVzZXI6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAxNzEwLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 27 Sep 2020 12:34:01
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : user
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_201710.0

SUBROUTINE TF.JBL.E.NOF.EXP.IM.PER.REG(Y.DATA.F)
*-----------------------------------------------------------------------------
*  Description: this routine fetch the data from LC & Drawing Application to generate a report
*               for Back To Back inport export performance register.
*  Attach Enquiry: JBL.ENQ.IMP.EXP.PER.REG
*  WRITTEN BY : MAHMUDUR RAHAMAN
*  DATE: 03-01-2021
*  FDS BD
****************************************************************************
    $INSERT I_COMMON
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BD.BTB.JOB.REGISTER
    $INSERT I_F.BD.SCT.CAPTURE
    
    $USING LC.Contract
    $USING EB.Reports
    $USING EB.Utility
    $USING EB.SystemTables
    $USING AC.AccountOpening
    $USING EB.DataAccess
    $USING RE.ConBalanceUpdates
    $USING AA.Account
    $USING AA.Limit
    $USING ST.Customer
    $USING LI.Config
    $USING AA.Interest
    $USING ST.CompanyCreation
    $USING AA.PaymentSchedule
    $USING AA.ProductManagement
    $USING ST.Config
    $USING EB.Updates
    $USING EB.API
    $USING EB.LocalReferences
           
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN

INIT:
    
    FN.DR = 'F.DRAWINGS'
    F.DR = ''
    
    FN.LC.APP = 'F.LC.APPLICANT'
    F.LC.APP = ''

    FN.LC = 'F.LETTER.OF.CREDIT'
    F.LC = ''

    FN.LC.BEN = 'F.LC.BENEFICIARY'
    F.LC.BEN = ''

    FN.LC.HIS = 'F.LETTER.OF.CREDIT$HIS'
    F.LC.HIS = ''

    FN.JOB.REG = 'F.BD.BTB.JOB.REGISTER'
    F.JOB.REG = ''
    
    FN.SCT = 'F.BD.SCT.CAPTURE'
    F.SCT = ''

    
    LOCATE 'BENEFICIARY.CUSTNO' IN EB.Reports.getEnqSelection()<2,1> SETTING BENEFICIARY.CUSTNO.POS THEN
        Y.CUS.ID =  EB.Reports.getEnqSelection()<4,BENEFICIARY.CUSTNO.POS>
    END
    LOCATE 'FROM.DATE' IN EB.Reports.getEnqSelection()<2,1> SETTING FROM.POS THEN
        Y.FROM.DATE =  EB.Reports.getEnqSelection()<4,FROM.POS>
    END

    LOCATE 'TO.DATE' IN EB.Reports.getEnqSelection()<2,1> SETTING TO.POS THEN
        Y.TO.DATE =  EB.Reports.getEnqSelection()<4,TO.POS>
    END
    !Y.CUS.ID = '100022023'
RETURN
OPENFILES:
    Y.COMPANY = EB.SystemTables.getIdCompany()
   
    EB.DataAccess.Opf(FN.LC.BEN,F.LC.BEN)
    EB.DataAccess.Opf(FN.LC,F.LC)
    EB.DataAccess.Opf(FN.LC.HIS,F.LC.HIS)
    EB.DataAccess.Opf(FN.JOB.REG,F.JOB.REG)
    EB.DataAccess.Opf(FN.DR,F.DR)
    EB.DataAccess.Opf(FN.SCT,F.SCT)
RETURN
PROCESS:
    
    APPLICATION.NAMES = 'LETTER.OF.CREDIT'
    LOCAL.FIELDS = 'LT.TF.JOB.NUMBR':VM:'LT.TF.LC.TENOR':VM:'LT.TF.COMMO.NM':VM:'LT.TF.COMMO.VOL':VM:'LT.TF.FORGN.CHG':VM:'LT.TF.NET.FOBVL':VM:'LT.TF.BTB.ENTAM':VM:'LT.TF.PC.ENT.AM':VM:'LT.TF.LAGENTCOM'
    EB.Updates.MultiGetLocRef(APPLICATION.NAMES, LOCAL.FIELDS, FLD.POS)
    Y.LT.JOB.NUM.POS      = FLD.POS<1,1>
    Y.LT.TF.LC.TENOR.POS  = FLD.POS<1,2>
    Y.LT.TF.COMMO.NM.POS  = FLD.POS<1,3>
    Y.LT.TF.COMMO.VOL.POS = FLD.POS<1,4>
    Y.LT.TF.FORGN.CHG.POS = FLD.POS<1,5>
    Y.LT.TF.NET.FOBVL.POS = FLD.POS<1,6>
    Y.LT.TF.BTB.ENTAM.POS = FLD.POS<1,7>
    Y.LT.TF.PC.ENT.AM.POS = FLD.POS<1,8>
    Y.LT.TF.LAGENTCOM.POS = FLD.POS<1,9>
    
    ! DEBUG
    IF Y.CUS.ID NE '' AND Y.FROM.DATE EQ '' AND Y.TO.DATE EQ '' THEN
        STMT = 'SELECT ':FN.JOB.REG:' WITH CUSTOMER.NO EQ ': Y.CUS.ID :' BY @ID'
        EB.DataAccess.Readlist(STMT,ID.LIST,'',REC.SIZE,R.ERR)
    END
    
    IF Y.CUS.ID NE '' AND Y.FROM.DATE NE '' AND Y.TO.DATE NE '' THEN
        STMT = 'SELECT ':FN.JOB.REG:' WITH CUSTOMER.NO EQ ': Y.CUS.ID :' AND JOB.CREATE.DATE GE ':Y.FROM.DATE:' AND JOB.CREATE.DATE LE ':Y.TO.DATE:' BY @ID'
        EB.DataAccess.Readlist(STMT,ID.LIST,'',REC.SIZE,R.ERR)
    END

    IF REC.SIZE GT 0 THEN
        FOR I=1 TO REC.SIZE
            Y.JOB.ID = ID.LIST<I>
            EB.DataAccess.FRead(FN.JOB.REG,Y.JOB.ID,JOB.REC,F.JOB.REG,Y.ERR)
            Y.JOB.NUMBER = Y.JOB.ID
            Y.JOB.SALES.CONT = JOB.REC<BTB.JOB.CONT.REFNO>
            Y.EXLC.REF = JOB.REC<BTB.JOB.EX.TF.REF>
            Y.JOB.CREATE.DATE = JOB.REC<BTB.JOB.JOB.CREATE.DATE>
            GOSUB SALES.CONT.INFO
            GOSUB EX.LC.INFO
        NEXT I
    END
    
    Y.DATA.F<-1> = Y.TEMP.DATA

    Y.PREV.JOB = ''
    Y.TOT.DATA = DCOUNT(Y.DATA,@FM)
    Y.PREV.JOB = ''
    FOR Z = 1 TO Y.TOT.DATA
        
        Y.TEMP.DATA = FIELD(Y.DATA,@FM,Z)
        Y.CURR.JOB = FIELD(Y.TEMP.DATA,'*',2)

        IF Y.PREV.JOB NE Y.CURR.JOB THEN
            Y.DATA.F<-1> = Y.TEMP.DATA
        END
        ELSE
            Y.TEMP.DATA.INS = EREPLACE(Y.TEMP.DATA,Y.CURR.JOB,'')
            Y.DATA.F<-1> = Y.TEMP.DATA.INS
        END
        Y.PREV.JOB = FIELD(Y.TEMP.DATA,'*',2)
    NEXT
    
RETURN
*----------------
                        
*****************************************************SALES CONTACT ENTRES*******************************
*---------------
SALES.CONT.INFO:
*--------------
    IF Y.JOB.SALES.CONT NE '' THEN
                
        Y.TOT.COT = DCOUNT(Y.JOB.SALES.CONT,@VM)
        FOR J  = 1 TO Y.TOT.COT
            Y.CONT.ID = Y.JOB.SALES.CONT<1,J>
       
            EB.DataAccess.FRead(FN.SCT,Y.CONT.ID,R.LC,F.SCT,SCT.ERR)
            IF R.LC THEN
                Y.TF.NO = Y.CONT.ID
                Y.EXP.LC.NO = R.LC<SCT.CONTRACT.NUMBER>
                Y.ISSUE.DATE = R.LC<SCT.CONTRACT.DATE>
                Y.LC.AMOUNT  = R.LC<SCT.CONTRACT.AMT>
                Y.CURRENCY = R.LC<SCT.CURRENCY>
                Y.TERM = ''
                Y.SHIPING.DATE = R.LC<SCT.SHIPMENT.DATE>
                Y.EXIPIRY.DATE = R.LC<SCT.EXPIRY.DATE>
                Y.COMMIDITY.NAME = R.LC<SCT.COMD.DESC>
                
                Y.QUANTITY = R.LC<SCT.COMD.QTY>
                Y.LOC.AGN.COM = R.LC<SCT.LOC.AGENT.COMM>
                Y.FOR.COM = R.LC<SCT.FOREIGN.CHARGES>
                Y.FOB = R.LC<SCT.NET.FOB.VALUE>
                Y.PC.ENT.AMT = R.LC<SCT.PCECC.ENT.AMT>
                Y.IMP.ENTILE = R.LC<SCT.BTB.ENT.AMT>
            END
            IF Y.FOB NE '' THEN
                Y.DATA<-1> = Y.JOB.CREATE.DATE:'*':Y.JOB.NUMBER:'*':Y.TF.NO:'*':Y.EXP.LC.NO:'*':Y.ISSUE.DATE:'*':Y.LC.AMOUNT:'*':Y.TERM:'*':Y.SHIPING.DATE:'*':Y.EXIPIRY.DATE:'*':Y.COMMIDITY.NAME:'*':Y.QUANTITY:'*':Y.LOC.AGN.COM:'*':Y.FOR.COM:'*':Y.FOB:'*':Y.PC.ENT.AMT:'*':Y.IMP.ENTILE:'*':Y.CURRENCY
                Y.DATA = SORT(Y.DATA)
                !                                     1                2              3              4               5              6              7            8                 9                  10                  11              12                13         14           15                 16       Y.LT.TF.COMMO.NM.POS
            END
        
        NEXT
    END
                
RETURN
*****************************************************SALES CONTACT ENTRES*******************************
EX.LC.INFO:
    
    IF Y.EXLC.REF NE '' THEN
                
        Y.TOT.LC = DCOUNT(Y.EXLC.REF,@VM)
        FOR J  = 1 TO Y.TOT.LC
            Y.EXLC.ID = Y.EXLC.REF<1,J>
       
            EB.DataAccess.FRead(FN.LC,Y.EXLC.ID,R.LC,F.LC,ERR.LC)
            IF R.LC THEN
                Y.TF.NO = Y.EXLC.ID
                Y.EXP.LC.NO = R.LC<LC.Contract.LetterOfCredit.TfLcIssBankRef>
                Y.ISSUE.DATE = R.LC<LC.Contract.LetterOfCredit.TfLcIssueDate>
                Y.LC.AMOUNT  = R.LC<LC.Contract.LetterOfCredit.TfLcLcAmount>
                Y.CURRENCY = R.LC<LC.Contract.LetterOfCredit.TfLcLcCurrency>
                Y.TERM = R.LC<LC.Contract.LetterOfCredit.TfLcLocalRef,Y.LT.TF.LC.TENOR.POS>
                Y.SHIPING.DATE = R.LC<LC.Contract.LetterOfCredit.TfLcLatestShipment>
                Y.EXIPIRY.DATE = R.LC<LC.Contract.LetterOfCredit.TfLcAdviceExpiryDate>
                Y.COMMIDITY.NAME = R.LC<LC.Contract.LetterOfCredit.TfLcLocalRef,Y.LT.TF.COMMO.NM.POS>
                
                Y.QUANTITY = R.LC<LC.Contract.LetterOfCredit.TfLcLocalRef,Y.LT.TF.COMMO.VOL.POS>
                Y.LOC.AGN.COM = R.LC<LC.Contract.LetterOfCredit.TfLcLocalRef,Y.LT.TF.LAGENTCOM.POS>
                Y.FOR.COM = R.LC<LC.Contract.LetterOfCredit.TfLcLocalRef,Y.LT.TF.FORGN.CHG.POS>
                Y.FOB = R.LC<LC.Contract.LetterOfCredit.TfLcLocalRef,Y.LT.TF.NET.FOBVL.POS>
                Y.PC.ENT.AMT = R.LC<LC.Contract.LetterOfCredit.TfLcLocalRef,Y.LT.TF.PC.ENT.AM.POS>
                Y.IMP.ENTILE = R.LC<LC.Contract.LetterOfCredit.TfLcLocalRef,Y.LT.TF.BTB.ENTAM.POS>
                                            
            END
            IF Y.FOB NE '' THEN
                Y.DATA<-1> = Y.JOB.CREATE.DATE:'*':Y.JOB.NUMBER:'*':Y.TF.NO:'*':Y.EXP.LC.NO:'*':Y.ISSUE.DATE:'*':Y.LC.AMOUNT:'*':Y.TERM:'*':Y.SHIPING.DATE:'*':Y.EXIPIRY.DATE:'*':Y.COMMIDITY.NAME:'*':Y.QUANTITY:'*':Y.LOC.AGN.COM:'*':Y.FOR.COM:'*':Y.FOB:'*':Y.PC.ENT.AMT:'*':Y.IMP.ENTILE:'*':Y.CURRENCY
                Y.DATA = SORT(Y.DATA)
                !                                     1                2              3              4               5              6              7            8                 9                  10                  11              12                13         14           15                16      Y.LT.TF.COMMO.NM.POS
            END
        
        NEXT
    END
    
RETURN

*-----------
END


SUBROUTINE TF.JBL.E.NOF.PARTCLR.BTB.EXP.FC.PC(Y.DATA)

    !Created by: Mahmudur Rahman Udoy!
    !Complete Date: 6/20/2021!
    !Attach Enq: JBL.ENQ.PARTCLR.BTB.EXP.FC.PC
     
    !-----------------------------------------------------------------!
    !                      ROUTINE HISTORY                            !
    !_________________________________________________________________!
    ! PURPOSE:                                                        !
    ! THIS ROUTINE DEVELOPED TO RETRIVE DATA FOR BTB LC & DRAWINGS,   !
    ! EXPORT LC & DRAWINGS, FC HELD DATA, PC DATA UNDER A PARTICULAR  !
    ! JOB OF A CUSTOMER.                                              !
    !_________________________________________________________________!
    !_________________________________________________________________!
    !PROCESS MODIFICATION:                                            !
    !(i)  ALL EXPORT LC AND BTB LC LIST READ FROM BD.BTB.JOB.REGISTER.!
    !                                                                 !
    !(ii) LC HOSTORY RECORD ID TAKEN FORM BD.BTB.JOB.RESIGSER.        !
    !                                                                 !
    !_________________________________________________________________!
    !_________________________________________________________________!
    !MODIFICATION:                                    DATE:09/28/2020 !
    !(iii) RETROFIT THE HOLE ROUTINE AS PER R19 AND CONVERTE LANDING  !
    !      PART AS ARRENGEMENT PACKING CREDIT LANDING.                !
    !_________________________________________________________________!

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.BD.BTB.JOB.REGISTER
    $INSERT I_F.BD.SCT.CAPTURE
    $INSERT I_AA.LOCAL.COMMON
    
     
    $USING LC.Contract
    $USING AA.Framework
    $USING RE.ConBalanceUpdates
*    $USING ST.AccountStatement
		$USING AC.AccountStatement
    $USING AC.EntryCreation
    $USING AC.AccountOpening
     
    $USING ST.CurrencyConfig
    $USING EB.API
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates
    $USING EB.Reports
    $USING ST.CompanyCreation
    
*    ST.CompanyCreation.LoadCompany('BNK')

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN

INIT:
    FN.LC.APP = 'F.LC.APPLICANT'
    F.LC.APP = ''

    FN.LC = 'F.LETTER.OF.CREDIT'
    F.LC = ''
    
    FN.ACC = 'F.ACCOUNT'
    F.ACC = ''

    FN.LC.BEN = 'F.LC.BENEFICIARY'
    F.LC.BEN = ''

    FN.LC.HIS = 'F.LETTER.OF.CREDIT$HIS'
    F.LC.HIS = ''

    FN.DRW = 'F.DRAWINGS'
    F.DRW = ''

    FN.DRW.HIS = 'F.DRAWINGS$HIS'
    F.DRW.HIS = ''
    
    FN.ARR = 'F.AA.ARRANGEMENT'
    F.ARR = ''
    
    FN.ECB = 'F.EB.CONTRACT.BALANCES'
    F.ECB  = ''
    
    FN.SCT = 'F.BD.SCT.CAPTURE'
    F.SCT = ''

    FN.CCY = 'F.CURRENCY'
    F.CCY = ''

    FN.JOB.REG = 'F.BD.BTB.JOB.REGISTER'
    F.JOB.REG =''

    FN.STMT.ENT = 'F.STMT.ENTRY'
    F.STMT.ENT  = ''

    LOCATE 'EXP.LC.NO' IN EB.Reports.getEnqSelection()<2,1> SETTING EXP.LC.NO.POS THEN
        Y.SCT.OR.EXP.LC.ID =  EB.Reports.getEnqSelection()<4,EXP.LC.NO.POS>
    END

    FLD.POS = ''
    APPLICATION.NAMES = 'DRAWINGS':FM:'LETTER.OF.CREDIT'
    LOCAL.FIELDS = 'LT.TF.DT.DOCREC':VM:'LT.TF.DT.PAYMNT':VM:'LT.TF.ELC.COLNO':VM:'LT.TF.MAT.DATE':VM:'LT.TF.CO.DOCAMT':FM:'LT.TF.JOB.NUMBR'
*                           1                   2                   3                   4                   5                   1
    EB.Updates.MultiGetLocRef(APPLICATION.NAMES, LOCAL.FIELDS, FLD.POS)
    LT.TF.DT.DOCREC.POS      = FLD.POS<1,1>
    LT.TF.DT.PAYMNT.POS      = FLD.POS<1,2>
    LT.TF.ELC.COLNO.POS      = FLD.POS<1,3>
    LT.TF.MAT.DATE.POS       = FLD.POS<1,4>
    LT.TF.CO.DOCAMT.POS      = FLD.POS<1,5>
    LT.TF.JOB.NUMBR.POS      = FLD.POS<2,1>
    
    Y.BAL.TOT = 0
    Y.DELIM = '...;...'
    Y.FCCY = 'USD'
    Y.TRN.DATE = ''
    Y.CR.DR.AMT = ''
    Y.COMPANY = EB.SystemTables.getIdCompany()
RETURN
 
OPENFILES:

    EB.DataAccess.Opf(FN.LC.APP,F.LC.APP)
    EB.DataAccess.Opf(FN.LC.BEN,F.LC.BEN)
    EB.DataAccess.Opf(FN.LC,F.LC)
    EB.DataAccess.Opf(FN.LC.HIS,F.LC.HIS)
    EB.DataAccess.Opf(FN.DRW,F.DRW)
    EB.DataAccess.Opf(FN.DRW.HIS,F.DRW.HIS)
    EB.DataAccess.Opf(FN.ACC, F.ACC)
    EB.DataAccess.Opf(FN.ARR,F.ARR)
    EB.DataAccess.Opf(FN.ECB,F.ECB)
    EB.DataAccess.Opf(FN.SCT,F.SCT)
    EB.DataAccess.Opf(FN.CCY,F.CCY)
    EB.DataAccess.Opf(FN.JOB.REG,F.JOB.REG)
    EB.DataAccess.Opf(FN.STMT.ENT,F.STMT.ENT)
RETURN

PROCESS:
    IF Y.SCT.OR.EXP.LC.ID MATCHES Y.DELIM THEN
        Y.SCT.OR.EXP.LC.ID = FIELD(Y.SCT.OR.EXP.LC.ID,';',1)
        EB.DataAccess.ReadHistoryRec(F.LC.HIS, Y.SCT.OR.EXP.LC.ID, R.LC.SEL,'')
    END
    ELSE
        EB.DataAccess.FRead(FN.LC , Y.SCT.OR.EXP.LC.ID , R.LC.SEL, F.LC , Y.ERR.LC.SEL)
        
    END
    
    IF R.LC.SEL NE '' THEN
        Y.CUS.SEL = R.LC.SEL<LC.Contract.LetterOfCredit.TfLcBeneficiaryCustno>
        Y.JOB.NO.EXP.SEL = R.LC.SEL<LC.Contract.LetterOfCredit.TfLcLocalRef,LT.TF.JOB.NUMBR.POS>
    END
    ELSE
        EB.DataAccess.FRead(FN.SCT,Y.SCT.OR.EXP.LC.ID,R.CONT,F.SCT,SCT.ERR)
        Y.CONT.CUS = R.CONT<SCT.BENEFICIARY.CUSTNO>
        Y.CONT.JOB.NO = R.CONT<SCT.BTB.JOB.NO>
        Y.CUS.SEL = Y.CONT.CUS
        Y.JOB.NO.EXP.SEL = Y.CONT.JOB.NO
    END
    
*    Y.JOB.NO.EXP.SEL = '1760.200000455.00031.21'
*    Y.JOB.NO.EXP.SEL = '1742.200000521.00035.21'
*    Y.JOB.NO.EXP.SEL = '1760.200000456.00004.21'

    EB.DataAccess.FRead(FN.JOB.REG,Y.JOB.NO.EXP.SEL, R.JOB.REG, F.JOB.REG , Y.ERR.REG)
********************MODIFIED FOR ADDING SALES CONTACT LC NUMBER WITH EX REF NUMBER*****************
    Y.SELCONT.LC.ALL = R.JOB.REG<BTB.JOB.COLL.TF.REFNO>
    CONVERT SM TO VM IN Y.SELCONT.LC.ALL
    Y.EX.LC.ALL  = R.JOB.REG<BTB.JOB.EX.TF.REF>
    Y.BEN.LC.ALL = Y.EX.LC.ALL:VM:Y.SELCONT.LC.ALL
********************MODIFICATION END*****************
    
    EB.DataAccess.FRead(FN.JOB.REG,Y.JOB.NO.EXP.SEL, R.JOB.REG, F.JOB.REG , Y.ERR.REG)
    Y.APP.LC.ALL = ''
    Y.APP.LC.ALL = R.JOB.REG<BTB.JOB.IM.TF.REF>
    Y.LOAN.ARR = R.JOB.REG<BTB.JOB.PCECC.LOAN.ID>  ;* This variable use in PCI.GET GOSUB
    
    Y.TOT.EXP.LC = DCOUNT(Y.BEN.LC.ALL,@VM)
    FOR X = 1  TO  Y.TOT.EXP.LC

        Y.EXP.LC.ID = FIELD(Y.BEN.LC.ALL,@VM,X)
        EB.DataAccess.FRead(FN.LC , Y.EXP.LC.ID , R.LC, F.LC , Y.ERR.LC)

        IF R.LC NE '' THEN
            Y.CUS.ID = R.LC<LC.Contract.LetterOfCredit.TfLcBeneficiaryCustno>
            Y.JOB.NO.EXP = R.LC<LC.Contract.LetterOfCredit.TfLcLocalRef,LT.TF.JOB.NUMBR.POS>
            Y.EXP.DR.STATUS = R.LC<LC.Contract.LetterOfCredit.TfLcRecordStatus>
            Y.NEXT.DR = R.LC<LC.Contract.LetterOfCredit.TfLcNextDrawing>
            Y.LC.DR.NUM = Y.NEXT.DR - 1
            GOSUB EXP.DRAW
        END
        ELSE
            EB.DataAccess.ReadHistoryRec(F.LC.HIS,Y.EXP.LC.ID, R.LC.HIS, '')
            Y.CUS.ID = R.LC.HIS<LC.Contract.LetterOfCredit.TfLcBeneficiaryCustno>
            Y.JOB.NO.EXP = R.LC.HIS<LC.Contract.LetterOfCredit.TfLcLocalRef,LT.TF.JOB.NUMBR.POS>
            Y.EXP.DR.STATUS = R.LC.HIS<LC.Contract.LetterOfCredit.TfLcRecordStatus>
            Y.NEXT.DR = R.LC.HIS<LC.Contract.LetterOfCredit.TfLcNextDrawing>
            Y.LC.DR.NUM = Y.NEXT.DR - 1
            GOSUB EXP.DRAW
        END

    NEXT X

    Y.TOT.BTB.LC = DCOUNT(Y.APP.LC.ALL,@VM)
    FOR Y = 1 TO Y.TOT.BTB.LC
        Y.LC.APP.ID = FIELD(Y.APP.LC.ALL,@VM,Y)
        EB.DataAccess.FRead(FN.LC , Y.LC.APP.ID , R.LC.IMP, F.LC , Y.ERR.LC)

        IF R.LC.IMP THEN
            Y.BTB.LC.NO = R.LC.IMP<LC.Contract.LetterOfCredit.TfLcOldLcNumber>
            Y.BTB.DATE =  R.LC.IMP<LC.Contract.LetterOfCredit.TfLcIssueDate>
            Y.BTB.TF.REF = Y.LC.APP.ID
            Y.BTB.CCY = R.LC.IMP<LC.Contract.LetterOfCredit.TfLcLcCurrency>
            
            Y.BTB.AMOUNT = R.LC.IMP<LC.Contract.LetterOfCredit.TfLcLcAmount>
            
            Y.BTB.FLAG = 'Y'
            Y.BTB.DR.STATUS = R.LC.IMP<LC.Contract.LetterOfCredit.TfLcRecordStatus>
            Y.NEXT.BTB.DR = R.LC.IMP<LC.Contract.LetterOfCredit.TfLcNextDrawing>
            Y.LC.BTB.DR.NUM = Y.NEXT.BTB.DR - 1
            Y.BTB.DATA<-1> = Y.BTB.LC.NO :'*': Y.BTB.DATE :'*': Y.BTB.TF.REF :'*': Y.BTB.CCY :'*': Y.BTB.AMOUNT
            !                    1                 2                 3                4                  5
            !Y.BTB.DATA= SORT(Y.BTB.DATA)
            GOSUB BTB.DRAW
        END
        ELSE

            EB.DataAccess.ReadHistoryRec(F.LC.HIS, Y.LC.APP.ID, R.LC.HIS, '')
            IF R.LC.HIS THEN
                Y.BTB.LC.NO = R.LC.HIS<LC.Contract.LetterOfCredit.TfLcOldLcNumber>
                Y.BTB.DATE =  R.LC.HIS<LC.Contract.LetterOfCredit.TfLcIssueDate>
                Y.BTB.TF.REF = Y.LC.APP.ID
                Y.BTB.CCY = R.LC.HIS<LC.Contract.LetterOfCredit.TfLcLcCurrency>
                Y.BTB.AMOUNT = R.LC.HIS<LC.Contract.LetterOfCredit.TfLcLcAmount>
                Y.BTB.FLAG = 'Y'
                Y.BTB.DR.STATUS = R.LC.HIS<LC.Contract.LetterOfCredit.TfLcRecordStatus>
                Y.NEXT.BTB.DR = R.LC.HIS<LC.Contract.LetterOfCredit.TfLcNextDrawing>
                Y.LC.BTB.DR.NUM = Y.NEXT.BTB.DR - 1
                Y.BTB.DATA<-1> = Y.BTB.LC.NO :'*': Y.BTB.DATE :'*': Y.BTB.TF.REF :'*': Y.BTB.CCY :'*': Y.BTB.AMOUNT
                !Y.BTB.DATA= SORT(Y.BTB.DATA)
                GOSUB BTB.DRAW
            END

        END

    NEXT

    GOSUB GET.FC.BAL
    GOSUB PCI.GET

    Y.TOT.BTB = DCOUNT(Y.BTB.DATA,@FM)
    Y.TOT.IMP = DCOUNT(Y.IMP.DATA,@FM)
    Y.TOT.EXP = DCOUNT(Y.EXP.DATA,@FM)
    Y.TOT.FC = DCOUNT(Y.FC.DETAIL,@FM)
    Y.TOT.PC = DCOUNT(Y.PC.DATA,@FM)

    Y.COMB.ALL = Y.TOT.BTB:@FM:Y.TOT.IMP:@FM:Y.TOT.EXP:@FM:Y.TOT.FC:@FM:Y.TOT.PC
    Y.MAX = 0
    FOR Q = 1 TO 5
        Y.TEMP = FIELD(Y.COMB.ALL,@FM,Q)
        IF Y.TEMP GT Y.MAX THEN
            Y.MAX = Y.TEMP
        END
    NEXT

    FOR I = 1 TO Y.MAX
        Y.BTB = FIELD(Y.BTB.DATA,@FM,I)
        Y.IMP = FIELD(Y.IMP.DATA,@FM,I)
        Y.EXP = FIELD(Y.EXP.DATA,@FM,I)
        Y.FC = FIELD(Y.FC.DETAIL,@FM,I)
        Y.PC = FIELD(Y.PC.DATA,@FM,I)

        IF Y.BTB EQ '' THEN
            Y.BTB = '':'*':'':'*':'':'*':'':'*':''
        END
        IF Y.IMP EQ '' THEN
            Y.IMP = '':'*':'':'*':'':'*':'':'*':'':'*':''
        END
        IF Y.EXP  EQ '' THEN
            Y.EXP = '':'*':'':'*':'':'*':'':'*':'':'*':'':'*':''
        END
        IF Y.FC EQ '' THEN
            Y.FC =  '':'*':'':'*':'':'*':''
        END
        IF Y.PC EQ '' THEN
            Y.PC = '':'*':'':'*':'':'*':''
        END
        Y.DATA<-1> = Y.BTB:'*':Y.IMP:'*':Y.EXP:'*':Y.FC:'*':Y.PC
*        Y.DATA<-1> = Y.BTB:'*':Y.IMP:'*':Y.EXP:'*':Y.FC:'*':Y.PC
    NEXT

RETURN
 
EXP.DRAW:
    FOR J = 1 TO Y.LC.DR.NUM
        IF LEN(J) EQ 1 THEN
            Y.EPF = '0':J
        END
        ELSE
            Y.EPF = J
        END
    
        Y.EXP.DRW.ID=''
        Y.LC.CL.ID = Y.EXP.LC.ID

        IF Y.LC.CL.ID MATCHES Y.DELIM THEN
            Y.EXP.LC.ID = FIELD(Y.LC.CL.ID,';',1)
        END

        Y.EXP.DRW.ID = Y.EXP.LC.ID : Y.EPF

        IF Y.EXP.DR.STATUS EQ 'MAT' THEN
            EB.DataAccess.ReadHistoryRec(F.DRW.HIS, Y.EXP.DRW.ID, R.EXP.DRW,'')
        END
        ELSE
            EB.DataAccess.FRead(FN.DRW , Y.EXP.DRW.ID , R.EXP.DRW, F.DRW , Y.ERR.EXP.DRW)
        END
        IF R.EXP.DRW NE '' THEN

            Y.EXP.DT = R.EXP.DRW<LC.Contract.Drawings.TfDrDateTime>[1,10]
            Y.IMP.BILL.NO = ''
            Y.IMP.AMT = 0
            Y.IMP.MD = ''
            Y.IMP.FMD = ''
            Y.IMP.D.OF.PAYMENT = ''

*            Y.EXP.D = R.EXP.DRW<LC.Contract.Drawings.TfDrLocalRef,LT.TF.DT.DOCREC.POS>
            Y.EXP.D = R.EXP.DRW<LC.Contract.Drawings.TfDrValueDate>
            Y.EXP.BILL.NO = R.EXP.DRW<LC.Contract.Drawings.TfDrLocalRef,LT.TF.ELC.COLNO.POS>
            Y.EXP.DWAW.ID = Y.EXP.DRW.ID
            Y.EXP.BILL.CCY = R.EXP.DRW<LC.Contract.Drawings.TfDrDrawCurrency>
            
            Y.DRAWING.TYPE = R.EXP.DRW<LC.Contract.Drawings.TfDrDrawingType>
            
            Y.CO.DOC.AMOUNT = R.EXP.DRW<LC.Contract.Drawings.TfDrLocalRef,LT.TF.CO.DOCAMT.POS>
            IF Y.CO.DOC.AMOUNT EQ '' THEN
                Y.EXP.BILL.AMT = R.EXP.DRW<LC.Contract.Drawings.TfDrDocumentAmount>
                Y.EXP.REALISE.AMT = R.EXP.DRW<LC.Contract.Drawings.TfDrDocumentAmount>
            END
            ELSE
                Y.EXP.BILL.AMT = Y.CO.DOC.AMOUNT
                Y.EXP.REALISE.AMT = R.EXP.DRW<LC.Contract.Drawings.TfDrDocumentAmount>
            END

 
            IF Y.DRAWING.TYPE EQ 'CO' THEN
                Y.EXP.REALISE.AMT = 0
                Y.EXP.REALISE.D = ''
                Y.FCH.REF = ''
            END
            ELSE
                Y.EXP.REALISE.D = R.EXP.DRW<LC.Contract.Drawings.TfDrValueDate>
                Y.FCH.REF = Y.EXP.BILL.NO
            END
            Y.PAYMENT.ACCOUNT = R.EXP.DRW<LC.Contract.Drawings.TfDrPaymentAccount>
            
            Y.AC.CODE = Y.PAYMENT.ACCOUNT[2,3]
            IF Y.AC.CODE EQ '154' THEN
                Y.CR.DR.AMT = R.EXP.DRW<LC.Contract.Drawings.TfDrDocAmtLcCcy>
            END

            Y.ASSN.CR.ACCT = R.EXP.DRW<LC.Contract.Drawings.TfDrAssnCrAcct>
           
            Y.TOT.ASSN.CR.ACCT = DCOUNT(Y.ASSN.CR.ACCT,@VM)

            IF Y.AC.CODE NE '154' THEN
                IF Y.TOT.ASSN.CR.ACCT EQ 0 THEN
                    Y.CR.DR.AMT = 0
                END
            END
            Y.TPPAY.CR.DR.AMT = ''
            Y.CR.DR.AMT = ''
            FOR M = 1 TO Y.TOT.ASSN.CR.ACCT
                Y.ASSN.CR.ACCT.SPILT = R.EXP.DRW<LC.Contract.Drawings.TfDrAssnCrAcct,M>
                Y.TPPAY = R.EXP.DRW<LC.Contract.Drawings.TfDrAssignmentRef,M>
                EB.DataAccess.FRead(FN.ACC, Y.ASSN.CR.ACCT.SPILT, REC.ACC, F.ACC, ERR.ACC)
                ACC.CUS.ID = REC.ACC<AC.AccountOpening.Account.Customer>
                IF Y.ASSN.CR.ACCT.SPILT[2,3] EQ '154' AND Y.CUS.ID EQ ACC.CUS.ID AND Y.TPPAY EQ 'TPPAY' THEN
                    Y.TPPAY.CR.DR.AMT = R.EXP.DRW<LC.Contract.Drawings.TfDrAssnAmount,M>
                    Y.CR.DR.AMT = Y.CR.DR.AMT + Y.TPPAY.CR.DR.AMT
*                   BREAK
                END
            NEXT
 
            !Y.EXP.IMP.DATA<-1> = Y.EXP.DT:'*':Y.IMP.BILL.NO :'*':Y.IMP.AMT:'*':Y.IMP.MD:'*':Y.IMP.FMD:'*':Y.IMP.D.OF.PAYMENT:'*':Y.EXP.D:'*':Y.EXP.BILL.NO:'*':Y.EXP.DWAW.ID:'*':Y.EXP.BILL.CCY:'*':Y.EXP.BILL.AMT:'*':Y.EXP.REALISE.AMT:'*':Y.EXP.REALISE.D:'*':Y.FCH.REF:'*':Y.CR.DR.AMT
            !                        6               7               8             9            10                 11                12             13                14              15                 16                         17                18             19              20
            !Y.EXP.IMP.DATA = SORT(Y.EXP.IMP.DATA)
            Y.EXP.DATA<-1> = Y.EXP.D:'*':Y.EXP.BILL.NO:'*':Y.EXP.DWAW.ID:'*':Y.EXP.BILL.CCY:'*':Y.EXP.BILL.AMT:'*':Y.EXP.REALISE.AMT:'*':Y.EXP.REALISE.D
            !                  12            13                14              15                   16                    17                    18
            Y.FC.DATA<-1> = Y.EXP.DT:'*':Y.FCH.REF:'*':Y.CR.DR.AMT
            !                  19           20              21
        END
    NEXT
RETURN
BTB.DRAW:
    
    FOR K = 1 TO Y.LC.BTB.DR.NUM
        IF LEN(K) EQ 1 THEN
            Y.PF = '0':K
        END
        ELSE
            Y.PF = K
        END
        Y.LC.CL.ID = Y.LC.APP.ID

        IF Y.LC.CL.ID MATCHES Y.DELIM THEN
            Y.LC.APP.ID = FIELD(Y.LC.CL.ID,';',1)
        END

        Y.BTB.DRW.ID = Y.LC.APP.ID : Y.PF
        
        IF Y.BTB.DR.STATUS EQ 'MAT' THEN
            EB.DataAccess.ReadHistoryRec(F.DRW.HIS, Y.BTB.DRW.ID, R.BTB.DRW,'')
        END
        ELSE
            EB.DataAccess.FRead(FN.DRW , Y.BTB.DRW.ID , R.BTB.DRW, F.DRW , Y.ERR.BTB.DRW)
        END
        IF R.BTB.DRW NE '' THEN

            Y.IMP.DT = R.BTB.DRW<LC.Contract.Drawings.TfDrDateTime>[1,10]
            Y.IMP.TYPE = R.BTB.DRW<LC.Contract.Drawings.TfDrDrawingType>
            Y.IMP.BILL.NO = Y.BTB.DRW.ID
            Y.IMP.AMT = R.BTB.DRW<LC.Contract.Drawings.TfDrDocumentAmount>
            Y.IMP.MD = R.BTB.DRW<LC.Contract.Drawings.TfDrLocalRef,LT.TF.MAT.DATE.POS>
            Y.IMP.FMD = R.BTB.DRW<LC.Contract.Drawings.TfDrMaturityReview>
            
            Y.IMP.D.OF.PAYMENT = R.BTB.DRW<LC.Contract.Drawings.TfDrLocalRef,LT.TF.DT.PAYMNT.POS>

            Y.EXP.D = ''
            Y.EXP.BILL.NO = ''
            Y.EXP.DWAW.ID = ''
            Y.EXP.BILL.CCY = ''
            Y.EXP.BILL.AMT = ''
            Y.EXP.REALISE.AMT = ''
            Y.EXP.REALISE.D = ''
            Y.FCH.REF = Y.IMP.BILL.NO

            Y.IMP.BILL.CCY = R.BTB.DRW<LC.Contract.Drawings.TfDrDrawCurrency>
            IF Y.IMP.BILL.CCY EQ 'USD' THEN
                Y.CR.DR.AMT = Y.EXP.REALISE.AMT - Y.IMP.AMT
            END
            ELSE

                GOSUB CONVERT.CCY
                Y.CR.DR.AMT = Y.EXP.REALISE.AMT - Y.IMP.AMT.CONV
            END

            !Y.EXP.IMP.DATA<-1> = Y.IMP.DT:'*':Y.IMP.BILL.NO :'*':Y.IMP.AMT:'*':Y.IMP.MD:'*':Y.IMP.FMD:'*':Y.IMP.D.OF.PAYMENT:'*':Y.EXP.D:'*':Y.EXP.BILL.NO:'*':Y.EXP.DWAW.ID:'*':Y.EXP.BILL.CCY:'*':Y.EXP.BILL.AMT:'*':Y.EXP.REALISE.AMT:'*':Y.EXP.REALISE.D:'*':Y.FCH.REF:'*':Y.CR.DR.AMT
            !                        6               7               8             9            10                 11                12             13                14                  15                16                      17                18             19              20
            !Y.EXP.IMP.DATA = SORT(Y.EXP.IMP.DATA)

            Y.IMP.DATA<-1> = Y.IMP.BILL.NO :'*':Y.IMP.AMT:'*':Y.IMP.TYPE:'*':Y.IMP.MD:'*':Y.IMP.FMD:'*':Y.IMP.D.OF.PAYMENT
            !                    6                  7          8                9          10              11
            IF K NE 1 THEN
                Y.BTB.DATA<-1> = Y.BTB.LC.NO:'*':'':'*':'':'*':'':'*':''
            END
            Y.BTB.FLAG = 'N'
            IF Y.IMP.TYPE EQ 'MA' OR Y.IMP.TYPE EQ 'SP' THEN
                Y.FC.DATA<-1> = Y.IMP.DT:'*':Y.FCH.REF:'*':Y.CR.DR.AMT
                !                 19           20              21
                Y.FC.DATA = SORT(Y.FC.DATA)
            END
        END
        ELSE
            IF Y.BTB.FLAG EQ 'Y' THEN
                Y.IMP.DATA<-1> = '':'*':'':'*':'':'*':'':'*':'':'*':''
*                BREAK
            END
        END
    NEXT
RETURN

CONVERT.CCY:

    EB.DataAccess.FRead(FN.CCY, Y.FCCY , R.CCY, F.CCY , Y.ERR.CCY)
    IF R.CCY THEN

        Y.TOT = R.CCY<ST.CurrencyConfig.Currency.EbCurCurrencyMarket>
        Y.TOT.MARKET = DCOUNT(R.CCY<ST.CurrencyConfig.Currency.EbCurCurrencyMarket>,@VM)
        FOR I = 1 TO Y.TOT.MARKET
            Y.CCY.MARKET = R.CCY<ST.CurrencyConfig.Currency.EbCurCurrencyMarket,I>
            IF Y.CCY.MARKET EQ '3' THEN
                Y.BUY.RATE = R.CCY<ST.CurrencyConfig.Currency.EbCurBuyRate,I>
                
                Y.IMP.AMT.CONV = Y.IMP.AMT/Y.BUY.RATE
            END
        NEXT
    END
RETURN

GET.FC.BAL:

    Y.TOT.FC = DCOUNT(Y.FC.DATA,@FM)
    Y.FC.BAL = 0
    FOR I = 1 TO Y.TOT.FC
        Y.DRAW = FIELD(Y.FC.DATA,@FM,I)
        Y.SORT.DIFF = FIELD(Y.DRAW,'*',3)
        Y.FC.BAL = Y.SORT.DIFF + Y.FC.BAL
        IF Y.SORT.DIFF NE 0 THEN
            Y.FC.DETAIL<-1> = Y.DRAW :'*':Y.FC.BAL
            !                               22
        END
    NEXT

RETURN

PCI.GET:
    Y.TRAN.ACCT  = ''
    Y.DBCRMVT = ''
    Y.TRAN.DATE = ''
    Y.BAL.TYPE = ''
     
    Y.TODATE = EB.SystemTables.getToday()
        
    IF Y.LOAN.ARR NE '' THEN
        Y.TOT.LN.ARR = DCOUNT(Y.LOAN.ARR,@VM)
        FOR J  = 1 TO Y.TOT.LN.ARR
            Y.LOAN.ARR.ID = Y.LOAN.ARR<1,J>
            EB.DataAccess.FRead(FN.ARR, Y.LOAN.ARR.ID, ARR.REC, F.ARR, ARR.ERR)
            Y.ACCT.ID = ARR.REC<AA.Framework.Arrangement.ArrLinkedApplId>
            Y.PC.ISSUE.DATE = ARR.REC<AA.Framework.Arrangement.ArrStartDate>
            ST.DATE = Y.PC.ISSUE.DATE
            EN.DATE = Y.TODATE
            
            Y.DATES = ST.DATE:@VM:EN.DATE
            DATE.TO.PROCESS = 'BOOK'
            ACCT.NO= Y.ACCT.ID
            NUM.OPER.VAL=2
            ENTRY.LIST = '':
*            ST.AccountStatement.AcGetAcctEntries(ACCT.NO, NUM.OPER.VAL, Y.DATES, DATE.TO.PROCESS, ENTRY.LIST)
            AC.AccountStatement.AcGetAcctEntries(ACCT.NO, NUM.OPER.VAL, Y.DATES, DATE.TO.PROCESS, ENTRY.LIST)
            Y.STMT.COUNT = DCOUNT(ENTRY.LIST, @FM)
            Y.PC.OUTSTANDING = '' ;* INISIALIZE THIS VARIABLE BEFORE THE LOOP BECASE NEW ACCOUNT START WITH O BALANCE.
            FOR K = 1 TO Y.STMT.COUNT  ;*this loop calculate ACCT.NO variable account all transtactions .
                Y.STMT.ID = ENTRY.LIST<K>
                EB.DataAccess.FRead(FN.STMT.ENT, Y.STMT.ID, REC.STMT, F.STMT.ENT, ERR.STMT)
                Y.TRAN.ACCT = REC.STMT<AC.EntryCreation.StmtEntry.SteAccountNumber>
                Y.DBCRMVT   = REC.STMT<AC.EntryCreation.StmtEntry.SteAmountLcy>
                Y.TRAN.DATE = REC.STMT<AC.EntryCreation.StmtEntry.SteValueDate>
                Y.BAL.TYPE  = REC.STMT<AC.EntryCreation.StmtEntry.SteBalanceType>
                Y.PC.OUTSTANDING +=  Y.DBCRMVT
                Y.PC.DATA<-1> = Y.TRAN.DATE:'*':Y.TRAN.ACCT:'*':Y.DBCRMVT:'*':Y.PC.OUTSTANDING
                !                   23               24           25                26

            NEXT K
        NEXT J
    END
RETURN

END



* @ValidationCode : MjoyMDAzMzQ3NzM5OkNwMTI1MjoxNjAxMTg4NDQxODg1OnVzZXI6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAxNzEwLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 12:34:01
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : user
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_201710.0
SUBROUTINE TF.JBL.E.NOF.EXP.UND.PROCESS(Y.DATA.F)
*-----------------------------------------------------------------------------
*  Description: Export Under Process; Summary position (Total BTB opened, Shipment Made, Shipment Due etc.)
*               of all export LCs/Contracts of a particular JOB. This position will be displayed in
*               JOB wise for all outstanding Export LCs/Contracts for a particular customer
*  Attach Enquiry: JBL.ENQ.EXP.UND.PROCESS
*  WRITTEN BY : ENAMUL HAQUE
*  DATE: 16-17 JANUARY
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
    $USING ST.Customer
    $USING LI.Config
    $USING ST.CompanyCreation
    $USING ST.Config
    $USING EB.Updates
    $USING EB.API
    $USING EB.LocalReferences
           
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
INIT:
    FN.ACC = 'F.ACCOUNT'
    F.ACC = ''
    
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
    
    Y.COMPANY = EB.SystemTables.getIdCompany()
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
    IF Y.CUS.ID NE '' AND Y.FROM.DATE EQ '' AND Y.TO.DATE EQ '' THEN
        STMT = 'SELECT ':FN.JOB.REG:' WITH CUSTOMER.NO EQ ': Y.CUS.ID :' BY @ID'
        EB.DataAccess.Readlist(STMT,ID.LIST,'',REC.SIZE,R.ERR)
    END
    
    IF Y.CUS.ID NE '' AND Y.FROM.DATE NE '' AND Y.TO.DATE NE '' THEN
        STMT = 'SELECT ':FN.JOB.REG:' WITH CUSTOMER.NO EQ ': Y.CUS.ID :' AND JOB.CREATE.DATE GE ':Y.FROM.DATE:' AND JOB.CREATE.DATE LE ':Y.TO.DATE:' AND CO.CODE EQ ':Y.COMPANY:' BY @ID'
        EB.DataAccess.Readlist(STMT,ID.LIST,'',REC.SIZE,R.ERR)
    END
    IF REC.SIZE GT 0 THEN
        FOR I=1 TO REC.SIZE
            !JOB ID/NUMBER 01
            Y.JOB.ID = ID.LIST<I>
            !   IF Y.JOB.ID EQ '1760.200000455.00028.20' THEN

            
            EB.DataAccess.FRead(FN.JOB.REG,Y.JOB.ID,JOB.REC,F.JOB.REG,Y.ERR)
            Y.EX.LC.AMT =0; Y.REALIZE.AMT=0; Y.FC.HELD.KEPT =0
            !~~~ EX TF REF ~~~
            Y.EX.TF.LIST = JOB.REC<BTB.JOB.EX.TF.REF>
            !~~~ EX TF DR LIST  ~~~~~ N1
            Y.EX.TF.DR.LIST = JOB.REC<BTB.JOB.EX.DR.ID>
            
            ! COL TF REFF
            !~~~ COLL TF REFF ~~~~
            Y.COLL.TF.REFF = JOB.REC<BTB.JOB.COLL.TF.REFNO>
            !COLL TF DR LIST
            Y.COLL.TF.DR.LIST = JOB.REC<BTB.JOB.COLL.DR.REFNO>
            
            CONVERT SM TO VM IN Y.COLL.TF.REFF
            CONVERT VM TO FM IN Y.COLL.TF.REFF

            !~~~ CONT REFF ~~~~
            Y.CONT.REFF = JOB.REC<BTB.JOB.CONT.REFNO>
            
            ! COL TF REFF
            CONVERT SM TO VM IN Y.CONT.REFF
            CONVERT VM TO FM IN Y.CONT.REFF
            
            CONVERT SM TO VM IN Y.EX.TF.LIST
            CONVERT VM TO FM IN Y.EX.TF.LIST
                          
            Y.CONT.REFF.SIZE = DCOUNT(Y.CONT.REFF,@FM)
            Y.TF.SZ = DCOUNT(Y.EX.TF.LIST,@FM)
            ! EX LC AMOUNT  5
            Y.EX.LC.AMT = JOB.REC<BTB.JOB.TOT.EX.LC.AMT>
            ! Realize amount -> (goto DRAWING where draw.type EQ SP/MA) [SUMMATION OF DRAWING AMOUNT] (17)
            Y.REALIZE.AMT=0
            ! FC HELD KEPT    13
            Y.FC.HELD.KEPT =0
            !~~~~~~~~~~~  EX TF & COLL TF REFF CALCULATION START ~~~~~~~~~~~~~~~~~~~~~~~ [ Y.REALIZE.AMT, Y.FC.HELD.KEPT]
            FOR J=1 TO Y.TF.SZ
                Y.TF.ID= Y.EX.TF.LIST<J>
                EB.DataAccess.FRead(FN.LC,Y.TF.ID,LC.REC,F.LC,LC.ERR)
                IF LC.REC EQ '' THEN
                    HIS.STMT = "SELECT ":FN.LC.HIS:" WITH @ID LIKE ":Y.TF.ID:"... BY.DSND @ID"
                    EB.DataAccess.Readlist(HIS.STMT,HIS.ID.LIST,"",HIS.ID.SIZE,HIS.ERR)
                    Y.TF.ID= HIS.ID.LIST<1>
                    EB.DataAccess.FRead(FN.LC.HIS,Y.TF.ID,LC.REC,F.LC.HIS,LC.ERR)
                    !#########
                    FOR KK=1 TO Y.TF.SZ
                        LC.ID.F = Y.EX.TF.LIST<KK>
                        IF LC.ID.F EQ Y.TF.ID[1,12] THEN
                            !Y.MERGE<KK> = Y.TF.ID
                            Y.EX.TF.LIST<KK> = Y.TF.ID
                            BREAK
                        END
                    NEXT KK
                    !#########
                END
            NEXT J
            !~~~~~~~~~~~  EX TF & COLL TF REFF CALCULATION END  ~~~~~~~~~~~~~~~~~~~~~~~
            Y.YET.TO.REALIZE.TOT =0
            Y.MERGE = Y.EX.TF.LIST:FM:Y.COLL.TF.REFF
                                
            ! DR CNV
            CONVERT SM TO VM IN Y.EX.TF.DR.LIST
            CONVERT VM TO FM IN Y.EX.TF.DR.LIST
                
            CONVERT SM TO VM IN Y.COLL.TF.DR.LIST
            CONVERT VM TO FM IN Y.COLL.TF.DR.LIST
                
            !EX TF & COLL TF DR MARGE
            Y.TF.DR.MERGE = Y.EX.TF.DR.LIST:FM:Y.COLL.TF.DR.LIST
            CONVERT SM TO VM IN Y.TF.DR.MERGE
            CONVERT VM TO FM IN Y.TF.DR.MERGE
                
            CHANGE '\ ' TO '^' IN Y.TF.DR.MERGE
                
            Y.TF.DR.MERGER.SIZE=DCOUNT(Y.TF.DR.MERGE,@FM)
            Y.DRAW.LIST=''
            FOR J1=1 TO Y.TF.DR.MERGER.SIZE
                Y.DRAW.ID=Y.TF.DR.MERGE<J1>
                IF Y.DRAW.ID NE '' THEN
                    Y.DRAW.LIST<-1> = Y.DRAW.ID
                END
            NEXT J1
            CONVERT SM TO VM IN Y.DRAW.LIST
            CONVERT VM TO FM IN Y.DRAW.LIST
            Y.TF.DR.MERGER.SIZE = DCOUNT(Y.DRAW.LIST,@FM)
            CONVERT VM TO FM IN Y.MERGE
            Y.M.SIZE = DCOUNT(Y.MERGE,@FM)
*********************************************************************
            !!!!!!!!   ~~~~~~~~~~~~ TEST BLOCK ~~~~~~~~~~~~~~~~
            Y.NEW.DR.LIST =''
            FOR I1=1 TO Y.M.SIZE
                YY.LC.ID=Y.MERGE<I1>
                FOR I2=1 TO Y.TF.DR.MERGER.SIZE
                    Y.DR.ID = Y.DRAW.LIST<I2>
                    IF  YY.LC.ID[1,12] EQ Y.DR.ID[1,12] THEN
                        Y.NEW.DR.LIST<-1> = Y.DR.ID
                    END
                NEXT I2
            NEXT I1
            ! DEBUG
            Y.TF.DR.MERGER.SIZE=DCOUNT(Y.NEW.DR.LIST,@FM)
*********************************************************************
     
            FOR  K=1 TO Y.TF.DR.MERGER.SIZE
                Y.DR.ID = Y.NEW.DR.LIST<K>

                EB.DataAccess.FRead(FN.DR,Y.DR.ID,DR.REC,F.DR,DR.ERR)
                Y.DRAW.TYPE=DR.REC<LC.Contract.Drawings.TfDrDrawingType>
                IF Y.DRAW.TYPE EQ 'SP' OR Y.DRAW.TYPE EQ 'MA' THEN
                        
                    Y.DOC.AMT = DR.REC<LC.Contract.Drawings.TfDrDocumentAmount>
                    Y.REALIZE.AMT += Y.DOC.AMT
                         
                    EB.LocalReferences.GetLocRef("DRAWINGS","LT.TF.CO.DOCAMT",FLD.POS)
                    Y.TO.REALIZE = DR.REC<LC.Contract.Drawings.TfDrLocalRef,FLD.POS>
                    Y.YET.TO.REALIZE.TOT += Y.TO.REALIZE

                    ! ASSN.CR.ACCT
                    Y.ASSN.CR.ACCT = DR.REC<LC.Contract.Drawings.TfDrAssnCrAcct>
                    CONVERT SM TO VM IN Y.ASSN.CR.ACCT
                    CONVERT VM TO FM IN Y.ASSN.CR.ACCT
                             
                    !Assignment Ref.2 EQ    TPPAY
                    Y.ASSN.REFF = DR.REC<LC.Contract.Drawings.TfDrAssignmentRef>
                    CONVERT SM TO VM IN Y.ASSN.REFF
                    CONVERT VM TO FM IN Y.ASSN.REFF
                        
                    Y.ACCT.POS = ''
                    Y.ACCT.SIZE = DCOUNT(Y.ASSN.CR.ACCT,@FM)
                    FOR ACCT.I=1 TO Y.ACCT.SIZE
                        Y.ACCT.SIZE.ID = Y.ASSN.CR.ACCT<ACCT.I>
                        Y.ASSN.REF.ID = Y.ASSN.REFF<ACCT.I>
                        ! CALL METHOD
                        GOSUB CHECK.ACCOUNT.CUSTOMER
                        IF Y.ACC.CUS.ID EQ Y.CUS.ID THEN
                            Y.BCCCC = Y.ACCT.SIZE.ID[2,3]
                            IF Y.BCCCC EQ '154'  AND Y.ASSN.REF.ID EQ 'TPPAY' THEN
                                Y.ACCT.POS = ACCT.I
                                !BREAK
                                Y.TOT.ASSN.AMT =  DR.REC<LC.Contract.Drawings.TfDrAssnAmount>
                                CONVERT SM TO VM IN Y.TOT.ASSN.AMT
                                CONVERT VM TO FM IN Y.TOT.ASSN.AMT
                                Y.TOT.ASSN.AMT = Y.TOT.ASSN.AMT<Y.ACCT.POS>
                                Y.FC.HELD.KEPT += Y.TOT.ASSN.AMT
                            END
                        END
                    NEXT ACCT.I
                END
            NEXT K
        
        
            !````````````  DRAWING STMT  `````````  END !
***********************************888888888888888***************************************
            ! TOTAL BTB OPENED (12) -> 6
            Y.TOT.BTB.OPENED = JOB.REC<BTB.JOB.TOT.BTB.AMT>
            ! SHIP MADE (15)  -> 09
            Y.SHIP.MADE = JOB.REC<BTB.JOB.TOT.EX.LC.DRAW.AMT>
            ! YET TO MADE (16)  ->10
            Y.YET.TO.MADE = Y.EX.LC.AMT - Y.SHIP.MADE
            ! YET TO REALIZE (18) - 12
            Y.YET.TO.REALIZE = Y.SHIP.MADE - Y.YET.TO.REALIZE.TOT
            ! Y.SHORT.PLUS  (20) -> 14
            !Y.SHORT.PLUS = Y.TOT.BTB.OPENED - Y.FC.HELD.KEPT
            Y.SHORT.PLUS = Y.FC.HELD.KEPT - Y.TOT.BTB.OPENED
            ! FOB VALUE
            !<BTB.JOB.EX.NET.FOB.VALUE>
            Y.FOB = JOB.REC<BTB.JOB.TOT.NET.FOB.VALUE>
            ! BTB % (13)  -> 07
            IF Y.FOB EQ 0 OR Y.TOT.BTB.OPENED EQ 0 THEN
                Y.BTB.PERCENT = 0
            END
            ELSE
                Y.BTB.PERCENT.CALC = (Y.TOT.BTB.OPENED/Y.FOB)
                Y.BTB.PERCENT.CALC *=100
                Y.BTB.PERCENT = DROUND(Y.BTB.PERCENT.CALC,2)
            END
            IF Y.TF.SZ GT 0 THEN
                FOR Q=1 TO Y.TF.SZ
                    Y.TF.IDD = Y.EX.TF.LIST<Q>
                    
                    IF Q EQ 1 THEN
                        GOSUB CUS.INFO.DETAILS
                        ! 5 Y.EX.LC.AMT [Y.R5.]
                        Y.R5.LC.AMT=Y.EX.LC.AMT
                        ! 6 Y.TOT.BTB.OPENED [Y.R6]
                        Y.R6 = Y.TOT.BTB.OPENED
                        ! 7 Y.BTB.PERCENT [Y.R7]
                        Y.R7 = Y.BTB.PERCENT
                        ! 9 Y.SHIP.MADE [Y.R9]
                        Y.R9 = Y.SHIP.MADE
                        ! 10 Y.YET.TO.MADE [Y.R10]
                        Y.R10 = Y.YET.TO.MADE
                        ! 11 Y.REALIZE.AMT [Y.R11]
                        Y.R11 = Y.REALIZE.AMT
                        !12 Y.YET.TO.REALIZE [Y.R12]
                        Y.R12 = Y.YET.TO.REALIZE
                        !               1            2                  3               4                5            6        7                8         09        10        11        12             13                14             15             16             17
                        Y.DATA<-1> = Y.JOB.ID:'*':Y.TF.IDD[1,12]:'*':Y.EXP.LC:'*':Y.TF.ISSUE.DATE:'*':Y.R5.LC.AMT:'*':Y.R6:'*':Y.R7:'*':Y.SHIPING.DATE:'*':Y.R9:'*':Y.R10:'*':Y.R11:'*':Y.R12:'*':Y.FC.HELD.KEPT:'*':Y.SHORT.PLUS:'*':Y.LC.CCY:'*':Y.LC.APPLICANT:'*':Y.FOB
                    END
                    IF Q GT 1 THEN
                        GOSUB CUS.INFO.DETAILS
                        !             1         2          3                4              5     6      7      8            09          10     11     12     13     14     15     16
                        Y.DATA<-1> = '':'*':Y.TF.IDD[1,12]:'*':Y.EXP.LC:'*':Y.TF.ISSUE.DATE:'*':'':'*':'':'*':'':'*':Y.SHIPING.DATE:'*':'':'*':'':'*':'':'*':'':'*':'':'*':'':'*':'':'*':''
                    END
                    !  Y.EX.LC.AMT =0; Y.REALIZE.AMT=0; Y.FC.HELD.KEPT =0
                NEXT Q
            
            
                IF Y.CONT.REFF.SIZE GT 0 AND Y.TF.SZ GT 0  THEN
                    FOR X=1 TO Y.CONT.REFF.SIZE
                        Y.CONT.ID = Y.CONT.REFF<X>
                        GOSUB SALES.CONT.INFO
                        GOSUB CUS.INFO.DETAILS
                        !             1         2                        3                 4            5      6      7             8             9      10     11     12     13     14     15     16
                        Y.DATA<-1> = '':'*':Y.CONT.ID:'*':Y.SCT.CONTRACT.NUMBER:'*':Y.TF.ISSUE.DATE:'*':'':'*':'':'*':'':'*':Y.SCT.SHIP.DATE:'*':'':'*':'':'*':'':'*':'':'*':'':'*':'':'*':'':'*':''
                    NEXT X
                END
            END
            IF Y.CONT.REFF.SIZE GT 0 AND Y.TF.SZ EQ 0 THEN
                FOR XY=1 TO Y.CONT.REFF.SIZE
                    Y.CONT.ID = Y.CONT.REFF<XY>
                    GOSUB SALES.CONT.INFO
                    GOSUB CUS.INFO.DETAILS
                    IF XY EQ 1 THEN
                        !             1              2                         3                 4                 5           6     7            8              9      10     11     12     13     14     15     16       17
                        Y.DATA<-1> = Y.JOB.ID:'*':Y.CONT.ID:'*':Y.SCT.CONTRACT.NUMBER:'*':Y.TF.ISSUE.DATE:'*':Y.EX.LC.AMT:'*':'':'*':'':'*':Y.SCT.SHIP.DATE:'*':'':'*':'':'*':'':'*':'':'*':'':'*':'':'*':'':'*':'':'*':Y.FOB
                    END
                    IF XY GT 1 THEN
                        !             1          2                 3                       4             5     6      7            8              9     10
                        Y.DATA<-1> = '':'*':Y.CONT.ID:'*':Y.SCT.CONTRACT.NUMBER:'*':Y.TF.ISSUE.DATE:'*':'':'*':'':'*':'':'*':Y.SCT.SHIP.DATE:'*':'':'*':'':'*':'':'*':'':'*':'':'*':'':'*':'':'*':''
                    END
                NEXT XY
                ! Y.EX.LC.AMT =0; Y.REALIZE.AMT=0; Y.FC.HELD.KEPT =0
            END
            ! DEBUG
            ! END
        NEXT I
    END
    Y.DATA.F<-1>= Y.DATA
RETURN
*----------------
CUS.INFO.DETAILS:
*---------------
    CHK.SIZE = LEN(Y.TF.IDD)
    IF CHK.SIZE EQ 12 THEN
        EB.DataAccess.FRead(FN.LC,Y.TF.IDD,LC.RECORD,F.LC,LC.ERR)
        ! Ex LC Iss Dt. (4)
        Y.TF.ISSUE.DATE = LC.RECORD<LC.Contract.LetterOfCredit.TfLcIssueDate>
        ! ~~~~~~  Export LC/Contract No.  ~~~~~~~  (3)
        Y.EXP.LC = LC.RECORD<LC.Contract.LetterOfCredit.TfLcIssBankRef>
        ! SHIP DATE
        Y.SHIPING.DATE= LC.RECORD<LC.Contract.LetterOfCredit.TfLcLatestShipment>
        !CCY
        Y.LC.CCY = LC.RECORD<LC.Contract.LetterOfCredit.TfLcLcCurrency>
        ! APPLICANT
        Y.LC.APPLICANT = LC.RECORD<LC.Contract.LetterOfCredit.TfLcApplicant,1>
    END
    ELSE
        ! HIS READ
        EB.DataAccess.FRead(FN.LC.HIS,Y.TF.IDD,LC.RECORD,F.LC.HIS,HIS.LC.ERR)
        ! Ex LC Iss Dt. (4)
        Y.TF.ISSUE.DATE = LC.RECORD<LC.Contract.LetterOfCredit.TfLcIssueDate>
        ! ~~~~~~  Export LC/Contract No.  ~~~~~~~  (3)
        Y.EXP.LC = LC.RECORD<LC.Contract.LetterOfCredit.TfLcIssBankRef>
        ! SHIP DATE
        Y.SHIPING.DATE= LC.RECORD<LC.Contract.LetterOfCredit.TfLcLatestShipment>
        !CCY
        Y.LC.CCY = LC.RECORD<LC.Contract.LetterOfCredit.TfLcLcCurrency>
        ! APPLICANT
        Y.LC.APPLICANT = LC.RECORD<LC.Contract.LetterOfCredit.TfLcApplicant,1>
    END
RETURN
*---------------
SALES.CONT.INFO:
*---------------
    EB.DataAccess.FRead(FN.SCT,Y.CONT.ID,SCT.REC,F.SCT,SCT.ERR)
    Y.SCT.CONTRACT.NUMBER = SCT.REC<SCT.CONTRACT.NUMBER>
    Y.SCT.SHIP.DATE = SCT.REC<SCT.SHIPMENT.DATE>
RETURN
*-------------------
CHECK.ACCOUNT.CUSTOMER:
*-------------------
    EB.DataAccess.FRead(FN.ACC, Y.ACCT.SIZE.ID, REC.ACC, F.ACC, ERR.ACC)
    Y.ACC.CUS.ID = REC.ACC<AC.AccountOpening.Account.Customer>
RETURN
END
 
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
SUBROUTINE TF.JBL.E.NOF.CUS.JOB.LIST(Y.RETURN)
*-----------------------------------------------------------------------------
*  Description: Customer JOB LIST;Shows customer wise JOB INFO details, and fetch data from LC & Sales Contract
*               Application, for LC DATA ->Ex Lc,Export Value,  BTB Ent Amt, BTB Avl Amt, PC Ent Amt, PC Avl Amt, Expiry Date
*               for Sales Contract -> only shows contract ID.
*  Attach Enquiry: JBL.ENQ.LC.CUS.JOB.LIST
* WRITTEN BY ENAMUL HAQUE
*            FDS BD
*            10 JANUARY 2021
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
   
    $INSERT I_ENQUIRY.COMMON
    $USING LC.Contract
    $USING LC.Config
    $USING ST.CompanyCreation
    
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.API
    $USING EB.Display
    $USING EB.Updates
    $USING EB.Foundation
    $USING EB.Reports
    $USING EB.LocalReferences
    
    $INSERT I_F.BD.BTB.JOB.REGISTER
    $INSERT I_F.BD.SCT.CAPTURE
    
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
*-----------
INIT:
*-----------
    FN.DR = 'F.DRAWINGS'
    F.DR = ''
    
    FN.JOB.REG = 'F.BD.BTB.JOB.REGISTER'
    F.JOB.REG = ''
    
    FN.LC = 'F.LETTER.OF.CREDIT'
    F.LC = ''
    
    FN.LC.HIS = 'F.LETTER.OF.CREDIT$HIS'
    F.LC.HIS = ''
    
    FN.SCT = 'F.BD.SCT.CAPTURE'
    F.SCT = ''
        
    Y.DOC.AMOUNT = 0.00
    Y.LC.REF.SIZE = ''
RETURN
*-----------
OPENFILES:
*-----------
    Y.COMPANY = EB.SystemTables.getIdCompany()
    EB.DataAccess.Opf(FN.DR,F.DR)
    EB.DataAccess.Opf(FN.JOB.REG,F.JOB.REG)
    EB.DataAccess.Opf(FN.LC.HIS,F.LC.HIS)
    EB.DataAccess.Opf(FN.SCT,F.SCT)
RETURN
*---------
PROCESS:
*---------
    !DEBUG
    LOCATE 'CUSTOMER.NO' IN EB.Reports.getEnqSelection()<2,1> SETTING CUS.POS THEN
        Y.CUS.NO= EB.Reports.getEnqSelection()<4,CUS.POS>
    END

    IF Y.CUS.NO NE '' THEN
        STMT='SELECT ':FN.JOB.REG:' WITH CUSTOMER.NO EQ ':Y.CUS.NO:' AND CO.CODE EQ ':Y.COMPANY:' BY @ID'
        EB.DataAccess.Readlist(STMT,REC,'',SIZE,ERR)
    END
    
    IF Y.CUS.NO EQ '' THEN
        STMT='SELECT ':FN.JOB.REG:' AND CO.CODE EQ ':Y.COMPANY:' BY @ID'
        EB.DataAccess.Readlist(STMT,REC,'',SIZE,ERR)
    END
    
    IF SIZE GT 0 THEN
        LOOP
            REMOVE Y.JOB.ID FROM REC SETTING POS
        WHILE Y.JOB.ID : POS
            EB.DataAccess.FRead(FN.JOB.REG,Y.JOB.ID,R.REC,F.JOB.REG,Y.ERR)
            IF R.REC THEN
                ! Y.JOB.NO = R.REC<BTB.JOB.CO.CODE>  SL 2
                Y.CUS.ID = R.REC<BTB.JOB.CUSTOMER.NO>
                ! EX TF REF < ~~~ MULTI VALUE FIELD  ~~~ >  SL 3  :: SL 7
                Y.LC.REF = R.REC<BTB.JOB.EX.TF.REF>
                ! BTB.JOB.CONT.REFNO  < ~~~ MULTI VALUE FIELD  ~~~ >  SL 3
                Y.CONT.REF.NO = R.REC<BTB.JOB.CONT.REFNO>
                ! EXPORT LC NO   SL 4
                Y.EXP.LC.NO = R.REC<BTB.JOB.EX.LC.NUMBER>
                ! TOT PC AMT  SL 5
                Y.TOT.PC.AMT = R.REC<BTB.JOB.TOT.PC.ENT.AMT>
                ! TOT PC AVL AMT  SL 6
                Y.TOT.PC.AVL.AMT = R.REC<BTB.JOB.TOT.PC.AVL.AMT>
                ! Tot BTB Ent Amt   SL 8
                Y.TOT.BTB.ENT.AMT = R.REC<BTB.JOB.TOT.BTB.ENT.AMT>
                ! Tot BTB Avl Amt    SL 9
                Y.TOT.BTB.AVL.AMT = R.REC<BTB.JOB.TOT.BTB.AVL.AMT>
                ! Job Expiry Date  SL 10
                Y.TOT.JOB.EXP.DT = R.REC<BTB.JOB.JOB.EXPIRY.DATE>
             
                ! NEWLY ADDED
                ! EX.LC.AMT
                Y.TOT.LC.AMT = R.REC<BTB.JOB.TOT.EX.LC.AMT>
          
            
                Y.LC.REF.SIZE = DCOUNT(Y.LC.REF,@VM)
                ! SALES CONTRACT TOTAL RECORD
                Y.SALES.CONT.SIZE = DCOUNT(Y.CONT.REF.NO,@VM)
                !!!!!!!!-----------F1--------------!!!!!!!!
                !DEBUG
            END
            IF Y.LC.REF.SIZE GE 1 THEN
                !EX TF REF
                FOR I=1 TO Y.LC.REF.SIZE
                    IF I EQ 1 THEN
                        YY.EXP.LC.NO =Y.EXP.LC.NO<1,I>
                        YY.LC.REF = Y.LC.REF<1,I>
                        !   (SL NO: 7)->
                        !            1              2             3            4Y.EXP.LC.NO       5            6                  7                  8                        9                  10
                        Y.DATA<-1>=Y.JOB.ID:'*':Y.CUS.ID:'*':YY.LC.REF:'*':YY.EXP.LC.NO:'*':Y.TOT.PC.AMT:'*':Y.TOT.PC.AVL.AMT:'*':Y.TOT.LC.AMT:'*':Y.TOT.BTB.ENT.AMT:'*':Y.TOT.BTB.AVL.AMT:'*':Y.TOT.JOB.EXP.DT
                        Y.DOC.AMOUNT=0
                    END
                    IF I GT 1 THEN
                        !Y.TEMP.EXP.VAL = Y.LC.REF<1,I>
                        !GOSUB TOT.DR.AMT
                        YY.LC.REF = Y.LC.REF<1,I>
                        YY.EXP.LC.NO =Y.EXP.LC.NO<1,I>
                        !           1      2          3              4          5      6   7 Y.DOC.AMOUNT           8      9     10
                        Y.DATA<-1>='':'*':'':'*':YY.LC.REF:'*':YY.EXP.LC.NO:'*':'':'*':'':'*':'':'*':'':'*':'':'*':''
                        Y.DOC.AMOUNT=0
                    END
                NEXT I
                IF Y.SALES.CONT.SIZE GE 1 THEN
                    FOR J=1 TO Y.SALES.CONT.SIZE
                        YY.CONT.REF.NO = Y.CONT.REF.NO<1,J>
                        GOSUB SCT.BANK.REFF.FLD
                        !!!!!      1       2          3                   4             5      6     7      8      9      10
                        Y.DATA<-1>='':'*':'':'*':YY.CONT.REF.NO:'*':Y.SCT.BNK.REFF:'*':'':'*':'':'*':'':'*':'':'*':'':'*':''
                    NEXT J
                END
            END
            ELSE
                !!!!!!---------F1-------!!!!!!!!!!!!!!!!!!!!!!!!
                IF Y.SALES.CONT.SIZE GE 1 THEN
                    FOR J=1 TO Y.SALES.CONT.SIZE
                        IF J EQ 1 THEN
                            ! GOSUB SUM.OF.SCT.AND.EX.TF.REF
                            YY.CONT.REF.NO = Y.CONT.REF.NO<1,J>
                            GOSUB SCT.BANK.REFF.FLD
                            !            1              2                3                4                5                 6              7: DOC.AMT               8                        9                  10
                            Y.DATA<-1>=Y.JOB.ID:'*':Y.CUS.ID:'*':YY.CONT.REF.NO:'*':Y.SCT.BNK.REFF:'*':Y.TOT.PC.AMT:'*':Y.TOT.PC.AVL.AMT:'*':Y.TOT.LC.AMT:'*':Y.TOT.BTB.ENT.AMT:'*':Y.TOT.BTB.AVL.AMT:'*':Y.TOT.JOB.EXP.DT
                        END
                        IF J GT 1 THEN
                            YY.CONT.REF.NO = Y.CONT.REF.NO<1,J>
                            GOSUB SCT.BANK.REFF.FLD
                            !           1      2         3                 4
                            Y.DATA<-1>='':'*':'':'*':YY.CONT.REF.NO:'*':Y.SCT.BNK.REFF:'*':'':'*':'':'*':'':'*':'':'*':'':'*':''
                        END
                    NEXT J
                END
                ELSE
                    ! GOSUB SUM.OF.SCT.AND.EX.TF.REF
                    !            1              2         3      4            5          6           7: DOC.AMT               8                        9                  10
                    Y.DATA<-1>=Y.JOB.ID:'*':Y.CUS.ID:'*':'':'*':'':'*':Y.TOT.PC.AMT:'*':Y.TOT.PC.AVL.AMT:'*':'':'*':Y.TOT.BTB.ENT.AMT:'*':Y.TOT.BTB.AVL.AMT:'*':Y.TOT.JOB.EXP.DT
                END
            END
        REPEAT
    END
    Y.RETURN<-1> = Y.DATA
RETURN

*------------------
SCT.BANK.REFF.FLD:
*-----------------
    !----  SCT.ISS.BANK.REF  ------------
    Y.SCT.ID = YY.CONT.REF.NO
    EB.DataAccess.FRead(FN.SCT,Y.SCT.ID,SCT.REC,F.SCT,SCT.ERR)
    IF SCT.REC THEN
        ! SCT.CONTRACT.NUMBER  ->  SCT.ISS.BANK.REF
        Y.SCT.BNK.REFF = SCT.REC<SCT.CONTRACT.NUMBER>
    END
RETURN
*----------------
END
